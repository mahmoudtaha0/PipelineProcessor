LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY select_adder IS
    PORT (
        A, B : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        cin : IN STD_LOGIC;
        C : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        cout : OUT STD_LOGIC);
END select_adder;

ARCHITECTURE arch_select_adder OF select_adder IS
    COMPONENT nadder IS
        PORT (
            A, B : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            cin : IN STD_LOGIC;
            C : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
            cout : OUT STD_LOGIC);
    END COMPONENT;
    SIGNAL S0, S1 : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL cout0, cout1 : STD_LOGIC;
BEGIN
    f0 : nadder  PORT MAP(A, B, '0', s0, cout0);
    f1 : nadder  PORT MAP(A, B, '1', s1, cout1);

    C <= s0 WHEN cin = '0' ELSE
        s1;
    cout <= cout0 WHEN cin = '0' ELSE
        cout1;
END arch_select_adder;