`timescale 1ns / 1ps

module process(
    input signed[23:0] in_l,
    input signed[23:0] in_r,
    output signed[23:0] out_l,
    output signed[23:0] out_r,
    input[7:0] volume
);

    /* most csak loopback */
    assign out_l=in_l>>>volume;
    assign out_r=in_r>>>volume;

endmodule
