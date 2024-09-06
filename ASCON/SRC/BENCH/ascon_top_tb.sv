//Test bench de Ascon Top-level
//Ennouri Youssef
//05/05/2024

`timescale 1 ns/ 1 ps

// Importation du module ascon_pack pour accéder à ses définitions
import ascon_pack::*;

// Définition du module de test pour le top-level Ascon
module ascon_top_tb (
    // Empty
);
    logic clock_s;                      // Signal d'horloge
    logic resetb_s;
    logic  [63:0] data_s;
    logic data_valid_s;
    logic [127:0] key_s;                // Clé de chiffrement
    logic start_s;                      // Signal de démarrage du chiffrement
    logic [127:0] nonce_s;
    logic [63:0] cipher_s;
    logic cipher_valid_s;
    logic [127:0] tag_s;                // Tag de chiffrement
    logic end_s;                        // Signal de fin de chiffrement
    logic [63:0] associated_data;
    logic [191:0] plain_text;

    // Instanciation du DUT (Design Under Test) Ascon_top
    ascon_top DUT(
        .clock_i(clock_s),
        .resetb_i(resetb_s),
        .start_i(start_s),
        .data_valid_i(data_valid_s),
        .data_i(data_s),
        .key_i(key_s),
        .nonce_i(nonce_s),
        .cipher_o(cipher_s),
        .cipher_valid_o(cipher_valid_s),
        .tag_o(tag_s),
        .end_o(end_s)
    );

    initial begin
        clock_s = 0;
        // Génération continue du signal d'horloge avec une période de 10ns
        forever #10 clock_s = ~clock_s;
    end

    // Initialisation des signaux de la simulation
    initial begin
        resetb_s = 0;
        #5;
        resetb_s = 1;
        data_s = '0;
        data_valid_s = 0;
        start_s = 0;
        
        key_s = 128'h8A55114D1CB6A9A2BE263D4D7AECAAFF;
        associated_data = {48'h4120746F2042, 16'h8000};
        nonce_s = 128'h4ED0EC0B98C529B7C8CDDF37BCD0284A;
        // Texte en clair et ajout d'un padding pour l'alignement
        plain_text = {186'h5244562061752054692762617220636520736F6972203F, 8'h80};

        // Début de l'initialisation

        #5;
        #40; 
        start_s = 1; // Activation du signal de démarrage
        #40;
        start_s = 0;
        #300;

        // Fin de l'initialisation

        // Début des données associées

        data_valid_s = 1;
        data_s = associated_data;
        #40; // Once again random but > 20
        data_valid_s = 0;
        #300;

        // Fin des données associées

        // Début du texte en clair
        
        // Première partie du texte

        data_valid_s = 1;
        data_s = plain_text[191:128];
        #40;
        data_valid_s = 0;
        #300;

        // Deuxième partie du texte

        data_valid_s = 1;
        data_s = plain_text[127:64];
        #40;
        data_valid_s = 0;
        #300;

        // Troisième partie du texte

        data_valid_s = 1;
        data_s = plain_text[63:0];
        #40;
        data_valid_s = 0;

        // Fin du texte en clair

        // Finalisation
        #300;

    end

    
endmodule