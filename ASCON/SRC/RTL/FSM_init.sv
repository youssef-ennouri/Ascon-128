// Initialisation FSM
// Youssef Ennouri
// 5 Avril 2024
//Inspiré du code fait en cours par M. Dutertre

import ascon_pack::*;
`timescale 1ns/1ps

module FSM_init (
    input logic clock_i, resetb_i,
    input logic start_i,
    input logic [3:0] round_i,
    output logic en_cpt_perm_o, init_p6_o, init_p12_o, 
    output logic input_mode_o, en_reg_state_o, xor_key_o, 
    output logic end_o
);


	//Enumerate type declaration
	typedef enum {attente, conf_init, init_rd0, init_rd1_to_10, init_rd11, fin} state_t;

	//Internal variable to model the FSM
	state_t current_state, next_state;

	//Sequential process modeling the state register
	always_ff @( posedge clock_i or negedge resetb_i ) 
		begin : seq_o
			if (resetb_i == 1'b0)
				//nonblocking assignement
				current_state <= attente;
			else current_state <= next_state;
		end : seq_o




	//First combinational process for transitions
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
			next_state = fin;

			fin:
			next_state = attente;

			default: next_state = attente;
		endcase // case (current_state)
	end : comb_0




	//Second combinational process for outputs
	always_comb begin : comb_1
	
		en_cpt_perm_o = 0;
		init_p6_o = 0;
		init_p12_o = 0;
		input_mode_o = 0;
		en_reg_state_o = 0;
		en_xor_key_final_o = 0;
		end_o = 0;

		case (current_state)
			attente :

			conf_init: begin
				en_cpt_perm_o = 1;
				init_p12_o = 1;
			end

			init_rd0: begin
				en_cpt_perm_o = 1;
				en_reg_state_o = 1;
			end

			init_rd1_to_10: begin
				en_cpt_perm_o = 1;
				en_reg_state_o = 1;
				input_mode_o = 1;
			end

			init_rd11: begin
				en_cpt_perm_o = 1;
				en_reg_state_o = 1;
				input_mode_o = 1;
				en_xor_key_final_o = 1;
			end

			fin : begin
				end_o = 1;
			end
		endcase // case (current_state)
	end : comb_1

endmodule : FSM_init
