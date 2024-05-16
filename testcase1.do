force -freeze sim:/processor/clk 1 0, 0 {50 ps} -r 100
mem load -filltype value -filldata 1011000000000010 -fillradix symbolic /processor/U2/ram(0)
mem load -filltype value -filldata 0000000000000001 -fillradix symbolic /processor/U2/ram(1)
mem load -filltype value -filldata 1010000011000100 -fillradix symbolic /processor/U2/ram(2)
mem load -filltype value -filldata 1010101010101010 -fillradix symbolic /processor/U2/ram(3)
mem load -filltype value -filldata 0000010000000000 -fillradix symbolic /processor/U2/ram(4)
mem load -filltype value -filldata 1100001000000000 -fillradix symbolic /processor/U2/ram(5)
mem load -filltype value -filldata 1001000000000010 -fillradix symbolic /processor/U2/ram(6)
mem load -filltype value -filldata 1001001000000101 -fillradix symbolic /processor/U2/ram(7)
mem load -filltype value -filldata 1011001000000110 -fillradix symbolic /processor/U2/ram(8)
mem load -filltype value -filldata 1111111111111111 -fillradix symbolic /processor/U2/ram(9)
force -freeze sim:/processor/reset 1 0
run

force -freeze sim:/processor/reset 0 0
run

force -freeze sim:/processor/enable 1 0
run
