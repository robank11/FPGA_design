'timescale 1 ns / 100 ps 
moduleax_debounce(
	input	clk,
	input	rst,
	input	button_in, 
	output reg button_posedge, 
	output reg button_negedge, 
	output reg button_outinput
);
//内部常量
parameter N = 32;//去抖动定时器位宽
parameter FREQ = 50;//模型时钟:兆赫
parameter MAX_TIME = 20;//ms
localparam TIMER_MAX_VAL =MAX_TIME * 1000 * FREQ;
//内部变量
reg[N-1: 0]q_reg;//定时规则
reg [N-1: 0] q_next;
reg DFF1, DFF2;// input flip-flops
wire q_add;//控制标志
wire q_reset;
reg button_out_d0;

assign q_reset = (DFF1 ^DFF2); //异或输入触发器寻找电平变化复位计数器
chage to reset counter
assign q_add = ~(q_reg ==TIMER_MAX_VAL);//当q_reg MSB 等于0时添加到计数器
////然后连击计数器管理q
always @ (q_reset, q_add, q_reg) 
begin
	case( {q_reset, q_add})
		2'b00:
			q_next <= q_reg;
		2'b01:
			q_next <= q_reg + 1;
		default:
			q_next <= {N {1'b0}};
	endcase
end

////触发器输入和qreg更新
always @ ( posedge clk or posedge rst) 
begin
	if(rst == 1'b1)
	begin
		DFF1 <= 1'bo;
		DFF2 <= 1'bo;
		q_reg <={N {1'b0}};
	end
	else
	begin
		DFF1 <= button_in;
		DFF2 <= DFF1;
		q_reg <= q_next,
	end
end
////计数器控制
always @ ( posedge clk or posedge rst)
begin
	if(rst == 1'b1)
		button_out <= 1'b1;
	else if(q_reg == TIMER_MAX_VAL) 
		button_out <= DFF2;
	else
		button_out <= button_out;
end
always @ ( posedge clk or posedge rst)
begin
	if(rst == 1'b1)
	begin
		button_out_dO <= 1'b1;
		button_posedge <= 1'b0;
		button_negedge <= 1'b0;
	end
	else
	begin
		button_out_do <= button_out;
		button_posedge <= ~button_out_d0 & button_out;
		button_negedge <= button_out_do & ~button_out;
	end
end 
endmodule