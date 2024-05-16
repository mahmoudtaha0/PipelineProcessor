
library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;

ENTITY ProgramCounter IS
PORT (
	clk, rst, en: IN std_logic;
	c : OUT std_logic_vector (31 DOWNTO 0)
);
END ENTITY;

ARCHITECTURE my_model OF ProgramCounter IS 
SIGNAL C2: std_logic_vector (31 DOWNTO 0);

BEGIN
c <= C2;

PROCESS (clk, rst)
BEGIN
IF rst = '1' THEN
	C2<= (OTHERS => '0');
ELSIF rising_edge(clk) THEN
	IF en = '1' THEN
		IF C2 = "11111111111111111111111111111111" THEN 
			C2 <= (OTHERS => '0');
		ELSE
			C2 <= std_logic_vector(unsigned(C2) + 1);
		END IF;
	END IF;
END IF;


END PROCESS;
END ARCHITECTURE;

 
