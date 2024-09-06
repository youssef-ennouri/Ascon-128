// Test Bench de la Couche de Diffusion Linéaire
// Youssef Ennouri
// 20 Mars 2024
// Inspiré du code fait en cours par M. Dutertre

`timescale 1ns / 1ps

// Importation du package ascon_pack pour accéder à ses définitions
import ascon_pack::*;

// Définition du module de test pour la couche de diffusion linéaire
module diffusion_layer_tb(
    // Empty
);

    // Déclaration des types de données pour les états d'entrée et de sortie
    type_state diffusion_i_s;
    type_state diffusion_o_s;

    // Instanciation du module à tester
    diffusion_layer DUT(
        .diffusion_i(diffusion_i_s),
        .diffusion_o(diffusion_o_s)
    );

    // Bloc initial de la simulation
    initial begin
        // Initialisation des états d'entrée avec les valeurs correspondantes au sujet
        diffusion_i_s[0] = 64'h78e2cc41faabaa1a;
        diffusion_i_s[1] = 64'hbc7a2e775aababf7;
        diffusion_i_s[2] = 64'h4b81c0cbbdb5fc1a;
        diffusion_i_s[3] = 64'hb22e133e424f0250;
        diffusion_i_s[4] = 64'h044d33702433805d;
    end

endmodule
