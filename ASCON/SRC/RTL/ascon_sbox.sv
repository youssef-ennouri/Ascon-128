// Ascon_Sbox
// Youssef Ennouri
// 20 Mars 2024

`timescale 1ns/1ps

import ascon_pack::*;

module ascon_sbox(
	input logic[4:0] sbox_i,
	output logic[4:0] sbox_o 
);

// Description de la substitution sur 5 bits
	assign sbox_o = sbox_t[sbox_i];


endmodule : ascon_sbox
