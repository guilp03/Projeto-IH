module sign_extended1bit_(
            input wire input_data,
            output wire [31:0] out_data
            );
            
    // replica o bit de sinal
    assign out_data = input_data[15] ? {{31{1'b1}}, input_data} : {{31{1'b0}}, input_data};

endmodule