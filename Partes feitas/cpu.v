module cpu(
    input wire clock,
    input wire reset
);

// Flags

    wire Overflow;
    wire Neg;
    wire Zero;
    wire EQ;
    wire GT;
    wire LT;

// Control wires

    wire WriteMemControl;
    wire IRWriteControl;
    wire [2:0] ShiftRegControl;
    wire RegWriteControl;
    wire [2:0] ALUControl;
    wire PcControl;
    wire HI_writeControl;
    wire LO_writeControl;
    wire RegAControl;
    wire RegBControl;
    wire ALUOutControl;
    wire WriteMDRControl;
    wire EpcControl;
    wire EX_control;
    wire [1:0] PcSourceControl;
    wire [2:0] IorDControl;
    wire [1:0] RegDstControl;
    wire [1:0] ShiftAmtControl;
    wire [1:0] ShiftSrcControl;
    wire [2:0] DataSrcControl;
    wire [1:0] ALUSrcAControl;
    wire [1:0] ALUSrcBControl;
    wire [1:0] SSControl;
    wire [1:0] LScontrol;

// Data wires

    // Constantes
    wire [31:0] ConstDiv0 ;
    assign ConstDiv0 = 32'b00000000000000000000000011111111;
    wire [31:0] ConstOverflow = 32'b00000000000000000000000011111110;
    assign ConstOverflow = 32'b00000000000000000000000011111110;
    wire [31:0] ConstNo_Opcode = 32'b00000000000000000000000011111101;
    assign ConstNo_Opcode = 32'b00000000000000000000000011111101;
    wire [31:0] ConstQuatro = 32'b00000000000000000000000000000010;
    assign ConstQuatro = 32'b00000000000000000000000000000010;
    wire [31:0] ConstVinte_nove = 32'b00000000000000000000000000011101;
    assign ConstVinte_nove = 32'b00000000000000000000000000011101;
    wire [31:0] ConstTrinta_um = 32'b00000000000000000000000000011111;
    assign ConstTrinta_um = 32'b00000000000000000000000000011111;
    wire [31:0] ConstDuzentos_vinte_sete = 32'b00000000000000000000000011100011;
    assign ConstDuzentos_vinte_sete = 32'b00000000000000000000000011100011;
    wire [31:0] ConstDezesseis = 32'b00000000000000000000000000001000;
    assign ConstDezesseis = 32'b00000000000000000000000000001000;

    wire [31:26] OPCODE;
    wire [25:21] RS;
    wire [20:16] RT;
    wire [15:0] OFFSET;
    wire [4:0] ShiftAmt_out;
    wire [4:0] RegDst_out;

    wire [31:0] Mem_out;
    wire [31:0] ShiftReg_out;
    wire [31:0] ReadData_outA;
    wire [31:0] ReadData_outB;
    wire [31:0] ALUresult;
    wire [31:0] PC_out;
    wire [31:0] HI_out;
    wire [31:0] LO_out;
    wire [31:0] RegA_out;
    wire [31:0] RegB_out;
    wire [31:0] ALUOut_out;
    wire [31:0] MDR_out;
    wire [31:0] EPC_out;
    wire [31:0] EX_out;
    wire [31:0] PCSource_out;
    wire [31:0] IorD_output;
    wire [31:0] DataSrc_out;
    wire [31:0] ShiftSrc_out;
    wire [31:0] ALUSrcA_out;
    wire [31:0] ALUSrcB_out;
    wire [31:0] SS_out;
    wire [31:0] LS_out;
    wire [31:0] ;
    wire [31:0] ;
    wire [31:0] ;
    wire [31:0] ;
    wire [31:0] ;
    wire [31:0] ;
    wire [31:0] ;

    // Padrão: Sinal -> Dados_in -> Dados_out
    // Componentes dados

    Memoria MEM_(
        IorD_out,
        clock,
        WriteMemControl,
        SS_out,
        Mem_out
    );

    Instr_Reg IR_(
        clock,
        reset,
        IRWriteControl,
        Mem_out,
        OPCODE,
        RS,
        RT,
        OFFSET
    );

    RegDesloc shift_reg_(
        clock,
        reset,
        ShiftRegControl,
        ShiftAmt_out,
        ShiftSrc_out,
        ShiftReg_out
    );

    Banco_reg Registradores_(
        clock,
        reset,
        RegWriteControl,
        RS,
        RT,
        RegDst_out,
        DataSrc_out,
        ReadData_outA,
        ReadData_outB
    );

    ula32 ALU_(
        ALUSrcA_out,
        ALUSrcB_out,
        ALUControl,
        ALUresult,

        Overflow,
        N,
        Zero,
        EQ,
        GT,
        LT
    );

    Registrador PC_(
        clock,
        reset,
        PcControl,
        EX_out,
        PC_out
    );

    Registrador HI(
        clock,
        reset,
        HI_Control,
        MDR_out,
        HI_out
    );

    Registrador LO(
        clock,
        reset,
        LO_Control,
        MDR_out,
        LO_out
    );

    Registrador A_(
        clock,
        reset,
        RegAControl,
        ReadData_outA,
        RegA_out
    );

    Registrador B_(
        clock,
        reset,
        RegBControl,
        ReadData_outB,
        RegB_out
    );

    Registrador ALUout_(
        clock,
        reset,
        ALUOutControl,
        ALUresult,
        ALUOut_out
    );

    Registrador MDR_(
        clock,
        reset,
        WriteMDRControl,
        Mem_out,
        MDR_out
    );

    Registrador EPC_(
        clock,
        reset,
        EpcControl,
        ALUresult,
        EPC_out
    );

    // Componentes feitos
    // Multiplexadores

    ex EX_(
        EX_control,
        PCSource_out,
        Mem_out,
        EX_out
    );

    pcsrc PcSource_(
        PcSourceControl,
        ALUresult,
        conc_SL26_PC_out,
        ALUOut_out,
        EPC_out,
        PCSource_out
    );

    iord IorD_(
        IorDControl,
        PC_out,
        ConstDiv0,
        ConstOverflow,
        ConstNo_Opcode,
        ALUresult,
        RegA_out,
        RegB_out,
        IorD_output
    );

    reg_destination RegDst_(
        RegDstControl,
        ConstVinte_nove,
        RT,
        ConstTrinta_um,
        OFFSET[15:11],
        RegDst_out
    );

    shift_amount ShiftAmt_(
        ShiftAmtControl,
        OFFSET[10:6],
        ConstDezesseis,
        RegB_out,
        ShiftAmt_out
    );

    shift_src ShiftSrc_(
        ShiftSrcControl,
        RegB_out,
        RegA_out,
        SL16_32_out,
        ShiftSrc_out
    );

    datasrc DataSrc_(
        DataSrcControl,
        LS_out,
        HI_out,
        LO_out,
        ShiftReg_out
        ConstDuzentos_vinte_sete,
        SE1_32_out,
        ALUOut_out_out,
        DataSrc_out
    );

    ALUSrcA ALUSrcA_(
        ALUSrcAControl,
        ALUOut_out,
        PC_out,
        RegA_out,
        MDR_out,
        ALUSrcA_out
    );

    ALUSrcB ALUSrcB_(
        ALUSrcBControl,
        SE16_32_out,
        ConstQuatro,
        RegB_out,
        SL2_out,
        ALUSrcB_out
    );

    MDSrcA MDSrcA_(
        MDSrcAControl,
        RegA_out,
        MDR_out,
        MDSrcA_out
    );

    MDSrcB MDSrcB_(
        MDSrcBControl,
        RegB_out,
        Mem_out,
        MDSrcB_out
    );

    // Componentes    
    StoreSize SS_(
        SSControl,
        RegB_out,
        MDR_out,
        SS_out
    );

    LoadSize LS_(
        LScontrol,
        MDR_out,
        LS_out
    );

    sign_extend8_32 sign_extend8_32_(
        Mem_output,
        sign_extend8_32_output
    );

    shift_left_2 SL2_(
        sign_extend_1_out,
        shift_left_2_output
    );

    sign_extend_1 Sign_extend_1(
        OFFSET,
        sign_extend_1_out
    );

    sign_extend1_32 sign_extend1_32_(
        LT,
        sign_extend1_32_output
    );

    SL_26to28_PC concatenacao(
        RS,
        RT,
        OFFSET,
        PC_output,

        conc_SL26_PC_output
    );

    SL_16to32 shiftleft16(
        OFFSET,

        SL_16to32_out
    );

    control control(
        clock,
        reset,
        OPCODE,
        OFFSET,
        WriteMemControl,
        IRWriteControl,
        ShiftRegControl,
        RegWriteControl,
        ALUControl,
        PcControl,
        HI_writeControl,
        LO_writeControl,
        RegAControl,
        RegBControl,
        ALUOutControl,
        WriteMDRControl,
        EpcControl,
        EX_control,
        PcSourceControl,
        IorDControl,
        RegDstControl,
        ShiftAmtControl,
        ShiftSrcControl,
        DataSrcControl,
        ALUSrcAControl,
        ALUSrcBControl,
        SSControl,
        LScontrol,
        EQ,
        GT,
        Overflow,
        reset
    );

endmodule