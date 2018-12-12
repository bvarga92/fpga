`timescale 1ns / 1ps
module twiddle(input[5:0] addr, output reg signed [12:0] w_re,w_im);

  always@(*)
    case(addr)
      6'd0: 
        begin
          w_re<=13'b0111111111111;
          w_im<=13'b0000000000000;
        end
      6'd1: 
        begin
          w_re<=13'b0111111111010;
          w_im<=13'b1111100110110;
        end
      6'd2: 
        begin
          w_re<=13'b0111111101011;
          w_im<=13'b1111001101101;
        end
      6'd3: 
        begin
          w_re<=13'b0111111010010;
          w_im<=13'b1110110100110;
        end
      6'd4: 
        begin
          w_re<=13'b0111110110000;
          w_im<=13'b1110011100000;
        end
      6'd5: 
        begin
          w_re<=13'b0111110000100;
          w_im<=13'b1110000011011;
        end
      6'd6: 
        begin
          w_re<=13'b0111101001110;
          w_im<=13'b1101101011010;
        end
      6'd7: 
        begin
          w_re<=13'b0111100001111;
          w_im<=13'b1101010011011;
        end
      6'd8: 
        begin
          w_re<=13'b0111011000111;
          w_im<=13'b1100111011111;
        end
      6'd9: 
        begin
          w_re<=13'b0111001110101;
          w_im<=13'b1100100101000;
        end
      6'd10: 
        begin
          w_re<=13'b0111000011011;
          w_im<=13'b1100001110100;
        end
      6'd11: 
        begin
          w_re<=13'b0110110111000;
          w_im<=13'b1011111000101;
        end
      6'd12: 
        begin
          w_re<=13'b0110101001100;
          w_im<=13'b1011100011011;
        end
      6'd13: 
        begin
          w_re<=13'b0110011011001;
          w_im<=13'b1011001110111;
        end
      6'd14: 
        begin
          w_re<=13'b0110001011101;
          w_im<=13'b1010111011001;
        end
      6'd15: 
        begin
          w_re<=13'b0101111011010;
          w_im<=13'b1010101000000;
        end
      6'd16: 
        begin
          w_re<=13'b0101101001111;
          w_im<=13'b1010010101111;
        end
      6'd17: 
        begin
          w_re<=13'b0101010111110;
          w_im<=13'b1010000100100;
        end
      6'd18: 
        begin
          w_re<=13'b0101000100101;
          w_im<=13'b1001110100001;
        end
      6'd19: 
        begin
          w_re<=13'b0100110000111;
          w_im<=13'b1001100100101;
        end
      6'd20: 
        begin
          w_re<=13'b0100011100011;
          w_im<=13'b1001010110010;
        end
      6'd21: 
        begin
          w_re<=13'b0100000111001;
          w_im<=13'b1001001000110;
        end
      6'd22: 
        begin
          w_re<=13'b0011110001010;
          w_im<=13'b1000111100011;
        end
      6'd23: 
        begin
          w_re<=13'b0011011010110;
          w_im<=13'b1000110001001;
        end
      6'd24: 
        begin
          w_re<=13'b0011000011111;
          w_im<=13'b1000100110111;
        end
      6'd25: 
        begin
          w_re<=13'b0010101100011;
          w_im<=13'b1000011101111;
        end
      6'd26: 
        begin
          w_re<=13'b0010010100100;
          w_im<=13'b1000010110000;
        end
      6'd27: 
        begin
          w_re<=13'b0001111100011;
          w_im<=13'b1000001111010;
        end
      6'd28: 
        begin
          w_re<=13'b0001100011110;
          w_im<=13'b1000001001110;
        end
      6'd29: 
        begin
          w_re<=13'b0001001011000;
          w_im<=13'b1000000101100;
        end
      6'd30: 
        begin
          w_re<=13'b0000110010001;
          w_im<=13'b1000000010011;
        end
      6'd31: 
        begin
          w_re<=13'b0000011001000;
          w_im<=13'b1000000000100;
        end
      6'd32: 
        begin
          w_re<=13'b0000000000000;
          w_im<=13'b1000000000000;
        end
      6'd33: 
        begin
          w_re<=13'b1111100110110;
          w_im<=13'b1000000000100;
        end
      6'd34: 
        begin
          w_re<=13'b1111001101101;
          w_im<=13'b1000000010011;
        end
      6'd35: 
        begin
          w_re<=13'b1110110100110;
          w_im<=13'b1000000101100;
        end
      6'd36: 
        begin
          w_re<=13'b1110011100000;
          w_im<=13'b1000001001110;
        end
      6'd37: 
        begin
          w_re<=13'b1110000011011;
          w_im<=13'b1000001111010;
        end
      6'd38: 
        begin
          w_re<=13'b1101101011010;
          w_im<=13'b1000010110000;
        end
      6'd39: 
        begin
          w_re<=13'b1101010011011;
          w_im<=13'b1000011101111;
        end
      6'd40: 
        begin
          w_re<=13'b1100111011111;
          w_im<=13'b1000100110111;
        end
      6'd41: 
        begin
          w_re<=13'b1100100101000;
          w_im<=13'b1000110001001;
        end
      6'd42: 
        begin
          w_re<=13'b1100001110100;
          w_im<=13'b1000111100011;
        end
      6'd43: 
        begin
          w_re<=13'b1011111000101;
          w_im<=13'b1001001000110;
        end
      6'd44: 
        begin
          w_re<=13'b1011100011011;
          w_im<=13'b1001010110010;
        end
      6'd45: 
        begin
          w_re<=13'b1011001110111;
          w_im<=13'b1001100100101;
        end
      6'd46: 
        begin
          w_re<=13'b1010111011001;
          w_im<=13'b1001110100001;
        end
      6'd47: 
        begin
          w_re<=13'b1010101000000;
          w_im<=13'b1010000100100;
        end
      6'd48: 
        begin
          w_re<=13'b1010010101111;
          w_im<=13'b1010010101111;
        end
      6'd49: 
        begin
          w_re<=13'b1010000100100;
          w_im<=13'b1010101000000;
        end
      6'd50: 
        begin
          w_re<=13'b1001110100001;
          w_im<=13'b1010111011001;
        end
      6'd51: 
        begin
          w_re<=13'b1001100100101;
          w_im<=13'b1011001110111;
        end
      6'd52: 
        begin
          w_re<=13'b1001010110010;
          w_im<=13'b1011100011011;
        end
      6'd53: 
        begin
          w_re<=13'b1001001000110;
          w_im<=13'b1011111000101;
        end
      6'd54: 
        begin
          w_re<=13'b1000111100011;
          w_im<=13'b1100001110100;
        end
      6'd55: 
        begin
          w_re<=13'b1000110001001;
          w_im<=13'b1100100101000;
        end
      6'd56: 
        begin
          w_re<=13'b1000100110111;
          w_im<=13'b1100111011111;
        end
      6'd57: 
        begin
          w_re<=13'b1000011101111;
          w_im<=13'b1101010011011;
        end
      6'd58: 
        begin
          w_re<=13'b1000010110000;
          w_im<=13'b1101101011010;
        end
      6'd59: 
        begin
          w_re<=13'b1000001111010;
          w_im<=13'b1110000011011;
        end
      6'd60: 
        begin
          w_re<=13'b1000001001110;
          w_im<=13'b1110011100000;
        end
      6'd61: 
        begin
          w_re<=13'b1000000101100;
          w_im<=13'b1110110100110;
        end
      6'd62: 
        begin
          w_re<=13'b1000000010011;
          w_im<=13'b1111001101101;
        end
      6'd63: 
        begin
          w_re<=13'b1000000000100;
          w_im<=13'b1111100110110;
        end
    endcase

endmodule