// Test bench de la Permutation Finale avec XOR
// Ennouri Youssef
// 5 Avril 2024

`timescale 1ns/1ps

// Importation du package ascon_pack pour accéder à ses définitions
import ascon_pack::*;

// Définition du module de test pour la permutation finale avec XOR
module permutation_tb(
    // Empty
);

    // Déclaration des signaux de la simulation
    type_state state_i;
    logic sel_i;
    logic en_out_cipher_i;
    logic en_out_tag_i;
    logic clock_i = 1'b0;
    logic resetb_i;
    logic en_i;
    logic en_xor_data_i;
    logic en_xor_lsb_i;
    logic en_xor_key_final_i;
    logic en_xor_key_i;
    logic [3:0] round_i;
    logic [127 : 0] key_i;
    logic [63 : 0] data_i;
    logic [127 : 0] tag_o;
    logic [63 : 0] cipher_o;
    logic [47:0] data_associe;
    type_state state_o;

    // Instanciation du module de permutation
    permutation DUT (
        .state_i(state_i),
        .sel_i(sel_i),
        .en_out_cipher_i(en_out_cipher_i),
        .en_out_tag_i(en_out_tag_i),
        .clock_i(clock_i),
        .resetb_i(resetb_i),
        .en_i(en_i),
        .en_xor_data_i(en_xor_data_i),
        .en_xor_lsb_i(en_xor_lsb_i),
        .en_xor_key_final_i(en_xor_key_final_i),
        .en_xor_key_i(en_xor_key_i),
        .round_i(round_i),
        .key_i(key_i),
        .data_i(data_i),
        .tag_o(tag_o),
        .cipher_o(cipher_o),
        .state_o(state_o)
    );

    // Génération du signal d'horloge
    always begin
        #10;
        assign clock_i = ~clock_i;
    end

    // Bloc initial de la simulation
    initial begin
        // Initialisation des valeurs des signaux
        en_xor_key_i = 1'b0;
        en_xor_key_final_i = 1'b0;
        en_xor_lsb_i = 1'b0;
        en_xor_data_i = 1'b0;
        en_out_cipher_i = 1'b0;
        en_out_tag_i = 1'b0;

        state_i[0] = 64'h80400c0600000000;
        state_i[1] = 64'h8a55114d1cb6a9a2;
        state_i[2] = 64'hbe263d4d7aecaaff;
        state_i[3] = 64'h4ed0ec0b98c529b7;
        state_i[4] = 64'hc8cddf37bcd0284a;

		key_i = 128'h8A55114D1CB6A9A2BE263D4D7AECAAFF;

        resetb_i = 1'b0;
        sel_i = 1'b0;
        en_i = 1'b1;

        round_i = 4'b0000;
        #2;
        resetb_i = 1'b1;
        #9; // Attente supplémentaire pour éviter les conflits de mise à jour du registre

        sel_i = 1'b1;
        round_i = 4'b0001;
        
        // Boucle de simulation pour plusieurs tours de permutation
        repeat (10) begin
            #20;
            round_i = round_i + 1;
        end

        // On active le xor à la 11ème permutation
        en_xor_key_i = 1'b1;
        #20;
        round_i = round_i + 1;
    end

endmodule : permutation_tb
