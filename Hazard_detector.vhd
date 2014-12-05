library ieee;
use ieee.std_logic_1164.all;
library work;
use work.common.all;

entity Hazard_Detector is
    port (
        wbenable   : in  WBEnableType                 := WBEnable_No;
        memop      : in  MemOpType                    := MemOp_None;
        idrx       : in  std_logic_vector(2 downto 0) := "000";
        idry       : in  std_logic_vector(2 downto 0) := "000";
        wbregister : in  std_logic_vector(3 downto 0) := "0000";
        exmwbclear : out std_logic                    := '0';
        idhold     : out std_logic                    := '0';
        pchold     : out std_logic                    := '0'
        );
end Hazard_Detector;

architecture behavioral of Hazard_Detector is
begin
    process(wbenable, memop, idrx, idry, wbregister)
    begin
        if (wbenable = WBEnable_Yes and memop = MemOp_read and (idrx = wbregister(2 downto 0) or idrx = wbregister(2 downto 0))) then
            exmwbclear <= '1';
            idhold     <= '1';
            pchold     <= '1';
        end if;
    end process;
end behavioral;
