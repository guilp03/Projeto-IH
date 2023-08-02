module Unid_Controle (
        input wire clock,
        input wire reset,
        // Flags
        input wire EQ,
        input wire GT,
        input wire Overflow,
        input wire ZR,
        input wire LT,
        input wire NG,

        //Código
        input wire [31:26] OPCODE,
        input wire [15:0] OFFSET,

        //Sinais de controle
        output reg WriteMemControl,
        output reg IRWriteControl,
        output reg [2:0] ShiftRegControl,
        output reg RegWriteControl,
        output reg [2:0] ALUControl,
        output reg PcControl,
        output reg HI_writeControl,
        output reg LO_writeControl,
        output reg RegAControl,
        output reg RegBControl,
        output reg ALUOutControl,
        output reg WriteMDRControl,
        output reg EpcControl,
        output reg [1:0] EX_control,
        output reg [1:0] PcSourceControl,
        output reg [2:0] IorDControl,
        output reg [1:0] RegDstControl,
        output reg [1:0] ShiftAmtControl,
        output reg [1:0] ShiftSrcControl,
        output reg [2:0] DataSrcControl,
        output reg [1:0] ALUSrcAControl,
        output reg [1:0] ALUSrcBControl,
        output reg [1:0] SSControl,
        output reg [1:0] LScontrol,
        output reg reset_out
    );

    reg [5:0] contador; // Contar os ciclos
    reg [5:0] estado;  // Armazenar o estado

    //Estados
    parameter Es_Comum = 6'b000001;

    parameter Es_Add = 6'b000010;
    parameter Es_And = 6'b000011;
    parameter Es_Mult = 6'b000100;
    parameter Es_Div = 6'b000101;
    parameter Es_Jr = 6'b000110;
    parameter Es_Mfhi = 6'b00111;
    parameter Es_Mflo = 6'b001000;
    parameter Es_Sll = 6'b001001;
    parameter Es_Sllv = 6'b001010;
    parameter Es_Slt = 6'b001011;
    parameter Es_Sra = 6'b001100;
    parameter Es_Srav = 6'b001101;
    parameter Es_Srl = 6'b001110;
    parameter Es_Sub = 6'b001111;
    parameter Es_Break = 6'b010000;
    parameter Es_Rte = 6'b010001;
    parameter Es_Divm = 6'b010010;
    parameter Es_Addi = 6'b010011;
    parameter Es_Addiu = 6'b010100;
    parameter Es_Beq = 6'b010101;
    parameter Es_Bne = 6'b010110;
    parameter Es_Ble = 6'b010111;
    parameter Es_Bgt = 6'b011000;
    parameter Es_Addm = 6'b011001;
    parameter Es_Lb = 6'b011010;
    parameter Es_Lh = 6'b011011;
    parameter Es_Lui = 6'b011100;
    parameter Es_Lw = 6'b011101;
    parameter Es_Sb = 6'b011110;
    parameter Es_Sh = 6'b011111;
    parameter Es_Slti = 6'b100000;
    parameter Es_Sw = 6'b100001;
    parameter Es_J = 6'b100010;
    parameter Es_Jal = 6'b100011;

    parameter Es_Op404 = 6'b100100;
    parameter Es_Overflow = 6'b100101;
    parameter Es_DivZero= 6'b100110;

    //Tipo R
    parameter R = 6'b000000;
    
    parameter Funct_Add = 6'b100000;
    parameter Funct_And = 6'b100100;
    parameter Funct_Div = 6'b011010;
    parameter Funct_Mult = 6'b011000;
    parameter Funct_Jr = 6'b001000;
    parameter Funct_Mfhi = 6'b010000;
    parameter Funct_Mflo = 6'b010010;
    parameter Funct_Sll = 6'b000000;
    parameter Funct_Sllv = 6'b000100;
    parameter Funct_Slt = 6'b101010;
    parameter Funct_Sra = 6'b000011;
    parameter Funct_Srav = 6'b000111;
    parameter Funct_Srl = 6'b000010;
    parameter Funct_Sub = 6'b100010;
    parameter Funct_Break = 6'b001101;
    parameter Funct_Rte = 6'b010011;
    parameter Funct_Divm = 6'b000101;

    //Tipo I

    parameter Op_Addi = 6'b001000;
    parameter Op_Addiu = 6'b001001;
    parameter Op_Beq = 6'b000100;
    parameter Op_Bne = 6'b000101;
    parameter Op_Ble = 6'b000110;
    parameter Op_Bgt = 6'b000111;
    parameter Op_Addm = 6'b000001;
    parameter Op_Lb = 6'b100000;
    parameter Op_Lh = 6'b100001;
    parameter Op_Lw = 6'b100011;
    parameter Op_Sb = 6'b101000;
    parameter Op_Sh = 6'b101001;
    parameter Op_Sw = 6'b101011;
    parameter Op_Slti = 6'b001010;
    parameter Op_Lui = 6'b001111;

    //Tipo J

    parameter Op_J = 6'b000010;
    parameter Op_Jal = 6'b000011;

    //Reset
    parameter In_Reset = 6'b111111
    parameter Es_Reset = 6'b111111;

    initial begin
        reset_out = 1'b1;
    end

    //Código
    always @(posedge clk) begin
        if(reset = 1'b1)begin
            if(estado != Es_Reset)begin
                estado = Es_Reset;

                WriteMemControl = 1'b0;
                IRWriteControl = 1'b0;
                ShiftRegControl = 3'b000;
                ALUControl = 3'b000;
                PcControl = 1'b0;
                HI_writeControl = 1'b0;
                LO_writeControl = 1'b0;
                RegAControl = 1'b0;
                RegBControl = 1'b0;
                ALUOutControl = 1'b0;
                WriteMDRControl = 1'b0;
                EpcControl = 1'b0;
                EX_control = 2'b00;
                PcSourceControl = 2'b00;
                IorDControl = 3'b000;
                ShiftAmtControl = 2'b00;
                ShiftSrcControl = 2'b00;
                DataSrcControl = 3'b100; ///
                ALUSrcAControl = 2'b00;
                ALUSrcBControl = 2'b00;
                SSControl = 2'b00;
                LScontrol = 2'b00;
                reset_out = 1'b1; ///
                RegDstControl = 2'b00; ///
                RegWriteControl = 1'b1; ///

                contador = 6'b000000;


            end else begin
                estado = Es_Comum;

                WriteMemControl = 1'b0;
                IRWriteControl = 1'b0;
                ShiftRegControl = 3'b000;
                ALUControl = 3'b000;
                PcControl = 1'b0;
                HI_writeControl = 1'b0;
                LO_writeControl = 1'b0;
                RegAControl = 1'b0;
                RegBControl = 1'b0;
                ALUOutControl = 1'b0;
                WriteMDRControl = 1'b0;
                EpcControl = 1'b0;
                EX_control = 1'b0;
                PcSourceControl = 2'b00;
                IorDControl = 3'b000;
                ShiftAmtControl = 2'b00;
                ShiftSrcControl = 2'b00;
                DataSrcControl = 3'b000; ///
                ALUSrcAControl = 2'b00;
                ALUSrcBControl = 2'b00;
                SSControl = 2'b00;
                LScontrol = 2'b00;
                reset_out = 1'b0; ///
                RegDstControl = 2'b00; ///
                RegWriteControl = 1'b0; ///

                contador = contador + 1;
            end

        end else begin
            case(estado):
                Es_Comum: begin
                    if (contador == 6'b000000 || contador == 6'b000001 || contador = 6'b000010)begin
                        estado = Es_Comum;

                        WriteMemControl = 1'b0; ///
                        IRWriteControl = 1'b0;
                        ShiftRegControl = 3'b000;
                        ALUControl = 3'b001; ///
                        PcControl = 1'b0;
                        HI_writeControl = 1'b0;
                        LO_writeControl = 1'b0;
                        RegAControl = 1'b0;
                        RegBControl = 1'b0;
                        ALUOutControl = 1'b0; 
                        WriteMDRControl = 1'b0;
                        EpcControl = 1'b0;
                        EX_control = 1'b0; ///
                        PcSourceControl = 2'b01; ///
                        IorDControl = 3'b000; ///
                        ShiftAmtControl = 2'b00;
                        ShiftSrcControl = 2'b00;
                        DataSrcControl = 3'b100;
                        ALUSrcAControl = 2'b01; ///
                        ALUSrcBControl = 3'b01; ///
                        SSControl = 2'b00;
                        LScontrol = 2'b00;
                        reset_out = 1'b0;
                        RegDstControl = 2'b00;
                        RegWriteControl = 1'b0;

                        contador = contador + 1;

                    end
                    
                    else if (contador == 6'b000011)begin
                        estado = Es_Comum;

                        IRWriteControl = 1'b1; 
                        PcControl = 1'b1; 

                        contador = contador + 1;
                        
                    end

                    else if (contador == 6'b000100) begin
                        estado = Es_Comum;

                        IRWriteControl = 1'b0; 
                        ALUControl = 3'b001; 
                        PcControl = 1'b0; 
                        RegAControl = 1'b1; 
                        RegBControl = 1'b1; 
                        ALUOutControl = 1'b1; 
                        ALUSrcAControl = 2'b01; 
                        ALUSrcBControl = 3'b11; 

                        contador = contador + 1;

                    end

                    else if (contador == 6'b000110) begin
                        case(OPCODE):
                            R: begin
                                case (OFFSET[5:0]): /// Funct
                                    Funct_Add: begin
                                        estado = Es_Add;
                                    end

                                    Funct_And: begin
                                        estado = Es_And;
                                    end

                                    Funct_Mult: begin
                                        estado = Es_Mult;
                                    end

                                    Funct_Div: begin
                                        estado = Es_Div;
                                    end

                                    Funct_Jr: begin
                                        estado = Es_Jr;
                                    end

                                    Funct_Mfhi: begin
                                        estado = Es_Mfhi;
                                    end

                                    Funct_Mflo: begin
                                        estado = Es_Mflo;
                                    end

                                    Funct_Sll: begin
                                        estado = Es_Sll;
                                    end

                                    Funct_Sllv: begin
                                        estado = Es_Sllv;
                                    end

                                    Funct_Slt: begin
                                        estado = Es_Slt;
                                    end

                                    Funct_Sra: begin
                                        estado = Es_Sra;
                                    end

                                    Funct_Srav: begin
                                        estado = Es_Srav;
                                    end

                                    Funct_Srl: begin
                                        estado = Es_Srl;
                                    end

                                    Funct_Sub: begin
                                        estado = Es_Sub;
                                    end

                                    Funct_Break: begin
                                        estado = Es_Break;
                                    end

                                    Funct_Rte: begin
                                        estado = Es_Rte;
                                    end 

                                    Funct_Divm: begin
                                        estado = Es_Divm;
                                    end

                                endcase
                            end

                            In_Reset: begin
                                estado = Es_Reset;
                            end

                            Op_Addi: begin
                                estado = Es_Addi;
                            end

                            Op_Addiu: begin
                                estado = Es_Addiu;
                            end

                            Op_Beq: begin
                                estado = Es_Beq;
                            end

                            Op_Bne: begin
                                estado = Es_Bne;
                            end

                            Op_Ble: begin
                                estado = Es_Ble;
                            end

                            Op_Bgt: begin
                                estado = Es_Bgt;
                            end

                            Op_Addm: begin
                                estado = Es_Addm;
                            end

                            Op_Lb: begin
                                estado = Es_Lb;
                            end

                            Op_Lh: begin
                                estado = Es_Lh;
                            end

                            Op_Lw: begin
                                estado = Es_Lw;
                            end

                            Op_Lui: begin
                                estado = Es_Lui;
                            end

                            Op_Sh: begin
                                estado = Es_Sh;
                            end

                            Op_Sb: begin
                                estado = Es_Sb;
                            end

                            Op_Sw: begin
                                estado = Es_Sw;
                            end

                            Op_Slti: begin
                                estado = Es_Slti;
                            end

                            Op_J: begin
                                estado = Es_J;
                            end
                            
                            Op_Jal: begin
                                estado = Es_Jal;
                            end
                    
                        endcase

                        WriteMemControl = 1'b0; 
                        IRWriteControl = 1'b0; 
                        ShiftRegControl = 3'b000;
                        ALUControl = 3'b000; /// 
                        PcControl = 1'b0; 
                        HI_writeControl = 1'b0;
                        LO_writeControl = 1'b0;
                        RegAControl = 1'b0; ///
                        RegBControl = 1'b0; ///
                        ALUOutControl = 1'b0; ///
                        WriteMDRControl = 1'b0;
                        EpcControl = 1'b0;
                        EX_control = 1'b0;
                        PcSourceControl = 2'b01; 
                        IorDControl = 3'b000; 
                        ShiftAmtControl = 2'b00;
                        ShiftSrcControl = 2'b00;
                        DataSrcControl = 3'b000;
                        ALUSrcAControl = 2'b00; 
                        ALUSrcBControl = 2'b00; 
                        SSControl = 2'b00;
                        LScontrol = 2'b00;
                        reset_out = 1'b0;
                        RegDstControl = 2'b00;
                        RegWriteControl = 1'b0;

                        contador = 6'b000000;
                    end
                end

                Es_Break: begin
                    if (contador == 6'b000000) begin
                        estado = Es_Break;

                        ALUControl = 3'b010;  
                        EX_control = 1'b0; 
                        PcSourceControl = 2'b01; 
                        ALUSrcAControl = 2'b01; 
                        ALUSrcBControl = 2'b01; 

                        contador = contador + 1;
                    end

                    else begin
                        estado = Es_Comum;

                        PcControl = 1'b1;

                        contador = 6'b000000;
                    end

                end
                Es_Sw, Es_Sh, Es_Sb: begin
                    if(contador == 6'b000000) begin
                        WriteMemControl = 1'b0;
                        IRWriteControl = 1'b0;
                        ShiftRegControl = 3'b000;
                        ALUControl = 3'b001; //
                        PcControl = 1'b0;
                        HI_writeControl = 1'b0;
                        LO_writeControl = 1'b0;
                        RegAControl = 1'b0; //
                        RegBControl = 1'b0; //
                        ALUOutControl = 1'b1; //
                        WriteMDRControl = 1'b0;
                        EpcControl = 1'b0;
                        EX_control = 1'b0;
                        PcSourceControl = 2'b00;
                        IorDControl = 3'b000;
                        ShiftAmtControl = 2'b00;
                        ShiftSrcControl = 2'b00;
                        DataSrcControl = 3'b000;
                        ALUSrcAControl = 2'b10; //
                        ALUSrcBControl = 3'b001; //
                        SSControl = 2'b00;
                        LScontrol = 2'b00;
                        reset_out = 1'b0;
                        RegDstControl = 2'b00;
                        RegWriteControl = 1'b0;
                        
                        contador = contador + 1
                    end 
                    else if (contador == 6'b000001 | contador == 6'b000010 |contador == 6'b000011)begin
                        WriteMemControl = 1'b0; //
                        IRWriteControl = 1'b0;
                        ShiftRegControl = 3'b000;
                        ALUControl = 3'b001;
                        PcControl = 1'b0;
                        HI_writeControl = 1'b0;
                        LO_writeControl = 1'b0;
                        RegAControl = 1'b0;
                        RegBControl = 1'b0;
                        ALUOutControl = 1'b0; //
                        WriteMDRControl = 1'b0;
                        EpcControl = 1'b0;
                        EX_control = 1'b0;
                        PcSourceControl = 2'b00;
                        IorDControl = 3'b110; //
                        ShiftAmtControl = 2'b00;
                        ShiftSrcControl = 2'b00;
                        DataSrcControl = 3'b000;
                        ALUSrcAControl = 2'b10;
                        ALUSrcBControl = 3'b001;
                        SSControl = 2'b00;
                        LScontrol = 2'b00;
                        reset_out = 1'b0;
                        RegDstControl = 2'b00;
                        RegWriteControl = 1'b0;

                        contador = contador + 1;
                        end
                    else if (contador == 6'b000100)begin
                        case(estado):
                        Es_Sw:begin

                        estado = Es_Comum;

                        WriteMemControl = 1'b1; //
                        IRWriteControl = 1'b0;
                        ShiftRegControl = 3'b000;
                        ALUControl = 3'b001;
                        PcControl = 1'b0;
                        HI_writeControl = 1'b0;
                        LO_writeControl = 1'b0;
                        RegAControl = 1'b0;
                        RegBControl = 1'b0;
                        ALUOutControl = 1'b0;
                        WriteMDRControl = 1'b0;
                        EpcControl = 1'b0;
                        EX_control = 1'b0;
                        PcSourceControl = 2'b00;
                        IorDControl = 3'b110;
                        ShiftAmtControl = 2'b00;
                        ShiftSrcControl = 2'b00;
                        DataSrcControl = 3'b000;
                        ALUSrcAControl = 2'b10;
                        ALUSrcBControl = 3'b001;
                        SSControl = 2'b01; //
                        LScontrol = 2'b00;
                        reset_out = 1'b0;
                        RegDstControl = 2'b00;
                        RegWriteControl = 1'b0;

                        contador = 6'b000000;
                        end

                        Es_Sh:begin
                            estado = Es_Comum;

                            WriteMemControl = 1'b1; //
                            IRWriteControl = 1'b0;
                            ShiftRegControl = 3'b000;
                            ALUControl = 3'b001;
                            PcControl = 1'b0;
                            HI_writeControl = 1'b0;
                            LO_writeControl = 1'b0;
                            RegAControl = 1'b0;
                            RegBControl = 1'b0;
                            ALUOutControl = 1'b0;
                            WriteMDRControl = 1'b0;
                            EpcControl = 1'b0;
                            EX_control = 1'b0;
                            PcSourceControl = 2'b00;
                            IorDControl = 3'b110;
                            ShiftAmtControl = 2'b00;
                            ShiftSrcControl = 2'b00;
                            DataSrcControl = 3'b000;
                            ALUSrcAControl = 2'b10;
                            ALUSrcBControl = 3'b001;
                            SSControl = 2'b11; //
                            LScontrol = 2'b00;
                            reset_out = 1'b0;
                            RegDstControl = 2'b00;
                            RegWriteControl = 1'b0;

                            contador = 6'b000000;
                        end

                        Es_Sb:begin
                            estado = Es_Comum;

                            WriteMemControl = 1'b1; //
                            IRWriteControl = 1'b0;
                            ShiftRegControl = 3'b000;
                            ALUControl = 3'b001;
                            PcControl = 1'b0;
                            HI_writeControl = 1'b0;
                            LO_writeControl = 1'b0;
                            RegAControl = 1'b0;
                            RegBControl = 1'b0;
                            ALUOutControl = 1'b0;
                            WriteMDRControl = 1'b0;
                            EpcControl = 1'b0;
                            EX_control = 1'b0;
                            PcSourceControl = 2'b00;
                            IorDControl = 3'b110;
                            ShiftAmtControl = 2'b00;
                            ShiftSrcControl = 2'b00;
                            DataSrcControl = 3'b000;
                            ALUSrcAControl = 2'b10;
                            ALUSrcBControl = 3'b001;
                            SSControl = 2'b10; //
                            LScontrol = 2'b00;
                            reset_out = 1'b0;
                            RegDstControl = 2'b00;
                            RegWriteControl = 1'b0;

                            contador = 6'b000000;
                        end
                        endcase
                    end
                end
            endcase
        end
    end
endmodule