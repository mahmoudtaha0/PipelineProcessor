LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY Processor IS
	PORT (
		clk : IN STD_LOGIC;
		reset : IN STD_LOGIC;
		enable : IN STD_LOGIC;
		inputport : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		outputport : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END Processor;

ARCHITECTURE my_model OF Processor IS
	COMPONENT ProgramCounter IS
		PORT (
			clk, rst, en : IN STD_LOGIC;
			c : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT InstructionCachee IS
		PORT (
			clk, reset, enable : IN STD_LOGIC;
			read_address : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			dataout : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
		);
	END COMPONENT;
	COMPONENT FetchDecodeBuffer1 IS
		PORT (
			clk, FD_reset, FD_enable : IN STD_LOGIC;
			Given_instruction : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			Op_code : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
			To_RegFile_data : OUT STD_LOGIC_VECTOR(8 DOWNTO 0);
			To_RegFile_op_Code : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
			IN_PORT : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			IN_PORT_FD : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
		);
	END COMPONENT;
	COMPONENT register_file IS
		PORT (
			clk, rst, write_enable : IN STD_LOGIC;
			write_addr : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			read_addr_1, read_addr_2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			write_data : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			read_data_1, read_data_2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
		);
	END COMPONENT;
	COMPONENT DEBuffer IS
		PORT (
			-- inputs
			readdata1, readdata2 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			writeRegAddr : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
			--pc: in std_logic_vector (31 downto 0);
			clk, imm_enable, reset, aluimm, alu_enable, write_enable, memorywrite, memoryread : IN STD_LOGIC;
			imm_value : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
			opcode : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
			--call_enable,return_enable: in std_logic;
			-- outputs
			readdata1_out, readdata2_out, imm_value_out : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
			memoryread_out, memorywrite_out, write_enable_out, alu_enable_out, aluimm_out, imm_enable_out : OUT STD_LOGIC;
			writeRegAddr_out : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
			opcode_out : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
			--pc_out: out std_logic_vector (31 downto 0)
			--return_enable_out,call_enable_out : out std_logic;
			INT, RTI : IN STD_LOGIC;
			INT_out, RTI_out : OUT STD_LOGIC;
			IN_PORT : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			IN_PORT_DE : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT ALU_Control IS
		PORT (
			opcode : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
			ALU_Code : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT ALU IS
		PORT (
			EN, rst : IN STD_LOGIC;
			in1, in2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			op : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			out_alu : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			ccr : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT CCR IS
		PORT (
			CCR_IN : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			CCR_OUT : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT EMBuffer IS
		PORT (
			--inputs
			clk, write_enable, reset, memoryread, memorywrite : IN STD_LOGIC;
			writeRegAddr : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
			--return_enable,call_enable,overflow,zeroflag : in std_logic;;
			alu_result, datain : IN STD_LOGIC_VECTOR (31 DOWNTO 0); --readdata2 ely tal3 mn register file 3shan yro7 ll data memory
			--pc: in std_logic_vector (31 downto 0);
			imm_value : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			imm_enable : IN STD_LOGIC;
			--outputs
			write_enable_out, memoryread_out, memorywrite_out : OUT STD_LOGIC;
			alu_result_out, dataout : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
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
	END COMPONENT;
	COMPONENT DataMemory IS
		PORT (
			rst, memoryWrite, memoryRead, clk : IN STD_LOGIC;
			writeData, Add : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			readData, PC_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			INT, RTI : IN STD_LOGIC;
			CCR : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			CCR_out : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
		);
	END COMPONENT;
	COMPONENT MWBuffer IS
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
	END COMPONENT;
	COMPONENT Controller IS
		PORT (
			opcode : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
			reset_input, ZF : IN STD_LOGIC;
			jump, jumpZ, rst, immEnable, immFlush, memoryWrite, memoryRead, returnEnable, callEnable, aluImm, writeEnable, alu_enable, oneoperand : OUT STD_LOGIC;
			opcode_to_alu : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
			INT, RTI : OUT STD_LOGIC
		);
	END COMPONENT;
	COMPONENT Demux2 IS
		PORT (
			F : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			Sel : IN STD_LOGIC;
			A, B : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
		);
	END COMPONENT;
	COMPONENT mux2 IS
		PORT (
			in0, in1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			sel : IN STD_LOGIC;
			out1 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
	END COMPONENT;
	COMPONENT mux2_3bits IS
		PORT (
			in0, in1 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			sel : IN STD_LOGIC;
			out1 : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
		);
	END COMPONENT;
	COMPONENT Demux16Bit IS
		PORT (
			F : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			Sel : IN STD_LOGIC;
			A, B : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
		);
	END COMPONENT;
	COMPONENT mux4 IS
		PORT (
			in0, in1, in2, in3 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			sel : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
			out1 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
		);
	END COMPONENT;

	SIGNAL c_pc_instCache : STD_LOGIC_VECTOR (31 DOWNTO 0);
	SIGNAL Instuction_instructioncache_FDBuffer, Demux_output_FDBuffer, Demux_output_DEBuffer : STD_LOGIC_VECTOR (15 DOWNTO 0);
	SIGNAL immidiate_enable_controller : STD_LOGIC := '0';
	SIGNAL op_code_FDBuffer_controller, op_code_controller_alu : STD_LOGIC_VECTOR (6 DOWNTO 0);
	SIGNAL data_FDBuffer_regFile : STD_LOGIC_VECTOR (8 DOWNTO 0);
	SIGNAL op_code_FDBuffer_RegFile : STD_LOGIC_VECTOR (1 DOWNTO 0);
	SIGNAL jump_controller, jumpZ_controller, rst_controller, immEnable_controller : STD_LOGIC;
	SIGNAL immFlush_controller, memoryWrite_controller, memoryRead_controller, returnEnable_controller, INT_controller, RTI_controller : STD_LOGIC;
	SIGNAL DE_INT, EM_INT, DE_RTI, EM_RTI : STD_LOGIC;
	SIGNAL callEnable_controller, aluImm_controller, writeEnable_controller, alu_enable_controller, reg_file_mux_sel : STD_LOGIC;
	SIGNAL writedata_WBBuffer_RefFile, ReadData1_RegFile_DEBuffer, ReadData2_RegFile_DEBuffer, Alu_Imm_mux : STD_LOGIC_VECTOR (31 DOWNTO 0);
	SIGNAL ReadData1Out_DEBuffer_Alu, ReadData2Out_DEBuffer_Alu, ImmValue_DEBuffer_Demux : STD_LOGIC_VECTOR (31 DOWNTO 0);
	SIGNAL MemoryRead_DEBuffer_EMBuffer, MemoryWrite_DEBuffer_EMBuffer, Write_Enable_DEBuffer_EMBuffer, Alu_Enable_DEBuffer_Alu : STD_LOGIC;
	SIGNAL ALUImm_DEBuffer_Demux, Imm_Enable_DEBUffer_Mux, Imm_Enable_EMBuffer, Imm_Enable_MWBuffer : STD_LOGIC;
	SIGNAL ImmValue_Demux_Alu, ImmValue_Demux_EMBuffer, Alu_Output_EMBuffer : STD_LOGIC_VECTOR (31 DOWNTO 0);
	SIGNAL CCR_signal : STD_LOGIC_VECTOR (3 DOWNTO 0);
	SIGNAL CCR_EM, CCR_DM : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL CCR_OP : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL Write_enable_EMBuffer_MWBuffer, Memory_Read_EMBuffer_DataMemory, Memory_write_EMBuffer_DataMemory : STD_LOGIC;
	SIGNAL AluResult_EMBuffer_DataMemory, ReadData1_EMBuffer_DataMemory, ReadData_DataMemory_MWBuffer, ReadData1_EM_Buffer : STD_LOGIC_VECTOR (31 DOWNTO 0);
	SIGNAL ImmValue_EMBuffer, ImmValue_MWBuffer : STD_LOGIC_VECTOR (31 DOWNTO 0);
	SIGNAL Write_Enable_MWBuffer_Mux : STD_LOGIC := '0';
	SIGNAL ReadData_MWBuffer_Mux, AluResult_MWBuffer_Mux : STD_LOGIC_VECTOR (31 DOWNTO 0);
	SIGNAL write_reg_out_DEBuffer_EMBuffer, write_reg_out_EMBuffer_MWBuffer : STD_LOGIC_VECTOR (2 DOWNTO 0);
	SIGNAL writeAdd_WBBuffer_RefFile : STD_LOGIC_VECTOR (2 DOWNTO 0);
	SIGNAL op_code_DEBuffer_ALU : STD_LOGIC_VECTOR (6 DOWNTO 0);
	SIGNAL ALU_OPCODE : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL reg_file_mux_out : STD_LOGIC_VECTOR(2 DOWNTO 0);
	SIGNAL PC_OP : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL PC : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL branch_pc, jump_pc : STD_LOGIC;
	SIGNAL pc_sel : STD_LOGIC_VECTOR(1 DOWNTO 0);
	SIGNAL mem_addr_sel : STD_LOGIC;
	SIGNAL FD_IP, DE_IP, EM_IP, MW_IP : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL write_data_regfile : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL IN_PORT_EN : STD_LOGIC;
	SIGNAL ReadData1_MW_Buffer : STD_LOGIC_VECTOR(31 DOWNTO 0);
BEGIN
	branch_pc <= INT_Controller OR RTI_Controller OR returnEnable_controller;
	jump_pc <= jump_controller OR jumpZ_controller OR callEnable_controller;
	pc_sel <= jump_pc & branch_pc;
	mem_addr_sel <= immEnable_controller AND (memoryWrite_controller OR memoryRead_controller);

	U0 : mux4 PORT MAP(
		in0 => c_pc_instCache, in1 => PC_OP, in2 => ReadData1_RegFile_DEBuffer, in3 => (OTHERS => '0'), sel => pc_sel,
		out1 => PC);

	U1 : ProgramCounter PORT MAP(clk => clk, rst => reset, en => enable, c => PC);

	U2 : InstructionCachee PORT MAP(
		reset => reset, clk => clk, enable => enable, read_address => c_pc_instCache (15 DOWNTO 0),
		dataout => Instuction_instructioncache_FDBuffer);

	U3 : Demux16Bit PORT MAP(
		F => Instuction_instructioncache_FDBuffer, Sel => immEnable_controller, A => Demux_output_FDBuffer,
		B => Demux_output_DEBuffer);

	U4 : FetchDecodeBuffer1 PORT MAP(
		clk => clk, FD_reset => reset, FD_enable => enable, Given_instruction => Demux_output_FDBuffer,
		Op_code => op_code_FDBuffer_controller, To_RegFile_data => data_FDBuffer_regFile,
		To_RegFile_op_Code => op_code_FDBuffer_RegFile, IN_PORT => inputport, IN_PORT_FD => FD_IP);

	U5 : Controller PORT MAP(
		opcode => op_code_FDBuffer_controller, reset_input => reset, jump => jump_controller,
		jumpZ => jumpZ_controller, rst => rst_controller, immEnable => immEnable_controller,
		immFlush => immFlush_controller, memoryWrite => memoryWrite_controller,
		memoryRead => memoryRead_controller, returnEnable => returnEnable_controller,
		callEnable => callEnable_controller, aluImm => aluImm_controller, writeEnable => writeEnable_controller,
		alu_enable => alu_enable_controller, opcode_to_alu => op_code_controller_alu, oneoperand => reg_file_mux_sel, INT => INT_controller, RTI => RTI_controller, ZF => CCR_signal(0));

	U6 : mux2_3bits PORT MAP(
		in0 => data_FDBuffer_regFile(8 DOWNTO 6), in1 => data_FDBuffer_regFile(2 DOWNTO 0), sel => reg_file_mux_sel,
		out1 => reg_file_mux_out);

	U7 : register_file PORT MAP(
		clk => clk, rst => reset, write_enable => Write_Enable_MWBuffer_Mux, write_addr => writeAdd_WBBuffer_RefFile,
		read_addr_1 => reg_file_mux_out, read_addr_2 => data_FDBuffer_regFile(5 DOWNTO 3),
		write_data => writedata_WBBuffer_RefFile, read_data_1 => ReadData1_RegFile_DEBuffer, read_data_2 => ReadData2_RegFile_DEBuffer);

	U8 : DEBuffer PORT MAP(
		clk => clk, readdata1 => ReadData1_RegFile_DEBuffer, readdata2 => ReadData2_RegFile_DEBuffer, imm_enable => immEnable_controller,
		reset => rst_controller, aluimm => aluImm_controller, alu_enable => alu_enable_controller, write_enable => writeEnable_controller,
		memorywrite => memoryWrite_controller, aluimm_out => ALUImm_DEBuffer_Demux, OPCode => op_code_controller_alu, opcode_out => op_code_DEBuffer_ALU,
		memoryread => memoryRead_controller, imm_value => Demux_output_DEBuffer, readdata1_out => ReadData1Out_DEBuffer_Alu,
		readdata2_out => ReadData2Out_DEBuffer_Alu, imm_value_out => ImmValue_DEBuffer_Demux, memoryread_out => MemoryRead_DEBuffer_EMBuffer,
		memorywrite_out => MemoryWrite_DEBuffer_EMBuffer, write_enable_out => Write_Enable_DEBuffer_EMBuffer, writeRegAddr => data_FDBuffer_regFile(2 DOWNTO 0),
		imm_enable_out => Imm_Enable_DEBUffer_Mux, alu_enable_out => Alu_Enable_DEBuffer_Alu, writeRegAddr_out => write_reg_out_DEBuffer_EMBuffer, INT => INT_Controller, INT_out => DE_INT, RTI => RTI_Controller, RTI_out => DE_RTI,
		IN_PORT => FD_IP, IN_PORT_DE => DE_IP);

	U9 : Demux2 PORT MAP(F => ImmValue_DEBuffer_Demux, Sel => ALUImm_DEBuffer_Demux, A => ImmValue_Demux_Alu, B => ImmValue_Demux_EMBuffer);

	U10 : ALU_Control PORT MAP(-- nn2l abl el DEbuffer
		opcode => op_code_DEBuffer_ALU, ALU_Code => ALU_OPCODE);

	U11 : ALU PORT MAP(
		EN => Alu_Enable_DEBuffer_Alu, in1 => ReadData1Out_DEBuffer_Alu, in2 => ReadData2Out_DEBuffer_Alu, op => ALU_OPCODE,
		out_alu => Alu_Output_EMBuffer, ccr => CCR_signal, rst => reset);

	U12 : EMBuffer PORT MAP(
		clk => clk, write_enable => Write_Enable_DEBuffer_EMBuffer, reset => rst_controller, memoryread => MemoryRead_DEBuffer_EMBuffer,
		memorywrite => MemoryWrite_DEBuffer_EMBuffer, alu_result => Alu_Output_EMBuffer, datain => ReadData1Out_DEBuffer_Alu,
		imm_value => ImmValue_Demux_EMBuffer, imm_enable => Imm_Enable_DEBUffer_Mux, write_enable_out => Write_enable_EMBuffer_MWBuffer,
		memoryread_out => Memory_Read_EMBuffer_DataMemory, memorywrite_out => Memory_write_EMBuffer_DataMemory, writeRegAddr_out => write_reg_out_EMBuffer_MWBuffer,
		alu_result_out => AluResult_EMBuffer_DataMemory, imm_value_out => ImmValue_EMBuffer, dataout => ReadData1_EM_Buffer,
		writeRegAddr => write_reg_out_DEBuffer_EMBuffer, imm_enable_out => Imm_Enable_EMBuffer, INT => DE_INT, INT_out => EM_INT, RTI => DE_RTI, RTI_out => EM_RTI, CCR => CCR_signal, CCR_out => CCR_EM,
		IN_PORT => DE_IP, IN_PORT_EM => EM_IP);

	U13 : DataMemory PORT MAP(
		rst => rst_controller, memoryWrite => Memory_write_EMBuffer_DataMemory, memoryRead => Memory_Read_EMBuffer_DataMemory,
		clk => clk, Add => AluResult_EMBuffer_DataMemory, writeData => ReadData1_EM_Buffer,
		readData => ReadData_DataMemory_MWBuffer, INT => EM_INT, RTI => EM_RTI, CCR => CCR_EM, CCR_out => CCR_DM, PC_out => PC_OP);

	U14 : CCR PORT MAP(CCR_IN => CCR_DM, CCR_OUT => CCR_OP);

	U15 : MWBuffer PORT MAP(
		clk => clk, reset => rst_controller, write_enable => Write_enable_EMBuffer_MWBuffer, readdata => ReadData_DataMemory_MWBuffer,
		alu_result => AluResult_EMBuffer_DataMemory, write_enable_out => Write_Enable_MWBuffer_Mux,
		readdata_out => ReadData_MWBuffer_Mux, alu_result_out => AluResult_MWBuffer_Mux, writeRegAddr => write_reg_out_EMBuffer_MWBuffer,
		writeRegAddr_out => writeAdd_WBBuffer_RefFile, imm_value => ImmValue_EMBuffer, imm_value_out => ImmValue_MWBuffer,
		imm_enable => Imm_Enable_EMBuffer, imm_enable_out => Imm_Enable_MWBuffer, IN_PORT => EM_IP, IN_PORT_MW => MW_IP, ReadData1 => ReadData1_EM_Buffer, ReadData1_MW => ReadData1_MW_Buffer);

	outputport <= ReadData1_MW_Buffer;

	U16 : mux2 PORT MAP(in0 => AluResult_MWBuffer_Mux, in1 => ImmValue_MWBuffer, sel => Imm_Enable_MWBuffer, out1 => Alu_Imm_mux);

	U17 : mux2 PORT MAP(in0 => ReadData_MWBuffer_Mux, in1 => Alu_Imm_mux, sel => Write_Enable_MWBuffer_Mux, out1 => writedata_WBBuffer_RefFile);
	U18 : mux2 PORT MAP(in0 => writedata_WBBuffer_RefFile, in1 => MW_IP, sel => IN_PORT_EN, out1 => write_data_regfile);
	U19 : mux2 PORT MAP(in0 => Alu_Output_EMBuffer, in1 => ImmValue_EMBuffer, sel => mem_addr_sel);
END ARCHITECTURE;