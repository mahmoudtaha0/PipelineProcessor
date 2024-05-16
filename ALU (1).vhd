LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY ALU IS
    PORT (
        EN, rst : IN STD_LOGIC;
        in1, in2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        op : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        out_alu : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        ccr : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
END ALU;

-- Condition Code Register
-- OF CF NF ZF

ARCHITECTURE behavior OF ALU IS

    COMPONENT select_32bit_adder IS
        PORT (
            A, B : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            cin : IN STD_LOGIC;
            C : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            cout : OUT STD_LOGIC);
    END COMPONENT;

    SIGNAL in1_adder, in2_adder, out_signal, out_adder : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL cin_adder, cout_adder : STD_LOGIC;

BEGIN

    -- MUX of first operand for adder and logic unit.
    with op select
    in1_adder <= not in1 when "0110",
    in1 when others;

    -- MUX of second operand for adder and logic unit.
    with op select
    in2_adder <= in2 when "0100",
    not in2 when "0101" | "1001",
    (others => '1') when "1000",
    (others => '0') when others;

    -- MUX of carry in for adder
    with op select
    cin_adder <= '1' when "0110" | "0111" | "0101" | "1001",
    '0' when others;

    -- Adder Instantiation
    u: select_32bit_adder port map (
        A => in1_adder,
        B => in2_adder,
        cin => cin_adder,
        C => out_adder,
        cout => cout_adder
    );

    -- MUX of output
    with op select
    out_signal <= not in1 when "0000",
    in1 and in2 when "0001",
    in1 or in2 when "0010",
    in1 xor in2 when "0011",
    out_adder when others;

    -- Enable to control the ALU output
    with EN select 
    out_alu <= out_signal when '1',
    in1 when others;

    -- Flags
    -- Zero Flag
    ccr(0) <= '1' WHEN to_integer(signed(out_signal)) = 0 and EN = '1'
        ELSE
        '0' WHEN NOT (to_integer(signed(out_signal)) = 0) and EN = '1'
        ELSE
        '0' WHEN EN = '0' AND rst = '1';

    -- Negative Flag
    ccr(1) <= '1' WHEN to_integer(signed(out_signal)) < 0 and EN = '1'
        ELSE
        '0' WHEN NOT (to_integer(signed(out_signal)) < 0) and EN = '1'
        ELSE
        '0' WHEN EN = '0' AND rst = '1';

    -- Carry FLag
    ccr(2) <= '0' WHEN (op = "1000" OR op = "0000") AND EN = '1'
        ELSE
        cout_adder when NOT (op = "1001") AND EN = '1'
        ELSE
        '0' WHEN EN = '0' AND rst = '1';

    -- Overflow Flag
    ccr(3) <= '0' WHEN (op = "0000" OR op = "0010") AND EN = '1'
    ELSE not in2(31) and out_signal(31) when EN = '1'
    ELSE
        '0' WHEN EN = '0' AND rst = '1';
    
END ARCHITECTURE behavior;