library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memory_b is
port (
    clk     : in std_logic;
    addr    : in unsigned(3 downto 0);
    q       : out unsigned(7 downto 0)
);

end entity memory_b;

architecture structure of memory_b is

    type mem is array(0 to 8) of unsigned(7 downto 0);

    signal memB : mem := (x"02",x"08",x"1F",x"8E",x"40",x"03",x"09",x"2F",x"02");
    

begin

    process(clk)
    begin

        if (rising_edge(clk)) then

            q <= memB(to_integer(addr));

        end if;

    end process;


end architecture structure;