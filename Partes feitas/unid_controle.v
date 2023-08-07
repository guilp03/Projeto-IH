module unid_controle(
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
        output reg EX_control,
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
        output reg MDSrcAControl,
        output reg MDSrcBControl,
        output reg MDControl,
        output reg reset_out
    );

    reg [5:0] contador; // Contar os ciclos
    reg [5:0] estado;  // Armazenar o estado

    //Estados
    parameter Es_Leitura_1 = 6'b000000;
    parameter Es_Leitura_2 = 6'b000001;
    parameter Es_Escrita = 6'b000010;
    parameter Es_Calc_Branch = 6'b000011;
    parameter Es_Instr = 6'b000100;

    parameter Es_Add = 6'b000101;    // 000010 + 2 = 000101
    parameter Es_And = 6'b000110;    // 000011 + 2 = 000110
    parameter Es_Mult = 6'b000111;   // 000100 + 2 = 000111
    parameter Es_Div = 6'b001000;    // 000101 + 2 = 001000
    parameter Es_Jr = 6'b001001;     // 000110 + 2 = 001001
    parameter Es_Mfhi = 6'b01010;    // 00111 + 2 = 01010
    parameter Es_Mflo = 6'b010011;   // 01000 + 2 = 010011
    parameter Es_Sll = 6'b010100;    // 01001 + 2 = 010100
    parameter Es_Sllv = 6'b010101;   // 01010 + 2 = 010101
    parameter Es_Slt = 6'b010110;    // 01011 + 2 = 010110
    parameter Es_Sra = 6'b010111;    // 010100 + 2 = 010111
    parameter Es_Srav = 6'b011000;   // 010101 + 2 = 011000
    parameter Es_Srl = 6'b011001;    // 010110 + 2 = 011001
    parameter Es_Sub = 6'b011010;    // 010111 + 2 = 011010
    parameter Es_Break = 6'b011011;  // 011000 + 2 = 011011
    parameter Es_Rte = 6'b011100;    // 011001 + 2 = 011100
    parameter Es_Divm = 6'b011101;   // 011010 + 2 = 011101
    parameter Es_Addi = 6'b011110;   // 011011 + 2 = 011110
    parameter Es_Addiu = 6'b011111;  // 011100 + 2 = 011111
    parameter Es_Beq = 6'b100000;    // 011101 + 2 = 100000
    parameter Es_Bne = 6'b100001;    // 011110 + 2 = 100001
    parameter Es_Ble = 6'b100010;    // 011111 + 2 = 100010
    parameter Es_Bgt = 6'b100011;    // 100000 + 2 = 100011
    parameter Es_Addm = 6'b100100;   // 100001 + 2 = 100100
    parameter Es_Lb = 6'b100101;     // 100010 + 2 = 100101
    parameter Es_Lh = 6'b100110;     // 100011 + 2 = 100110
    parameter Es_Lui = 6'b100111;    // 100100 + 2 = 100111
    parameter Es_Lw = 6'b101000;     // 100101 + 2 = 101000
    parameter Es_Sb = 6'b101001;     // 100110 + 2 = 101001
    parameter Es_Sh = 6'b101010;     // 100111 + 2 = 101010
    parameter Es_Slti = 6'b101011;   // 101000 + 2 = 101011
    parameter Es_Sw = 6'b101100;     // 101001 + 2 = 101100
    parameter Es_J = 6'b101101;      // 101010 + 2 = 101101
    parameter Es_Jal = 6'b101110;    // 101011 + 2 = 101110
    parameter Es_Op404 = 6'b101111;  // 101100 + 2 = 101111
    parameter Es_Overflow = 6'b110000; // 101101 + 2 = 110000
    parameter Es_DivZero= 6'b110001;  // 101110 + 2 = 110001

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
    parameter Es_Reset = 6'b111111;

    initial begin
        reset_out = 1'b1;
    end

    //Código
    always @(posedge clock) begin
        if(reset_out)begin
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

            end 
            else begin
                estado = Es_Leitura_1;

                DataSrcControl = 3'b000; ///
                reset_out = 1'b0; ///
                RegDstControl = 2'b00; ///
                RegWriteControl = 1'b0; ///

                reset_out = 1'b0;

                contador = 6'b000000;
            end
        end 

        else begin
            case(estado)
                Es_Leitura_1: begin                
                    WriteMemControl = 1'b0; ///
                    ALUControl = 3'b001; ///
                    EX_control = 1'b0; ///
                    PcSourceControl = 2'b01; ///
                    IorDControl = 3'b000; ///
                    ALUSrcAControl = 2'b01; ///
                    ALUSrcBControl = 3'b01; ///

                    contador = contador + 1;
                    estado = Es_Leitura_2;
                end

                Es_Leitura_2: begin
                    contador = contador + 1;
                    estado = Es_Escrita;                  
                end

                Es_Escrita: begin                      
                    IRWriteControl = 1'b1; 
                    PcControl = 1'b1; 

                    contador = contador + 1;
                    estado = Es_Calc_Branch;                      
                end

                Es_Calc_Branch: begin
                    IRWriteControl = 1'b0; 
                    ALUControl = 3'b001; 
                    PcControl = 1'b0; 
                    RegAControl = 1'b1; 
                    RegBControl = 1'b1; 
                    ALUOutControl = 1'b1; 
                    ALUSrcAControl = 2'b01; 
                    ALUSrcBControl = 3'b11; 

                    contador = contador + 1;
                    estado = Es_Instr;
                end

                Es_Instr: begin
                    ALUOutControl = 1'b0;
                    RegAControl = 1'b0; 
                    RegBControl = 1'b0; 

                    case(OPCODE)
                        R: begin
                            case (OFFSET[5:0]) /// Funct
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

                        reset: begin
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

                    contador = 6'b000000;
                end

                Es_Add: begin
                    if (contador == 6'b000000) begin
                        ALUControl = 3'b001;  
                        ALUSrcAControl = 2'b10; 
                        ALUSrcBControl = 2'b10; 
                        ALUOutControl = 1'b1;

                        contador = contador + 1;
                        estado = Es_Add;
                    end

                    else if (contador == 6'b000001) begin
                        ALUOutControl = 1'b0;
                        RegDstControl = 2'b11;
                        DataSrcControl = 3'b100;
                        RegWriteControl = 1'b1;

                        contador = contador + 1;
                        estado = Es_Add;
                    end

                    else if (contador == 6'b000010) begin
                        estado = Es_Leitura_1;

                        RegWriteControl = 1'b0;

                        contador = 6'b000000;
                    end
                end

                Es_Sub: begin
                    if (contador == 6'b000000) begin
                        estado = Es_Sub;

                        ALUControl = 3'b010;  
                        ALUSrcAControl = 2'b10; 
                        ALUSrcBControl = 2'b10; 
                        ALUOutControl = 1'b1;

                        contador = contador + 1;
                    end

                    if (contador == 6'b000001) begin
                        estado = Es_Sub;

                        ALUOutControl = 1'b0;
                        RegDstControl = 2'b11;
                        DataSrcControl = 3'b100;
                        RegWriteControl = 1'b1;

                        contador = contador + 1;
                    end

                    if (contador == 6'b000010) begin
                        estado = Es_Leitura_1;

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
                        PcControl = 1'b1;

                        contador = contador + 1;
                    end

                    else begin
                        estado = Es_Leitura_1;

                        PcControl = 1'b0;

                        contador = 6'b000000;
                    end
                end

                Es_Rte: begin
                    if (contador == 6'b000000) begin
                        estado = Es_Rte;

                        PcSourceControl = 2'b11;
                        EX_control = 1'b0;
                        PcControl = 1'b1;

                        contador = contador + 1;
                    end    

                    else begin
                        estado = Es_Leitura_1;

                        PcControl = 1'b0;

                        contador = 6'b000000;
                    end
                end

                Es_Addm: begin
                    if (contador == 6'b000000) begin
                        estado = Es_Addm;

                        ALUSrcAControl = 2'b10;
                        ALUSrcBControl = 2'b00;
                        ALUControl = 3'b001;
                        ALUOutControl = 1'b1;

                        contador = contador + 1;
                    end    

                    if (contador == 6'b000001 || contador == 6'b000010) begin
                        estado = Es_Addm;

                        ALUOutControl = 1'b0;
                        IorDControl = 3'b100;
                        WriteMemControl = 1'b0;

                        contador = contador + 1;
                    end

                    if (contador == 6'b000011) begin
                        estado = Es_Addm;

                        WriteMDRControl = 1'b1;

                        contador = contador + 1;
                    end

                    if (contador == 6'b000100) begin
                        estado = Es_Addm;

                        WriteMDRControl = 1'b0;
                        ALUSrcAControl = 2'b11;
                        ALUSrcBControl = 2'b10;
                        ALUControl = 3'b001;
                        ALUOutControl = 1'b1;

                        contador = contador + 1;
                    end

                    if (contador == 6'b000101 || contador == 6'b000111) begin
                        estado = Es_Addm;

                        ALUOutControl = 1'b0;
                        DataSrcControl = 3'b110;
                        RegDstControl = 2'b01;
                        RegWriteControl = 1'b1;

                        contador = contador + 1;
                    end

                    else begin
                        estado = Es_Leitura_1;

                        RegWriteControl = 1'b0;

                        contador = 6'b000000;
                    end
                end

                Es_Divm: begin
                    if(contador == 6'b000000 || contador == 6'b000001) begin        
                        estado = Es_Divm;

                        IorDControl = 3'b101;
                        WriteMemControl = 1'b0;

                        contador = contador + 1;
                    end

                    if(contador == 6'b000010) begin
                        estado = Es_Divm;

                        WriteMDRControl = 1'b1;

                        contador = contador + 1;
                    end

                    if(contador == 6'b000011 || contador == 6'b000100) begin        
                        estado = Es_Divm;

                        WriteMDRControl = 1'b0;
                        IorDControl = 3'b110;
                        WriteMemControl = 1'b0;

                        contador = contador + 1;
                    end

                    if(contador <= 6'b100110) begin
                        estado = Es_Divm;

                        MDSrcAControl = 1'b1;
                        MDSrcBControl = 1'b1;
                        MDControl = 1'b1;

                        contador = contador + 1;
                    end

                    if(contador == 6'b100111) begin
                        estado = Es_Divm;

                        HI_writeControl = 1'b1;
                        LO_writeControl = 1'b1;

                        contador = contador + 1;
                    end

                    if(contador == 6'b101000) begin
                        estado = Es_Leitura_1;

                        HI_writeControl = 1'b0;
                        LO_writeControl = 1'b0;

                        contador = 6'b000000;
                    end

                end

                // Es_Sw, Es_Sh, Es_Sb: begin
                //     if(contador == 6'b000000) begin

                //         ALUControl = 3'b001; //
                //         RegAControl = 1'b0; //
                //         RegBControl = 1'b0; //
                //         ALUOutControl = 1'b1; //
                //         ALUSrcAControl = 2'b10; //
                //         ALUSrcBControl = 3'b001; //
                        
                //         contador = contador + 1;
                //     end 

                //     if (contador == 6'b000001 | contador == 6'b000010 |contador == 6'b000011)begin
                //         WriteMemControl = 1'b0; //
                //         ALUOutControl = 1'b0; //
                //         IorDControl = 3'b110; //

                //         contador = contador + 1;
                //         end

                //     if (contador == 6'b000100)begin
                //         case(estado)
                //             Es_Sw:begin
                //                 estado = Es_Leitura_1;

                //                 WriteMemControl = 1'b1; //
                //                 SSControl = 2'b01; //

                //             contador = 6'b000000;
                //             end

                //             Es_Sh:begin
                //                 estado = Es_Leitura_1;

                //                 WriteMemControl = 1'b1; //
                //                 SSControl = 2'b11; //

                //                 contador = 6'b000000;
                //             end

                //             Es_Sb:begin
                //                 estado = Es_Leitura_1;

                //                 WriteMemControl = 1'b1; //
                //                 SSControl = 2'b10; //

                //                 contador = 6'b000000;
                //             end
                //         endcase
                //     end
                // end

                // Es_Lb, Es_Lh, Es_Lw:begin
                //     if (contador == 6'b000000) begin                       

                //         ALUControl = 3'b001; //
                //         RegAControl = 1'b0; //
                //         RegBControl = 1'b0; //
                //         ALUOutControl = 1'b1; //
                //         ALUSrcAControl = 2'b10; //
                //         ALUSrcBControl = 3'b011; //

                //         contador = contador + 1;
                //     end

                //     else if(contador == 6'b000001 || contador == 6'b000010 || contador == 6'000011) begin
                //         WriteMemControl = 1'b0; //
                //         ALUOutControl = 1'b0; //
                //         IorDControl = 3'b110; //

                //         contador = contador + 1;
                //     end

                //     else if(contador == 6'b000100)begin
                //         case(estado)
                //             Es_lw:begin
                //                 estado = Es_Leitura_1;

                //                 DataSrcControl = 3'b111; //
                //                 LScontrol = 2'b01; //
                //                 RegDstControl = 2'b11; //
                //                 RegWriteControl = 1'b1; //

                //                 contador = 6'b000000;
                //             end
                //             Es_Lb:begin
                //                 estado = Es_Leitura_1;

                //                 DataSrcControl = 3'b111; //
                //                 LScontrol = 2'b10; //
                //                 RegDstControl = 2'b11; //
                //                 RegWriteControl = 1'b1; //

                //                 contador = 6'b000000;
                //             end
                //             Es_Lh:begin
                //                 estado = Es_Leitura_1;

                //                 DataSrcControl = 3'b111; //
                //                 LScontrol = 2'b11; //
                //                 RegDstControl = 2'b11; //
                //                 RegWriteControl = 1'b1; //

                //                 contador = 6'b000000;
                //             end
                            
                //             Es_Lui:begin
                //                 if(contador == 6'b000000)begin
                //                 estado = Es_Leitura_1;

                //                 DataSrcControl = 3'b101; //
                //                 RegDstControl = 2'b01; //
                //                 RegWriteControl = 1'b1; //

                //                 contador = 6'b000000;
                //                 end
                //             end
                //         endcase                    
                //     end
                // end
            endcase
        end
    end
endmodule