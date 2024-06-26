LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY HDU IS
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
END HDU;

ARCHITECTURE MY_MODEL OF HDU IS
BEGIN
    ----------------------------------------------
    -- Check Alu Control                        --
    -- If ALU_ALU forward -> Forward = "01"     --
    -- If MEM_ALU forward -> Forward = "11"     --
    -- If no forward -> Forward = "00"          --
    ----------------------------------------------

    -- Checks for RAW
    -- Forward(0) <= '1' when Instruction(8 downto 6) = Next_Instruction(5 downto 3) or Instruction(8 downto 6) = Next_Instruction(2 downto 0);
    -- else '0';

    -- Checks whether ALU/Mem forwarding using the opcode
    -- If ALU_Forward then Forward(1) = '0'
    -- Else if MEM_Forward then Forward(1) = '1'
    -- Forward(1) <= '1' when Instruction(15 downto 9) = -- "LDD,LDM,MOV ..etc" --modify with corresponding opcodes
    -- else '0' --ALU

    Forward_op1 <= "01" WHEN ((Rdst_ExMem = Instruction(8 DOWNTO 6)) AND WE_ExMem = '1') OR (Instruction(15 downto 14) = "00" AND Rdst_ExMem = Instruction(2 DOWNTO 0)) -- ALU_ALU forward
        ELSE
        "11" WHEN ((Rdst_MemWb = Instruction(8 DOWNTO 6)) AND WE_MemWb = '1') OR (Instruction(15 downto 14) = "00" AND Rdst_MemWb = Instruction(2 DOWNTO 0)) -- MEM_ALU forward
        ELSE
        "00"; -- no forward

    Forward_op2 <= "01" WHEN (Rdst_ExMem = Instruction(5 DOWNTO 3)) AND WE_ExMem = '1' And Instruction(15 DOWNTO 9) /= "0101000" -- ALU_ALU forward
        ELSE
        "11" WHEN (Rdst_MemWb = Instruction(5 DOWNTO 3)) AND WE_MemWb = '1' And Instruction(15 DOWNTO 9) /= "0101000" -- MEM_ALU forward
        ELSE
        "00"; -- no forward

    Stall <= "0000";
    Flush <= "0110" WHEN protection_violation = '1' else
        "0000";

--     Flush(0) <= '1' WHEN Previous_instruction(15 DOWNTO 9) = "1010000" OR Previous_instruction(15 DOWNTO 9) = "0111000" OR Previous_instruction(15 DOWNTO 9) = "0111001" --flush FD buffer for immidiate
-- ELSE
--     '0';

END ARCHITECTURE;