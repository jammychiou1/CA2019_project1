module CPU
(
    clk_i, 
    start_i
);

// Ports
input         clk_i;
input         start_i;

wire [31:0] PC_IF;
wire [31:0] Instruction_IF;

reg [31:0] PC_ID;
reg [31:0] Instruction_ID;
reg Flush_ID;

wire RegWrite_ID;
wire MemWrite_ID;
wire ALUSrc_ID;
wire Branch_ID;
wire MemRead_ID;
wire [4:0] RS1Addr_ID;
wire [4:0] RS2Addr_ID;
wire [4:0] RDAddr_ID;
wire [2:0] ALUOp_ID;
wire [31:0] RS1Data_ID;
wire [31:0] RS2Data_ID;
wire [31:0] Immediate_ID;
wire [31:0] JumpOffset_ID;
wire Taken_ID;
wire Stall_ID;

reg RegWrite_EX;
reg MemWrite_EX;
reg ALUSrc_EX;
reg MemRead_EX;
reg [2:0] ALUOp_EX;
reg [31:0] RS1Data_EX;
reg [31:0] RS2Data_EX;
reg [31:0] Immediate_EX;
reg [4:0] RS1Addr_EX;
reg [4:0] RS2Addr_EX;
reg [4:0] RDAddr_EX;

wire [1:0] Forward1_EX;
wire [1:0] Forward2_EX;
wire [31:0] TrueRS1Data_EX;
wire [31:0] TrueRS2Data_EX;
wire [31:0] ALURes_EX;

reg RegWrite_MEM;
reg MemWrite_MEM;
reg MemRead_MEM;
reg [31:0] ALURes_MEM;
reg [31:0] RS2Data_MEM;
reg [4:0] RDAddr_MEM;

wire [31:0] MemData_MEM;

reg RegWrite_WB;
reg MemRead_WB;
reg [31:0] ALURes_WB;
reg [31:0] MemData_WB;
reg [4:0] RDAddr_WB;

wire [31:0] RDData_WB;

PC PC(
    .clk_i          (clk_i),
    .start_i        (start_i),
    .PCWrite_i      (!Stall_ID),
    .pc_i           (Taken_ID ? PC_ID + JumpOffset_ID : PC_IF + 4),
    .pc_o           (PC_IF)
);

Instruction_Memory Instruction_Memory(
    .addr_i         (PC_IF),
    .instr_o        (Instruction_IF)
);

always @(posedge clk_i) begin
    if (!Stall_ID) begin
        PC_ID <= PC_IF;
        Instruction_ID <= Instruction_IF;
        Flush_ID <= Taken_ID;
    end
end

Control Control(
    .Instruction_in (Instruction_ID),
    .Flush_in       (Flush_ID),
    .RegWrite_out   (RegWrite_ID),
    .MemWrite_out   (MemWrite_ID),
    .ALUSrc_out     (ALUSrc_ID),
    .Branch_out     (Branch_ID),
    .MemRead_out    (MemRead_ID),
    .ALUOp_out      (ALUOp_ID)
);

assign RS1Addr_ID = Instruction_ID[19:15];
assign RS2Addr_ID = Instruction_ID[24:20];
assign RDAddr_ID = Instruction_ID[11:7];

Registers Registers(
    .clk_i          (clk_i),
    .RS1addr_i      (RS1Addr_ID),
    .RS2addr_i      (RS2Addr_ID),
    .RDaddr_i       (RDAddr_WB),
    .RDdata_i       (RDData_WB),
    .RegWrite_i     (RegWrite_WB),
    .RS1data_o      (RS1Data_ID),
    .RS2data_o      (RS2Data_ID)
);

Imm_Gen Imm_Gen(
    .Instruction_in (Instruction_ID),
    .Immediate_out  (Immediate_ID)
);

Shift_Left_1 Shift_Left_1(
    .Immediate_in   (Immediate_ID),
    .JumpOffset_out (JumpOffset_ID)
);

HDU HDU(
    .Branch_ID_in   (Branch_ID),
    .Zr_in          (RS1Data_ID == RS2Data_ID),
    .RS1Addr_ID_in  (RS1Addr_ID),
    .RS2Addr_ID_in  (RS2Addr_ID),
    .ALUSrc_ID_in   (ALUSrc_ID),
    .RegWrite_ID_in (RegWrite_ID),
    .MemWrite_ID_in (MemWrite_ID),
    .RegWrite_EX_in (RegWrite_EX),
    .MemRead_EX_in  (MemRead_EX),
    .RDAddr_EX_in   (RDAddr_EX),
    .Taken_out      (Taken_ID),
    .Stall_out      (Stall_ID)
);

always @(posedge clk_i) begin
    RegWrite_EX <= RegWrite_ID & (!Stall_ID);
    MemWrite_EX <= MemWrite_ID & (!Stall_ID);
    ALUSrc_EX <= ALUSrc_ID;
    MemRead_EX <= MemRead_ID;
    ALUOp_EX <= ALUOp_ID;
    RS1Data_EX <= RS1Data_ID;
    RS2Data_EX <= RS2Data_ID;
    Immediate_EX <= Immediate_ID;
    RS1Addr_EX <= RS1Addr_ID;
    RS2Addr_EX <= RS2Addr_ID;
    RDAddr_EX <= RDAddr_ID;
end

Forward Forward(
	.RDAddr_WB		(RDAddr_WB),
	.RDAddr_MEM		(RDAddr_MEM),
	.RegWrite_WB	(RegWrite_WB),
	.RegWrite_MEM	(RegWrite_MEM),
	.RS1Addr_EX		(RS1Addr_EX),
	.RS2Addr_EX		(RS2Addr_EX),
	.Forward1_EX	(Forward1_EX),
	.Forward2_EX	(Forward2_EX)
);                       

assign TrueRS1Data_EX = Forward1_EX == 0 ? RS1Data_EX :
                        Forward1_EX == 1 ? RDData_WB : ALURes_MEM;
assign TrueRS2Data_EX = Forward2_EX == 0 ? RS2Data_EX :
                        Forward2_EX == 1 ? RDData_WB : ALURes_MEM;

ALU ALU(
    .Data1_in       (TrueRS1Data_EX),
    .Data2_in       (ALUSrc_EX ? Immediate_EX : TrueRS2Data_EX),
    .ALUOp_in       (ALUOp_EX),
    .Data_out       (ALURes_EX)
);

always @(posedge clk_i) begin
    RegWrite_MEM <= RegWrite_EX;
    MemWrite_MEM <= MemWrite_EX;
    MemRead_MEM <= MemRead_EX;
    ALURes_MEM <= ALURes_EX;
    RS2Data_MEM <= TrueRS2Data_EX;
    RDAddr_MEM <= RDAddr_EX;
end

Data_Memory Data_Memory(
    .clk_i          (clk_i),

    .addr_i         (ALURes_MEM),
    .MemWrite_i     (MemWrite_MEM),
    .data_i         (RS2Data_MEM),
    .data_o         (MemData_MEM)
);

always @(posedge clk_i) begin
    RegWrite_WB <= RegWrite_MEM;
    MemRead_WB <= MemRead_MEM;
    ALURes_WB <= ALURes_MEM;
    MemData_WB <= MemData_MEM;
    RDAddr_WB <= RDAddr_MEM;
end

assign RDData_WB = MemRead_WB ? MemData_WB : ALURes_WB;

endmodule

