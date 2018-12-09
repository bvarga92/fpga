`timescale 1ns / 1ps

module fifo_tb;

    reg clk;
    reg rst;
    reg wr;
    reg rd;
    reg[23:0] din;

    wire[23:0] dout;
    wire full;
    wire empty;

    fifo #(
        .WIDTH(24),
        .DEPTH(16)
    ) uut(
        .clk(clk), 
        .rst(rst), 
        .wr(wr), 
        .rd(rd), 
        .din(din), 
        .dout(dout), 
        .full(full), 
        .empty(empty)
    );

    task fifo_wr(input[23:0] data0, input[4:0] n);
        integer i;
        begin
            for(i=0; i<n; i=i+1)
            begin
                din=data0+i;
                @(posedge clk) wr=1;
                @(posedge clk) wr=0;            
            end
        end
    endtask

    task fifo_rd(input[4:0] n);
        integer i;
        begin
            for(i=0; i<n; i=i+1)
            begin
                @(posedge clk) rd=1;
                @(posedge clk) rd=0;            
            end
        end
    endtask

    task fifo_rdwr(input[23:0] data);
        begin
            din=data;
            @(posedge clk) ;
            wr=1;
            rd=1;
            @(posedge clk) ;
            wr=0;
            rd=0;            
        end
    endtask

    initial begin
        clk=0;
        rst=1;
        wr=0;
        rd=0;
        din=0;
        #100;
        rst=0;
        #101;
        fifo_wr(24'h123450,16); //beiras
        #101;
        fifo_wr(24'hFFFFF0,16); //ennek hatastalannak kell lennie (tele a FIFO)
        #101;
        fifo_rd(16); //visszaolvasas (123450-12345F)
        #101;
        fifo_rd(16); //mar nincs mit kiolvasni (ures a FIFO)
        #101;
        fifo_rdwr(24'h555555); //szimultan iras-olvasas ures FIFO-n: transzparens
        #101;
        fifo_wr(24'hABCDEF,5); //beiras
        #101;
        fifo_rdwr(24'h808080); //szimultan iras-olvasas (be: 808080, ki: ABCDEF)
        #101;
        fifo_wr(24'h000000,11); //beiras
        #101;
        fifo_rdwr(24'hFFFFFF); //szimultan iras-olvasas teli FIFO-n (be: FFFFFF, ki: ABCDF0)
        #101;
        fifo_rd(16); //kiuritjuk a FIFO-t (ABCDF1-ABCDF3, 808080, 000000-00000A, FFFFFF)
    end

    always #5 clk<=~clk;

endmodule
