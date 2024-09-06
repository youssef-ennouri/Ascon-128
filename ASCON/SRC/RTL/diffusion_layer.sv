// Couche de Diffusion Linéaire
// Youssef Ennouri
// 20 Mars 2024 
//Inspiré du code fait en cours par M. Dutertre

// Importation du package ascon_pack pour accéder à ses définitions
import ascon_pack::*;

// Définition du module pour la Couche de Diffusion Linéaire
module diffusion_layer(
    input type_state diffusion_i,       // Entrée
    output type_state diffusion_o       // Sortie
);
    // Effectue les rotations cycliques pour chaque registre xi vers la droite.

    // Opération de diffusion pour diffusion_o[0]
    assign diffusion_o[0] = diffusion_i[0] ^ {diffusion_i[0][18:0], diffusion_i[0][63:19]} ^ {diffusion_i[0][27:0], diffusion_i[0][63:28]};
    
    // Opération de diffusion pour diffusion_o[1]
    assign diffusion_o[1] = diffusion_i[1] ^ {diffusion_i[1][60:0], diffusion_i[1][63:61]} ^ {diffusion_i[1][38:0], diffusion_i[1][63:39]};
    
    // Opération de diffusion pour diffusion_o[2]
    assign diffusion_o[2] = diffusion_i[2] ^ {diffusion_i[2][0], diffusion_i[2][63:1]} ^ {diffusion_i[2][5:0], diffusion_i[2][63:6]};
    
    // Opération de diffusion pour diffusion_o[3]
    assign diffusion_o[3] = diffusion_i[3] ^ {diffusion_i[3][9:0], diffusion_i[3][63:10]} ^ {diffusion_i[3][16:0], diffusion_i[3][63:17]};
    
    // Opération de diffusion pour diffusion_o[4]
    assign diffusion_o[4] = diffusion_i[4] ^ {diffusion_i[4][6:0], diffusion_i[4][63:7]} ^ {diffusion_i[4][40:0], diffusion_i[4][63:41]};
    
endmodule: diffusion_layer

