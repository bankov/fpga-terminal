/* "a b c d e f g h"
 *   --a--
 *  |     |
 *  f     b
 *  |     |
 *   --g--
 *  |     |
 *  e     c
 *  |     |
 *   --d--
 */

module nibble (
	input wire [3:0] number,
	output reg [7:0] segment
);

always @(number)
	case(number)
		4'h0: segment <= 8'b11000000;  
		4'h1: segment <= 8'b11111001;
		4'h2: segment <= 8'b10100100;  
		4'h3: segment <= 8'b10110000;
		4'h4: segment <= 8'b10011001;  
		4'h5: segment <= 8'b10010010;  
		4'h6: segment <= 8'b10000010;  
		4'h7: segment <= 8'b11111000;
		4'h8: segment <= 8'b10000000;  
		4'h9: segment <= 8'b10010000;  
		4'ha: segment <= 8'b10001000;  
		4'hb: segment <= 8'b10000011;
		4'hc: segment <= 8'b11000110;
		4'hd: segment <= 8'b10100001;
		4'he: segment <= 8'b10000110;
		4'hf: segment <= 8'b10001110;
		default: segment <= 8'bx;
	endcase

endmodule

module display (
	input wire clk,
	input wire [31:0] num,

	output reg[7:0] seg,
	output reg[3:0] an
);

reg [20:0] count = 0;
wire [1:0] n;

assign n = count[20:19];

always @(posedge clk) begin
	count = count + 1'b1;
	case(n)
		0: seg <= num[31:24];
		1: seg <= num[23:16];
		2: seg <= num[15:8];
		3: seg <= num[7:0];
	endcase
	case(n)
		0: an <= 4'b1110;
		1: an <= 4'b1101;
		2: an <= 4'b1011;
		3: an <= 4'b0111;
	endcase
end

endmodule

module hexdisplay (
	input wire clk,
	input wire [15:0] word,
	output wire [7:0] seg,
	output wire [3:0] an
);

wire [31:0] num;

nibble conv1(.number(word[15:12]), .segment(num[7:0]));
nibble conv2(.number(word[11:8]),  .segment(num[15:8]));
nibble conv3(.number(word[7:4]),   .segment(num[23:16]));
nibble conv4(.number(word[3:0]),   .segment(num[31:24]));
display display(.clk(clk), .num(num), .seg(seg), .an(an));

endmodule

