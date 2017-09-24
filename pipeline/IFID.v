module IFID_Register(speccial_hazard,HazardControl,PC_out,PC_in,Instruchtion_out,Instruchtion_in,clk,reset,IRQ_in,IRQ_out, badInstr);
  input HazardControl;
  input [31:0]Instruchtion_in;
  input [31:0]PC_in;
  input IRQ_in;
  input clk;
  input reset;
  input speccial_hazard;
  output reg [31:0]Instruchtion_out;
  output reg [31:0]PC_out;
  output reg IRQ_out;
  output badInstr;

  assign badInstr = (Instruchtion_out == 32'b0) ? 1 : 0;
  always@(posedge clk or negedge reset)
  begin
    if(!reset)
      begin
        Instruchtion_out<=32'b0;
        PC_out<=32'b0;
        IRQ_out<=1'b0;
      end
    else begin
      if(!HazardControl&&!speccial_hazard)
      begin
        Instruchtion_out<=Instruchtion_in;
        PC_out<=PC_in;
      end
      else
      begin
        Instruchtion_out<=Instruchtion_out;
        PC_out<=PC_out;
      end
      IRQ_out<=IRQ_in;
    end
  end
  
endmodule