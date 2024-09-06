// Test Bench de l'Addition de Constante
// Youssef Ennouri
// 13 Mars 2024
// Inspiré du code fait en cours par M. Dutertre

`timescale 1ns / 1ps

// Importation du package ascon_pack pour accéder à ses définitions
import ascon_pack::*;

// Définition du module de test pour l'addition de constante
module constant_addition_tb (
    //Empty
);

    // Déclaration des types de données pour les états d'entrée et de sortie
    type_state state_i_s, state_o_s;

    // Déclaration du signal représentant le tour actuel
    logic [3:0] round_i_s;

    // Instanciation du module d'addition de constante
    constant_addition DUT (
        .state_i(state_i_s),
        .round_i(round_i_s),
        .state_o(state_o_s)
    );

    // Bloc initial de la simulation
    initial begin
        // Initialisation des états d'entrée avec des valeurs arbitraires
        state_i_s[0] = 64'h80400c0600000000;
        state_i_s[1] = 64'h8a55114d1cb6a9a2;
        state_i_s[2] = 64'hbe263d4d7aecaaff;
        state_i_s[3] = 64'h4ed0ec0b98c529b7;
        state_i_s[4] = 64'hc8cddf37bcd0284a;

        // Initialisation du tour actuel à 0
        round_i_s = 4'h0;
    end

endmodule : constant_addition_tb
