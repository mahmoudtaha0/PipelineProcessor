LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY DEBuffer IS
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
        out_port_in : IN STD_LOGIC;
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
        out_port_out : OUT STD_LOGIC;
        IN_PORT_DE : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        --pc_out: out std_logic_vector (31 downto 0)
        --return_enable_out,call_enable_out : out std_logic;
    );
END DEBuffer;

ARCHITECTURE mymodel OF DEBuffer IS
BEGIN
    PROCESS (reset, clk)
    BEGIN
        IF reset = '1' THEN
            readdata1_out <= (OTHERS => '0');
            readdata2_out <= (OTHERS => '0');
            memoryread_out <= '0';
            memorywrite_out <= '0';
            write_enable_out <= '0';
            --return_enable_out <= '0';
            --call_enable_out <= '0';
            alu_enable_out <= '0';
            aluimm_out <= '0';
            imm_enable_out <= '0';
            --pc_out <= (others => '0');
            imm_value_out <= (OTHERS => '0');
            writeRegAddr_out <= (OTHERS => '0');
            opcode_out <= (OTHERS => '0');
            INT_out <= '0';
            IN_PORT_DE <= (OTHERS => '0');
            RTI_out <= '0';
            instruction_DE_OUT <= (OTHERS => '0');
            ALU_CODE_DE_OUT <= "0000";
            out_port_out <= '0';
        ELSE
            IF rising_edge(clk) AND Stall = '0' AND DE_Flush = '0' THEN
                readdata1_out <= readdata1;
                readdata2_out <= readdata2;
                memoryread_out <= memoryread;
                memorywrite_out <= memorywrite;
                write_enable_out <= write_enable;
                --return_enable_out <= return_enable;
                --call_enable_out <= call_enable;
                alu_enable_out <= alu_enable;
                aluimm_out <= aluimm;
                imm_enable_out <= imm_enable;
                writeRegAddr_out <= writeRegAddr;
                --pc_out <= pc;
                opcode_out <= opcode;
                INT_out <= INT;
                RTI_out <= RTI;
                out_port_out <= out_port_in;

                IN_PORT_DE <= IN_PORT;
                instruction_DE_OUT <= instruction_DE_IN;
                ALU_CODE_DE_OUT <= ALU_CODE_DE_IN;
                IF imm_value(15) = '0' THEN
                    imm_value_out <= (31 DOWNTO 16 => '0') & imm_value;
                ELSE
                    imm_value_out <= (31 DOWNTO 16 => '1') & imm_value;
                END IF;
            ELSIF rising_edge(clk) AND DE_Flush = '1' THEN
                readdata1_out <= (OTHERS => '0');
                readdata2_out <= (OTHERS => '0');
                memoryread_out <= '0';
                memorywrite_out <= '0';
                write_enable_out <= '0';
                --return_enable_out <= '0';
                --call_enable_out <= '0';
                alu_enable_out <= '0';
                aluimm_out <= '0';
                imm_enable_out <= '0';
                --pc_out <= (others => '0');
                imm_value_out <= (OTHERS => '0');
                writeRegAddr_out <= (OTHERS => '0');
                opcode_out <= (OTHERS => '0');
                INT_out <= '0';
                IN_PORT_DE <= (OTHERS => '0');
                RTI_out <= '0';
                instruction_DE_OUT <= (OTHERS => '0');
                ALU_CODE_DE_OUT <= "0000";
                out_port_out <= '0';
            END IF;
        END IF;
    END PROCESS;
END mymodel;