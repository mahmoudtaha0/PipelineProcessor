LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY nadder IS
    PORT (
        A, B : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        cin : IN STD_LOGIC;
        C : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        cout : OUT STD_LOGIC);
END nadder;

ARCHITECTURE arch_nadder OF nadder IS
    COMPONENT adder IS
        PORT (
            A, B, cin : IN STD_LOGIC;
            C, cout : OUT STD_LOGIC);
    END COMPONENT;
    SIGNAL temp : STD_LOGIC_VECTOR(4 DOWNTO 0);
BEGIN

    temp(0) <= cin;
    loop1 : FOR i IN 0 TO 3 GENERATE
        fx : adder PORT MAP(A(i), B(i), temp(i), C(i), temp(i + 1));
    END GENERATE;
    cout <= temp(4);
END arch_nadder;