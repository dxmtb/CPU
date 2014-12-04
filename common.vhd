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
    type PCSrcType is (PCSrc_PC1, PCSrc_B, PCSrc_Rx_0, PCSrc_Rx_1, PCSrc_T_0, PCSrc_Rx, PCSrc_RA);
    type ImmExtType is (ImmExt_Sign_7, ImmExt_Sign_3, ImmExt_Sign_10, ImmExt_Sign4, ImmExt_Shift_4_2,
                        ImmExt_Zero_7);
    type RAWriteType is (RAWrite_Yes, RAWrite_No);
    type Op1SrcType is (Op1Src_Rx, Op1Src_Ry, Op1Src_SP, Op1Src_Imm, Op1Src_IH, Op1Src_PC1);
    type Op2SrcType is (Op2Src_Imm, Op2Src_Ry, Op2Src_0);
    type WBDstType is (WBDst_Rx, WBDst_Ry, WBDst_Rz, WBDst_SP, WBDst_IH, WBDst_T);
    type ALUOpType is (ALUOp_Plus, ALUOp_And, ALUOp_Sub, ALUOp_Or, ALUOp_SLL, ALUOp_SRA, ALUOp_If_Less);
    type MemDataType is (MemData_Rx, MemData_Ry);
    type MemOpType is (MemOp_Read, MemOp_Write);
    type WBSrcType is (WBSRrc_ALURes, WBSrc_Mem);
    type WBEnableType is (WBEnable_Yes, WBEnable_No);

    type ForwardBType is (ForwardB_Un, ForwardB_WriteData, ForwardB_ALUout);
    type ForwardAType is (ForwardA_Un, ForwardA_WriteData, ForwardA_ALUout);

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

    constant INST_CODE_ADDSP3 : std_logic_vector(4 downto 0) := "00000";

    constant INST_CODE_NOP : std_logic_vector(4 downto 0) := "00001";

    constant INST_CODE_B : std_logic_vector(4 downto 0) := "00010";

    constant INST_CODE_BEQZ : std_logic_vector(4 downto 0) := "00100";

    constant INST_CODE_BNEZ : std_logic_vector(4 downto 0) := "00101";

    constant INST_CODE_SLL_SRA : std_logic_vector(4 downto 0) := "00110";
    constant INST_FUNC_SLL     : std_logic_vector(1 downto 0) := "00";
    constant INST_FUNC_SRA     : std_logic_vector(1 downto 0) := "11";

    constant INST_CODE_ADDIU3 : std_logic_vector(4 downto 0) := "01000";

    constant INST_CODE_ADDIU : std_logic_vector(4 downto 0) := "01001";

    constant INST_CODE_ADDSP_BTEQZ_MTSP : std_logic_vector(4 downto 0) := "01100";
    constant INST_RS_ADDSP              : std_logic_vector(2 downto 0) := "011";
    constant INST_RS_BTEQZ              : std_logic_vector(2 downto 0) := "000";
    constant INST_RS_MTSP               : std_logic_vector(2 downto 0) := "100";

    constant INST_CODE_LI : std_logic_vector(4 downto 0) := "01101";

    constant INST_CODE_CMPI : std_logic_vector(4 downto 0) := "01110";

    constant INST_CODE_LW_SP : std_logic_vector(4 downto 0) := "10010";

    constant INST_CODE_LW : std_logic_vector(4 downto 0) := "10011";

    constant INST_CODE_SW_SP : std_logic_vector(4 downto 0) := "11010";

    constant INST_CODE_SW : std_logic_vector(4 downto 0) := "11011";

    constant INST_CODE_ADDU_SUBU : std_logic_vector(4 downto 0) := "11100";
    constant INST_FUNC_ADDU      : std_logic_vector(1 downto 0) := "01";
    constant INST_FUNC_SUBU      : std_logic_vector(1 downto 0) := "11";

    constant INST_CODE_AND_TO_SLT      : std_logic_vector(4 downto 0) := "11101";
    constant INST_RD_FUNC_AND          : std_logic_vector(4 downto 0) := "01100";
    constant INST_RD_FUNC_CMP          : std_logic_vector(4 downto 0) := "01010";
    constant INST_RD_FUNC_JALR_JR_MFPC : std_logic_vector(4 downto 0) := "00000";
    constant INST_RT_JALR              : std_logic_vector(2 downto 0) := "110";
    constant INST_RT_JR                : std_logic_vector(2 downto 0) := "000";
    constant INST_RT_MFPC              : std_logic_vector(2 downto 0) := "010";
    constant INST_RD_FUNC_NEG          : std_logic_vector(4 downto 0) := "01011";
    constant INST_RD_FUNC_OR           : std_logic_vector(4 downto 0) := "01101";
    constant INST_RD_FUNC_SLT          : std_logic_vector(4 downto 0) := "00010";

    constant INST_CODE_MFIH_MTIH : std_logic_vector(4 downto 0) := "11110";
    constant INST_FUNC_MFIH      : std_logic_vector(1 downto 0) := "00";
    constant INST_FUNC_MTIH      : std_logic_vector(1 downto 0) := "01";

end common;
