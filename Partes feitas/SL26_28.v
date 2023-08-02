module shift_left_26to28(
            input wire [25:0] input_data,
            output wire [27:0] out_data
            );

    assign out_data = {input_data, 2'b00};

endmodule