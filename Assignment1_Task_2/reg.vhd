library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg is
	port(
	clk : in std_logic;
	enable : in std_logic;
	reset :in std_logic;
	inputA : in unsigned (16 downto 0);
	output : out unsigned(16 downto 0)
	
	);
end entity reg;


architecture beh of reg is

begin

	process(clk,enable,reset)

		begin

			if(rising_edge(clk))then
				if(enable = '1') then 
					if(reset = '0') then
				output <= inputA;
					else
						output <= "00000000000000000";
					end if;
				end if;
			end if;
			end process;


end beh;