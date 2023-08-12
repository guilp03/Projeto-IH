module sign_extended1_32_(
    input wire LT,
    output wire [31:0] sign_extended1_32_out
    );

    assign sign_extended1_32_out = {{31{1'b0}}, LT};
endmodule   