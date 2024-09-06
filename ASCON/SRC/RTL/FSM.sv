// Initialisation FSM
// Youssef Ennouri
// 5 Avril 2024
//Inspiré du code fait en cours par M. Dutertre

// Importation du package ascon_pack pour accéder à ses définitions
import ascon_pack::*;

`timescale 1ns/1ps

// Définition du module FSM qui est une FSM_Moore
module FSM (
    input logic clock_i, resetb_i,
    input logic start_i,
    input logic [3:0] round_i,
    input logic data_valid_i,
	output logic en_cipher_o,
	output logic en_tag_o,
    output logic en_xor_lsb_o,
    output logic en_xor_key_o,
    output logic en_xor_data_o,
    output logic en_xor_key_final_o,
    output logic en_cpt_perm_o, init_p6_o, init_p12_o, 
    output logic input_mode_o, en_reg_state_o,
	output logic cipher_valid_o,
	output logic sel_i,
    output logic end_o
);


	// Déclaration de l'énumération pour les états de la machine à états finis (FSM)
	typedef enum {attente, conf_init, init_rd0, init_rd1_to_10, init_rd11,conf_data, data_rd0, data_rd1_to_4, data_rd5,
    conf_texte1, texte1_rd0, texte1_rd1_to_4, texte1_rd5,conf_texte2,texte2_rd0, texte2_rd1_to_4,texte2_rd5,conf_final, final_rd0, final_rd1_to_10, final_rd11,
	attente_texte1,attente_texte2,attente_data,attente_final, fin} state_t;

	// Variables internes pour modéliser le FSM
	state_t current_state, next_state;

	// Processus séquentiel pour le registre d'état
	always_ff @( posedge clock_i or negedge resetb_i ) 
		begin : seq_o
			if (resetb_i == 1'b0)
				current_state <= attente;
			else current_state <= next_state;
		end : seq_o




	// Processus combinatoire pour les transitions d'état
	always_comb begin : comb_0
		case (current_state)

			attente:
				if (start_i == 1'b1) next_state = conf_init;
				else next_state = attente;

			conf_init:
			next_state = init_rd0;

			init_rd0:
			next_state = init_rd1_to_10;

			init_rd1_to_10:
				if (round_i == 10) next_state = init_rd11;
				else next_state = init_rd1_to_10; 

			init_rd11:
			next_state = attente_data;

            attente_data:
                if(data_valid_i == 1) next_state = conf_data;
				else next_state = attente_data;

            conf_data:
			next_state = data_rd0;

			data_rd0:
			next_state = data_rd1_to_4;

			data_rd1_to_4:
				if (round_i == 10) next_state = data_rd5;
				else next_state = data_rd1_to_4; 

			data_rd5:
			next_state = attente_texte1;

			attente_texte1:
                if(data_valid_i == 1) next_state = conf_texte1;
				else next_state = attente_texte1;

			conf_texte1:
			next_state = texte1_rd0;

			texte1_rd0:
			next_state = texte1_rd1_to_4;

			texte1_rd1_to_4:
				if (round_i == 10) next_state = texte1_rd5;
				else next_state = texte1_rd1_to_4; 

			texte1_rd5:
			next_state = attente_texte2;
			
			attente_texte2:
                if(data_valid_i == 1) next_state = conf_texte2;
				else next_state = attente_texte2;
			
			conf_texte2:
			next_state = texte2_rd0;

			texte2_rd0:
			next_state = texte2_rd1_to_4;

			texte2_rd1_to_4:
				if (round_i == 10) next_state = texte2_rd5;
				else next_state = texte2_rd1_to_4; 

			texte2_rd5:
			next_state = attente_final;

			attente_final:
                if(data_valid_i == 1) next_state = conf_final;
				else next_state = attente_final;
			
			conf_final:
			next_state = final_rd0;

			final_rd0:
			next_state = final_rd1_to_10;

			final_rd1_to_10:
				if (round_i == 10) next_state = final_rd11;
				else next_state = final_rd1_to_10; 

			final_rd11:
			next_state = fin;

			fin:
			next_state = attente;

			default: next_state = attente;
		endcase 
	end : comb_0




	// Second processus combinatoire pour les sorties
	always_comb begin : comb_1
	// J'ai mis les données au dessus du case pour quelles soient initialement à 0 et juste mettre à 1 celles dont j'ai besoin.
		en_cpt_perm_o = 0;
        init_p6_o = 0;
        init_p12_o = 0;
		en_cipher_o = 0;
		en_tag_o = 0;
        input_mode_o = 0;
        en_reg_state_o = 0;
        en_xor_data_o = 0;
        en_xor_key_o = 0;
        en_xor_key_final_o = 0;
        en_xor_lsb_o = 0;
		cipher_valid_o = 0;
		sel_i = 1;
        end_o = 0;
		case (current_state)
		// Affectation des sorties en fonction de l'état courant
			attente : begin
			end

			conf_init: begin
				sel_i = 0; 				// On prend notre valeur en entrée
				en_cpt_perm_o = 1;		// On incrémente le compteur
				init_p12_o = 1;			// On a 12 rondes
			end

			init_rd0: begin
				sel_i = 0;
				en_reg_state_o = 1;
				en_cpt_perm_o = 1; 
			end

			init_rd1_to_10: begin
				en_reg_state_o = 1;
				input_mode_o = 1;
				en_cpt_perm_o = 1;
			end

			init_rd11: begin
				en_reg_state_o = 1;
				input_mode_o = 1;
				en_cpt_perm_o = 1;
				en_xor_key_o = 1;
			end

			attente_data: begin
				input_mode_o = 1;
			end

            conf_data: begin
				input_mode_o = 1;
				init_p6_o = 1;
				en_cpt_perm_o = 1;
			end

			data_rd0: begin
				input_mode_o = 1;
				en_reg_state_o = 1;
				en_cpt_perm_o = 1;
				en_xor_data_o = 1;
			end

			data_rd1_to_4: begin
				en_reg_state_o = 1;
				input_mode_o = 1;
				en_cpt_perm_o = 1; 
			end

			data_rd5: begin
				en_cpt_perm_o = 1;
				en_reg_state_o = 1;
				input_mode_o = 1;
				en_xor_lsb_o = 1;
			end

			attente_texte1: begin
				cipher_valid_o = 1;
				input_mode_o = 1;
			end

            conf_texte1: begin
				input_mode_o = 1;
				init_p6_o = 1;
				en_cpt_perm_o = 1;
			end

			texte1_rd0: begin
				input_mode_o = 1;
				en_reg_state_o = 1;
                en_xor_data_o = 1;
				en_cpt_perm_o = 1;
				en_cipher_o = 1;
			end

			texte1_rd1_to_4: begin
				en_reg_state_o = 1;
				input_mode_o = 1;
				en_cpt_perm_o = 1;
			end

			texte1_rd5: begin
				en_reg_state_o = 1;
				input_mode_o = 1;
				en_cpt_perm_o = 1;
			end

			attente_texte2: begin
				input_mode_o = 1;
			end

           conf_texte2: begin
				input_mode_o = 1;
				init_p6_o = 1;
				en_cpt_perm_o = 1;
			end

			texte2_rd0: begin
				input_mode_o = 1;
				en_reg_state_o = 1;
                en_xor_data_o = 1;
				en_cpt_perm_o = 1;
				en_cipher_o = 1;
			end

			texte2_rd1_to_4: begin
				en_reg_state_o = 1;
				input_mode_o = 1;
				en_cpt_perm_o = 1;
			end

			texte2_rd5: begin
				en_reg_state_o = 1;
				input_mode_o = 1;
				en_cpt_perm_o = 1;
			end

			attente_final: begin
				input_mode_o = 1;
				cipher_valid_o = 1;
			end

			conf_final: begin
				input_mode_o = 1;
				en_cpt_perm_o = 1;
				init_p12_o = 1;
			end

			final_rd0: begin
				input_mode_o = 1;
				en_reg_state_o = 1;
				en_xor_data_o = 1;
				en_xor_key_final_o = 1;
				en_cpt_perm_o = 1;
				en_cipher_o = 1;
			end

			final_rd1_to_10: begin
				en_reg_state_o = 1;
				input_mode_o = 1;
				en_cpt_perm_o = 1;
			end

			final_rd11: begin
				en_reg_state_o = 1;
				input_mode_o = 1;
				en_cpt_perm_o = 1;
				en_xor_key_o = 1;
				en_tag_o = 1;
			end

			fin : begin
				end_o = 1;
			end
		endcase
	end : comb_1

endmodule : FSM
