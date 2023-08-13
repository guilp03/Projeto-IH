module  multidivBasicVersion(
    input wire MDControl,
    input wire Reset,
    input wire clock,
    input wire [31:0] RegA_out,
    input wire [31:0] RegB_out,
    output reg [31:0] Hi,
    output reg [31:0] Lo,
    output reg divide_by_zero
);
   
    reg [31:0] A_int;
    reg [31:0] Q_int;
    reg Q1_int;
    reg Q_last_bit;
    reg aux_int;
    reg [31:0] M_int;
    reg [31:0] Quo_int;
    reg [31:0] Rest_int;
    reg [31:0] Temp_int;
    reg [5:0] contador_Mult_Div;

    initial begin
        contador_Mult_Div = 6'b000000;
    end

    always @(posedge clock) begin
        case(Reset)
            1'b1: begin
                Hi <= 32'b0;
                Lo <= 32'b0;
                contador_Mult_Div = 6'b000000;
                A_int = 0;
                Q_int = RegA_out;
                Q1_int = 0;
                M_int = RegB_out;
                divide_by_zero = 0;
                Quo_int = 0;
                Rest_int = 0;
                Temp_int = RegA_out;
            end
            1'b0: begin
                if (contador_Mult_Div == 6'b000000) begin
                    A_int = 0;
                    Q_int = RegA_out;
                    Q1_int = 0;
                    M_int = RegB_out;
                    divide_by_zero = 0;
                    Quo_int = 0;
                    Rest_int = 0;
                    Temp_int = RegA_out;
                end
                case(MDControl)
                    1'b0: begin //multiplicação
                        if (contador_Mult_Div < 32) begin
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
                            Q_int = {aux_int, Q_int[31:1]};
                        end
                        if (contador_Mult_Div == 32) begin
                            Hi = A_int;
                            Lo = Q_int;
                        end
                        contador_Mult_Div = contador_Mult_Div + 1;
                    end
                    1'b1: begin //divisao
                        if (RegB_out == 0) begin
                            divide_by_zero = 1'b1;
                        end
                        else begin
                            if (contador_Mult_Div < 32) begin
                                Rest_int = Rest_int << 1;
                                Rest_int[0] = Temp_int[31];
                                Temp_int = Temp_int << 1;
                                if (Rest_int >= 0) begin
                                    Rest_int = Rest_int - RegB_out;
                                    Quo_int[contador_Mult_Div] = 1;
                                end
                                else begin
                                    Quo_int[contador_Mult_Div] = 0;
                                end
                                contador_Mult_Div = contador_Mult_Div + 1;
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
