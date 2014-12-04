library ieee;
use ieee.std_logic_1164.all;
library work;
use work.common.all;

entity EX_M_WB_Registers is
    port (
        clk        : in  std_logic;
        force_nop  : in  std_logic;
        in_EXRegs  : in  EXRegsType;
        in_MRegs   : in  MRegsType;
        in_WBRegs  : in  WBRegsType;
        in_data    : in  EX_M_WB_Data;
        out_EXRegs : out EXRegsType;
        out_MRegs  : out MRegsType;
        out_WBRegs : out WBRegsType;
        out_data   : out  EX_M_WB_Data
        ) ;
end entity;  -- EX_WB_M_Registers

architecture arch of EX_M_WB_Registers is

begin
    process(clk)
    begin
        if(rising_edge(clk)) then
            if (force_nop = '1') then
				out_MRegs.MemOp <= MemOp_Read;
		        out_WBRegs.WBEnable <= WBEnable_No;
            else
                out_EXRegs <= in_EXRegs;
                out_MRegs  <= in_MRegs;
                out_WBRegs <= in_WBRegs;
                out_data   <= in_data;
            end if;
        end if;
    end process;
end architecture;  -- arch
