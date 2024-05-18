LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY FetchDecodeBuffer1 IS
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
END FetchDecodeBuffer1;
ARCHITECTURE fetch_model OF FetchDecodeBuffer1 IS
BEGIN
    PROCESS (clk, FD_reset)
    BEGIN
        IF FD_reset = '1' THEN
            Op_code <= (OTHERS => '0');
            To_RegFile_data <= (OTHERS => '0');
            To_RegFile_op_Code <= (OTHERS => '0');
            Given_instruction_output <= (OTHERS => '0');
            IN_PORT_FD <= (OTHERS => '0');

        ELSIF rising_edge(clk) THEN
            IF FD_enable = '1' AND FD_flush = '0' THEN
                Op_code <= Given_instruction(15 DOWNTO 9);
                To_RegFile_data <= Given_instruction(8 DOWNTO 0);
                To_RegFile_op_Code <= Given_instruction(15 DOWNTO 14); --For the registers to know the type
                Given_instruction_output <= Given_instruction;
                IN_PORT_FD <= IN_PORT;
            ELSIF FD_flush = '1' THEN
                Op_code <= (OTHERS => '0');
                To_RegFile_data <= (OTHERS => '0');
                To_RegFile_op_Code <= (OTHERS => '0');
                Given_instruction_output <= (OTHERS => '0');
                IN_PORT_FD <= (OTHERS => '0');
            END IF;
        END IF;
    END PROCESS;

END ARCHITECTURE;