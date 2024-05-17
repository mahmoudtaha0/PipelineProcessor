
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY ProgramCounter IS
	PORT (
		PC_in : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		clk, rst, en : IN STD_LOGIC;
		c : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
END ENTITY;

ARCHITECTURE my_model OF ProgramCounter IS
	-- SIGNAL C2 : STD_LOGIC_VECTOR (31 DOWNTO 0);

BEGIN
	PROCESS (clk, rst)
	BEGIN
		IF rst = '1' THEN
			c <= (OTHERS => '0');
		ELSIF rising_edge(clk) THEN
			IF en = '1' THEN
				IF PC_in = "11111111111111111111111111111111" THEN
					c <= (OTHERS => '0');
				ELSE
					c <= STD_LOGIC_VECTOR(unsigned(PC_in) + 1);
				END IF;
			END IF;
		END IF;
	END PROCESS;
END ARCHITECTURE;