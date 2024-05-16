LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY Demux16Bit IS
    PORT (
        F : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        Sel : IN STD_LOGIC;
        A, B : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END Demux16Bit;

ARCHITECTURE bhv OF Demux16Bit IS
BEGIN
    A <= F WHEN Sel = '0' ELSE
        (OTHERS => '0');
    B <= F WHEN Sel = '1' ELSE
        (OTHERS => '0');
END bhv;
