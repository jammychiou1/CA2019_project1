addi x1, x0, 16
addi x2, x0, 0
addi x0, x0, x0
addi x0, x0, x0
addi x0, x0, x0
addi x0, x0, x0
addi x2, x2, 4
addi x0, x0, x0
addi x0, x0, x0
addi x0, x0, x0
addi x0, x0, x0
sw x2, 0(x2)
beq x1, x2, 2
beq x0, x0, -8
addi x1, x0, 24
