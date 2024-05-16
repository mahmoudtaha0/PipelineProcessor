LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
ENTITY SP IS
    PORT (
        Clk, Rst, En : IN STD_LOGIC;
        d : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        q : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END SP;

ARCHITECTURE stack_reg OF SP IS
BEGIN
    PROCESS (Clk, Rst)
    BEGIN
        IF Rst = '1' THEN
            q <= "00000000000000000000111111111111";
        ELSIF rising_edge(Clk) THEN
            IF En = '1' THEN
                q <= d;
            END IF;
        END IF;
    END PROCESS;
END stack_reg;