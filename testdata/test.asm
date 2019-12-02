addi x1, x0, 16
addi x2, x0, 0
addi x2, x2, 4
sw x2, 0(x2)
add x1, x1, x0
beq x1, x2, 2
beq x0, x0, -4
addi x1, x0, 24
