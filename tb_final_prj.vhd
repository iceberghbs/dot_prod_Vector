library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity dot_prob_4_tb is
end dot_prob_4_tb;

architecture Behavioral of dot_prob_4_tb is
-- Correct component declaration 
component dot_prod_4 
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
end component;

-- Correct signal declaration 

 signal tb_Reset, tb_Clock, tb_start,tb_done: std_logic;
 signal tb_a1, tb_a2, tb_a3, tb_a4, tb_b1, tb_b2, tb_b3, tb_b4,tb_y: std_logic_vector (15 downto 0);
 constant period : time := 20 ns;

begin

 -- Correct component instantiation 
 -- unit uder test
UUT : dot_prod_4 
  port map (
           rst => tb_Reset,
           start => tb_start,
           clk => tb_Clock,
           a1 =>tb_a1,
           a2 =>tb_a2,
           a3 =>tb_a3,
           a4 =>tb_a4,
           b1 =>tb_b1,
           b2 =>tb_b2,
           b3 =>tb_b3,
           b4 =>tb_b4,
           y=>tb_y,
           done=>tb_done        
);
-- Correct Clock generation 
-- produce tb_Clock signal
process
  begin
     tb_Clock <= '1';
     wait for period/2;
     tb_Clock <= '0';
     wait for period/2;
end process;
stimuli : process
begin
       tb_Reset <= '1';
        tb_start <= '0';
        wait for 3*period;
        
        tb_Reset <= '0';
        tb_start <= '1';    
        tb_a1<="0000110011001101";
        tb_a2<="0000110011001101";   
        tb_a3<="0000110011001101";   
        tb_a4<="0000110011001101";
        
        tb_b1<="0000110011001101";
        tb_b2<="0000110011001101";
        tb_b3<="0000110011001101";
        tb_b4<="0000110011001101";    
        -- ouput should be 1311, radix signed decimal
        wait for 5*period; 
           
        wait;
        end  process;

end Behavioral;
