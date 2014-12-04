library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

package common is
-- constants
    constant ZERO : std_logic_vector(15 downto 0) := "0000000000000000";
    constant HIGH_RESIST : std_logic_vector(15 downto 0) := "ZZZZZZZZZZZZZZZZ";
    constant T_index : std_logic_vector(2 downto 0) := "100";
    constant IH_index : std_logic_vector(2 downto 0) := "101";
    constant SP_index : std_logic_vector(2 downto 0) := "110";
-- MUX control signals    
    type WBSrcType is (WBSRrc_ALURes, WBSrc_Mem);
    type MemDataType is (MemData_Rx, MemData_Ry);
    type PCSrcType is (PCSrc_PC1, PCSrc_B, PCSrc_Rx_0, PCSrc_Rx_1, PCSrc_T_0, PCSrc_Rx, PCSrc_RA);
    type Op1SrcType is (Op1Src_Rx, Op1Src_Ry, Op1Src_SP, Op1Src_Imm, Op1Src_IH, Op1Src_PC1);
    type Op2SrcType is (Op2Src_Imm, Op2Src_Ry, Op2Src_0);
    type ForwardBType is (ForwardB_None, ForwardB_WriteData, ForwardB_ALUout);
    type ForwardAType is (ForwardA_None, ForwardA_WriteData, ForwardA_ALUout);
    type WBDstType is (WBDst_Rx, WBDst_Ry, WBDst_Rz, WBDst_SP, WBDst_IH, WBDst_T);

end common;