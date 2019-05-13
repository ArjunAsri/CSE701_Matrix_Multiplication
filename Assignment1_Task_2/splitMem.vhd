library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity splitMem is
port (
    clk     : in std_logic;
    input    : in unsigned(23 downto 0);
	 reset : in std_logic;
    output_1       : out unsigned(7 downto 0);
	 output_2      : out unsigned(7 downto 0);
	 output_3       : out unsigned(7 downto 0)
);

end entity;


architecture beh of splitMem is

begin

	process(clk)

		begin

			if(rising_edge(clk))then
				if(reset = '0') then
				output_1 <= input(23 downto 16);
				output_2 <= input(15 downto 8);
				output_3 <= input(7 downto 0);
					else
				output_1 <= x"00";
				output_2 <= x"00";
				output_3 <= x"00";
				end if;
			end if;
			end process;


end beh;