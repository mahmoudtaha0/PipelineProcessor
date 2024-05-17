LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY DataMemory IS
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
END DataMemory;

ARCHITECTURE mymodel OF DataMemory IS
    TYPE ram_type IS ARRAY(0 TO 2 ** 12 - 1) OF STD_LOGIC_VECTOR(15 DOWNTO 0); -- 4096 16-bit words (8 KB)
    TYPE ram_type_protect IS ARRAY(0 TO 2 ** 12 - 1) OF STD_LOGIC; -- 4096 1-bit words (4 KB)
    SIGNAL ram : ram_type;
    SIGNAL ram_protected : ram_type_protect;
    SIGNAL SP_Signal : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL PC_signal : STD_LOGIC_VECTOR(31 DOWNTO 0);
BEGIN
    PROCESS (clk, rst, memoryRead, Addr)
    BEGIN
        IF rst = '1' THEN
            ram <= (OTHERS => (OTHERS => '0'));
            ram_protected <= (OTHERS => '0');
            violation_signal <= '0';
            PC_out <= (OTHERS => '0');
            PC_signal <= (OTHERS => '0');
            SP <= "00000000000000000000111111111111";
            SP_Signal <= "00000000000000000000111111111111";
        ELSIF rising_edge(clk) AND rst = '0' THEN
            IF memoryWrite = '1' AND ram_protected(to_integer(unsigned(Addr))) = '0' AND push_en = '0' AND call_en = '0' THEN
                ram(to_integer(unsigned(Addr))) <= writeData(31 DOWNTO 16); -- WRITE
                ram(to_integer(unsigned(Addr) + 1)) <= writeData(15 DOWNTO 0);
            ELSIF memoryWrite = '1' AND ram_protected(to_integer(unsigned(Addr))) = '1' THEN
                violation_signal <= '1';
            ELSIF protect_enable = '1' THEN
                ram_protected(to_integer(unsigned(Addr))) <= '1';
            ELSIF free_enable = '1' THEN
                ram_protected(to_integer(unsigned(Addr))) <= '0';
            ELSIF memoryWrite = '1' AND push_en = '1' THEN -- Push
                ram(to_integer(unsigned(SP_Signal))) <= writeData(31 DOWNTO 16);
                ram(to_integer(unsigned(SP_Signal) - 1)) <= writeData(15 DOWNTO 0);
                SP <= STD_LOGIC_VECTOR(unsigned(SP_Signal) - 2);
                SP_Signal <= STD_LOGIC_VECTOR(unsigned(SP_Signal) - 2);
            ELSIF call_en = '1' AND memoryWrite = '1' THEN
                PC_signal <= STD_LOGIC_VECTOR(unsigned(PC) + 1);
                ram(to_integer(unsigned(SP_Signal))) <= PC_signal(31 DOWNTO 16);
                ram(to_integer(unsigned(SP_Signal) - 1)) <= PC_signal(15 DOWNTO 0);
                SP <= STD_LOGIC_VECTOR(unsigned(SP_Signal) - 2);
                SP_Signal <= STD_LOGIC_VECTOR(unsigned(SP_Signal) - 2);
            ELSIF INT = '1' THEN
                -- SAVE PC
                ram(to_integer(unsigned(SP_Signal))) <= PC(31 DOWNTO 16);
                ram(to_integer(unsigned(SP_Signal) - 1)) <= PC(15 DOWNTO 0);
                SP <= STD_LOGIC_VECTOR(unsigned(SP_Signal) - 2);
                SP_Signal <= STD_LOGIC_VECTOR(unsigned(SP_Signal) - 2);
                -- SAVE CCR
                ram(to_integer(unsigned(SP_Signal))) <= "0000000000000000";
                ram(to_integer(unsigned(SP_Signal) - 1)) <= "000000000000" & CCR;
                SP <= STD_LOGIC_VECTOR(unsigned(SP_Signal) - 2);
                SP_Signal <= STD_LOGIC_VECTOR(unsigned(SP_Signal) - 2);
                -- PC <- M[3], M[2]
                PC_out <= ram(3) & ram(2);
            ELSIF RTI = '1' OR ret_en = '1' THEN
                -- RESTORE PC
                SP <= STD_LOGIC_VECTOR(unsigned(SP_Signal) + 2);
                SP_Signal <= STD_LOGIC_VECTOR(unsigned(SP_Signal) + 2);
                PC_out <= ram(to_integer(unsigned(SP_Signal))) & ram(to_integer(unsigned(SP_Signal) - 1));
                -- RESTORE CCR if RTI
                IF RTI = '1' THEN
                    CCR_out <= ram(to_integer(unsigned(SP_Signal)) - 1)(3 DOWNTO 0);
                END IF;
                SP <= STD_LOGIC_VECTOR(unsigned(SP_Signal) + 2);
                SP_Signal <= STD_LOGIC_VECTOR(unsigned(SP_Signal) + 2);
            END IF;
        ELSIF falling_edge(clk) THEN
            violation_signal <= '0';
            IF memoryRead = '1' AND push_en = '0' AND pop_en = '0' AND call_en = '0' THEN -- READ
                readData(31 DOWNTO 16) <= ram(to_integer(unsigned(Addr)));
                readData(15 DOWNTO 0) <= ram(to_integer(unsigned(Addr) + 1));
            ELSIF memoryRead = '1' AND pop_en = '1' THEN -- POP
                readData(31 DOWNTO 16) <= ram(to_integer(unsigned(SP_Signal)));
                readData(15 DOWNTO 0) <= ram(to_integer(unsigned(SP_Signal) + 1));
                SP <= STD_LOGIC_VECTOR(unsigned(SP_Signal) + 2);
                SP_Signal <= STD_LOGIC_VECTOR(unsigned(SP_Signal) + 2);
            ELSIF memoryRead = '1' AND call_en = '1' THEN -- CALL
                PC_out(31 DOWNTO 16) <= ram(to_integer(unsigned(Addr)));
                PC_out(15 DOWNTO 0) <= ram(to_integer(unsigned(Addr) + 1));
            ELSE
                readData <= (OTHERS => '0');
            END IF;
        END IF;
    END PROCESS;

    -- PROCESS (memoryRead, Addr, clk, rst)
    -- BEGIN
    --     -- IF rst = '1' THEN
    --     --     ram <= (OTHERS => (OTHERS => '0'));
    --     --     ram_protected <= (OTHERS => '0');
    --     --     violation_signal <= '0';
    --     --     PC_out <= (OTHERS => '0');
    --     --     SP_Signal <= "00000000000000000000111111111111";
    --     --     SP <= "00000000000000000000111111111111";
    --     IF falling_edge(clk) and rst = '0' THEN
    --         IF memoryRead = '1' AND push_en = '0' THEN -- READ
    --             readData(31 DOWNTO 16) <= ram(to_integer(unsigned(Addr)));
    --             readData(15 DOWNTO 0) <= ram(to_integer(unsigned(Addr) + 1));
    --         ELSIF memoryRead = '1' AND pop_en = '1' THEN -- POP
    --             readData(31 DOWNTO 16) <= ram(to_integer(unsigned(SP_Signal)));
    --             readData(15 DOWNTO 0) <= ram(to_integer(unsigned(SP_Signal) + 1));
    --             SP_Signal <= STD_LOGIC_VECTOR(unsigned(SP_Signal) + 2);
    --             SP <= STD_LOGIC_VECTOR(unsigned(SP_Signal));
    --         ELSIF memoryRead = '1' AND call_en = '1' THEN -- CALL
    --             PC_out(31 DOWNTO 16) <= ram(to_integer(unsigned(Addr)));
    --             PC_out(15 DOWNTO 0) <= ram(to_integer(unsigned(Addr) + 1));
    --         ELSE
    --             readData <= (OTHERS => '0');
    --         END IF;
    --     END IF;
    -- END PROCESS;
END ARCHITECTURE;