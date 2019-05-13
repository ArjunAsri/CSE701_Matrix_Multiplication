library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Adder is
port( clk : in std_logic;
		input_1, input_2, input_3 : in unsigned (16 downto 0);
		enable : in std_logic;
		output : out unsigned (16 downto 0)
		);
end entity;

architecture beh of Adder is 
signal outputSum : unsigned(16 downto 0) := "00000000000000000";

begin
process(clk, enable)
begin

	if (rising_edge(clk)) then
		if (enable = '1') then
		
		outputSum <= ((input_1)+ (input_2) + (input_3));
		
		end if;
	
	
	end if;
	end process;
output <= outputSum; 


end beh;