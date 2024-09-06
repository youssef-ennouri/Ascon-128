//Test bench de ascon top init
//Ennouri Youssef
//05/04/2024
//Inspiré du code fait en cours par M. Dutertre

`timescale 1ns/1ps
import ascon_pack::*;

module ascon_top_init_tb(
	);

// internal declaration
	logic clock_s=0'b0;
	logic resetb_s;
	logic start_s;
	logic end_s;

//DUT 
	ascon_top_init DUT(
		.clock_i(clock_s),
		.resetb_i(resetb_s),
		.start_i(start_s),
		.end_o(end_s)
	);
	//Stimuli test bench
	//horloge
	always 
	begin
		clock_s=-clock_s;
	end
	//gestion du reset et du start
	initial 
	begin
		start_s=1'b0;
		resetb_s=1'b0;
		#2
		resetb_s=1'b1;
		#35
		start_s=1'b1;
		#39
		start_s=1'b1;
	end
endmodule : ascon_top_init_tb