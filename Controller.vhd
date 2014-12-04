library ieee;
use ieee.std_logic_1164.all;
use work.common.all;

entity Controller is
    port (
        INS    : in  std_logic_vector(15 downto 0);
        IFRegs : out IFRegsType;
        IDRegs : out IDRegsType;
        EXRegs : out EXRegsType;
        MRegs  : out MRegsType;
        WBRegs : out WBRegsType
        ) ;
end entity;  -- Controller

architecture arch of Controller is

    signal ins_op   : std_logic_vector(4 downto 0);
    signal ins_func : std_logic_vector(1 downto 0);

begin
    ins_op <= INS(15 downto 11);
    process (INS)
        variable RetIFRegs : IFRegsType;
        variable RetIDRegs : IDRegsType;
        variable RetEXRegs : EXRegsType;
        variable RetMRegs  : MRegsType;
        variable RetWBRegs : WBRegsType;
    begin
        -- NOP by default
        RetIFRegs.PCSrc    := PCSrc_PC1;
        RetIDRegs.RAWrite  := RAWrite_No;
        RetMRegs.MemOp     := MemOp_Read;
        RetWBRegs.WBEnable := WBEnable_No;
        
        
    end process;

end architecture;  -- arch
