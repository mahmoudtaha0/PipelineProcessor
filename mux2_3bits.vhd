LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY mux2_3bits IS
    PORT (
        in0, in1 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        sel      : IN STD_LOGIC;
        out1     : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
    );
END mux2_3bits;

ARCHITECTURE arch_mux2_3 OF mux2_3bits IS
BEGIN
    PROCESS (sel, in0, in1)
    BEGIN
        IF sel = '0' THEN
            out1 <= in0;
        ELSE
            out1 <= in1;
        END IF;
    END PROCESS;
END arch_mux2_3;