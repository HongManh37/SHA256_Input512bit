module sha_256(
    input wire i_clk,
    input wire i_rst,
    input wire i_enable,
    input [511:0] i_data,
    input [7:0] i_N,
    output reg [255:0] o_data,
    output reg o_done
);

    parameter IDLE = 2'd0,
              INITIAL = 2'd1,
              COMPRESS = 2'd2,
              FINISH = 2'd3;  
    reg [1:0] state, next_state;
    reg [31:0] a,b,c,d,e,f,g,h;
    reg [31:0] H [0:7];
    reg cnt_j_en, cnt_i_en;
    reg clr_j, clr_i;
    wire [31:0] w_out;
    wire [31:0] k_j;
    wire [6:0] counter_j;
    wire [7:0] counter_i;
    
    sha256_counter_j u_counter_j(
        .i_clk(i_clk),
        .i_rst(i_rst),
        .clr_j(clr_j),
        .cnt_j_en(cnt_j_en),
        .j(counter_j)
    );

    sha256_counter_i u_counter_i(
        .i_clk(i_clk),
        .i_rst(i_rst),
        .clr_i(clr_i),
        .cnt_i_en(cnt_i_en),
        .i(counter_i)
    );
    sha256_scheduler u_scheduler(
        .clk(i_clk),
        .rst(i_rst),
        .i_block(i_data),
        .i_enable(i_enable),
        .W_out(w_out)
    );

    sha256_functions u_functions (
        .j(counter_j),
        .k_j(k_j)
    );

    always @(*) begin
        clr_j   = 0;
        clr_i   = 0;
        cnt_i_en = 0;
        cnt_j_en = 0;
        next_state = state;
        case(state)
            IDLE: begin
                clr_j = 1;
                clr_i = 1;
                if (i_enable) next_state = INITIAL;
            end

            INITIAL: begin
                next_state = COMPRESS;
                cnt_i_en = 1;
            end

            COMPRESS: begin
                cnt_j_en = 1;
                if (counter_j == 7'd64) begin
                    next_state = FINISH;
                    clr_j = 1;
                    cnt_j_en = 0;
                end
            end

            FINISH: begin
                if (i_enable) next_state = INITIAL;
                else if(counter_i == i_N) next_state = IDLE;
            end
            default: next_state = state;
        endcase
        
    end

    always@(posedge i_clk or negedge i_rst) begin
        if(!i_rst) begin
            state <= IDLE;
            a <= 0; b <= 0; c <= 0; d <= 0; e <= 0; f <= 0; g <= 0; h <= 0;
            o_done <= 0;
            o_data <= 0;
            H[0] <= 32'h6a09e667;
            H[1] <= 32'hbb67ae85;
            H[2] <= 32'h3c6ef372;
            H[3] <= 32'ha54ff53a;
            H[4] <= 32'h510e527f;
            H[5] <= 32'h9b05688c;
            H[6] <= 32'h1f83d9ab;
            H[7] <= 32'h5be0cd19;
        end else begin
            state <= next_state;
            case(state)
                IDLE: begin
                    o_done <= 1;
                    a <= H[0]; b <= H[1];
                    c <= H[2]; d <= H[3];
                    e <= H[4]; f <= H[5];
                    g <= H[6]; h <= H[7];
                    if (i_enable) begin
                        o_done <= 0;
                    end
                    state <= next_state;
                end

                INITIAL: begin
                    o_done <= 0;
                    a <= H[0]; b <= H[1];
                    c <= H[2]; d <= H[3];
                    e <= H[4]; f <= H[5];
                    g <= H[6]; h <= H[7];
                    state <= next_state;
                end

                COMPRESS: begin
                    a <= t1 + t2;
                    b <= a;
                    c <= b;
                    d <= c;
                    e <= d + t1;
                    f <= e;
                    g <= f;
                    h <= g;
                    if (counter_j == 7'd64) begin
                        o_done <= 1;
                        H[0] <= a + H[0];
                        H[1] <= b + H[1];
                        H[2] <= c + H[2];
                        H[3] <= d + H[3];
                        H[4] <= e + H[4];
                        H[5] <= f + H[5];
                        H[6] <= g + H[6];
                        H[7] <= h + H[7];
                    end 
                    state <= next_state;
                end

                FINISH: begin
                    if (counter_i == i_N) begin
                        o_data <= {
                            H[0],
                            H[1],
                            H[2],
                            H[3],
                            H[4],
                            H[5],
                            H[6],
                            H[7]
                        };
                    end
                    state <= next_state;
                end
            endcase
        end
    end

    function [31:0] CH(input [31:0] e, f, g);
        CH = (e & f) ^ (~e & g);
    endfunction

    function [31:0] MAJ(input [31:0] a, b, c);
        MAJ = (a & b) ^ (a & c) ^ (b & c);
    endfunction

    function [31:0] SIG0(input [31:0] x);
        SIG0 = {x[1:0], x[31:2]} ^ {x[12:0], x[31:13]} ^ {x[21:0], x[31:22]};
    endfunction

    function [31:0] SIG1(input [31:0] x);
        SIG1 = {x[5:0], x[31:6]} ^ {x[10:0], x[31:11]} ^ {x[24:0], x[31:25]};
    endfunction
    wire [31:0] t1 = h + SIG1(e) + CH(e, f, g) + k_j + w_out;
    wire [31:0] t2 = SIG0(a) + MAJ(a, b, c);

    reg[8*8:0] DISPLAY;
    always@(*) begin
        case(state) 
            IDLE: DISPLAY = "IDLE";
            INITIAL: DISPLAY = "INITIAL";
            COMPRESS: DISPLAY = "COMPRESS";
            FINISH: DISPLAY = "FINISH";
            default: DISPLAY = "UNKNOW";
        endcase
    end
endmodule


