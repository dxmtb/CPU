library ieee;
use ieee.std_logic_1164.all;
library work;
use work.common.all;

entity ID_Registers is
    port (
        clk        : in  std_logic;
        in_PC1     : in  std_logic_vector(15 downto 0);
        in_INS     : in  std_logic_vector(15 downto 0);
        in_hazard : in  std_logic;
        out_PC1    : out std_logic_vector(15 downto 0);
        out_INS    : out std_logic_vector(15 downto 0)
        ) ;
end entity;

architecture arch of ID_Registers is

begin
    process(clk)
    begin
        if(rising_edge(clk)) then
            if in_hazard /= '1' then
                out_PC1 <= in_PC1;
                out_INS <= in_INS;
            end if;
        end if;
    end process;
end architecture;  -- arch
