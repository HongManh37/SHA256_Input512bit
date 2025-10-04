module sha256_scheduler (
    input wire clk,
    input wire rst,
    input wire [511:0] i_block,
    input wire i_enable,
    output reg [31:0] W_out
);

    parameter  IDLE = 2'd0,
               LOAD = 2'd1,
               GEN  = 2'd2; 
    wire [31:0] w_new;
    reg [1:0] state, next_state;
    reg [511:0] i_block_reg;
    reg [31:0] w_mem [0:15];
    reg [5:0] j;
    assign w_new = sigma1(w_mem[14]) + w_mem[9] + sigma0(w_mem[1]) + w_mem[0];


    function [31:0] sigma0(input [31:0] x);
        sigma0 = {x[6:0], x[31:7]} ^ {x[17:0], x[31:18]} ^ (x >> 3);
    endfunction

    function [31:0] sigma1(input [31:0] x);
        sigma1 = {x[16:0], x[31:17]} ^ {x[18:0], x[31:19]} ^ (x >> 10);
    endfunction

    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (i_enable) next_state = LOAD;
            end
            LOAD: begin
                if (j == 6'd15) begin
                    next_state = GEN;
                end;
            end

            GEN: begin
                if (j == 6'd63) begin
                    next_state = IDLE;
                end
            end
            default: next_state = state;
        endcase
    end

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            state <= IDLE;
            j <= 0;
            W_out <= 0;
            i_block_reg <= 0;
            w_mem[0]  <= 0;
            w_mem[1]  <= 0;
            w_mem[2]  <= 0;
            w_mem[3]  <= 0;
            w_mem[4]  <= 0;
            w_mem[5]  <= 0;
            w_mem[6]  <= 0;
            w_mem[7]  <= 0;
            w_mem[8]  <= 0;
            w_mem[9]  <= 0;
            w_mem[10] <= 0;
            w_mem[11] <= 0;
            w_mem[12] <= 0;
            w_mem[13] <= 0;
            w_mem[14] <= 0;
            w_mem[15] <= 0;
        end else begin
            state <= next_state;
            i_block_reg <= i_block;
            case (state)
                IDLE: begin
                    j <= 0;
                    W_out <= 0;
                end

                LOAD: begin
                    w_mem[j] <= i_block_reg[511 - j*32 -: 32];
                    W_out <= i_block_reg[511 - j*32 -: 32];
                    j <= j + 1;
                end

                GEN: begin
                    W_out <= w_new;
                    w_mem[0] <= w_mem[1];
                    w_mem[1] <= w_mem[2];
                    w_mem[2] <= w_mem[3];
                    w_mem[3] <= w_mem[4];
                    w_mem[4] <= w_mem[5];
                    w_mem[5] <= w_mem[6];
                    w_mem[6] <= w_mem[7];
                    w_mem[7] <= w_mem[8];
                    w_mem[8] <= w_mem[9];
                    w_mem[9] <= w_mem[10];
                    w_mem[10] <= w_mem[11];
                    w_mem[11] <= w_mem[12];
                    w_mem[12] <= w_mem[13];
                    w_mem[13] <= w_mem[14];
                    w_mem[14] <= w_mem[15];
                    w_mem[15] <= w_new;
                    if (j < 63) begin
                        j <= j + 1;
                    end
                end

                default: state <= next_state;
            endcase
        end
    end
    reg [60:0] display;
    always @(*) begin
        case(state)
            IDLE: display = "IDLE";
            LOAD: display = "LOAD";
            GEN:  display = "GEN ";
            default: display = "UNKNOW";
        endcase
    end

endmodule
