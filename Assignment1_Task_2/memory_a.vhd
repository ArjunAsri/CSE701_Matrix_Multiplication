library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memory_a is
port (
    clk     : in std_logic;
    addr    : in unsigned(3 downto 0);
    q       : out unsigned(7 downto 0)
);

end entity memory_a;

architecture structure of memory_a is

    type mem is array(0 to 8) of unsigned(7 downto 0);

    signal memA : mem := (x"05",x"0C",x"04",x"01",x"07",x"09",x"0F",x"03",x"07");

begin

    process(clk)
    begin

        if (rising_edge(clk)) then

            q <= memA(to_integer(addr));

        end if;

    end process;


end architecture structure;