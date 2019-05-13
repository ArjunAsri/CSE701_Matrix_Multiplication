library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Multiplier_tb is
end Multiplier_tb;


architecture beh of Multiplier_tb is
  signal t_enable : std_logic := '0';
  signal t_inputA : unsigned(7 downto 0);
  signal t_inputB : unsigned(7 downto 0);
  signal t_clk : std_logic;
  signal t_output : unsigned(16 downto 0);
  
  component Multiplier is
    port (
      clk : in std_logic;
	 enable : in std_logic;
	 inputA : in unsigned(7 downto 0);
	 inputB : in unsigned (7 downto 0);
	 output : out unsigned(16 downto 0)
	 );
	 end component Multiplier;
	 
	 begin
	   Multiplier_inst : Multiplier
	   
	   
	   --Map the components to their respective signals 
	   port map(
	     clk    => t_clk,
	     enable => t_enable,
	     inputA => t_inputA,
	     inputB => t_inputB,
	     output => t_output
	   );
	   
	   
	   multiply_process: process 
	     begin
	  
	  wait for 10 ns;    
	       
    t_enable <= '1';
    t_inputA <= "11001000"; --200
    t_inputB <= "00100011"; -- 67
    
    wait for 10 ns;
      
    t_enable <= '0';
    t_inputA <= "11001000"; --200
    t_inputB <= "00100011"; -- 67
    
    wait for 20 ns;
    t_enable <= '0';
    t_inputA <= "11111111"; --200
    t_inputB <= "00000000"; -- 67
    
    wait for 10 ns;
    t_enable <= '1';
    t_inputA <= "11111111"; --200
    t_inputB <= "00000000"; -- 67
    
   wait for 10 ns;
    t_enable <= '1';
    t_inputA <= "11111111"; --200
    t_inputB <= "00000001"; -- 67
	     
	     
	   end process;


      clk_process: process
        begin
          t_clk <= '0';
        wait for 10 ns;
          t_clk <= '1';
        wait for 10 ns;
        
    end process;
end beh;
	       
	       
	       
	       
	   
      
  
