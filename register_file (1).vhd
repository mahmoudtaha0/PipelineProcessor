LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY register_file IS
    PORT (
        clk, rst, write_enable, swap_enable : IN STD_LOGIC;
        write_addr1, write_addr2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        read_addr_1, read_addr_2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        write_data1, write_data2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        read_data_1, read_data_2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END register_file;

ARCHITECTURE arch_register_file OF register_file IS
    TYPE my_mem_array IS ARRAY(0 TO 7) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL my_ram : my_mem_array;
    BEGIN
    PROCESS (clk, rst)
    VARIABLE temp : STD_LOGIC_VECTOR(31 DOWNTO 0);
    BEGIN
        IF rst = '1' THEN
            my_ram <= (OTHERS => (OTHERS => '0'));
            temp := (others => '0');
        ELSIF rising_edge(clk) THEN
            IF write_enable = '1' AND swap_enable = '0' THEN
                my_ram(to_integer(unsigned(write_addr1))) <= write_data1;
            ELSIF write_enable = '1' AND swap_enable = '1' THEN
                temp := my_ram(to_integer(unsigned(write_addr2)));
                my_ram(to_integer(unsigned(write_addr2))) <= write_data1;
                my_ram(to_integer(unsigned(write_addr1))) <= temp;
            END IF;
        END IF;
    END PROCESS;
    read_data_1 <= my_ram(to_integer(unsigned(read_addr_1)));
    read_data_2 <= my_ram(to_integer(unsigned(read_addr_2)));
END arch_register_file;