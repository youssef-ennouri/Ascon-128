// Addition de Constante Pc
// Youssef Ennouri
// 13 Mars 2024
//Inspiré du code fait en cours par M. Dutertre

import ascon_pack::*;

module constant_addition (
	input type_state state_i,
	input logic[3:0] round_i,
	output type_state state_o 
);

// Description de l'add. de cte

// On ne modifie pas les registres x0,x1,x3,x4
	assign state_o[0] = state_i[0];
	assign state_o[1] = state_i[1];
	assign state_o[3] = state_i[3];
	assign state_o[4] = state_i[4];

	assign state_o[2][63:8] = state_i[2][63:8];
// On ne modifie que l'octet de poids faible du registre x2
	assign state_o[2][7:0] = state_i[2][7:0]^round_constant[round_i];


endmodule : constant_addition
