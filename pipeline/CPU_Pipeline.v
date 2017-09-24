module CPU_Pipeline(clk,reset,switch,led,digi,rx_data,tx_data,rx_status,tx_status,tx_en);  
  input clk;
  input reset;
  input [7:0] switch;
  input [7:0] rx_data;
  input rx_status;
  input tx_status;
  output wire tx_en;
  output wire [7:0]tx_data;
	output wire[7:0] led;
	output wire[11:0] digi;	
	
  wire bad_signal;
  wire [4:0]Xp;
  assign Xp=5'b11010;
  wire [4:0]Ra;
  assign Ra=5'b11111;
  //IF period
	reg [31:0]PC;
  wire [31:0]PCnext;
  wire [31:0]Instruct;
  
  //IF-ID register
  wire [31:0]IF_ID_PC_in;
  wire [31:0]IF_ID_Instruct_in;
  wire [31:0]IF_ID_PC_out;
  wire [31:0]IF_ID_Instruct_out;
  wire IF_ID_IRQ_in;
  wire IF_ID_IRQ_out;
  wire IF_ID_PC31;
  wire IF_ID_badInstr; //renew
  
  assign IF_ID_PC31 = IF_ID_PC_out[31];
  //ID period
  wire [31:0]UI_VALUE;      //For LUI
  wire [31:0]imm32;
  wire [25:0]IF_ID_JT;
  wire [2:0]PCSrc;
  //wire [31:0]DATAbusA;
  wire compare1;            //compare for pcsrc
  wire compare2;            //compare for pcsrc
  wire PC_sign;             //difference from two address
  wire [31:0]addr1;
  wire [31:0]addr2;
  wire [31:0]ConBAd;
  wire LUOp;
  wire [31:0]XSHAMP;        //displacement
  wire Sgn_Hazard;          //Hazard signal
  wire flush_signal;
  wire [4:0]EX_MEM_RegAddress_in;

  //ID-EX register
  wire ID_EX_SIGN_1bit_in;
  wire [31:0]ID_EX_VALUE1_in;
  wire [31:0]ID_EX_VALUE2_in;
  wire [31:0]ID_EX_SGN_in;
  wire [4:0]ID_EX_shamt_in;
  wire [4:0]ID_EX_RS_in;
  wire [4:0]ID_EX_RT_in;
  wire [4:0]ID_EX_RD_in;
  wire [5:0]ID_EX_ALUFun_in;
  wire ID_EX_ExtOp_in;
  wire ID_EX_ALUSrc1_in;
  wire ID_EX_ALUSrc2_in;
  wire [1:0]ID_EX_RegDst_in;
  wire ID_EX_MemWr_in;
  wire ID_EX_MemRd_in;
  wire [1:0]ID_EX_MemtoReg_in;
  wire ID_EX_RegWR_in;
  wire [31:0]ID_EX_VALUE1_out;
  wire [31:0]ID_EX_VALUE2_out;
  wire [31:0]ID_EX_SGN_out;
  wire [4:0]ID_EX_shamt_out;
  wire [4:0]ID_EX_RS_out;
  wire [4:0]ID_EX_RT_out;
  wire [4:0]ID_EX_RD_out;
  wire [5:0]ID_EX_ALUFun_out;
  wire ID_EX_ExtOp_out;
  wire ID_EX_ALUSrc1_out;
  wire ID_EX_MemRd_out;
  wire ID_EX_ALUSrc2_out;
  wire [1:0]ID_EX_RegDst_out;
  wire ID_EX_MemWr_out;
  wire [1:0]ID_EX_MemtoReg_out;
  wire ID_EX_RegWR_out;
  wire ID_EX_SIGN_1bit_out;
  wire [31:0]ID_EX_PCp4m4_in;
  
  //EX period
  reg [4:0]EX_MEM_RegAddress_out;
  wire [4:0]MEM_WB_WBAddress_out;
  wire [31:0]RdData1;
  wire [31:0]RdData2;
  wire [1:0]FORWARD_SGN_1;
  wire [1:0]FORWARD_SGN_2;
  wire [31:0]FORWARD_NUM_1;
  wire [31:0]FORWARD_NUM_2;
  
  wire [31:0]ALU_input1;
  wire [31:0]ALU_input2;
  wire [4:0]RegFile_Dst;
  
  //EX-MEM register
  wire [31:0]EX_MEM_ALUResult_in;
  wire [31:0]EX_MEM_BusB_in;
  wire EX_MEM_MemWr_in;
  wire EX_MEM_MemRd_in;
  wire [1:0]EX_MEM_MemtoReg_in;
  
  wire [31:0]EX_MEM_ALUResult_out;
  wire [31:0]EX_MEM_BusB_out;
  wire EX_MEM_MemWr_out;
  wire EX_MEM_MemRd_out;
  wire [1:0]EX_MEM_MemtoReg_out;
  
  //MEM-WB register
  wire [31:0]MEM_WB_Memory_in;
  wire [1:0]MEM_WB_MemtoReg_in;
  wire MEM_WB_RegWr_in;

  wire [31:0]MEM_WB_Memory_out;
  wire [31:0]ALU_Result_out;
  wire [1:0]MEM_WB_MemtoReg_out;
  wire MEM_WB_RegWr_out;

  //WB period
  wire [31:0]WB_VALUE;
  

