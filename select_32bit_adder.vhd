LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY select_32bit_adder IS
    PORT (
        A, B : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        cin : IN STD_LOGIC;
        C : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        cout : OUT STD_LOGIC);
END select_32bit_adder;

ARCHITECTURE arch_select_32bit_adder OF select_32bit_adder IS
    COMPONENT nadder IS
        PORT (
            A, B : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            cin : IN STD_LOGIC;
            C : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
            cout : OUT STD_LOGIC);
    END COMPONENT;

    COMPONENT select_adder IS
        PORT (
            A, B : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            cin : IN STD_LOGIC;
            C : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
            cout : OUT STD_LOGIC);
    END COMPONENT;

    SIGNAL temp : STD_LOGIC_VECTOR(8 DOWNTO 0);

BEGIN
    temp(0) <= cin;
    U0 : nadder PORT MAP(A(3 DOWNTO 0), B(3 DOWNTO 0), cin, C(3 DOWNTO 0), temp(1));
    loop1 : FOR i IN 1 TO 8-1 GENERATE
        ax : select_adder PORT MAP(A((4 * i + 3) DOWNTO (4 * i)), B((4 * i + 3) DOWNTO (4 * i)), temp(i), C((4 * i + 3) DOWNTO (4 * i)), temp(i + 1));
    END GENERATE;
    cout <= temp(8);
END arch_select_32bit_adder;