library ieee;
use ieee.std_logic_1164.all;
library work;
use work.common.all;

entity RA is
    port (
        clk        : in  std_logic;
        RAWrite    : in  RAWriteType;
        write_data : in  std_logic_vector(15 downto 0);
        RA         : out std_logic_vector(15 downto 0)
        ) ;
end entity;

architecture arch of RA is
    signal RA_value : std_logic_vector(15 downto 0);
begin
    RA <= RA_value;
    process(clk)
    begin
        if(rising_edge(clk)) then
            if (RAWrite = RAWrite_Yes) then
                RA_value <= write_data;
            end if;
        end if;
    end process;
end architecture;  -- arch

