module ALU(A,B,ALUFun,Sign,Z);
  input [31:0]A;
  input [31:0]B;
  input [5:0]ALUFun;
  input Sign;
  output reg [31:0]Z;
  
  wire [31:0]Calculate;
  wire [31:0]CMP;
  wire [31:0]Logic;
  wire [31:0]Shift;
  
  reg [32:0]temp_V;
  reg [31:0]temp_C;
  reg [31:0]temp_L;
  reg [31:0]temp_S;
  
  reg zero;
  reg V;
  reg N;
  
  wire [31:0]Shift_left_1;
  wire [31:0]Shift_left_2;
  wire [31:0]Shift_left_4;
  wire [31:0]Shift_left_8;
  wire [31:0]Shift_left_16;
  
  wire [31:0]Shift_right_1;
  wire [31:0]Shift_right_2;
  wire [31:0]Shift_right_4;
  wire [31:0]Shift_right_8;
  wire [31:0]Shift_right_16;
  
  wire [31:0]Shift_right_sign_1;
  wire [31:0]Shift_right_sign_2;
  wire [31:0]Shift_right_sign_4;
  wire [31:0]Shift_right_sign_8;
  wire [31:0]Shift_right_sign_16;
  
  always@(*)
  begin
    case(ALUFun[5:4])
      2'b00:Z=Calculate;
      2'b11:Z=CMP;
      2'b10:Z=Shift;
      2'b01:Z=Logic;
    endcase
    
    case(ALUFun[0])
      1'b0:
      begin
        temp_V=A+B;
        //Calculate=temp_V[31:0];
        zero=(Calculate==32'b0)?1'b0:1'b1;
        V=temp_V[32];
        N=Sign?temp_V[31]:temp_V[32];
      end
      1'b1:
      begin
        temp_V=A+(~B)+1;
        zero=(Calculate==32'b0)?1'b0:1'b1;
        V=temp_V[32];
        N=Sign?temp_V[31]:temp_V[32];
      end
    endcase
    
    case(ALUFun[3:1])
      3'b001:temp_C={31'b0,~zero};
      3'b000:temp_C={31'b0,zero};
      3'b010:temp_C={31'b0,N};
      3'b110:temp_C={31'b0,(Sign&A[31])|(A[31:0]==32'b0)};
      3'b101:temp_C={31'b0,Sign&A[31]};
      3'b111:temp_C={31'b0,(~(Sign&A[31])&A!=32'b0)};
    endcase
    
    case(ALUFun[3:0])
      4'b1000:temp_L=A&B;
      4'b1110:temp_L=A|B;
      4'b0110:temp_L=A^B;
      4'b0001:temp_L=~(A|B);
      4'b1010:temp_L=A;
    endcase
    
    case(ALUFun[1:0])
      2'b00:temp_S=Shift_left_16;
      2'b01:temp_S=Shift_right_16;
      2'b11:
      begin
        case(B[31])
          1'b0:temp_S=Shift_right_16;
          1'b1:temp_S=Shift_right_sign_16;
        endcase
      end
    endcase
    
    
    
    
  end
  
  
  assign Calculate[31:0] =temp_V[31:0];
  assign CMP[31:0] = temp_C[31:0];
  assign Logic[31:0]=temp_L[31:0];
  assign Shift[31:0]=temp_S[31:0];
  
  assign Shift_left_1=A[0]?{B[30:0],1'b0}:B;
  assign Shift_left_2=A[1]?{Shift_left_1[29:0],2'b0}:Shift_left_1;
  assign Shift_left_4=A[2]?{Shift_left_2[27:0],4'b0}:Shift_left_2;
  assign Shift_left_8=A[3]?{Shift_left_4[23:0],8'b0}:Shift_left_4;
  assign Shift_left_16=A[4]?{Shift_left_8[18:0],16'b0}:Shift_left_8;
  
  assign Shift_right_1=A[0]?{1'b0,B[31:1]}:B;
  assign Shift_right_2=A[1]?{2'b0,Shift_right_1[31:2]}:Shift_right_1;
  assign Shift_right_4=A[2]?{4'b0,Shift_right_2[31:4]}:Shift_right_2;
  assign Shift_right_8=A[3]?{8'b0,Shift_right_4[31:8]}:Shift_right_4;
  assign Shift_right_16=A[4]?{16'b0,Shift_right_8[31:16]}:Shift_right_8;
  
  assign Shift_right_sign_1=A[0]?{1'b1,B[31:1]}:B;
  assign Shift_right_sign_2=A[1]?{2'b11,Shift_right_1[31:2]}:Shift_right_1;
  assign Shift_right_sign_4=A[2]?{4'b1111,Shift_right_2[31:4]}:Shift_right_2;
  assign Shift_right_sign_8=A[3]?{8'b11111111,Shift_right_4[31:8]}:Shift_right_4;
  assign Shift_right_sign_16=A[4]?{16'b1111111111111111,Shift_right_8[31:16]}:Shift_right_8;
  
endmodule