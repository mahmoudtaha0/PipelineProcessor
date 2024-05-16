LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

entity ALU_Control IS
port (
    opcode : in std_logic_vector(6 downto 0);
    ALU_Code : out std_logic_vector(3 downto 0)
);
end ALU_Control;

architecture behavior of ALU_Control is 
begin
    with opcode select
    ALU_Code <= "0100" when "0110000" | "0111000" | "1011000" | "1011001", -- PLUS
    "0101" when "0110001" | "0111001", -- MINUS
    "0110" when "0001001", -- NEG
    "0111" when "0001010", -- INC
    "1000" when "0001011", -- DEC
    "0000" when "0001000", -- NOT
    "0001" when "0110010", -- AND
    "0010" when "0110011", -- OR
    "0011" when "0110100", -- XOR
    "1001" when "0100000", -- CMP
    "1111" when others; -- DUMMY
end architecture;