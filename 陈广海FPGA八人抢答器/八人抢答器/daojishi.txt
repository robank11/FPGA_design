module daojishi( 
	input clk, 
	input rst, 
	input start_pos, 
	output reg clear, 
	output reg flag_set, 
	output reg [3:0] data, 
	output reg beep
);
reg[31:0] timer_cnt;
reg en_1hz;//1 second , 1 counter enable
always@(posedge clk or posedge rst) 
begin
	if(rst == 1'b1)
	begin
		en_1hz <= 1'b0;
		timer_cnt <= 32'd0;
	end
	else if(timer_cnt >= 32'd49_999_999) 
	begin
		en_1hz <= 1'b1;
		timer_cnt <= 32'd0;
	end
	else
	begin
		en_1hz <= 1'b0;
		endtimer_cnt <= timer_cnt + 32'd1;
	end
end
reg[31:0] timer_cnt1;
reg en_1khz;   //1 second , 1 counter enable
always@(posedge clk or posedge rst)
begin
	if(rst == 1'b1) 
	begin
		en_1khz <= 1'b0;
		timer_cnt1 <= 32'd0;
	end
	else if(timer_cnt >= 32'd49_999) 
	begin
		en_1khz <= 1'b1;
		timer_cnt1 <= 32'd0;
	end
	else
	begin
		en_1khz <= 1'b0;
		timer_cnt1 <= timer_cnt1 + 32'd1;
	end
end

reg flag;
always@(posedge clk or posedge rst) 
begin
	if(rst == 1'b1)
	begin
		flag <= 1'd0;
		clear <= 1'd0;
	end
	else if(start_pos) 
	begin
		flag <= 1'd1;
		clear <= 1'd1;
	end
	else if(data == 4'd0) 
	begin
		flag <= 1'd0;
	end
	else
		clear <= 1'd0;
end

reg flag_set1;
always@(posedge clk or posedge rst) 
begin
	if(rst == 1'b1)
	begin
		data <= 4'd9;
		flag_set1 <= 1'd0;
	end
	else if(start_pos) 
	begin
		data <= 4'd9;
		flag_set1 <= 1'd0;
	end
	else if(flag)
	begin
		if(data == 4'd0) 
		begin
			data <= 4'd0;
			flag_set1 <= 1'd1;
		end
		else if(en_1hz)
		data <= data - 1'd1;
	end
end

reg [3:0]cnt;
always @(posedge clk or posedge rst) 
begin
	if(rst)
	begin
		beep <= 1'd0;
		flag_set <= 1'd0;
		cnt <= 4'd0;
	end
	else if(flag_set1)
	begin
		if(en_1hz && cnt <  4'd1) 
			cnt <= cnt + 1'd1;
		if(cnt<4'd1)
			 beep <= 1;
		else if(cnt ==4'd1)
	          begin
			flag_set <= 1'd1;
			beep <= 0;
		end
	end
	else
	begin
		beep <= 1'd0;
		flag_set <= 1'd0;
		cnt <= 1'd0;
	end
end
endmodule

