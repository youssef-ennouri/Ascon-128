// Ascon Top
// Youssef Ennouri
// 29 Avril 2024
//Inspiré du code fait en cours par M. Dutertre

`timescale 1ns/1ps

// Importation du package ascon_pack pour accéder à ses définitions
import ascon_pack::*;

// Module principal pour l'algorithme Ascon
// Ce module coordonne les différents blocs fonctionnels de l'algorithme Ascon

// Définition du module Ascon_top
module ascon_top (
	input logic clock_i, resetb_i,start_i,data_valid_i,
    input logic [63 : 0] data_i,
    input logic [127 : 0] key_i,
    input logic [127 : 0] nonce_i,
    output logic [63 : 0] cipher_o,
    output logic [127 : 0] tag_o,
	output logic cipher_valid_o,end_o 
);

    // Initialisation des variables internes

	logic [3:0] round_s;
	logic en_cpt_perm_s, init_p6_s,init_p12_s, sel_s,en_s;
	logic input_mode_s,en_cipher_s,en_tag_s;
    logic xor_key_s,xor_data_s,xor_lsb_s,xor_key_final_s;
    type_state state_s,state_out_s;

    logic[63:0] init_s = 64'h80400C0600000000;

    // Initialisation de l'état initial avec la clé et le nonce
    assign state_s = {init_s,key_i,nonce_i};

    // Instanciation de la machine à états finis (FSM)
	FSM Machine_Moore (
		.clock_i(clock_i),
		.resetb_i(resetb_i),
		.start_i(start_i),
		.round_i(round_s),
        .data_valid_i(data_valid_i),
        .en_cipher_o(en_cipher_s),
        .en_tag_o(en_tag_s),
		.en_cpt_perm_o(en_cpt_perm_s),
		.init_p6_o(init_p6_s),
		.init_p12_o(init_p12_s),
		.input_mode_o(input_mode_s),
		.en_reg_state_o(en_s),
		.en_xor_key_o(xor_key_s),
        .en_xor_lsb_o(xor_lsb_s),
        .en_xor_data_o(xor_data_s),
        .en_xor_key_final_o(xor_key_final_s),
        .cipher_valid_o(cipher_valid_o),
        .sel_i(sel_s),
		.end_o(end_o)
	);

    // Instanciation du compteur double
	compteur_double_init compteur_double (
        .clock_i(clock_i),
        .resetb_i(resetb_i),
        .cpt_o(round_s),
        .en_i(en_cpt_perm_s),
        .init_a_i(init_p12_s),
        .init_b_i(init_p6_s)
    );
	
    // Instanciation de la permutation Ascon
	permutation ASCON_perm (
        .state_i(state_s),
        .sel_i(input_mode_s),
        .en_out_cipher_i(en_cipher_s),
        .en_out_tag_i(en_tag_s),
        .round_i(round_s),
        .clock_i(clock_i),
        .resetb_i(resetb_i),
        .en_i(en_s),
        .en_xor_data_i(xor_data_s),
        .en_xor_lsb_i(xor_lsb_s),
        .en_xor_key_final_i(xor_key_final_s),
        .en_xor_key_i(xor_key_s),
        .key_i(key_i),
        .data_i(data_i),
        .tag_o(tag_o),
        .cipher_o(cipher_o),
        .state_o(state_out_s)
    );

endmodule: ascon_top