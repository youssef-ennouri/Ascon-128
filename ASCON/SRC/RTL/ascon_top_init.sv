// Ascon Top init
// Youssef Ennouri
// 5 Avril 2024
//Inspiré du code fait en cours par M. Dutertre


`timescale 1ns/1ps

import ascon_pack::*;

module ascon_top_init(
	input logic clock_i, resetb_i,start_i,
	output logic end_o 
);

	logic [3:0] round_s;
	logic en_cpt_perm_s, init_p6_s,init_p12_s;
	logic input_mode_s, en_reg_state_s,xor_key_s;

	FSM_init FSM_init (
		.clock_i(clock_i),
		.resetb_i(resetb_i),
		.start_i(start_i),
		.round_i(round_s),
		.en_cpt_perm_o(en_cpt_perm_s),
		.init_p6_o(init_p6_s),
		.init_p12_o(init_p12_s),
		.input_mode_o(input_mode_s),
		.en_reg_state_o(en_reg_state_s),
		.xor_key_o(xor_key_s),
		.end_o(end_o)

	);

	compteur_double_init compteur_double_init (
        .clock_i(clock_i),
        .resetb_i(resetb_i),
        .cpt_o(round_s),
        .en_i(en_cpt_perm_s),
        .init_a_i(init_p12_s),
        .init_b_i(init_p6_s)
    );
	
	permutation_step1 ASCON_step1 (

        .state_i(state_input_s),
        .data_sel_i(input_mode_s),
        .round_i(round_s),
        .clock_i(clock_i),
        .resetb_i(resetb_i),
        .en_reg_state_i(en_reg_state_s),
        .state_o(state_output_s)

    );

endmodule: ascon_top_init

