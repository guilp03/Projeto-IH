module sign_extended1bit(
            input wire [15:0] input_data,
            output wire [31:0] out_data
            );
    // replica o bit de sinal
    assign out_data =  {{31{1'b0}}, input_data}

endmodule