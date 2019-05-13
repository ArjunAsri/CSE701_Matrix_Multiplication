library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memory_c is
port (
    clk     : in std_logic;
    addr    : in unsigned(1 downto 0);
    q       : out unsigned(23 downto 0)
);

end entity memory_c;

architecture structure of memory_c is

    type mem is array(0 to 2) of unsigned(23 downto 0);

    signal memC : mem := (x"040C05",x"090701",x"07030F");

begin

    process(clk)
    begin

        if (rising_edge(clk)) then

            q <= memC(to_integer(addr));

        end if;

    end process;


end architecture structure;