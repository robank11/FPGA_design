`timescale 1ns / 1ps
module lcd1(
 input clk,//50M
 input rst_n,
 output reg SW1,
 output lcd_p,
 output lcd_n,
 output reg lcd_rs,
 output lcd_rw,
 output reg lcd_en,
 output reg[7:0] lcd_data
 );

 parameter Mode_Set =8'h38,
 Cursor_Set=8'h0c,
 Address_Set =8'hFF,
 Clear_Set =8'h01;

 wire [7:0] data0,data1;//counter data
 wire [7:0] addr;//write address

 reg[31:0]cnt1;
 reg[7:0]data_r0,data_r1;
 
 always@(posedge clk or posedge rst_n)
 begin
 if(rst_n)
 begin
 cnt1<=1'b0;
 data_r0<=1'b0;
 data_r1<=1'b0;
 end
 else if(cnt1==32'd50000000)
 begin
 if(data_r0==8'd9)
 begin
 data_r0<=1'b0;
 if(data_r1==8'd9)
 data_r1<=1'b0;
 else
 data_r1<=data_r1+1'b1;
 end
 else
 data_r0<=data_r0+1'b1;
 cnt1<=1'b0;
 end
 else
 cnt1<=cnt1+1'b1;
 end
 assign data0=8'h30+data_r0;
 assign data1=8'h30+data_r1;
 assign addr =8'h80;

 //----1cd1602c1ken-------------
 reg [31:0]cnt;
 reg lcd_clk_en;
 always@(posedge clk or posedge rst_n)
 begin
 if(rst_n)
 begin
 cnt<=1'b0;
 lcd_clk_en<=1'b0;
 end
 else if(cnt ==32'h24999)//500us
 begin
 lcd_clk_en<=1'b1;
 cnt<=1'b0;
 end
 else
 begin
 cnt<=cnt+1'b1;
 lcd_clk_en<=1'b0;
 end
 end

 //----1cd1602 display state
 reg[6:0]state;
 
 always@(posedge clk)
 begin
 if(rst_n)
 begin
 
 state<=1'b0;
 lcd_rs<=1'b0;
 lcd_en<=1'b0;
 lcd_data<=1'b0;
 SW1<=!SW1;

 end
 else if(lcd_clk_en==1&&SW1==1)
 begin
 case(state)
 //init state
7'd0:begin
lcd_rs<=1'b0;
lcd_en<=1'b1;
lcd_data<=Mode_Set;
state<=state+1'b1;

end
7'd1:begin
lcd_en<=1'b0;

state<=state+1'b1;
end
7'd2:begin
lcd_rs<=1'b0;
lcd_en<=1'b1;
lcd_data<=Cursor_Set;
state<=state+1'b1;
end
7'd3:begin
lcd_en<=1'b0;
state<=state+1'b1;
end
7'd4:begin
lcd_rs<=1'b0;
lcd_en<=1'b1;
lcd_data<=Address_Set;
state<=state+1'b1;
end
7'd5:begin
lcd_en<=1'b0;
state<=state+1'b1;
end
7'd6:begin
lcd_rs<=1'b0;
lcd_en<=1'b1;
lcd_data<=Clear_Set;
state<=state+1'b1;
end
7'd7:begin
lcd_en<=1'b0;
state<=state+1'b1;
end
//--work state-
7'd8:begin
lcd_rs<=1'b0;
lcd_en<=1'b1;
lcd_data<=addr; //write addr
state<=state+1'b1;
end
7'd9:begin
lcd_en<=1'b0;
state<=state+1'b1;
end
 
 7'd10:begin
 lcd_rs<=1'b1;
 lcd_en<=1'b1;
 lcd_data<="C";//write data
 state<=state+1'b1;
 end
 7'd11:begin
 lcd_en<=1'b0;
 state<=state+1'b1;
 end
 7'd12:begin
 lcd_rs<=1'b1;
 lcd_en<=1'b1;
 lcd_data<="n";//write data
 state<=state +1'b1;
 end
 7'd13:begin
 lcd_en<=1'b0;
 state<=state+1'b1;
 end
 7'd14:begin
 lcd_rs<=1'b1;
 lcd_en<=1'b1;
 lcd_data<="t";//write data
 state<=state +1'b1;
 end
 7'd15:begin
 lcd_en<=1'b0;
 state<=state+1'b1;
 end
 7'd16:begin
 lcd_rs<=1'b1;
 lcd_en<=1'b1;
 lcd_data<=":";
 state<=state+1'b1;
 end
 7'd17:begin
 lcd_en<=1'b0;
 state<=state+1'b1;
 end
 7'd18:begin
 lcd_rs<=1'b1;
 lcd_en<=1'b1;
 lcd_data<=data1;//write data:tens digit
 state<=state+1'b1;
 end
 7'd19:begin
 lcd_en<=1'b0;
 state<=state+1'b1;
 end
 7'd20:begin
 lcd_rs<=1'b1;
 lcd_en<=1'b1;
 lcd_data<=data0;//write data:single digit
 state<=state+1'b1;
 end
 7'd21:
 begin
 lcd_en<=1'b0;
 state<=7'd8;
 end

 
 default:state <=7'bxxxxxxx;
 endcase
 end
 
 else if(lcd_clk_en==1&&SW1==0)
 begin
 case(state)
 //init state
7'd0:begin
lcd_rs<=1'b0;
lcd_en<=1'b1;
lcd_data<=Mode_Set;
state<=state+1'b1;
end
7'd1:begin
lcd_en<=1'b0;
state<=state+1'b1;
end
7'd2:begin
lcd_rs<=1'b0;
lcd_en<=1'b1;
lcd_data<=Cursor_Set;
state<=state+1'b1;
end
7'd3:begin
lcd_en<=1'b0;
state<=state+1'b1;
end
7'd4:begin
lcd_rs<=1'b0;
lcd_en<=1'b1;
lcd_data<=Address_Set;
state<=state+1'b1;
end
7'd5:begin
lcd_en<=1'b0;
state<=state+1'b1;
end
7'd6:begin
lcd_rs<=1'b0;
lcd_en<=1'b1;
lcd_data<=Clear_Set;
state<=state+1'b1;
end
7'd7:begin
lcd_en<=1'b0;
state<=state+1'b1;
end
//--work state-
7'd8:begin
lcd_rs<=1'b0;
lcd_en<=1'b1;
lcd_data<=addr; //write addr
state<=state+1'b1;
end
7'd9:begin
lcd_en<=1'b0;
state<=state+1'b1;
end
 
 7'd10:begin
 lcd_rs<=1'b1;
 lcd_en<=1'b1;
 lcd_data<="2";//write data
 state<=state+1'b1;
 end
 7'd11:begin
 lcd_en<=1'b0;
 state<=state+1'b1;
 end
 7'd12:begin
 lcd_rs<=1'b1;
 lcd_en<=1'b1;
 lcd_data<="0";//write data
 state<=state +1'b1;
 end
 7'd13:begin
 lcd_en<=1'b0;
 state<=state+1'b1;
 end
 7'd14:begin
 lcd_rs<=1'b1;
 lcd_en<=1'b1;
 lcd_data<="1";//write data
 state<=state +1'b1;
 end
 7'd15:begin
 lcd_en<=1'b0;
 state<=state+1'b1;
 end
 7'd16:begin
 lcd_rs<=1'b1;
 lcd_en<=1'b1;
 lcd_data<="2";
 state<=state+1'b1;
 end
 7'd17:begin
 lcd_en<=1'b0;
 state<=state+1'b1;
 end
 7'd18:begin
 lcd_rs<=1'b1;
 lcd_en<=1'b1;
 lcd_data<="0";//write data:tens digit
 state<=state+1'b1;
 end
 7'd19:begin
 lcd_en<=1'b0;
 state<=state+1'b1;
 end
 7'd20:begin
 lcd_rs<=1'b1;
 lcd_en<=1'b1;
 lcd_data<="2";//write data:single digit
 state<=state+1'b1;
 end
 7'd21:begin
 lcd_en<=1'b0;
 state<=state+1'b1;
 end
 7'd22:begin
 lcd_rs<=1'b1;
 lcd_en<=1'b1;
 lcd_data<="0";//write data:single digit
 state<=state+1'b1;
 end
 7'd23:begin
 lcd_en<=1'b0;
 state<=state+1'b1;
 end
 7'd24:begin
 lcd_rs<=1'b1;
 lcd_en<=1'b1;
 lcd_data<="2";//write data:single digit
 state<=state+1'b1;
 end
 7'd25:begin
 lcd_en<=1'b0;
 state<=state+1'b1;
 end
 7'd26:begin
 lcd_rs<=1'b1;
 lcd_en<=1'b1;
 lcd_data<="0";//write data:single digit
 state<=state+1'b1;
 end
 7'd27:begin
 lcd_en<=1'b0;
 state<=state+1'b1;
 end
 7'd28:begin
 lcd_rs<=1'b1;
 lcd_en<=1'b1;
 lcd_data<="1";//write data:single digit
 state<=state+1'b1;
 end
 7'd29:begin
 lcd_en<=1'b0;
 state<=state+1'b1;
 end
 7'd30:begin
 lcd_rs<=1'b1;
 lcd_en<=1'b1;
 lcd_data<="0";//write data:single digit
 state<=state+1'b1;
 end
 7'd31:begin
 lcd_en<=1'b0;
 state<=state+1'b1;
 end
 7'd32:begin
 lcd_rs<=1'b1;
 lcd_en<=1'b1;
 lcd_data<="9";//write data:single digit
 state<=state+1'b1;
 end
 7'd33:begin
 lcd_en<=1'b0;
 state<=state+1'b1;
 end
 7'd34:begin
 lcd_rs<=1'b1;
 lcd_en<=1'b1;
 lcd_data<="H";//write data:single digit
 state<=state+1'b1;
 end
 7'd35:begin
 lcd_en<=1'b0;
 state<=state+1'b1;
 end
 7'd36:begin
 lcd_rs<=1'b1;
 lcd_en<=1'b1;
 lcd_data<="F";//write data:single digit
 state<=state+1'b1;
 end
 7'd37:begin
 lcd_en<=1'b0;
 state<=state+1'b1;
 end
 7'd38:begin
 lcd_rs<=1'b1;
 lcd_en<=1'b1;
 lcd_data<="B";//write data:single digit
 state<=state+1'b1;
 end
 
 7'd39:begin
 lcd_en<=1'b0;
 state<=7'd8;
 end

 

 
 
 
 default:state <=7'bxxxxxxx;
 endcase
 end
 
 
 
 
 end
 assign lcd_rw=1'b0;//only write
 //backlight driver
 assign lcd_n=1'b0;
 assign lcd_p=1'b1;
 endmodule