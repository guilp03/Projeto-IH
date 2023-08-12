module shift_left8_32_exce_(
            input wire [31:0] Mem_out,
            output wire [31:0] shift_left8_32_exce_out
            );

    reg [7:0] temp;     

    initial begin
        assign temp = Mem_out[7:0];
    end
    // replica o bit de sinal
    assign shift_left8_32_exce_out = {24'b000000000000000000000000, temp};

endmodule