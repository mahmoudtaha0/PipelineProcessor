LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY DataMemory IS
    PORT (
        rst, memoryWrite, memoryRead, clk, protect_enable, free_enable, push_en, pop_en, call_en : IN STD_LOGIC;
        writeData, Add : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        PC : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        readData, PC_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        violation_signal : OUT STD_LOGIC;
        INT, RTI : IN STD_LOGIC;
        CCR : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        CCR_out : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
END DataMemory;

ARCHITECTURE mymodel OF DataMemory IS
    TYPE ram_type IS ARRAY(0 TO 2 ** 11 - 1) OF STD_LOGIC_VECTOR(15 DOWNTO 0); -- 4096 16-bit words (4 KB)
    TYPE ram_type_protect IS ARRAY(0 TO 2 ** 11 - 1) OF STD_LOGIC; -- 4096 1-bit words (4 KB)
    SIGNAL ram : ram_type;
    SIGNAL ram_protected : ram_type_protect;
    SIGNAL st_in : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL st_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL PC_signal : STD_LOGIC_VECTOR(31 DOWNTO 0);
    COMPONENT SP IS
        PORT (
            Clk, Rst, En : IN STD_LOGIC;
            d : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            q : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END COMPONENT;
BEGIN
    -- st_in <= STD_LOGIC_VECTOR(unsigned(st_out) - 2) WHEN (push_en = '1' AND pop_en = '0')
    --     ELSE
    --     STD_LOGIC_VECTOR(unsigned(st_out) + 2) WHEN (pop_en = '1' AND push_en = '0')
    --     ELSE
    --     st_out;

    spp : SP PORT MAP(clk, rst, '1', st_in, st_out);
    PROCESS (clk, rst)
    BEGIN
        IF rst = '1' THEN
            ram <= (OTHERS => (OTHERS => '0'));
            ram_protected <= (OTHERS => '0');
            violation_signal <= '0';
            PC_out <= (OTHERS => '0');
        ELSIF rising_edge(clk) THEN
            IF memoryWrite = '1' AND ram_protected(to_integer(unsigned(Add))) = '0' THEN
                ram(to_integer(unsigned(Add))) <= writeData(31 DOWNTO 16); --------- e7na msh fahmen hena hanktb ezay 32 bits fel memory ely heya 16 bit keda hattktb 3ala mkanen ??
                ram(to_integer(unsigned(Add) + 1)) <= writeData(15 DOWNTO 0);
            ELSIF memoryWrite = '1' AND ram_protected(to_integer(unsigned(Add))) = '1' THEN
                violation_signal <= '1';
            ELSIF protect_enable = '1' THEN
                ram_protected(to_integer(unsigned(Add))) <= '1';
            ELSIF free_enable = '1' THEN
                ram_protected(to_integer(unsigned(Add))) <= '0';
            ELSIF memoryWrite = '1' AND push_en = '1' THEN
                ram(to_integer(unsigned(st_out))) <= writeData(31 DOWNTO 16); --------- e7na msh fahmen hena hanktb ezay 32 bits fel memory ely heya 16 bit keda hattktb 3ala mkanen ??
                ram(to_integer(unsigned(st_out) - 1)) <= writeData(15 DOWNTO 0);
                st_in <= STD_LOGIC_VECTOR(unsigned(st_out) - 2);
            ELSIF call_en = '1' AND memoryWrite = '1' THEN
                PC_signal <= STD_LOGIC_VECTOR(unsigned(PC) + 1);
                ram(to_integer(unsigned(st_out))) <= PC_signal(31 DOWNTO 16);
                ram(to_integer(unsigned(st_out) - 1)) <= PC_signal(15 DOWNTO 0);
                st_in <= std_logic_vector(unsigned(st_out) - 2);
                -- Fadel PC <- R[Rdst]
            ELSIF INT = '1' THEN
            -- SAVE PC
            ram(to_integer(unsigned(st_out))) <= PC_signal(31 DOWNTO 16);
            ram(to_integer(unsigned(st_out) - 1)) <= PC_signal(15 DOWNTO 0);
            st_in <= STD_LOGIC_VECTOR(unsigned(st_out) - 2);
            -- SAVE CCR
            ram(to_integer(unsigned(st_out))) <= "0000" & "0000" & "0000" & "0000";
            ram(to_integer(unsigned(st_out)) - 1) <= "0000" & "0000" & "0000" & CCR;
            -- 16'0
            -- 12'0 + CCR

            -- PC <- M[3], M[2]
            st_in <= STD_LOGIC_VECTOR(unsigned(st_out) - 2);
            PC_out <= ram(3) & ram(2);

            ELSIF RTI = '1' THEN
            -- RESTORE CCR
            st_in <= STD_LOGIC_VECTOR(unsigned(st_out) + 2);
            CCR_out <= ram(to_integer(unsigned(st_out )) - 1)(3 DOWNTO 0);
            -- RESTORE PC
            st_in <= STD_LOGIC_VECTOR(unsigned(st_out) + 2);
            PC_out <= ram(to_integer(unsigned(st_out))) & ram(to_integer(unsigned(st_out)) - 1);
            
            END IF;
        ELSIF falling_edge(clk) THEN
            violation_signal <= '0';
        END IF;
    END PROCESS;

    PROCESS (memoryRead, Add, clk)
    BEGIN
        IF falling_edge(clk) THEN
            IF memoryRead = '1' AND push_en = '0' THEN
                readData(31 DOWNTO 16) <= ram(to_integer(unsigned(Add)));
                readData(15 DOWNTO 0) <= ram(to_integer(unsigned(Add) + 1));
            ELSIF memoryRead = '1' AND pop_en = '1' THEN
                readData(31 DOWNTO 16) <= ram(to_integer(unsigned(st_out)));
                readData(15 DOWNTO 0) <= ram(to_integer(unsigned(st_out) + 1));
                st_in <= STD_LOGIC_VECTOR(unsigned(st_out) + 2);
            ELSIF memoryRead = '1' AND call_en = '1' THEN
                PC_out(31 DOWNTO 16) <= ram(to_integer(unsigned(Add)));
                PC_out(15 DOWNTO 0) <= ram(to_integer(unsigned(Add) + 1));
            ELSE
                readData <= (OTHERS => '0');
            END IF;
        END IF;
    END PROCESS;
END ARCHITECTURE;