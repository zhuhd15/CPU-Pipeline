module Compare(data1,data2,equal,tpe);
	input [31:0]data1;
	input [31:0]data2;
	input tpe;
	output equal;

	

	assign equal=((data1==data2&&tpe)||(data1!=data2&&~tpe))?1'b1:1'b0;
endmodule
