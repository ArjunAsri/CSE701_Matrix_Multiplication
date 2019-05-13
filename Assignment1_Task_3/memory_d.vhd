library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memory_d is
port (
    clk     : in std_logic;
    addr    : in unsigned(1 downto 0);
    q       : out unsigned(23 downto 0)
);

end entity memory_d;

architecture structure of memory_d is

    type mem is array(0 to 2) of unsigned(23 downto 0);

    signal memD : mem := (x"098E02",x"2F4008",x"02031F");
    

begin

    process(clk)
    begin

        if (rising_edge(clk)) then

            q <= memD(to_integer(addr));

        end if;

    end process;


end architecture structure;