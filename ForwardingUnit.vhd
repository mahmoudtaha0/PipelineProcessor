LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY ForwardingUnit IS
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
END ForwardingUnit;

ARCHITECTURE behavior OF ForwardingUnit IS
BEGIN
    Forwarded_data_op1 <= ALU_Result WHEN Forward_op1 = "01" AND input_en = '0' AND input_en_prev = '0'
        ELSE
        input_port_prev WHEN Forward_op1 = "01" AND input_en_prev = '1' AND input_en = '0'
        ELSE
        MEM_Loaded WHEN Forward_op1 = "11" AND input_en = '0'
        ELSE
        input_port WHEN Forward_op1 = "11" AND input_en = '1'
        ELSE
        (OTHERS => '0');

    Forwarded_data_op2 <= ALU_Result WHEN Forward_op2 = "01" AND input_en = '0' AND input_en_prev = '0'
        ELSE
        input_port_prev WHEN Forward_op2 = "01" AND input_en_prev = '1' AND input_en = '0'
        ELSE
        MEM_Loaded WHEN Forward_op2 = "11" AND input_en = '0'
        ELSE
        input_port WHEN Forward_op2 = "11" AND input_en = '1'
        ELSE
        (OTHERS => '0');
END ARCHITECTURE;