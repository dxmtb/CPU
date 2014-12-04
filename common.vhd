library IEEE;
use IEEE.STD_LOGIC_1164.all;

package common is
    -- constants
    constant ZERO        : std_logic_vector(15 downto 0) := "0000000000000000";
    constant HIGH_RESIST : std_logic_vector(15 downto 0) := "ZZZZZZZZZZZZZZZZ";
    constant T_index     : std_logic_vector(2 downto 0)  := "100";
    constant IH_index    : std_logic_vector(2 downto 0)  := "101";
    constant SP_index    : std_logic_vector(2 downto 0)  := "110";

    -- MUX control signals
    type WBSrcType is (WBSRrc_ALURes, WBSrc_Mem);
    type MemDataType is (MemData_Rx, MemData_Ry);
    type PCSrcType is (PCSrc_PC1, PCSrc_B, PCSrc_Rx_0, PCSrc_Rx_1, PCSrc_T_0, PCSrc_Rx, PCSrc_RA);
    type Op1SrcType is (Op1Src_Rx, Op1Src_Ry, Op1Src_SP, Op1Src_Imm, Op1Src_IH, Op1Src_PC1);
    type Op2SrcType is (Op2Src_Imm, Op2Src_Ry, Op2Src_0);
    type ForwardBType is (ForwardB_Un, ForwardB_WriteData, ForwardB_ALUout);
    type ForwardAType is (ForwardA_Un, ForwardA_WriteData, ForwardA_ALUout);
    type WBDstType is (WBDst_Rx, WBDst_Ry, WBDst_Rz, WBDst_SP, WBDst_IH, WBDst_T);

    -- Registers
    type IFRegsType is record
        PCSrc : PCSrcType;
    end record;
    type IDRegsType is record
        ImmExt  : ImmExtType;
        RAWrite : RAWriteType;
    end record;
    type EXRegsType is record
        Op1Src  : Op1SrcType;
        Op2Src  : Op2SrcType;
        WBDst   : WBDstType;
        ALUOp   : ALUOpType;
        MemData : MemDataType;
    end record;
    type MRegsType is record
        MemOp : MemOpType;
    end record;
    type WBRegsType is record
        WBSrc    : WBSrcType;
        WBEnable : WBEnableType;
    end record;
    type EX_M_WB_Data is record
        PC1   : std_logic_vector(15 downto 0);
        SP    : std_logic_vector(15 downto 0);
        IH    : std_logic_vector(15 downto 0);
        T     : std_logic;
        Rx    : std_logic_vector(15 downto 0);
        Ry    : std_logic_vector(15 downto 0);
        Imm   : std_logic_vector(15 downto 0);
        Rx_WB : std_logic_vector(2 downto 0);
        Ry_WB : std_logic_vector(2 downto 0);
        Rz_WB : std_logic_vector(2 downto 0);
    end record;
    type M_WB_Data is record
        ALURes  : std_logic_vector(15 downto 0);
        MemData : std_logic_vector(15 downto 0);
        WBDst   : std_logic_vector(2 downto 0);
    end record;
    type WB_Data is record
        MemData : std_logic_vector(15 downto 0);
        ALURes  : std_logic_vector(15 downto 0);
        WBDst   : std_logic_vector(2 downto 0);
    end record;
end common;
