LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY InstructionCachee IS
    PORT (
        reset, enable, clk : IN STD_LOGIC;
        read_address : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        dataout : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END InstructionCachee;

ARCHITECTURE ic_model OF InstructionCachee IS
    TYPE ram_type IS ARRAY(0 TO 4095) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL ram : ram_type;
BEGIN
    PROCESS (reset, enable, clk, read_address)
    BEGIN
        IF reset = '1' THEN
            dataout <= ram(0);
        ELSE
            -- IF falling_edge(clk) THEN
            IF enable = '1' THEN
                dataout <= ram(to_integer(unsigned(read_address)));
            END IF;
            -- END IF;
        END IF;
    END PROCESS;
END ARCHITECTURE;