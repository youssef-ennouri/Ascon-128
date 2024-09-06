// Couche de Substitution
// Youssef Ennouri
// 20 Mars 2024
// Inspiré du code fait en cours par M. Dutertre

`timescale 1ns/1ps

// Importation du package ascon_pack pour accéder à ses définitions
import ascon_pack::*;

// Définition du module pour la couche de substitution
module substitution_layer(
    input type_state state_i,  // Entrée 
    output type_state state_o  // Sortie 
);

    genvar i;
    generate
        // Parcours des 5 lignes de 64 bits
        for (i = 0; i < 64; i++) begin : g_sbox
            // Instanciation de la S-box Ascon pour substituer chaque ligne
            ascon_sbox ascon_sbox_inst(
                .sbox_i({state_i[0][i], state_i[1][i], state_i[2][i], state_i[3][i], state_i[4][i]}),  // Entrée de la S-box
                .sbox_o({state_o[0][i], state_o[1][i], state_o[2][i], state_o[3][i], state_o[4][i]})   // Sortie de la S-box
            );
        end : g_sbox
    endgenerate
endmodule : substitution_layer
