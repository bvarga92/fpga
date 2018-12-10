`timescale 1ns / 1ps

module toplevel_tb;
    reg clk100;
    reg rst;
    reg adc_sdata;
    reg[7:0] sw;

    wire dac_mclk;
    wire dac_lrck;
    wire dac_sclk;
    wire dac_sdata;
    wire adc_mclk;
    wire adc_lrck;
    wire adc_sclk;
    wire[7:0] led;

    toplevel uut(
        .clk100(clk100), 
        .rst(rst), 
        .dac_mclk(dac_mclk), 
        .dac_lrck(dac_lrck), 
        .dac_sclk(dac_sclk), 
        .dac_sdata(dac_sdata), 
        .adc_mclk(adc_mclk), 
        .adc_lrck(adc_lrck), 
        .adc_sclk(adc_sclk), 
        .adc_sdata(adc_sdata),
        .sw(sw),
        .led(led)
    );

    task i2s_transmit(input[23:0] data_l, input[23:0] data_r);
        integer i;
        begin
            @(negedge adc_lrck) ;
            for(i=0; i<24; i=i+1) @(negedge adc_sclk) adc_sdata=data_l[23-i];
            @(negedge adc_sclk) adc_sdata=0;
            @(posedge adc_lrck) ;
            for(i=0; i<24; i=i+1) @(negedge adc_sclk) adc_sdata=data_r[23-i];
            @(negedge adc_sclk) adc_sdata=0;
        end
    endtask

    initial begin
        clk100=0;
        rst=1;
        adc_sdata=0;
        sw=0;
        #100;
        rst=0;
        i2s_transmit(23'h555555, 23'h123456);
    end

    always #5 clk100<=~clk100;

endmodule
