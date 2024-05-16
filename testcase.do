force -freeze sim:/processor/clk 1 0, 0 {50 ps} -r 100
mem load -filltype value -filldata 1010000000000000 -fillradix symbolic /processor/U2/ram(0)
mem load -filltype value -filldata 0000000000000001 -fillradix symbolic /processor/U2/ram(1)
mem load -filltype value -filldata 1010000000000001 -fillradix symbolic /processor/U2/ram(2)
mem load -filltype value -filldata 1010101010101010 -fillradix symbolic /processor/U2/ram(3)
mem load -filltype value -filldata 1010000000000010 -fillradix symbolic /processor/U2/ram(4)
mem load -filltype value -filldata 1111111111111111 -fillradix symbolic /processor/U2/ram(5)
mem load -filltype value -filldata 0001011000000000 -fillradix symbolic /processor/U2/ram(6)
mem load -filltype value -filldata 0101000001000100 -fillradix symbolic /processor/U2/ram(7)
mem load -filltype value -filldata 0001000000000001 -fillradix symbolic /processor/U2/ram(8)
mem load -filltype value -filldata 0101000000000011 -fillradix symbolic /processor/U2/ram(9)
mem load -filltype value -filldata 0001011000000000 -fillradix symbolic /processor/U2/ram(10)
mem load -filltype value -filldata 0100000100010000 -fillradix symbolic /processor/U2/ram(11)
mem load -filltype value -filldata 0110011001100101 -fillradix symbolic /processor/U2/ram(12)
mem load -filltype value -filldata 0101000000000110 -fillradix symbolic /processor/U2/ram(13)
mem load -filltype value -filldata 0100000100010000 -fillradix symbolic /processor/U2/ram(14)
mem load -filltype value -filldata 0100000000101000 -fillradix symbolic /processor/U2/ram(15)
mem load -filltype value -filldata 0110011100011111 -fillradix symbolic /processor/U2/ram(16)
mem load -filltype value -filldata 0001000000000110 -fillradix symbolic /processor/U2/ram(17)
mem load -filltype value -filldata 0001011000000000 -fillradix symbolic /processor/U2/ram(18)


force -freeze sim:/processor/reset 1 0
run

force -freeze sim:/processor/reset 0 0
run

force -freeze sim:/processor/enable 1 0
run
