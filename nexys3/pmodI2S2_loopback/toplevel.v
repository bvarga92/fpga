`timescale 1ns / 1ps

module toplevel(
    input clk100, //100 MHz
    input rst,
    output dac_mclk,
    output dac_lrck,
    output dac_sclk,
    output dac_sdata,
    output adc_mclk,
    output adc_lrck,
    output adc_sclk,
    input adc_sdata,
    input[7:0] sw,
    output[7:0] led
);

    /* orajelgenerator: 100 MHz --> 98.304 MHz */
    wire clk;
    clk_gen clk_gen_i(
        .clk_in(clk100),
        .clk_out(clk)
    );

    /* a PmodI2S2 modul vezerloje */
    wire mclk, lrck, sclk;
    wire[23:0] dac_l, dac_r, adc_l, adc_r;
    pmodi2s2 codec(
         .clk(clk),
         .rst(rst),
         .mclk(mclk),
         .lrck(lrck),
         .sclk(sclk),
         .dac_l(dac_l),
         .dac_r(dac_r),
         .dac_sdata(dac_sdata),
         .adc_sdata(adc_sdata),
         .adc_l(adc_l),
         .adc_r(adc_r),
         .dac_rd_adc_wr()
    );

    assign adc_mclk=mclk;
    assign dac_mclk=mclk;
    assign adc_sclk=sclk;
    assign dac_sclk=sclk;
    assign adc_lrck=lrck;
    assign dac_lrck=lrck;

    /* feldolgozas */
    process volume(
         .in_l(adc_l),
         .in_r(adc_r),
         .out_l(dac_l),
         .out_r(dac_r),
         .volume(sw)
    );

    assign led=sw;

endmodule
