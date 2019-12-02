module Forward (RDAddr_WB, RDAddr_MEM, RegWrite_WB, RegWrite_MEM, RS1Addr_EX, RS2Addr_EX, ForwardA, ForwardB);
input [4:0] RDAddr_WB;
input       RegWrite_WB;
input [4:0] RDAddr_MEM;
input       RegWrite_MEM;
input [4:0] RS1Addr_EX;
input [4:0] RS2Addr_EX;
output [2:0] ForwardA;
output [2:0] ForwardB;

assign ForwardA = (RegWrite_MEM == 1 && RDAddr_MEM != 0 && RDAddr_MEM == RS1Addr_EX ) 2'b10 :
                   (RegWrite_WB ==1 && RDAddr_WB !=0 && RDAddr_EX == RS1Addr_EX ) 2'b01 :
                   	2'b00;
assign ForwardB = (RegWrite_MEM == 1 && RDAddr_MEM != 0 && RDAddr_MEM == RS2Addr_EX ) 2'b10 :
                   (RegWrite_WB ==1 && RDAddr_WB !=0 && RDAddr_EX == RS2Addr_EX ) 2'b01 :
                   	2'b00;
endmodule
