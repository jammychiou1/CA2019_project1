module HDU(Branch_in, Zr_in, Taken_out);
input Branch_in;
input Zr_in;
output Taken_out;
assign Taken_out = Branch_in & Zr_in;
endmodule
