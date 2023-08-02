module  Multdiv(
    input wire MultDiv_cntrl,
    input wire Reset,
    input wire Clk,
    input wire [31:0] RegA,
    input wire [31:0] RegB,
    output reg [31:0] Hi,
    output reg [31:0] Lo,
    output reg divide_by_zero
);
    reg [5:0] contador_mult;
    reg [31:0] A_int;
    reg [31:0] Q_int;
    reg Q1_int;
    reg Q_last_bit;
    reg aux_int;
    reg [31:0] M_int;
    reg [5:0] contador_div;
    reg [31:0] Quo_int;
    reg [31:0] Rest_int;
    reg [31:0] Temp_int;

    initial begin
        contador_mult = 32;
        A_int = 0;
        Q_int = RegA;
        Q1_int = 0;
        M_int = RegB;
        divide_by_zero = 0;
        contador_div = 0;
        Quo_int = 0;
        Rest_int = 0;
        Temp_int = RegA;
    end

    always @(posedge Clk) begin
        case(Reset)
            1'b1: begin
                Hi <= 32'b0;
                Lo <= 32'b0;
                contador_mult = 32;
                A_int = 0;
                Q_int = RegA;
                Q1_int = 0;
                M_int = RegB;

                divide_by_zero = 0;
                contador_div = 0;
                Quo_int = 0;
                Rest_int = 0;
                Temp_int = RegA;
            end
            1'b0: begin
                case(MultDiv_cntrl)
                    1'b0: begin //multiplicação
                        if (contador_mult > 0) begin
                            Q_last_bit = Q_int[0];
                            if (Q_last_bit > Q1_int) begin
                                A_int = A_int - M_int;
                            end
                            else if (Q1_int >  Q_last_bit) begin
                                A_int = A_int + M_int;
                            end
                            Q1_int = Q_last_bit;
                            aux_int = A_int[0];
                            A_int = {A_int[31], A_int[31], A_int[30:1]};
                            Q1_int = {aux_int, Q_int[31:1]};
                        end
                        if (contador_mult == 0) begin
                            Hi = A_int;
                            Lo = Q_int;
                        end
                        contador_mult = contador_mult - 1;
                    end
                    1'b1: begin //divisao
                        if (RegB == 0) begin
                            divide_by_zero = 1'b1;
                        end
                        else begin
                            if (contador_div < 32) begin
                                Rest_int = Rest_int << 1;
                                Rest_int[0] = Temp_int[31];
                                Temp_int = Temp_int << 1;
                                if (Rest_int >= 0) begin
                                    Rest_int = Rest_int - RegB;
                                    Quo_int[contador_div] = 1;
                                end
                                else begin
                                    Quo_int[contador_div] = 0;
                                end
                                contador_div = contador_div + 1;
                            end
                            else begin
                                Hi = Rest_int;
                                Lo = Quo_int;
                            end
                        end
                    end
                endcase
            end
        endcase
    end
endmodule                    
