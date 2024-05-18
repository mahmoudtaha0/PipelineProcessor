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
			PC_in : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
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
			Given_instruction_output : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			To_RegFile_data : OUT STD_LOGIC_VECTOR(8 DOWNTO 0);
			To_RegFile_op_Code : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
			IN_PORT : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			FD_flush : IN STD_LOGIC;
			IN_PORT_FD : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
		);
	END COMPONENT;
	COMPONENT register_file IS
		PORT (
			clk, rst, write_enable, swap_enable : IN STD_LOGIC;
			write_addr1, write_addr2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			read_addr_1, read_addr_2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			write_data1, write_data2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			read_data_1, read_data_2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
		);
	END COMPONENT;
	COMPONENT DEBuffer IS
		PORT (
			-- inputs
			DE_Flush : IN STD_LOGIC;
			readdata1, readdata2 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			writeRegAddr : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
			instruction_DE_IN : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			instruction_DE_OUT : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			ALU_CODE_DE_IN : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			ALU_CODE_DE_OUT : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			--pc: in std_logic_vector (31 downto 0);
			clk, imm_enable, reset, aluimm, alu_enable, write_enable, memorywrite, memoryread : IN STD_LOGIC;
			imm_value : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
			opcode : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
			out_port_in, in_port_en : IN STD_LOGIC;
			swap : IN STD_LOGIC;
			--call_enable,return_enable: in std_logic;
			-- outputs
			readdata1_out, readdata2_out, imm_value_out : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
			memoryread_out, memorywrite_out, write_enable_out, alu_enable_out, aluimm_out, imm_enable_out : OUT STD_LOGIC;
			writeRegAddr_out : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
			opcode_out : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
			INT, RTI : IN STD_LOGIC;
			Stall : IN STD_LOGIC;
			INT_out, RTI_out : OUT STD_LOGIC;
			IN_PORT : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			out_port_out, in_port_en_out : OUT STD_LOGIC;
			swap_out : OUT STD_LOGIC;
			IN_PORT_DE : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
			--pc_out: out std_logic_vector (31 downto 0)
			--return_enable_out,call_enable_out : out std_logic;
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
			EM_Flush : IN STD_LOGIC;
			clk, write_enable, reset, memoryread, memorywrite : IN STD_LOGIC;
			writeRegAddr : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
			--return_enable,call_enable,overflow,zeroflag : in std_logic;;
			alu_result, datain1, datain2 : IN STD_LOGIC_VECTOR (31 DOWNTO 0); --readdata2 ely tal3 mn register file 3shan yro7 ll data memory
			--pc: in std_logic_vector (31 downto 0);
			imm_value : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			imm_enable, in_port_en : IN STD_LOGIC;
			out_port_in : IN STD_LOGIC;
			aluimm : IN STD_LOGIC;
			swap : IN STD_LOGIC;
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
			out_port_out, in_port_en_out : OUT STD_LOGIC;
			aluimm_OUT : OUT STD_LOGIC;
			swap_out : OUT STD_LOGIC;
			IN_PORT_EM : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
		);
	END COMPONENT;
	COMPONENT DataMemory IS
		PORT (
			rst, memoryWrite, memoryRead, clk, protect_enable, free_enable, push_en, pop_en, call_en, ret_en : IN STD_LOGIC;
			writeData, Addr : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			PC : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			readData, PC_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			violation_signal : OUT STD_LOGIC;
			INT, RTI : IN STD_LOGIC;
			CCR : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			CCR_out : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			SP : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
		);
	END COMPONENT;
	COMPONENT MWBuffer IS
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
			out_port_in, in_port_en : IN STD_LOGIC;
			aluimm : IN STD_LOGIC;
			swap : IN STD_LOGIC;
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
			out_port_out, in_port_en_out : OUT STD_LOGIC;
			aluimm_OUT : OUT STD_LOGIC;
			swap_out : OUT STD_LOGIC;
			ReadData1_MW : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
		);
	END COMPONENT;
	COMPONENT Controller IS
		PORT (
			opcode : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
			reset_input : IN STD_LOGIC;
			ZF : IN STD_LOGIC;
			jump, jumpZ, rst, IN_PORT_EN, immEnable, immFlush, memoryWrite, memoryRead, returnEnable, callEnable, aluImm, writeEnable, alu_enable, oneoperand, swap_enable, protect_enable, free_enable, push_enable, pop_enable, Out_port : OUT STD_LOGIC;
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
	COMPONENT HDU IS
		PORT (
			INT_Enable, MemR, MemW, protection_violation : IN STD_LOGIC;
			EA : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			Instruction : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			Rdst_ExMem, Rdst_MemWb : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			-- Previous_instruction : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			WE_ExMem, WE_MemWb : IN STD_LOGIC;
			Forward_op1, Forward_op2 : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
			Stall, Flush : OUT STD_LOGIC_VECTOR (3 DOWNTO 0)
			-- Fadel el selka el beida
		);
	END COMPONENT;
	COMPONENT ForwardingUnit IS
		PORT (
			Forward_op1, Forward_op2 : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
			-- 00: No forwarding, 01: ALU_ALU, 11: MEM_ALU
			ALU_Result : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			MEM_Loaded : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			Forwarded_data_op1, Forwarded_data_op2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			input_port : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			input_port_prev : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			input_en : IN STD_LOGIC;
			input_en_prev : IN STD_LOGIC
		);
	END COMPONENT;

	SIGNAL c_pc_instCache : STD_LOGIC_VECTOR (31 DOWNTO 0) := (OTHERS => '0');
	SIGNAL Instuction_instructioncache_FDBuffer, Demux_output_FDBuffer, Demux_output_DEBuffer : STD_LOGIC_VECTOR (15 DOWNTO 0);
	SIGNAL immidiate_enable_controller : STD_LOGIC := '0';
	SIGNAL op_code_FDBuffer_controller, op_code_controller_alu : STD_LOGIC_VECTOR (6 DOWNTO 0);
	SIGNAL data_FDBuffer_regFile : STD_LOGIC_VECTOR (8 DOWNTO 0);
	SIGNAL op_code_FDBuffer_RegFile : STD_LOGIC_VECTOR (1 DOWNTO 0);
	SIGNAL jump_controller, jumpZ_controller, rst_controller, immEnable_controller : STD_LOGIC;
	SIGNAL immFlush_controller, memoryWrite_controller, memoryRead_controller, returnEnable_controller, INT_controller, RTI_controller, push_controller, pop_controller, protect_controller, free_controller : STD_LOGIC;
	SIGNAL DE_INT, EM_INT, DE_RTI, EM_RTI : STD_LOGIC;
	SIGNAL callEnable_controller, aluImm_controller, writeEnable_controller, alu_enable_controller, reg_file_mux_sel : STD_LOGIC;
	SIGNAL writedata_WBBuffer_RefFile, ReadData1_RegFile_DEBuffer, ReadData2_RegFile_DEBuffer, Alu_Imm_mux : STD_LOGIC_VECTOR (31 DOWNTO 0);
	SIGNAL ReadData1Out_DEBuffer_Alu, ReadData2Out_DEBuffer_Alu, ImmValue_DEBuffer_Demux : STD_LOGIC_VECTOR (31 DOWNTO 0);
	SIGNAL MemoryRead_DEBuffer_EMBuffer, MemoryWrite_DEBuffer_EMBuffer, Write_Enable_DEBuffer_EMBuffer, Alu_Enable_DEBuffer_Alu : STD_LOGIC;
	SIGNAL ALUImm_DEBuffer_Demux, Imm_Enable_DEBUffer_Mux, Imm_Enable_EMBuffer, Imm_Enable_MWBuffer, ALUImm_EMBuffer_Demux, ALUImm_MWBuffer_Demux : STD_LOGIC;
	SIGNAL ImmValue_Demux_Alu, ImmValue_Demux_EMBuffer, Alu_Output_EMBuffer : STD_LOGIC_VECTOR (31 DOWNTO 0);
	SIGNAL CCR_signal : STD_LOGIC_VECTOR (3 DOWNTO 0);
	SIGNAL CCR_EM, CCR_DM : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL CCR_OP : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL Write_enable_EMBuffer_MWBuffer, Memory_Read_EMBuffer_DataMemory, Memory_write_EMBuffer_DataMemory : STD_LOGIC;
	SIGNAL AluResult_EMBuffer_DataMemory, ReadData1_EMBuffer_DataMemory, ReadData_DataMemory_MWBuffer, ReadData1_EM_Buffer : STD_LOGIC_VECTOR (31 DOWNTO 0);
	SIGNAL ImmValue_EMBuffer, ImmValue_MWBuffer : STD_LOGIC_VECTOR (31 DOWNTO 0);
	SIGNAL Write_Enable_MWBuffer_Mux : STD_LOGIC := '0';
	SIGNAL ReadData1_MWBuffer_Mux, ReadData2_MWBuffer_Mux, AluResult_MWBuffer_Mux : STD_LOGIC_VECTOR (31 DOWNTO 0);
	SIGNAL write_reg_out_DEBuffer_EMBuffer, write_reg_out_EMBuffer_MWBuffer : STD_LOGIC_VECTOR (2 DOWNTO 0);
	SIGNAL writeAdd_WBBuffer_RefFile : STD_LOGIC_VECTOR (2 DOWNTO 0);
	SIGNAL op_code_DEBuffer_ALU : STD_LOGIC_VECTOR (6 DOWNTO 0);
	SIGNAL ALU_OPCODE : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL reg_file_mux_out : STD_LOGIC_VECTOR(2 DOWNTO 0);
	SIGNAL PC_OP : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL PC, PC_exept : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL branch_pc, jump_pc : STD_LOGIC;
	SIGNAL pc_sel : STD_LOGIC_VECTOR(1 DOWNTO 0) := "00";
	SIGNAL mem_addr_sel : STD_LOGIC;
	SIGNAL FD_IP, DE_IP, EM_IP, MW_IP : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL write_data1_regfile : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL write_data2_regfile : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL IN_PORT_EN : STD_LOGIC := '0'; -------------- 
	SIGNAL ReadData1_MW_Buffer, ReadData2_EM_Buffer : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL SWAP_EN, SWAP_EN_DE, SWAP_EN_EM, SWAP_EN_MW : STD_LOGIC;
	SIGNAL stack_pointer : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL stall_DE : STD_LOGIC := '0';
	SIGNAL violation_sig : STD_LOGIC;
	SIGNAL Exception : STD_LOGIC := '0';
	SIGNAL Exception_handler : STD_LOGIC_VECTOR(31 DOWNTO 0) := "00000000000000000000011111111111";
	SIGNAL instructionDE : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL stall_HDU : STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');
	SIGNAL flush_HDU : STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');
	SIGNAL ALU_CODE_DE : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL FW_OP1 : STD_LOGIC_VECTOR(1 DOWNTO 0) := "00";
	SIGNAL FW_OP2 : STD_LOGIC_VECTOR(1 DOWNTO 0) := "00";
	SIGNAL FW_OP1_sig, FW_OP2_sig : STD_LOGIC_VECTOR(1 DOWNTO 0);
	SIGNAL Forwarded_Data1, Forwarded_Data2 : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL op2_imm_mux, op2_imm_forward, op1_forward : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL out_port_Cont, out_port_DE, out_port_EM, out_port_MW, in_port_DE, in_port_EM, in_port_MW : STD_LOGIC;
BEGIN
	branch_pc <= INT_Controller OR RTI_Controller OR returnEnable_controller;
	jump_pc <= jump_controller OR jumpZ_controller OR callEnable_controller;
	pc_sel <= jump_pc & branch_pc;
	mem_addr_sel <= immEnable_controller AND (memoryWrite_controller OR memoryRead_controller);

	U0 : mux4 PORT MAP(
		in0 => c_pc_instCache, in1 => PC_OP, in2 => ReadData1_RegFile_DEBuffer, in3 => (OTHERS => '0'), sel => pc_sel,
		out1 => PC);

	U26 : mux2 PORT MAP(in0 => PC, in1 => Exception_handler, sel => Exception, out1 => PC_exept);

	U1 : ProgramCounter PORT MAP(PC_in => PC_exept, clk => clk, rst => reset, en => enable, c => c_pc_instCache);

	U2 : InstructionCachee PORT MAP(
		reset => reset, clk => clk, enable => enable, read_address => c_pc_instCache (15 DOWNTO 0),
		dataout => Instuction_instructioncache_FDBuffer);

	U3 : Demux16Bit PORT MAP(
		F => Instuction_instructioncache_FDBuffer, Sel => immEnable_controller, A => Demux_output_FDBuffer,
		B => Demux_output_DEBuffer);

	U4 : FetchDecodeBuffer1 PORT MAP(
		clk => clk, FD_reset => reset, FD_enable => enable, Given_instruction => Demux_output_FDBuffer,
		Op_code => op_code_FDBuffer_controller, To_RegFile_data => data_FDBuffer_regFile,
		To_RegFile_op_Code => op_code_FDBuffer_RegFile, IN_PORT => inputport, IN_PORT_FD => FD_IP, FD_flush => flush_HDU(0));

	U5 : Controller PORT MAP(
		opcode => op_code_FDBuffer_controller, reset_input => reset, jump => jump_controller,
		jumpZ => jumpZ_controller, rst => rst_controller, immEnable => immEnable_controller, IN_PORT_EN => IN_PORT_EN,
		immFlush => immFlush_controller, memoryWrite => memoryWrite_controller,
		memoryRead => memoryRead_controller, returnEnable => returnEnable_controller,
		callEnable => callEnable_controller, aluImm => aluImm_controller, writeEnable => writeEnable_controller,
		alu_enable => alu_enable_controller, opcode_to_alu => op_code_controller_alu, oneoperand => reg_file_mux_sel, INT => INT_controller, RTI => RTI_controller, ZF => CCR_signal(0),
		swap_enable => SWAP_EN, push_enable => push_controller, pop_enable => pop_controller, protect_enable => protect_controller, free_enable => free_controller, Out_port => out_port_Cont);

	U6 : mux2_3bits PORT MAP(
		in0 => data_FDBuffer_regFile(8 DOWNTO 6), in1 => data_FDBuffer_regFile(2 DOWNTO 0), sel => reg_file_mux_sel,
		out1 => reg_file_mux_out);

	U7 : register_file PORT MAP(
		clk => clk, rst => reset, write_enable => Write_Enable_MWBuffer_Mux, write_addr1 => writeAdd_WBBuffer_RefFile, write_addr2 => data_FDBuffer_regFile(2 DOWNTO 0),
		read_addr_1 => reg_file_mux_out, read_addr_2 => data_FDBuffer_regFile(5 DOWNTO 3),
		write_data1 => write_data1_regfile, write_data2 => write_data2_regfile, read_data_1 => ReadData1_RegFile_DEBuffer, read_data_2 => ReadData2_RegFile_DEBuffer, swap_enable => SWAP_EN_MW);

	U8 : ALU_Control PORT MAP(
		opcode => op_code_DEBuffer_ALU, ALU_Code => ALU_OPCODE);

	U9 : DEBuffer PORT MAP(
		clk => clk, readdata1 => ReadData1_RegFile_DEBuffer, readdata2 => ReadData2_RegFile_DEBuffer, imm_enable => immEnable_controller,
		reset => rst_controller, aluimm => aluImm_controller, alu_enable => alu_enable_controller, write_enable => writeEnable_controller,
		memorywrite => memoryWrite_controller, aluimm_out => ALUImm_DEBuffer_Demux, OPCode => op_code_controller_alu, opcode_out => op_code_DEBuffer_ALU,
		memoryread => memoryRead_controller, imm_value => Demux_output_DEBuffer, readdata1_out => ReadData1Out_DEBuffer_Alu,
		readdata2_out => ReadData2Out_DEBuffer_Alu, imm_value_out => ImmValue_DEBuffer_Demux, memoryread_out => MemoryRead_DEBuffer_EMBuffer,
		memorywrite_out => MemoryWrite_DEBuffer_EMBuffer, write_enable_out => Write_Enable_DEBuffer_EMBuffer, writeRegAddr => data_FDBuffer_regFile(2 DOWNTO 0),
		imm_enable_out => Imm_Enable_DEBUffer_Mux, alu_enable_out => Alu_Enable_DEBuffer_Alu, writeRegAddr_out => write_reg_out_DEBuffer_EMBuffer, INT => INT_Controller, INT_out => DE_INT, RTI => RTI_Controller, RTI_out => DE_RTI,
		IN_PORT => FD_IP, IN_PORT_DE => DE_IP, Stall => stall_DE, instruction_DE_IN => Instuction_instructioncache_FDBuffer,
		instruction_DE_OUT => instructionDE, ALU_CODE_DE_IN => ALU_OPCODE, ALU_CODE_DE_OUT => ALU_CODE_DE, DE_Flush => flush_HDU(1),
		out_port_in => out_port_Cont, out_port_out => out_port_DE, in_port_en => IN_PORT_EN, in_port_en_out => in_port_DE, swap => SWAP_EN, swap_out => SWAP_EN_DE);

	U10 : Demux2 PORT MAP(F => ImmValue_DEBuffer_Demux, Sel => ALUImm_DEBuffer_Demux, A => ImmValue_Demux_Alu, B => ImmValue_Demux_EMBuffer);

	U23 : mux2 PORT MAP(in0 => ReadData2Out_DEBuffer_Alu, in1 => ImmValue_Demux_Alu, sel => Imm_Enable_DEBUffer_Mux, out1 => op2_imm_mux);

	U24 : mux2 PORT MAP(in0 => op2_imm_mux, in1 => Forwarded_Data2, sel => FW_OP2_Sig(0), out1 => op2_imm_forward);

	U25 : mux2 PORT MAP(in0 => ReadData1Out_DEBuffer_Alu, in1 => Forwarded_Data1, sel => FW_OP1_Sig(0), out1 => op1_forward);

	U11 : ALU PORT MAP(
		EN => Alu_Enable_DEBuffer_Alu, in1 => op1_forward, in2 => op2_imm_forward, op => ALU_OPCODE,
		out_alu => Alu_Output_EMBuffer, ccr => CCR_signal, rst => reset);

	Exception <= violation_sig OR CCR_signal(3);

	U13 : EMBuffer PORT MAP(
		clk => clk, write_enable => Write_Enable_DEBuffer_EMBuffer, reset => rst_controller, memoryread => MemoryRead_DEBuffer_EMBuffer,
		memorywrite => MemoryWrite_DEBuffer_EMBuffer, alu_result => Alu_Output_EMBuffer, datain1 => ReadData1Out_DEBuffer_Alu,
		datain2 => ReadData2Out_DEBuffer_Alu, imm_value => ImmValue_Demux_EMBuffer, imm_enable => Imm_Enable_DEBUffer_Mux, write_enable_out => Write_enable_EMBuffer_MWBuffer,
		memoryread_out => Memory_Read_EMBuffer_DataMemory, memorywrite_out => Memory_write_EMBuffer_DataMemory, writeRegAddr_out => write_reg_out_EMBuffer_MWBuffer,
		alu_result_out => AluResult_EMBuffer_DataMemory, imm_value_out => ImmValue_EMBuffer, dataout1 => ReadData1_EM_Buffer, dataout2 => ReadData2_EM_Buffer,
		writeRegAddr => write_reg_out_DEBuffer_EMBuffer, imm_enable_out => Imm_Enable_EMBuffer, INT => DE_INT, INT_out => EM_INT, RTI => DE_RTI, RTI_out => EM_RTI, CCR => CCR_signal, CCR_out => CCR_EM,
		IN_PORT => DE_IP, IN_PORT_EM => EM_IP, EM_Flush => flush_HDU(2), out_port_in => out_port_DE, out_port_out => out_port_EM,
		in_port_en => in_port_DE, in_port_en_out => in_port_EM, aluimm => ALUImm_DEBuffer_Demux, aluimm_OUT => ALUImm_EMBuffer_Demux,
		swap => SWAP_EN_DE, swap_out => SWAP_EN_EM);

	U14 : DataMemory PORT MAP(
		rst => rst_controller, memoryWrite => Memory_write_EMBuffer_DataMemory, memoryRead => Memory_Read_EMBuffer_DataMemory,
		clk => clk, Addr => AluResult_EMBuffer_DataMemory, writeData => ReadData1_EM_Buffer,
		readData => ReadData_DataMemory_MWBuffer, INT => EM_INT, RTI => EM_RTI, CCR => CCR_EM, CCR_out => CCR_DM, PC_out => PC_OP, protect_enable => protect_controller, free_enable => free_controller, push_en => push_controller, pop_en => pop_controller,
		call_en => callEnable_controller, ret_en => returnEnable_controller, PC => PC, SP => stack_pointer, violation_signal => violation_sig
	);

	U15 : CCR PORT MAP(CCR_IN => CCR_DM, CCR_OUT => CCR_OP);

	U12 : HDU PORT MAP(
		INT_Enable => INT_controller, MemR => memoryRead_controller, MemW => memoryWrite_controller,
		protection_violation => Exception,
		EA => Demux_output_DEBuffer,
		Instruction => instructionDE,
		Forward_op1 => FW_OP1, Forward_op2 => FW_OP2, Stall => stall_HDU, Flush => flush_HDU,
		Rdst_ExMem => write_reg_out_DEBuffer_EMBuffer, Rdst_MemWb => write_reg_out_EMBuffer_MWBuffer, WE_ExMem => Write_Enable_DEBuffer_EMBuffer,
		WE_MemWb => Write_enable_EMBuffer_MWBuffer);

	U16 : MWBuffer PORT MAP(
		clk => clk, reset => rst_controller, write_enable => Write_enable_EMBuffer_MWBuffer,
		readdata2 => ReadData2Out_DEBuffer_Alu,
		alu_result => AluResult_EMBuffer_DataMemory, write_enable_out => Write_Enable_MWBuffer_Mux, readdata2_out => ReadData2_MWBuffer_Mux,
		alu_result_out => AluResult_MWBuffer_Mux, writeRegAddr => write_reg_out_EMBuffer_MWBuffer,
		writeRegAddr_out => writeAdd_WBBuffer_RefFile, imm_value => ImmValue_EMBuffer, imm_value_out => ImmValue_MWBuffer,
		imm_enable => Imm_Enable_EMBuffer, imm_enable_out => Imm_Enable_MWBuffer, IN_PORT => EM_IP, IN_PORT_MW => MW_IP,
		ReadData1 => ReadData1_EM_Buffer, ReadData1_MW => ReadData1_MW_Buffer, FW_op1 => FW_OP1, FW_op2 => FW_OP2, FW_op1_out => FW_OP1_sig,
		FW_op2_out => FW_OP2_sig, MW_Flush => flush_HDU(3), out_port_in => out_port_EM, out_port_out => out_port_MW, in_port_en => in_port_EM,
		in_port_en_out => in_port_MW, aluimm => ALUImm_EMBuffer_Demux, aluimm_OUT => ALUImm_MWBuffer_Demux, swap => SWAP_EN_EM, swap_out => SWAP_EN_MW);

	outputport <= ReadData1_MW_Buffer WHEN out_port_MW = '1';

	U17 : ForwardingUnit PORT MAP(
		Forward_op1 => FW_OP1_sig, Forward_op2 => FW_OP2_sig,
		ALU_Result => AluResult_EMBuffer_DataMemory,
		MEM_Loaded => writedata_WBBuffer_RefFile,
		Forwarded_data_op1 => Forwarded_Data1, Forwarded_data_op2 => Forwarded_Data2, input_port => MW_IP, input_en => in_port_MW, input_port_prev => EM_IP, input_en_prev => in_port_EM);

	U18 : mux2 PORT MAP(in0 => AluResult_MWBuffer_Mux, in1 => ImmValue_MWBuffer, sel => ALUImm_MWBuffer_Demux, out1 => Alu_Imm_mux);

	U19 : mux2 PORT MAP(in0 => ReadData1_MW_Buffer, in1 => Alu_Imm_mux, sel => Write_Enable_MWBuffer_Mux, out1 => writedata_WBBuffer_RefFile);

	U20 : mux2 PORT MAP(in0 => writedata_WBBuffer_RefFile, in1 => MW_IP, sel => in_port_MW, out1 => write_data1_regfile);

	U21 : mux2 PORT MAP(in0 => Alu_Output_EMBuffer, in1 => ImmValue_EMBuffer, sel => mem_addr_sel);

	U22 : mux2 PORT MAP(in0 => (OTHERS => '0'), in1 => ReadData2_MWBuffer_Mux, sel => SWAP_EN, out1 => write_data2_regfile);
END ARCHITECTURE;