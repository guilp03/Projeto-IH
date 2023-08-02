module shift_left_32(
            input wire [31:0] input_data,
            output wire [31:0] out_data
            );

    assign out_data = input_data << 2;

endmodule