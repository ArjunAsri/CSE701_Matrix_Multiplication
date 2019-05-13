library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity specialregStore is
	port(
	clk : in std_logic;
	enable : in std_logic;
	reset :in std_logic;
	input : in unsigned (23 downto 0);
	output : out unsigned(23 downto 0)
	
	);
end entity ;


architecture beh of specialregStore is

begin

	process(clk,enable,reset)

		begin

			if(rising_edge(clk))then
				if(enable = '1') then 
					if(reset = '0') then
				output <= input;
					else
						output <= x"000000";
					end if;
				end if;
			end if;
			end process;


end beh;