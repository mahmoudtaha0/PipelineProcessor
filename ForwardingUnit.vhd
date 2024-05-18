LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY ForwardingUnit IS
    PORT (
        Forward_op1, Forward_op2 : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        -- 00: No forwarding, 01: ALU_ALU, 11: MEM_ALU
        ALU_Result : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        MEM_Loaded : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        Forwarded_data_op1, Forwarded_data_op2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END ForwardingUnit;

ARCHITECTURE behavior OF ForwardingUnit IS
BEGIN
    Forwarded_data_op1 <= ALU_Result WHEN Forward_op1 = "01" ELSE
        MEM_Loaded WHEN Forward_op1 = "11" ELSE
        (OTHERS => '0');

    Forwarded_data_op2 <= ALU_Result WHEN Forward_op2 = "01" ELSE
        MEM_Loaded WHEN Forward_op2 = "11" ELSE
        (OTHERS => '0');

    -- Begin after resolving Imm/Operand mux selector from control unit issue 
END ARCHITECTURE;