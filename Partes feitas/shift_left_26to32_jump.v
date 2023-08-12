module shift_left_26to32_jump_(
            input wire [4:0] RS,
            input wire [4:0] RT,
            input wire [15:0] OFFSET,
            input wire [31:0] PC_out,
            output wire [31:0] shift_left_26to32_jump_out
            );
    

    assign shift_left_26to32_jump_out = {PC_out[31:28], RS, RT, OFFSET, 2'b00};

endmodule