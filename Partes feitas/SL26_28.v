module shift_left_26to28(
            input wire [4:0] RS,
            input wire [4:0] RT,
            input wire [15:0] OFFSET,
            input wire [3:0] PC_output,
            output wire [31:0] out_data
            );

    wire [27:0] conc_data;

    assign conc_data = {OFFSET, RS, RT, 2'b00};
    assign out_data = {conc_data, PC_output};

endmodule