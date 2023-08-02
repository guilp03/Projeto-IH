module sign_extended(
            input wire [15:0] input_data,
            output wire [31:0] out_data
            );
    // replica o bit de sinal
    assign out_data = (input_data[15]) ? {{16{1'b1}}, input_data} : {{16{1'b0}}, input_data}

endmodule