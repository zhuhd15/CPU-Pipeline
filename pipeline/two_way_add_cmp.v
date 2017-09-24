module two_way_add_cmp(address1,address2,num1,num2,result);
	input [4:0] address1,address2;
	input [31:0] num1,num2;
	output [31:0] result;

	assign result=(address1==address2)?num1:num2;

	endmodule
