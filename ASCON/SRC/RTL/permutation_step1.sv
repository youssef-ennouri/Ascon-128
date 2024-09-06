// Permutation Elementaire
// Youssef Ennouri
// 27 Mars 2024
//Inspiré du code fait en cours par M. Dutertre

import ascon_pack::*;

module permutation (
	input type_state state_i,
	input logic sel_i,
	input logic[3:0] round_i,
	input logic clock_i,
	input logic resetb_i,
	input logic en_i,
	type_state mux_to_state_s,
	type_state cst_to_sub_s,
	type_state lin_to_reg_s,
	type_state state_s,
	output type_state state_o
);

	mux_state mux(
		.sel_i(sel_i),
		.data1_i(state_i),
		.data2_i(state_s),
		.data_o(mux_to_state_s)
	);

	constante_addition pc(
		.state_i(mux_to_state_s),
		.round_i(round_i),
		.state_o(cst_to_sub_s)
	);
	
	diffusion_layer pl(
		.state_i(sub_to_lin_s),
		.state_o(lin_to_reg_s)
	);

	substitution_layer ps(
		.state_i(cst_to_sub_s),
		.state_o(sub_to_lin_s)
	);

	state_register_w_en state_register(
		.clock_i(clock_i),
		.resetb_i(resetb_i),
		.en_i(en_reg_state_i),
		.data_i(lin_to_reg_s),
		.data_o(state_s)
	);

	assign state_o = state_s;

endmodule;
