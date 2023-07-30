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
        output reg [2:0] ALUSrcBControl,
        output reg [1:0] SSControl,
        output reg [1:0] LScontrol,
        output reg reset_out
    );

    reg [5:0] contador;
    reg [5:0] estado;

    //Estados
    parameter Es_Fetch = 6'b000001;
    parameter Es_Decode = 6'b000010;

    parameter Es_Add = 6'b000011;
    parameter Es_And = 6'b000100;
    parameter Es_Mult_Div = 6'b000101;
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
    parameter Es_Addm = 6'b010010;
    parameter Es_Addi = 6'b010011;
    parameter Es_Addiu = 6'b010100;
    parameter Es_Beq = 6'b010101;
    parameter Es_Bne = 6'b010110;
    parameter Es_Ble = 6'b010111;
    parameter Es_Bgt = 6'b011000;
    parameter Es_Sllm = 6'b011001;
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
    parameter Es_Reset = 6'b111111;

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
    parameter Funct_Addm = 6'b000101;

    //Tipo I

    parameter Op_Addi = 6'b001000;
    parameter Op_Addiu = 6'b001001;
    parameter Op_Beq = 6'b000100;
    parameter Op_Bne = 6'b000101;
    parameter Op_Ble = 6'b000110;
    parameter Op_Bgt = 6'b000111;
    parameter Op_Sllm = 6'b000001;
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
                ALUSrcAControl = 3'b000;
                ALUSrcBControl = 3'b000;
                SSControl = 2'b00;
                LScontrol = 2'b00;
                reset_out = 1'b0;
                RegDstControl = 2'b00; ///
                RegWriteControl = 1'b1; ///

                contador = 6'b000000;


            end else begin
                estado = Es_Fetch;

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
                ALUSrcAControl = 3'b000;
                ALUSrcBControl = 3'b000;
                SSControl = 2'b00;
                LScontrol = 2'b00;
                reset_out = 1'b0;
                RegDstControl = 2'b00;
                RegWriteControl = 1'b0; ///

                contador = contador + 1;
            end

        end else begin
            case(estado):
            Es_Fetch: begin
                if (contador == 6'b000000 || contador == 6'b000001 || contadorr = 6'b000010)begin
                    estado = Es_Fetch;

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
                    ALUSrcBControl = 3'b010; ///
                    SSControl = 2'b00;
                    LScontrol = 2'b00;
                    reset_out = 1'b0;
                    RegDstControl = 2'b00;
                    RegWriteControl = 1'b0;

                    contador = contador + 1;

                end
                
                else if (contador == 6'b000011)begin
                    estado = Es_Fetch;

                    WriteMemControl = 1'b0; 
                    IRWriteControl = 1'b1; ///
                    ShiftRegControl = 3'b000;
                    ALUControl = 3'b001; 
                    PcControl = 1'b1; ///
                    HI_writeControl = 1'b0;
                    LO_writeControl = 1'b0;
                    RegAControl = 1'b0;
                    RegBControl = 1'b0;
                    ALUOutControl = 1'b0; 
                    WriteMDRControl = 1'b0;
                    EpcControl = 1'b0;
                    EX_control = 1'b0;
                    PcSourceControl = 2'b01; 
                    IorDControl = 3'b000; 
                    ShiftAmtControl = 2'b00;
                    ShiftSrcControl = 2'b00;
                    DataSrcControl = 3'b100;
                    ALUSrcAControl = 2'b01; 
                    ALUSrcBControl = 3'b010; 
                    SSControl = 2'b00;
                    LScontrol = 2'b00;
                    reset_out = 1'b0;
                    RegDstControl = 2'b00;
                    RegWriteControl = 1'b0;

                    contador = contador + 1;
                    
                end

                else if (contador == 6'b000100) begin
                    estado = Es_Fetch;

                    WriteMemControl = 1'b0; 
                    IRWriteControl = 1'b0; ///
                    ShiftRegControl = 3'b000;
                    ALUControl = 3'b001; ///
                    PcControl = 1'b0; ///
                    HI_writeControl = 1'b0;
                    LO_writeControl = 1'b0;
                    RegAControl = 1'b1; ///
                    RegBControl = 1'b1; ///
                    ALUOutControl = 1'b1; ///
                    WriteMDRControl = 1'b0;
                    EpcControl = 1'b0;
                    EX_control = 1'b0;
                    PcSourceControl = 2'b01; 
                    IorDControl = 3'b000; 
                    ShiftAmtControl = 2'b00;
                    ShiftSrcControl = 2'b00;
                    DataSrcControl = 3'b100;
                    ALUSrcAControl = 2'b01; ///
                    ALUSrcBControl = 3'b100; ///
                    SSControl = 2'b00;
                    LScontrol = 2'b00;
                    reset_out = 1'b0;
                    RegDstControl = 2'b00;
                    RegWriteControl = 1'b0;

                    contador = contador + 1;

                end

               else if (contador == 6'b000110) begin
                    case(OPCODE):
                        R: begin
                            case (OFFSET[5:0])
                                add_funct: begin
                                    state = add_st;
                                end

                                sub_funct: begin
                                    state = sub_st;
                                end

                                and_funct: begin
                                    state = and_st;
                                end

                                sll_funct: begin
                                    state = sll_st;
                                end

                                slt_funct: begin
                                    state = slt_st;
                                end

                                sra_funct: begin
                                    state = sra_st;
                                end

                                srl_funct: begin
                                    state = srl_st;
                                end

                                sllv_funct: begin
                                    state = sllv_st;
                                end

                                srav_funct: begin
                                    state = srav_st;
                                end

                                jr_funct: begin
                                    state = jr_st;
                                end

                                mfhi_funct: begin
                                    state = mfhi_st;
                                end

                                mflo_funct: begin
                                    state = mflo_st;
                                end

                                break_funct: begin
                                    state = break_st;
                                end

                                rte_funct: begin
                                    state = rte_st;
                                end

                            endcase
                        end

                        reset_op: begin
                            state = reset_st;
                        end

                        addi_op: begin
                            state = addi_st;
                        end

                        addiu_op: begin
                            state = addiu_st;
                        end

                        j_op: begin
                            state = j_st;
                        end

                        jal_op: begin
                            state = jal_st;
                        end

                        slti_op: begin
                            state = slti_st;
                        end

                        beq_op: begin
                            state = beq_st;
                        end

                        bne_op: begin
                            state = bne_st;
                        end

                        ble_op: begin
                            state = ble_st;
                        end

                        bgt_op: begin
                            state = bgt_st;
                        end

                        lui_op: begin
                            state = lui_st;
                        end

                        lw_op: begin
                            state = loads_st;
                        end

                        lh_op: begin
                            state = loads_st;
                        end

                        lb_op: begin
                            state = loads_st;
                        end

                        sw_op: begin
                            state = stores_st;
                        end

                        sh_op: begin
                            state = stores_st;
                        end

                        sb_op: begin
                            state = stores_st;
                        end
                
                endcase

                    estado = Es_Fetch;

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
                    DataSrcControl = 3'b100;
                    ALUSrcAControl = 2'b01; 
                    ALUSrcBControl = 3'b010; 
                    SSControl = 2'b00;
                    LScontrol = 2'b00;
                    reset_out = 1'b0;
                    RegDstControl = 2'b00;
                    RegWriteControl = 1'b0;

                    contador = contador + 1;
                end
            endcase
        end
    endmodule