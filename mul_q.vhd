
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity mul_q is
Port (  m1 : in std_logic_vector (15 downto 0);
        m2 : in std_logic_vector (15 downto 0);
        m3 : out std_logic_vector (15 downto 0));
end mul_q;

architecture Behavioral of mul_q is
    signal m1i, m2i : signed(15 downto 0);
    signal m3i : signed(31 downto 0);
begin
    m1i <= signed(m1);
    m2i <= signed(m2);
    m3i <= m1i*m2i;
    m3 <= std_logic_vector(m3i(30 downto 15));  -- q30 to q15
end Behavioral;
