library ieee;
use ieee.std_logic_1164.all;
library work;
use work.common.all;

entity M_WB_Registers is
    port (
        clk        : in  std_logic;
        in_MRegs   : in  MRegsType;
        in_WBRegs  : in  WBRegsType;
        in_data    : in  M_WB_Data;
        out_MRegs  : out MRegsType;
        out_WBRegs : out WBRegsType;
        out_data   : out M_WB_Data
        ) ;
end entity;

architecture arch of M_WB_Registers is

begin
    process(clk)
    begin
        if(rising_edge(clk)) then
            out_MRegs  <= in_MRegs;
            out_WBRegs <= in_WBRegs;
            out_data   <= in_data;
        end if;
    end process;
end architecture;  -- arch
