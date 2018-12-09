`timescale 1ns / 1ps

module fifo#(
    parameter WIDTH=24, //ennyi bites adatokat tarolunk
    parameter DEPTH=16  //ennyi adat fer a FIFO-ba
)(
    input clk,
    input rst,
    input wr,
    input rd,
    input[WIDTH-1:0] din,
    output reg[WIDTH-1:0] dout,
    output full,
    output empty
);

    reg[WIDTH-1:0] m[DEPTH-1:0];
    reg[$clog2(DEPTH+1)-1:0] cntr;
    reg[$clog2(DEPTH)-1:0] rd_addr, wr_addr;

    assign empty=(cntr==0);
    assign full=(cntr==DEPTH);

    always@(posedge clk)
        if(rst)
            cntr<=0;
        else if(rd & ~empty & ~wr)
            cntr<=cntr-1;
        else if(wr & ~full & ~rd)
            cntr<=cntr+1;

    always@(posedge clk)
        if(rst)
            rd_addr<=0;
        else if(rd & ~empty)
            rd_addr<=rd_addr+1;                

    always@(posedge clk)
        if(rst)
            wr_addr<=0;
        else if(wr & (~full | rd) & ~(empty & rd))
            wr_addr<=wr_addr+1;

    always@(posedge clk)
        if(wr & (~full | rd) & ~(empty & rd))
            m[wr_addr]<=din;

    always@(posedge clk)
        if(rst)
            dout<=0;
        else if(rd)
            if(~empty)
                dout<=m[rd_addr];
            else if(wr)
                dout<=din;

endmodule
