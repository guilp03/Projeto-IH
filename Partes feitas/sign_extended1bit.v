module sign_extended1bit(
            input wire input_data,
            output wire [31:0] out_data
            );

    assign out_data = {{31{input_data}}, input_data};
endmodule   