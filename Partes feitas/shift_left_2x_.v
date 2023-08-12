module shift_left_2x_(
            input wire [15:0] OFFSET,
            output wire [31:0] shift_left_2x_out
            );

    assign shift_left_2x_out = OFFSET << 2;

endmodule