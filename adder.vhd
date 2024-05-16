LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY adder IS
    PORT (
        A, B, cin : IN STD_LOGIC;
        C, cout : OUT STD_LOGIC);
END adder;

ARCHITECTURE arch_adder OF adder IS
BEGIN
    C <= A XOR B XOR cin;
    cout <= (A AND B) OR (cin AND (A XOR B));
END arch_adder;