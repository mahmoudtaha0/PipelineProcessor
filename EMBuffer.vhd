LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY EMBuffer IS
	PORT (
		--inputs
		clk, write_enable, reset, memoryread, memorywrite : IN STD_LOGIC;
		writeRegAddr : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
		--return_enable,call_enable,overflow,zeroflag : in std_logic;;
		alu_result, datain1, datain2 : IN STD_LOGIC_VECTOR (31 DOWNTO 0); --readdata2 ely tal3 mn register file 3shan yro7 ll data memory
		--pc: in std_logic_vector (31 downto 0);
		imm_value : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		imm_enable : IN STD_LOGIC;
		--outputs
		write_enable_out, memoryread_out, memorywrite_out : OUT STD_LOGIC;
		alu_result_out, dataout1, dataout2 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		imm_value_out : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		imm_enable_out : OUT STD_LOGIC;
		--return_enable_out,call_enable_out,overflow_out,zeroflag_out: out std_logic;
		--pc_out: out std_logic_vector (31 downto 0);
		writeRegAddr_out : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
		INT, RTI : IN STD_LOGIC;
		INT_out, RTI_out : OUT STD_LOGIC;
		CCR : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		CCR_out : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		IN_PORT : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		IN_PORT_EM : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END EMBuffer;

ARCHITECTURE my_model OF EMBuffer IS
BEGIN
	PROCESS (clk, reset)
	BEGIN
		IF reset = '1' THEN
			write_enable_out <= '0';
			--return_enable_out <= '0';
			--call_enable_out<= '0';
			memoryread_out <= '0';
			memorywrite_out <= '0';
			-- pc_out <= (others => '0');
			imm_value_out <= (OTHERS => '0');
			imm_enable_out <= '0';
			alu_result_out <= (OTHERS => '0');
			dataout1 <= (OTHERS => '0');
			dataout2 <= (others => '0');
			--overflow_out<= '0';
			--zeroflag_out<= '0';
			writeRegAddr_out <= (OTHERS => '0');
			INT_out <= '0';
			IN_PORT_EM <= (OTHERS => '0');
			RTI_out <= '0';
			CCR_out <= (others => '0');
		ELSE
			IF rising_edge(clk) THEN
				write_enable_out <= write_enable;
				--return_enable_out <= return_enable;
				--call_enable_out<= call_enable;
				memoryread_out <= memoryread;
				memorywrite_out <= memorywrite;
				--pc_out <= pc;
				imm_value_out <= imm_value;
				imm_enable_out <= imm_enable;
				alu_result_out <= alu_result;
				dataout1 <= datain1;
				dataout2 <= datain2;
				--overflow_out<= overflow;
				--zeroflag_out<= zeroflag;
				writeRegAddr_out <= writeRegAddr;
				INT_out <= INT;
				IN_PORT_EM <= IN_PORT;
				RTI_out <= RTI;
				CCR_out <= CCR;
			END IF;
		END IF;
	END PROCESS;

END my_model;