//IF period

InstructMem INS_MEM(.Address(PC), .Instruction(Instruct));  
Two_way_selector IFFlush(.num_A(Instruct),.num_B(32'b0),.sel_signal(flush_signal),.result(IF_ID_Instruct_in));

wire speccial_hazard;
always @(negedge reset or posedge clk)
if(!reset)
  PC=32'b00000000_00000000_00000000_00000000;
else
  if(!Sgn_Hazard&&!speccial_hazard)
    PC=PCnext;
  else
    PC=PC;

assign IF_ID_PC_in=PC+32'b00000000_00000000_00000000_00000100;
//IF-ID
IFID_Register IFID_REG(
.speccial_hazard(speccial_hazard),
  .HazardControl(Sgn_Hazard),
  .PC_out(IF_ID_PC_out),
  .PC_in(IF_ID_PC_in),
  .Instruchtion_out(IF_ID_Instruct_out),
  .Instruchtion_in(IF_ID_Instruct_in),
  .clk(clk),
  .reset(reset),
  .IRQ_out(IF_ID_IRQ_out),
  .IRQ_in(IF_ID_IRQ_in),
  .badInstr(IF_ID_badInstr)
  );
 
//ID 
//reg [2:0]PSCRC_FMER;
//always@(negedge clk)
//  PSCRC_FMER=PCSrc;
  
//always@(posedge clk)
//  IF_ID_Instruct_out=(PSCRC_FMER==3'b010)?32'b0:IF_ID_Instruct_out_temp;


assign UI_VALUE={IF_ID_Instruct_out[15:0],16'b0};
assign ConBAd=IF_ID_PC_out+{imm32[29:0],2'b00};
assign IF_ID_JT=IF_ID_Instruct_out[25:0];
assign ID_EX_shamt_in=IF_ID_Instruct_out[10:6];
assign ID_EX_RS_in=IF_ID_Instruct_out[25:21];
assign ID_EX_RT_in=IF_ID_Instruct_out[20:16];
assign ID_EX_RD_in=IF_ID_Instruct_out[15:11];

 
Control CTRL(
.IRQ(IF_ID_IRQ_out),
.PC31(IF_ID_PC31),
.OpCode(IF_ID_Instruct_out[31:26]), 
.Funct(IF_ID_Instruct_out[5:0]), 
.PCSrc(PCSrc),
.RegDst(ID_EX_RegDst_in), 
.RegWr(ID_EX_RegWR_in), 
.ALUSrc1(ID_EX_ALUSrc1_in), 
.ALUSrc2(ID_EX_ALUSrc2_in), 
.ALUFun(ID_EX_ALUFun_in), 
.sign(ID_EX_SIGN_1bit_in), 
.MemWr(ID_EX_MemWr_in), 
.MemRd(ID_EX_MemRd_in), 
.MemtoReg(ID_EX_MemtoReg_in), 
.ExtOp(ID_EX_ExtOp_in), 
.LUOp(LUOp));
  
wire [31:0] temp_value1,temp_value2;
RegFile REG_FILE
(.reset(reset), 
.clk(clk), 
.AddrA(IF_ID_Instruct_out[25:21]), 
.AddrB(IF_ID_Instruct_out[20:16]), 
.AddrC(MEM_WB_WBAddress_out), 
.WrC(MEM_WB_RegWr_out), 
.WrtDataC(WB_VALUE), 
.RdDataA(temp_value1), 
.RdDataB(temp_value2));

PCplus4minus4 ppm(.IRQ(IF_ID_IRQ_out), .PC31(IF_ID_PC31), .in(IF_ID_PC_out), .out(ID_EX_PCp4m4_in), .badInstr(IF_ID_badInstr));
two_way_add_cmp wbad1(.address1(IF_ID_Instruct_out[25:21]),.address2(MEM_WB_WBAddress_out),.num1(WB_VALUE),.num2(temp_value1),.result(ID_EX_VALUE1_in));
two_way_add_cmp wbad2(.address1(IF_ID_Instruct_out[20:16]),.address2(MEM_WB_WBAddress_out),.num1(WB_VALUE),.num2(temp_value2),.result(ID_EX_VALUE2_in));

reg HZ_rec;
always@(posedge clk or negedge reset)
if(!reset)
HZ_rec=1'b0;
else
HZ_rec=speccial_hazard;


Hazard Hazard_UNIT
(.ID_EX_RT(ID_EX_RT_out),
.IF_ID_RS(IF_ID_Instruct_out[25:21]),
.IF_ID_RT(IF_ID_Instruct_out[20:16]),
.ID_EX_MEMRead(ID_EX_MemRd_out),
.JMP(PCSrc),
.Hazard_signal(Sgn_Hazard),
.flush(flush_signal),
.pc_sign(PC_sign),
.reset(reset),
.IRQ(IF_ID_IRQ_out),
.PC31(IF_ID_PC31),
.OpCode(IF_ID_Instruct_out[31:26]),
.HZ_rec(HZ_rec),
.speccial_hazard(speccial_hazard)
);
 
wire tpe;
assign tpe=(IF_ID_Instruct_out[31:26]==6'b000100)?1'b1:1'b0;
Forward_PC FP(.EX_MEM_WB(EX_MEM_RegAddress_out),.IF_ID_R1(ID_EX_RS_in),.IF_ID_R2(ID_EX_RT_in),.address1(compare1),.address2(compare2));
Two_way_selector TWS1(.num_A(ID_EX_VALUE1_in),.num_B(EX_MEM_ALUResult_out),.sel_signal(compare1),.result(addr1));
Two_way_selector TWS2(.num_A(ID_EX_VALUE2_in),.num_B(EX_MEM_ALUResult_out),.sel_signal(compare2),.result(addr2));
Compare Cmp(.data1(addr1),.data2(addr2),.equal(PC_sign),.tpe(tpe));
PCnext_MUX PC_NXT_SEL(.PCSrc(PCSrc),.ALUOut(PC_sign),.PCplus4(IF_ID_PC_in),.ConBA(ConBAd), .JT(IF_ID_JT), .DATAbusA(temp_value1), .PCnext(PCnext));


EXT32 extension(.imm16(IF_ID_Instruct_out[15:0]), .ExtOp(ID_EX_SIGN_1bit_in), .imm32(imm32));
Two_way_selector EXT_VALUE(.num_A(imm32),.num_B(UI_VALUE),.sel_signal(LUOp),.result(ID_EX_SGN_in));

wire [31:0]ID_EX_PC_out;
//ID-EX
IDEX_Register IDEX_REG
(.speccial_hazard(speccial_hazard),
.ID_EX_PCP4_in(ID_EX_PCp4m4_in),
.ID_EX_PCP4_out(ID_EX_PC_out),
.hazard(Sgn_Hazard),
.ID_EX_SIGN_1bit_out(ID_EX_SIGN_1bit_out),
.ID_EX_SIGN_1bit_in(ID_EX_SIGN_1bit_in),
.shamt_out(ID_EX_shamt_out),
.ALUFun_out(ID_EX_ALUFun_out),
.ReadData1_out(ID_EX_VALUE1_out),
.ReadData2_out(ID_EX_VALUE2_out),
.SgnExtend_out(ID_EX_SGN_out),
.Rs_out(ID_EX_RS_out),
.Rt_out(ID_EX_RT_out),
.Rd_out(ID_EX_RD_out),
.ExtOp_out(ID_EX_ExtOp_out),
.ALUSrc1_out(ID_EX_ALUSrc1_out),
.ALUSrc2_out(ID_EX_ALUSrc2_out),
.RegDst_out(ID_EX_RegDst_out),
.MemWr_out(ID_EX_MemWr_out),
.MemRd_out(ID_EX_MemRd_out),
.MemtoReg_out(ID_EX_MemtoReg_out),
.RegWr_out(ID_EX_RegWR_out),
.shamt_in(ID_EX_shamt_in),
.ALUFun_in(ID_EX_ALUFun_in),
.ReadData1_in(ID_EX_VALUE1_in),
.ReadData2_in(ID_EX_VALUE2_in),
.SgnExtend_in(ID_EX_SGN_in),
.Rs_in(ID_EX_RS_in),
.Rt_in(ID_EX_RT_in),
.Rd_in(ID_EX_RD_in),
.ExtOp_in(ID_EX_ExtOp_in),
.ALUSrc1_in(ID_EX_ALUSrc1_in),
.ALUSrc2_in(ID_EX_ALUSrc2_in),
.RegDst_in(ID_EX_RegDst_in),
.MemWr_in(ID_EX_MemWr_in),
.MemRd_in(ID_EX_MemRd_in),
.MemtoReg_in(ID_EX_MemtoReg_in),
.RegWr_in(ID_EX_RegWR_in),
.clk(clk),
.reset(reset));


//EX
assign EX_MEM_MemtoReg_in=ID_EX_MemtoReg_out;
assign EX_MEM_MemWr_in=ID_EX_MemWr_out;
assign EX_MEM_MemRd_in=ID_EX_MemRd_out;
assign EX_MEM_BusB_in=FORWARD_NUM_2;
assign XSHAMP={27'b0,ID_EX_shamt_out};
assign EX_MEM_RegAddress_in=RegFile_Dst;


Four_way_selector DSTTarget
(.num_A(ID_EX_RD_out),
.num_B(ID_EX_RT_out),
.num_C(Ra),
.num_D(Xp),
.sel_signal(ID_EX_RegDst_out),
.result(RegFile_Dst));


ForwardUnit FORWARD
(
.EX_MEM_RD(EX_MEM_RegAddress_out),
.MEM_WB_RD(MEM_WB_WBAddress_out),
.ID_EX_RS(ID_EX_RS_out),
.ID_EX_RT(ID_EX_RT_out),
.EX_MEM_RegWrite(MEM_WB_RegWr_in),
.MEM_WB_RegWrite(MEM_WB_RegWr_out),
.Forward_Signal_A(FORWARD_SGN_1),
.Forward_Signal_B(FORWARD_SGN_2));

/*
Three_way_special firstALUin
(.num_A(ID_EX_VALUE1_out),
.num_B(WB_VALUE),
.num_C(EX_MEM_ALUResult_out),
.num_D(XSHAMP),
.forwardSign(FORWARD_SGN_1),
.PcSrcSgn(ID_EX_ALUSrc1_out),
.result(ALU_input1)
);
Three_way_special secondALUin
(.num_A(ID_EX_VALUE2_out),
.num_B(WB_VALUE),
.num_C(EX_MEM_ALUResult_out),
.num_D(ID_EX_SGN_out),
.forwardSign(FORWARD_SGN_2),
.PcSrcSgn(ID_EX_ALUSrc2_out),
.result(ALU_input2)
);
*/

Three_way_selector Forward_selector1
(.num_A(ID_EX_VALUE1_out),
.num_B(WB_VALUE),
.num_C(EX_MEM_ALUResult_out),
.sel_signal(FORWARD_SGN_1),
.result(FORWARD_NUM_1)
);

Three_way_selector Forward_selector2
(.num_A(ID_EX_VALUE2_out),
.num_B(WB_VALUE),
.num_C(EX_MEM_ALUResult_out),
.sel_signal(FORWARD_SGN_2),
.result(FORWARD_NUM_2)
);


Two_way_selector ALU_first_pipeline(.num_A(FORWARD_NUM_1),.num_B(XSHAMP),.sel_signal(ID_EX_ALUSrc1_out),.result(ALU_input1));
Two_way_selector ALU_second_pipeline(.num_A(FORWARD_NUM_2),.num_B(ID_EX_SGN_out),.sel_signal(ID_EX_ALUSrc2_out),.result(ALU_input2));

ALU ALUunit(.A(ALU_input1),.B(ALU_input2),.ALUFun(ID_EX_ALUFun_out),.Sign(ID_EX_SIGN_1bit_out),.Z(EX_MEM_ALUResult_in));

always@(posedge clk or negedge reset)
if(!reset)
EX_MEM_RegAddress_out=5'b0;
else
EX_MEM_RegAddress_out=RegFile_Dst;


//EX-MEM
wire [31:0]EX_MEM_PC_out;
EXMEM_Register EXMEM_REG
(
.EX_MEM_PCP4_in(ID_EX_PC_out),
.EX_MEM_PCP4_out(EX_MEM_PC_out),
.ALUResult_in(EX_MEM_ALUResult_in),
.BusB_in(EX_MEM_BusB_in),
.MemWr_in(EX_MEM_MemWr_in),
.MemRd_in(EX_MEM_MemRd_in),
.MemtoReg_in(EX_MEM_MemtoReg_in),
.RegWr_in(ID_EX_RegWR_out),
.clk(clk),
.reset(reset),
.ALUResult_out(EX_MEM_ALUResult_out),
.BusB_out(EX_MEM_BusB_out),
.MemWr_out(EX_MEM_MemWr_out),
.MemRd_out(EX_MEM_MemRd_out),
.MemtoReg_out(EX_MEM_MemtoReg_out),
.RegWr_out(MEM_WB_RegWr_in)
);

//MEM
assign EX_MEM_MemWr_in=ID_EX_MemWr_out;
//assign ID_EX_VALUE2_in=EX_MEM_ALUResult_out;
assign MEM_WB_MemtoReg_in=EX_MEM_MemtoReg_out;

RAM ram(.reset(reset), 
.clk(clk), 
.WrtData(EX_MEM_BusB_out), 
.MemRd(EX_MEM_MemRd_out), 
.MemWr(EX_MEM_MemWr_out), 
.Addr(EX_MEM_ALUResult_out), 
.RdData(RdData1));

Peripheral pp
(.reset(reset), 
.clk(clk), 
.rd(EX_MEM_MemRd_out), 
.wr(EX_MEM_MemWr_out), 
.addr(EX_MEM_ALUResult_out), 
.wdata(EX_MEM_BusB_out), 
.rdata(RdData2), 
.led(led), 
.switch(switch), 
.digi(digi), 
.irqout(IF_ID_IRQ_in), 
.tx_data(tx_data), 
.rx_data(rx_data), 
.rx_status(rx_status), 
.tx_status(tx_status), 
.tx_en(tx_en));

RdData_Mux ram_pp
(.RdData1(RdData1), 
.RdData2(RdData2), 
.ALUOut(EX_MEM_ALUResult_out), 
.RdData(MEM_WB_Memory_in));

//MEM-WB
wire [31:0]MEM_WB_PC_out;
MEMWB_Register MEMWB_REG
(
.MEM_WB_PCP4_in(EX_MEM_PC_out),
.MEM_WB_PCP4_out(MEM_WB_PC_out),
.Memory_in(MEM_WB_Memory_in),
  .BusB_in(EX_MEM_ALUResult_out),
  .WBAddress_in(EX_MEM_RegAddress_out),
  .MemtoReg_in(MEM_WB_MemtoReg_in),
  .RegWr_in(MEM_WB_RegWr_in),
  .clk(clk),
  .reset(reset),
  .Memory_out(MEM_WB_Memory_out),
  .BusB_out(ALU_Result_out),
  .WBAddress_out(MEM_WB_WBAddress_out),
  .MemtoReg_out(MEM_WB_MemtoReg_out),
  .RegWr_out(MEM_WB_RegWr_out)
  );
  
  //WB
Three_way_selector REG_WRITE_BACK
(.num_A(ALU_Result_out),
.num_B(MEM_WB_Memory_out),
.num_C(MEM_WB_PC_out),
.sel_signal(MEM_WB_MemtoReg_out),
.result(WB_VALUE)
);
endmodule

