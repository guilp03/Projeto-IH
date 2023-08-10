module shift_left_16to32(
            input wire [15:0] input_data,
            output wire [31:0] out_data
            );

    assign out_data = {input_data, 16'b0000000000000000};

endmodule