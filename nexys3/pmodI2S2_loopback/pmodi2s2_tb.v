`timescale 1ns / 1ps

module pmodi2s2_tb;

    reg clk;
    reg rst;
    reg[23:0] dac_l;
    reg[23:0] dac_r;
    reg adc_sdata;

    wire mclk;
    wire lrck;
    wire sclk;
    wire dac_sdata;
    wire[23:0] adc_l;
    wire[23:0] adc_r;
    wire dac_rd_adc_wr;

    pmodi2s2 uut(
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
         .dac_rd_adc_wr(dac_rd_adc_wr)
    );

    task i2s_transmit(input[23:0] data_l, input[23:0] data_r);
        integer i;
        begin
            @(negedge lrck) ;
            for(i=0; i<24; i=i+1) @(negedge sclk) adc_sdata=data_l[23-i];
            @(negedge sclk) adc_sdata=0;
            @(posedge lrck) ;
            for(i=0; i<24; i=i+1) @(negedge sclk) adc_sdata=data_r[23-i];
            @(negedge sclk) adc_sdata=0;
        end
    endtask

    initial begin
        clk=0;
        rst=1;
        dac_l=24'hFFFFFF;
        dac_r=24'h000000;
        adc_sdata=0;
        #100;
        rst=0;
        #100;
        i2s_transmit(23'h555555, 23'h123456);
    end

    always #5 clk<=~clk;
    
endmodule

