library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memory_r is
port (
    clk     : in std_logic;
    wr      : in std_logic;
    addr    : in unsigned(3 downto 0);
    q       : in unsigned(16 downto 0);
    output : out unsigned(16 downto 0)
);

end entity memory_r;

architecture structure of memory_r is

    type mem is array(0 to 8) of unsigned(16 downto 0);

    signal memR : mem;

begin

    process(clk)
    begin

        if (rising_edge(clk)) then
            if wr = '1' then
                memR(to_integer(addr)) <= q;
		output <= memR(to_integer(addr));
            end if;

        end if;

    end process;


end architecture structure;