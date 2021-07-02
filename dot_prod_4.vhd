
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;

entity dot_prod_4 is
Port( clk : in std_logic;
rst : in std_logic;
start : in std_logic;
-- first vector
a1 : in std_logic_vector(15 downto 0);
a2 : in std_logic_vector(15 downto 0);
a3 : in std_logic_vector(15 downto 0);
a4 : in std_logic_vector(15 downto 0);
-- second vector
b1 : in std_logic_vector(15 downto 0);
b2 : in std_logic_vector(15 downto 0);
b3 : in std_logic_vector(15 downto 0);
b4 : in std_logic_vector(15 downto 0);
-- outputs
y : out std_logic_vector(15 downto 0);
done : out std_logic);
end dot_prod_4;


architecture Behavioral of dot_prod_4 is

component mul_q
Port (  m1 : in std_logic_vector (15 downto 0);
        m2 : in std_logic_vector (15 downto 0);
        m3 : out std_logic_vector (15 downto 0));
end component;

component adder_so_sat
generic( N : integer:=16);
Port ( a1 : in STD_LOGIC_VECTOR (N-1 downto 0);
   a2 : in STD_LOGIC_VECTOR (N-1 downto 0);
   a3 : out STD_LOGIC_VECTOR (N-1 downto 0);
   ov : out STD_LOGIC);
end component;

signal m11_buffer, m12_buffer, m13_buffer : std_logic_vector(15 downto 0);
signal m21_buffer, m22_buffer, m23_buffer : std_logic_vector(15 downto 0);
signal a1b1_reg, a2b2_reg, a3b3_reg, a4b4_reg : std_logic_vector(15 downto 0);
signal y1, y2 ,y3, nx_y: std_logic_vector(15 downto 0);
signal ov1, ov2, ov3 : std_logic;
type states is (idle, mt1, mt2, ok);
signal nx_state, state : states;
signal nx_done : std_logic;

begin
    inst1:  mul_q
        port map(m1=>m11_buffer, m2=>m12_buffer, m3=>m13_buffer);
        
    inst2:  mul_q
        port map(m1=>m21_buffer, m2=>m22_buffer, m3=>m23_buffer);
        
    adder1: adder_so_sat
        port map(a1=>a1b1_reg, a2=>a2b2_reg, a3=>y1, ov=>ov1);
        
    adder2: adder_so_sat
        port map(a1=>y1, a2=>a3b3_reg, a3=>y2, ov=>ov2);
        
    adder3: adder_so_sat
        port map(a1=>y2, a2=>a4b4_reg, a3=>y3, ov=>ov3);
        
    process(clk, rst)
    begin
        if rst='1' then
            done <= '0';
            y <= (others=>'0');
            state <= idle;
        elsif rising_edge(clk) then
            state <= nx_state;
            done <= nx_done;
            y <= nx_y;
        end if;
    end process;
    
    fsm:process(clk)
    begin
        nx_state <= state;
        nx_y <= y3;
        nx_done <= '0';
        
        case state is
            when idle=>
                if start='1' then
                    nx_state <= mt1;
                end if;
            when mt1=>
                m11_buffer <= a1;
                m12_buffer <= b1;
                a1b1_reg <= m13_buffer;
                
                m21_buffer <= a2;
                m22_buffer <= b2;
                a2b2_reg <= m23_buffer;
                
                nx_state <= mt2;
            when mt2=>
                m11_buffer <= a3;
                m12_buffer <= b3;
                a3b3_reg <= m13_buffer;
                
                m21_buffer <= a4;
                m22_buffer <= b4;
                a4b4_reg <= m23_buffer;
                
                nx_state <= ok;
                
            when ok=>
                nx_done <= '1';
                nx_y <= y3;
        end case;
    end process;

end Behavioral;
