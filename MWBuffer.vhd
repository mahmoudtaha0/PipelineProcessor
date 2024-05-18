LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY MWBuffer IS
	PORT (
		--inputs
		MW_Flush : IN STD_LOGIC;
		clk, reset, write_enable : IN STD_LOGIC;
		writeRegAddr : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
		readdata2, alu_result : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		alu_result_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		imm_value : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		imm_enable : IN STD_LOGIC;
		FW_op1, FW_op2 : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
		out_port_in,in_port_en : IN STD_LOGIC;
		--outputs
		write_enable_out : OUT STD_LOGIC;
		imm_enable_out : OUT STD_LOGIC;
		readdata2_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		imm_value_out : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		writeRegAddr_out : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
		IN_PORT : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		IN_PORT_MW : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		ReadData1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		FW_op1_out, FW_op2_out : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
		out_port_out,in_port_en_out : OUT STD_LOGIC;
		ReadData1_MW : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END MWBuffer;

ARCHITECTURE mymodel OF MWBuffer IS
BEGIN
	PROCESS (clk, reset)
	BEGIN
		IF reset = '1' THEN
			write_enable_out <= '0';
			readdata2_out <= (OTHERS => '0');
			alu_result_out <= (OTHERS => '0');
			writeRegAddr_out <= (OTHERS => '0');
			imm_value_out <= (OTHERS => '0');
			imm_enable_out <= '0';
			IN_PORT_MW <= (OTHERS => '0');
			ReadData1_MW <= (OTHERS => '0');
			FW_op1_out <= (OTHERS => '0');
			FW_op2_out <= (OTHERS => '0');
			out_port_out <= '0';
			in_port_en_out <= '0';
		ELSE
			IF rising_edge(clk) AND MW_Flush = '0' THEN
				write_enable_out <= write_enable;
				readdata2_out <= readdata2;
				alu_result_out <= alu_result;
				writeRegAddr_out <= writeRegAddr;
				imm_value_out <= imm_value;
				imm_enable_out <= imm_enable;
				IN_PORT_MW <= IN_PORT;
				ReadData1_MW <= ReadData1;
				FW_op1_out <= FW_op1;
				FW_op2_out <= FW_op2;
				out_port_out <= out_port_in;
				in_port_en_out <= in_port_en;
			ELSIF rising_edge(clk) AND MW_Flush = '1' THEN
				write_enable_out <= '0';
				readdata2_out <= (OTHERS => '0');
				alu_result_out <= (OTHERS => '0');
				writeRegAddr_out <= (OTHERS => '0');
				imm_value_out <= (OTHERS => '0');
				imm_enable_out <= '0';
				IN_PORT_MW <= (OTHERS => '0');
				ReadData1_MW <= (OTHERS => '0');
				FW_op1_out <= (OTHERS => '0');
				FW_op2_out <= (OTHERS => '0');
				out_port_out <= '0';
				in_port_en_out <= '0';
			END IF;
		END IF;
	END PROCESS;
END ARCHITECTURE;