library ieee;
use ieee.std_logic_1164.all;
library work;
use work.common.all;

entity WB_Registers is
    port (
        clk        : in  std_logic;
        in_WBRegs  : in  WBRegsType;
        in_data    : in  WB_Data;
        out_WBRegs : out WBRegsType;
        out_data   : out WB_Data
        ) ;
end entity;

architecture arch of WB_Registers is

begin
    process(clk)
    begin
        if(rising_edge(clk)) then
            out_WBRegs <= in_WBRegs;
            out_data   <= in_data;
        end if;
    end process;
end architecture;  -- arch
