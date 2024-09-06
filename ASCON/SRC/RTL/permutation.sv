// Permutation Avec XOR
// Youssef Ennouri
// 15 Avril 2024

// Importation du package ascon_pack pour accéder à ses définitions
import ascon_pack::*;

// Définition du module de permutation
module permutation (
	input type_state state_i,
	input logic sel_i,
	input logic en_out_cipher_i,
	input logic en_out_tag_i,
	input logic[3:0] round_i,
	input logic clock_i,
	input logic resetb_i,
	input logic en_i,
	input logic en_xor_data_i,
	input logic en_xor_lsb_i,
    input logic en_xor_key_final_i, 
	input logic en_xor_key_i,
    input logic [127 : 0] key_i,
    input logic [63 : 0] data_i,
	output logic [127 : 0] tag_o,
	output logic [63 : 0] cipher_o,
	output type_state state_o
);

    // Déclaration des signaux internes
	type_state mux_to_xorb_s;
	type_state xorb_to_add_s;
	type_state cst_to_sub_s;
	type_state lin_to_xore_s;
	type_state xore_to_reg_s;
	type_state state_s;
	type_state sub_to_lin_s;

    // Instanciation des différents blocs fonctionnels

	// Multiplexeur pour sélectionner entre l'état d'entrée
	mux_state mux(
		.sel_i(sel_i),
		.data1_i(state_i),
		.data2_i(state_s),
		.data_o(mux_to_xorb_s)
	);

	// XOR de début pour effectuer un XOR entre l'état intermédiaire et les données/clés
	xor_begin_perm xor_debut(
		.en_xor_data_i(en_xor_data_i),
		.en_xor_key_i(en_xor_key_final_i),
		.data_i(data_i),
		.key_i(key_i),
		.state_i(mux_to_xorb_s),
		.state_o(xorb_to_add_s)
	);

	// Registre pour stocker la sortie du XOR de début
	register_w_en #(64) reg_1(
		.clock_i(clock_i),
		.resetb_i(resetb_i),
		.en_i(en_out_cipher_i),
		.data_i(xorb_to_add_s[0]),
		.data_o(cipher_o)
	);

	// Voir Module Constant_Addition
	constant_addition pc(
		.state_i(xorb_to_add_s),
		.round_i(round_i),
		.state_o(cst_to_sub_s)
	);

	// Voir Module Substitution_Layer
	substitution_layer ps(
		.state_i(cst_to_sub_s),
		.state_o(sub_to_lin_s)
	);

	// Voir Module Diffusion_Layer
	diffusion_layer pl(
		.diffusion_i(sub_to_lin_s),
		.diffusion_o(lin_to_xore_s)
	);

	// XOR de fin pour effectuer un XOR entre l'état intermédiaire et la clé
	xor_end_perm xor_fin(
		.en_xor_lsb_i(en_xor_lsb_i),
		.en_xor_key_i(en_xor_key_i),
		.key_i(key_i),
		.state_i(lin_to_xore_s),
		.state_o(xore_to_reg_s)
	);

	// Registre pour stocker la sortie du XOR de fin
	state_register_w_en state_register(
		.clock_i(clock_i),
		.resetb_i(resetb_i),
		.en_i(en_i),
		.data_i(xore_to_reg_s),
		.data_o(state_s)
	);

	// Registre pour stocker les 2 derniers registres de la sortie du XOR de fin pour former le tag
	register_w_en #(128) reg_2(
		.clock_i(clock_i),
		.resetb_i(resetb_i),
		.en_i(en_out_tag_i),
		.data_i({xore_to_reg_s[3],xore_to_reg_s[4]}),
		.data_o(tag_o)
	);

    // Assignation de l'état de sortie
	assign state_o = state_s;
	
endmodule : permutation