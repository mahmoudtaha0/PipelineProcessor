LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY mux4 IS
    PORT (
        in0, in1, in2, in3 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        sel      : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        out1     : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END mux4;

ARCHITECTURE arch_mux4 OF mux4 IS
BEGIN
    PROCESS (sel, in0, in1, in2, in3)
    BEGIN
        IF sel = "00" THEN
            out1 <= in0;
        ELSIF sel = "01" THEN
            out1 <= in1;
        ELSIF sel = "10" THEN
            out1 <= in2;
        ELSIF sel = "11" THEN
            out1 <= in3;
        END IF;
    END PROCESS;
END arch_mux4;