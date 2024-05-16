LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY ForwardingUnit IS
    PORT (
        Forward_Sig : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        -- 00: No forwarding, 01: ALU_ALU, 11: MEM_ALU
        ALU_Result : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        MEM_Loaded : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        Forwarded_data : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
       
    );
END ForwardingUnit;

ARCHITECTURE behavior OF ForwardingUnit IS
BEGIN
	Forwarded_data <= ALU_Result when Forward_Sig = "01" else
        MEM_Loaded when Forward_Sig = "11" else
        (others => '0');
			  
-- Begin after resolving Imm/Operand mux selector from control unit issue 
END ARCHITECTURE;