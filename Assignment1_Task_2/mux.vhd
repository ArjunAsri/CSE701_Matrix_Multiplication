--The mux will be used to enable the specific registers
--to store the calculated values

library ieee;
use ieee.std_logic_1164.all;

entity Mux is
port(
	clk : in std_logic;
	input: in std_logic_vector (1 downto 0);
	enableRegA : out std_logic;
	enableRegB : out std_logic;
	enableRegC : out std_logic

);

end entity;

architecture beh of mux is 

signal outputSigA : std_logic := '0';
signal outputSigB : std_logic := '0';
signal outputSigC : std_logic := '0';
begin

	process(clk, input)
	begin
	
	if(rising_edge(clk)) then
		if(input = "00") then
		outputSigA <= '1';
		outputSigB <= '0';
		outputSigC <= '0';
		elsif (input = "01") then
		outputSigA <= '0';
		outputSigB <= '1';
		outputSigC <= '0';
		elsif (input = "10") then
		outputSigA <= '0';
		outputSigB <= '0';
		outputSigC <= '1';
		else
		outputSigA <= '0';
		outputSigB <= '0';
		outputSigC <= '0';
		end if;
	end if;
	end process;
	
	enableRegA <= outputSigA;
	enableRegB <= outputSigB;
	enableRegC <= outputSigC;
	
end beh;