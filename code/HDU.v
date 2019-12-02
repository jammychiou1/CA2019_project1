module HDU(Branch_ID_in, Zr_in, RS1Addr_ID_in, RS2Addr_ID_in, ALUSrc_ID_in, RegWrite_ID_in, MemWrite_ID_in,
           RegWrite_EX_in, MemRead_EX_in, RDAddr_EX_in, RegWrite_MEM_in, MemRead_MEM_in, RDAddr_MEM_in, Taken_out, Stall_out);
input Branch_ID_in;
input Zr_in;
input [4:0] RS1Addr_ID_in;
input [4:0] RS2Addr_ID_in;
input ALUSrc_ID_in;
input RegWrite_ID_in;
input MemWrite_ID_in;
input RegWrite_EX_in;
input MemRead_EX_in;
input [4:0] RDAddr_EX_in;
input RegWrite_MEM_in;
input MemRead_MEM_in;
input [4:0] RDAddr_MEM_in;
output Taken_out;
output Stall_out;

wire RS1_EX;
wire RS2_EX;
wire RS1_MEM;
wire RS2_MEM;

assign Taken_out = Branch_ID_in & Zr_in & !Stall_out;

assign RS1_EX = RS1Addr_ID_in != 0 & RS1Addr_ID_in == RDAddr_EX_in;
assign RS2_EX = (!ALUSrc_ID_in) & RS2Addr_ID_in != 0 & RS2Addr_ID_in == RDAddr_EX_in;
assign RS1_MEM = RS1Addr_ID_in != 0 & RS1Addr_ID_in == RDAddr_MEM_in;
assign RS2_MEM = (!ALUSrc_ID_in) & RS2Addr_ID_in != 0 & RS2Addr_ID_in == RDAddr_MEM_in;

assign Stall_out = (Branch_ID_in & RegWrite_EX_in & (RS1_EX | RS2_EX)) | 
                   (Branch_ID_in & (RegWrite_MEM_in & MemRead_MEM_in) & (RS1_MEM | RS2_MEM)) |
                   ((RegWrite_ID_in | MemWrite_ID_in) & (RegWrite_EX_in & MemRead_EX_in) & (RS1_EX | RS2_EX));
endmodule 
