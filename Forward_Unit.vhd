library ieee;
use ieee.std_logic_1164.all;
library work;
use work.common.all;

entity Forward_Unit is
    port (
        op1src : in Op1SrcType;
        op2src : in Op2SrcType;
        rx : in std_logic_vector(2 downto 0);
        ry : in std_logic_vector(2 downto 0);
        wbregister1 : in std_logic_vector(2 downto 0);
        wbsrc1 : in WBSrcType;
        wbenable1: in WBEnableType;
        wbregister2 : in std_logic_vector(2 downto 0);
        wbsrc2 : in WBSrcType;
        wbenable2 : in WBEnableType; 
        forwarda : out ForwardType := Forward_None;
        forwardb : out ForwardType := Forward_None
    );
end Forward_Unit;

architecture behavioral of Forward_Unit is
begin
    process(op1src, op2src, rx, ry, wbregister1, wbsrc1, wbenable1, wbregister2, wbsrc2, wbenable2)
    begin
        -- for muxA
        forwarda <= Forward_None;
        case op1src is
            when Op1Src_Rx =>
                if (("0" & rx) = wbregister1 and wbenable1 = WBEnable_Yes and wbsrc1 = WBSrc_ALURes) then
                    forwarda <= Forward_ALURes;
                elsif (("0" & rx) = wbregister2 and wbenable2 = WBEnable_Yes and wbsrc2 = WBSrc_Mem) then
                    forwarda <= Forward_Mem;
                end if;
            when Op1Src_Ry =>
                if (("0" & ry) = wbregister1 and wbenable1 = WBEnable_Yes and wbsrc1 = WBSrc_ALURes) then
                    forwarda <= Forward_ALURes;
                elsif (("0" & ry) = wbregister2 and wbenable2 = WBEnable_Yes and wbsrc2 = WBSrc_Mem) then
                    forwarda <= Forward_Mem;
                end if;
            when Op1Src_SP =>
                if (wbregister1 = SP_index and wbenable1 = WBEnable_Yes and wbsrc1 = WBSrc_ALURes) then
                    forwarda <= Forward_ALURes;
                elsif (wbregister2 = SP_index and wbenable2 = WBEnable_Yes and wbsrc2 = WBSrc_Mem) then
                    forwarda <= Forward_Mem;
                end if; 
            when Op1Src_IH =>
                if (wbregister1 = IH_index and wbenable1 = WBEnable_Yes and wbsrc1 = WBSrc_ALURes) then
                    forwarda <= Forward_ALURes;
                elsif (wbregister2 = IH_index and wbenable2 = WBEnable_Yes and wbsrc2 = WBSrc_Mem) then
                    forwarda <= Forward_Mem;
                end if; 
            when others =>
        end case;
        -- for muxB
        forwardb <= Forward_None;
        if (op2src = Op2Src_Ry) then
            if (("0" & ry) = wbregister1 and wbenable1 = WBEnable_Yes and wbsrc1 = WBSrc_ALURes) then
                forwardb <= Forward_ALURes;
            elsif (("0" & ry) = wbregister2 and wbenable2 = WBEnable_Yes and wbsrc2 = WBSrc_Mem) then
                forwardb <= Forward_Mem;
            end if;
        end if;
    end process;
end behavioral;
