module sha256_functions (
    input  wire [6:0]  j,
    output wire [31:0] k_j
);
    reg [31:0] K_ROM [0:63];
    initial begin
        K_ROM[ 0] = 32'h428a2f98; K_ROM[ 1] = 32'h71374491; K_ROM[ 2] = 32'hb5c0fbcf; K_ROM[ 3] = 32'he9b5dba5;
        K_ROM[ 4] = 32'h3956c25b; K_ROM[ 5] = 32'h59f111f1; K_ROM[ 6] = 32'h923f82a4; K_ROM[ 7] = 32'hab1c5ed5;
        K_ROM[ 8] = 32'hd807aa98; K_ROM[ 9] = 32'h12835b01; K_ROM[10] = 32'h243185be; K_ROM[11] = 32'h550c7dc3;
        K_ROM[12] = 32'h72be5d74; K_ROM[13] = 32'h80deb1fe; K_ROM[14] = 32'h9bdc06a7; K_ROM[15] = 32'hc19bf174;
        K_ROM[16] = 32'he49b69c1; K_ROM[17] = 32'hefbe4786; K_ROM[18] = 32'h0fc19dc6; K_ROM[19] = 32'h240ca1cc;
        K_ROM[20] = 32'h2de92c6f; K_ROM[21] = 32'h4a7484aa; K_ROM[22] = 32'h5cb0a9dc; K_ROM[23] = 32'h76f988da;
        K_ROM[24] = 32'h983e5152; K_ROM[25] = 32'ha831c66d; K_ROM[26] = 32'hb00327c8; K_ROM[27] = 32'hbf597fc7;
        K_ROM[28] = 32'hc6e00bf3; K_ROM[29] = 32'hd5a79147; K_ROM[30] = 32'h06ca6351; K_ROM[31] = 32'h14292967;
        K_ROM[32] = 32'h27b70a85; K_ROM[33] = 32'h2e1b2138; K_ROM[34] = 32'h4d2c6dfc; K_ROM[35] = 32'h53380d13;
        K_ROM[36] = 32'h650a7354; K_ROM[37] = 32'h766a0abb; K_ROM[38] = 32'h81c2c92e; K_ROM[39] = 32'h92722c85;
        K_ROM[40] = 32'ha2bfe8a1; K_ROM[41] = 32'ha81a664b; K_ROM[42] = 32'hc24b8b70; K_ROM[43] = 32'hc76c51a3;
        K_ROM[44] = 32'hd192e819; K_ROM[45] = 32'hd6990624; K_ROM[46] = 32'hf40e3585; K_ROM[47] = 32'h106aa070;
        K_ROM[48] = 32'h19a4c116; K_ROM[49] = 32'h1e376c08; K_ROM[50] = 32'h2748774c; K_ROM[51] = 32'h34b0bcb5;
        K_ROM[52] = 32'h391c0cb3; K_ROM[53] = 32'h4ed8aa4a; K_ROM[54] = 32'h5b9cca4f; K_ROM[55] = 32'h682e6ff3;
        K_ROM[56] = 32'h748f82ee; K_ROM[57] = 32'h78a5636f; K_ROM[58] = 32'h84c87814; K_ROM[59] = 32'h8cc70208;
        K_ROM[60] = 32'h90befffa; K_ROM[61] = 32'ha4506ceb; K_ROM[62] = 32'hbef9a3f7; K_ROM[63] = 32'hc67178f2;
    end

    assign k_j = K_ROM[j];
endmodule
