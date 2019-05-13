--Author : Arjun Kumar
--Date : 12/03/2018
--Description: Multiplier block takes 2 8 bit numbers and multiplies them together to give a 16 bit output

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Multiplier is
	port(
	clk : in std_logic;
	enable : in std_logic;
	inputA :in unsigned(7 downto 0);
	inputB : in unsigned (7 downto 0);
	output : out unsigned(16 downto 0)
	
	);
end entity Multiplier;


architecture beh of Multiplier is
begin

process(clk,enable)
variable multiplicationResult : unsigned(15 downto 0) := X"0000";


begin

if(rising_edge(clk))then
	if(enable = '1') then 
	multiplicationResult := ((inputA) * (inputB));
	end if;
end if;
output <= unsigned ('0'& std_logic_vector(multiplicationResult));
end process;


end beh;