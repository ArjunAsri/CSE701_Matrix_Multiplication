library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity Counter is 
	port(
	clk, reset : in std_logic;
	output: out std_logic_vector(3 downto 0)
	
	);
end entity;

architecture beh of Counter is

-- one zero represents the counter value is zero
signal counter : std_logic_vector (3 downto 0) := X"0";
begin
	process (clk, reset)

	begin
	
	if(rising_edge(clk))then
		if(reset = '0') then
			counter <= counter + '1';
		else
			counter <= X"0";
		end if;
	
	end if;

end process;
output <= counter;

end beh;

