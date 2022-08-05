module top(
input clk,
input rst,
input SW1,
input SW2,
input SW3,
input SW4,
input SW5,
input SW6,
input SW7,
input SW8,
input btn_start,
output[6:0]seg,
output[3:0]sel,
output beep
);
wire start_pos;
ax_debounce ax_debounce_m0
(
	.clk			                                (clk),
	.rst                                        (rst),
	.button_in                         (btn_start),
	.button_posedge           (start_pos),
	.button_negedge                     (),
	.button_out                           ()
);
wire clear,start;
wire [3:0]name;
wire flag_set;
shujuchuli shujuchuli(
	.clk(clk),
	.rst(rst),
	.flag_set(flag_set),
	.clear(clear),
	.SW1(SW1),
	.SW2(SW2),
	.SW3(SW3),
	.SW4(SW4),
	.SW5(SW5),
	.SW6(SW6),
	.SW7(SW7),
	.SW8(SW8),
	.start(start),
	.name(name)
);
wire [3:0] data;
daojishi daojishi(
	.clk(clk),
	.rst(rst), 
	.flag_set(flag_set),
	.start_pos(start_pos),
	.clear(clear),
	.data(data),
	.beep(beep)
);
reg [3:0] xianshi;
always@(posedge clk or posedge rst) 
begin
	if(rst == 1'b1)
		xianshi <= 4'd0;
	else if(start == 1'd0)
		xianshi <= data;//如果 start未按下,则显示计时信息
	else if(start == 1'd1)
		xianshi <= name;//如果 start按下,则显示学号
end

seg_decoder seg_decoder(//数码管译码
	bin_data (xianshi),
	seg_data (seg)
);
assign sel = 4'b1110;//只亮一个数码管
endmodule