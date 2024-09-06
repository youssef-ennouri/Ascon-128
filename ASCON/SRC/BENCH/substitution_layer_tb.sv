// Test Bench de la Couche de Substitution
// Youssef Ennouri
// 20 Mars 2024

`timescale 1ns / 1ps

// Importation du package ascon_pack pour accéder à ses définitions
import ascon_pack::*;

// Définition du module de test pour la couche de substitution
module substitution_layer_tb(
    // Empty
);

    // Déclaration des types de données pour les états d'entrée et de sortie
    type_state state_i_s;
    type_state state_o_s;

    // Instanciation du module à tester
    substitution_layer DUT(
        .state_i(state_i_s),
        .state_o(state_o_s)
    );

    // Bloc initial de la simulation
    initial begin
        // Initialisation des états d'entrée avec les valeurs en sortie de constante addition
        state_i_s[0] = 64'h80400c0600000000;
        state_i_s[1] = 64'h8a55114d1cb6a9a2;
        state_i_s[2] = 64'hbe263d4d7aecaa0f;
        state_i_s[3] = 64'h4ed0ec0b98c529b7;
        state_i_s[4] = 64'hc8cddf37bcd0284a;
    end

endmodule
