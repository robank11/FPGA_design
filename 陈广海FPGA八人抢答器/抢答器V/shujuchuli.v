moduleshujuchuli(
	input	clk,
	input	rst,
	input clear, 
	input flag_set, 
	input SW1,
 	input SW2,
 	input SW3, 
	inputSW4,
	input SW5, 
	inputSW6,
	input SW7,
 	input SW8,
 	output reg start,
	output reg [3:0]name
);
reg block;
always @(posedge clk or posedge rst)begin 
if(rst)
begin
	start <= 0;
	block <= 0;
end
else if(clear == 1'd1) 
begin
	start <= 0;
	block <= 0;
end
else if(flag_set)
begin
	if(SW1|SW2|SW3|SW4|SW5|SW6|SW7|SW8)//block为锁存,即有一个学号按下后,不允许其他学号按下
	begin
		start <= 1;
		block <= 1;
	end
end
end

always @(posedge clk or posedge rst)
begin
	if(rst)
	begin
		name <= 4'd0;
	end
	else if(SW1 == 1'd1)//输出学号, SW1为1, SW2为2,依次类似
	begin
		if(block == 1'd0)
			name <= 4'd1;
	end
	else if(SW2 == 1'd1) 
	begin
		if(block == 1'd0)
			name <= 4'd2;
	end
	else if(SW3 == 1'd1) 
	begin
		if(block == 1'd0)
			name <= 4'd3;
	end
	else if(SW4 == 1'd1) 
	begin
		if(block == 1'd0)
			name <= 4'd4;
	end
	else if(SW5 == 1'd1) 
	begin
		if(block == 1'd0)
			name <= 4'd5;
	end
	else if(SW6 == 1'd1)
          begin
		if(block == 1'd0)
			name <= 4'd6;
	end
	else if(SW7 == 1'd1) 
	begin
		if(block == 1'd0)
			name <= 4'd7;
	end
	else if(SW8 == 1'd1) 
	begin
		if(block == 1'd0)
			name <= 4'd8;
	end
end 
endmodule