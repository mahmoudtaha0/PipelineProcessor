LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY MWBuffer IS
	PORT (
		--inputs
		clk, reset, write_enable : IN STD_LOGIC;
		writeRegAddr : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
		readdata, alu_result : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		imm_value : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		imm_enable : IN STD_LOGIC;
		--outputs
		write_enable_out : OUT STD_LOGIC;
		imm_enable_out : OUT STD_LOGIC;
		readdata_out, alu_result_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		imm_value_out : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		writeRegAddr_out : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
		IN_PORT : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		IN_PORT_MW : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		ReadData1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		ReadData1_MW : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END MWBuffer;

ARCHITECTURE mymodel OF MWBuffer IS
BEGIN
	PROCESS (clk, reset)
	BEGIN
		IF reset = '1' THEN
			write_enable_out <= '0';
			readdata_out <= (OTHERS => '0');
			alu_result_out <= (OTHERS => '0');
			writeRegAddr_out <= (OTHERS => '0');
			imm_value_out <= (OTHERS => '0');
			imm_enable_out <= '0';
			IN_PORT_MW <= (OTHERS => '0');
			ReadData1_MW <= (OTHERS => '0');
		ELSE
			IF rising_edge(clk) THEN
				write_enable_out <= write_enable;
				readdata_out <= readdata;
				alu_result_out <= alu_result;
				writeRegAddr_out <= writeRegAddr;
				imm_value_out <= imm_value;
				imm_enable_out <= imm_enable;
				IN_PORT_MW <= IN_PORT;
				ReadData1_MW <= ReadData1;
			END IF;
		END IF;
	END PROCESS;
END ARCHITECTURE;