module shift_left_16to32(
            input wire [15:0] OFFSET,
            output wire [31:0] shift_left_16to32_out
            );

    assign shift_left_16to32_out = {OFFSET, 16'b0000000000000000};

endmodule