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

    signal ins_op       : std_logic_vector(4 downto 0);
    signal ins_10_8     : std_logic_vector(2 downto 0);
    signal ins_func_1   : std_logic_vector(1 downto 0);
    signal ins_func_4   : std_logic_vector(4 downto 0);
    signal ins_func_7   : std_logic_vector(7 downto 0);
    signal ins_func_7_5 : std_logic_vector(2 downto 0);

begin
    ins_op       <= INS(15 downto 11);
    ins_10_8     <= INS(10 downto 8);
    ins_func_1   <= INS(1 downto 0);
    ins_func_4   <= INS(4 downto 0);
    ins_func_7   <= INS(7 downto 0);
    ins_func_7_5 <= INS(7 downto 5);
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

        case ins_op is
            when INST_CODE_ADDIU =>
                RetIDRegs.ImmExt := ImmExt_Sign_7;
                RetEXRegs.Op1Src := Op1Src_Rx;
                RetEXRegs.Op2Src := Op2Src_Imm;
                RetEXRegs.WBDst  := WBDst_Rx;
                RetEXRegs.ALUOp  := ALUOp_Plus;
                RetWBRegs.WBSrc  := WBSrc_ALURes;
            when INST_CODE_ADDIU3 =>
                RetIDRegs.ImmExt := ImmExt_Sign_3;
                RetEXRegs.Op1Src := Op1Src_Rx;
                RetEXRegs.Op2Src := Op2Src_Imm;
                RetEXRegs.WBDst  := WBDst_Ry;
                RetEXRegs.ALUOp  := ALUOp_Plus;
                RetWBRegs.WBSrc  := WBSrc_ALURes;
            when INST_CODE_ADDSP_BTEQZ_MTSP =>
                case ins_10_8 is
                    when INST_RS_ADDSP =>
                        RetIDRegs.ImmExt := ImmExt_Sign_7;
                        RetEXRegs.Op1Src := Op1Src_SP;
                        RetEXRegs.Op2Src := Op2Src_Imm;
                        RetEXRegs.WBDst  := WBDst_SP;
                        RetEXRegs.ALUOp  := ALUOp_Plus;
                        RetWBRegs.WBSrc  := WBSrc_ALURes;
                    when INST_RS_BTEQZ =>
                        RetIFRegs.PCSrc  := PCSrc_T_0;
                        RetIDRegs.ImmExt := ImmExt_Sign_7;
                    when INST_RS_MTSP =>
                        RetEXRegs.Op1Src := Op1Src_Rx;
                        RetEXRegs.Op2Src := Op2Src_0;
                        RetEXRegs.WBDst  := WBDst_SP;
                        RetEXRegs.ALUOp  := ALUOp_Or;
                        RetWBRegs.WBSrc  := WBSrc_ALURes;
                    when others =>
                        null;
                end case;
            when INST_CODE_ADDU_SUBU =>
                case ins_func_1 is
                    when INST_FUNC_ADDU =>
                        RetEXRegs.Op1Src := Op1Src_Rx;
                        RetEXRegs.Op2Src := Op2Src_Ry;
                        RetEXRegs.WBDst  := WBDst_Rz;
                        RetEXRegs.ALUOp  := ALUOp_Plus;
                        RetWBRegs.WBSrc  := WBSrc_ALURes;
                    when INST_FUNC_SUBU =>
                        RetEXRegs.Op1Src := Op1Src_Rx;
                        RetEXRegs.Op2Src := Op2Src_Ry;
                        RetEXRegs.WBDst  := WBDst_Rz;
                        RetEXRegs.ALUOp  := ALUOp_Sub;
                        RetWBRegs.WBSrc  := WBSrc_ALURes;
                    when others =>
                        null;
                end case;
            when INST_CODE_AND_TO_SLT =>
                case ins_func_4 is
                    when INST_RD_FUNC_AND =>
                        RetEXRegs.Op1Src := Op1Src_Rx;
                        RetEXRegs.Op2Src := Op2Src_Ry;
                        RetEXRegs.WBDst  := WBDst_Rx;
                        RetEXRegs.ALUOp  := ALUOp_And;
                        RetWBRegs.WBSrc  := WBSrc_ALURes;
                    when INST_RD_FUNC_CMP =>
                        RetEXRegs.Op1Src := Op1Src_Rx;
                        RetEXRegs.Op2Src := Op2Src_Ry;
                        RetEXRegs.WBDst  := WBDst_T;
                        RetEXRegs.ALUOp  := ALUOp_Sub;
                        RetWBRegs.WBSrc  := WBSrc_ALURes;
                    when INST_RD_FUNC_JALR_JR_MFPC_JRRA =>
                        case ins_func_7_5 is
                            when INST_RT_JALR =>
                                RetIFRegs.PCSrc   := PCSrc_Rx;
                                RetIDRegs.RAWrite := RAWrite_Yes;
                            when INST_RT_JR =>
                                RetIFRegs.PCSrc := PCSrc_Rx;
                            when INST_RT_MFPC =>
                                RetEXRegs.Op1Src := Op1Src_PC1;
                                RetEXRegs.Op2Src := Op2Src_0;
                                RetEXRegs.WBDst  := WBDst_Rx;
                                RetEXRegs.ALUOp  := ALUOp_Or;
                                RetWBRegs.WBSrc  := WBSrc_ALURes;
                            when INST_RT_JRRA =>
                                RetIFRegs.PCSrc := PCSrc_RA;
                            when others => null;
                        end case;
                    when INST_RD_FUNC_OR =>
                        RetEXRegs.Op1Src := Op1Src_Rx;
                        RetEXRegs.Op2Src := Op2Src_Ry;
                        RetEXRegs.WBDst  := WBDst_Rx;
                        RetEXRegs.ALUOp  := ALUOp_Or;
                        RetWBRegs.WBSrc  := WBSrc_ALURes;
                    when INST_RD_FUNC_SLT =>
                        RetEXRegs.Op1Src := Op1Src_Rx;
                        RetEXRegs.Op2Src := Op2Src_Ry;
                        RetEXRegs.WBDst  := WBDst_T;
                        RetEXRegs.ALUOp  := ALUOp_If_Less;
                        RetWBRegs.WBSrc  := WBSrc_ALURes;
                    when others =>
                        null;
                end case;
            when INST_CODE_B =>
                RetIFRegs.PCSrc  := PCSrc_B;
                RetIDRegs.ImmExt := ImmExt_Sign_10;
            when INST_CODE_BEQZ =>
                RetIFRegs.PCSrc  := PCSrc_Rx_0;
                RetIDRegs.ImmExt := ImmExt_Sign_7;
            when INST_CODE_BNEZ =>
                RetIFRegs.PCSrc  := PCSrc_Rx_1;
                RetIDRegs.ImmExt := ImmExt_Sign_7;
            when INST_CODE_LI =>
                RetIDRegs.ImmExt := ImmExt_Zero_7;
                RetEXRegs.Op1Src := Op1Src_Imm;
                RetEXRegs.Op2Src := Op2Src_0;
                RetEXRegs.WBDst  := WBDst_Rx;
                RetEXRegs.ALUOp  := ALUOp_Or;
                RetWBRegs.WBSrc  := WBSrc_ALURes;
            when INST_CODE_LW =>
                RetIDRegs.ImmExt := ImmExt_Sign_4;
                RetEXRegs.Op1Src := Op1Src_Rx;
                RetEXRegs.Op2Src := Op2Src_Imm;
                RetEXRegs.WBDst  := WBDst_Ry;
                RetEXRegs.ALUOp  := ALUOp_Plus;
                RetMRegs.MemOp   := MemOp_Read;
                RetWBRegs.WBSrc  := WBSrc_Mem;
            when INST_CODE_LW_SP =>
                RetIDRegs.ImmExt := ImmExt_Sign_7;
                RetEXRegs.Op1Src := Op1Src_SP;
                RetEXRegs.Op2Src := Op2Src_Imm;
                RetEXRegs.WBDst  := WBDst_Rx;
                RetEXRegs.ALUOp  := ALUOp_Plus;
                RetMRegs.MemOp   := MemOp_Read;
                RetWBRegs.WBSrc  := WBSrc_Mem;
            when INST_CODE_MFIH_MTIH =>
                case ins_func_1 is
                    when INST_FUNC_MFIH =>
                        RetEXRegs.Op1Src := Op1Src_IH;
                        RetEXRegs.Op2Src := Op2Src_0;
                        RetEXRegs.WBDst  := WBDst_Rx;
                        RetEXRegs.ALUOp  := ALUOp_Or;
                        RetWBRegs.WBSrc  := WBSrc_ALURes;
                    when INST_FUNC_MTIH =>
                        RetEXRegs.Op1Src := Op1Src_Rx;
                        RetEXRegs.Op2Src := Op2Src_0;
                        RetEXRegs.WBDst  := WBDst_IH;
                        RetEXRegs.ALUOp  := ALUOp_Or;
                        RetWBRegs.WBSrc  := WBSrc_ALURes;
                    when others => null;
                end case;
            when INST_CODE_SLL_SRA =>
                case ins_func_1 is
                    when INST_FUNC_SLL =>
                        RetIDRegs.ImmExt := ImmExt_Shift_4_2;
                        RetEXRegs.Op1Src := Op1Src_Ry;
                        RetEXRegs.Op2Src := Op2Src_Imm;
                        RetEXRegs.WBDst  := WBDst_Rx;
                        RetEXRegs.ALUOp  := ALUOp_SLL;
                        RetWBRegs.WBSrc  := WBSrc_ALURes;
                    when INST_FUNC_SRA =>
                        RetIDRegs.ImmExt := ImmExt_Shift_4_2;
                        RetEXRegs.Op1Src := Op1Src_Ry;
                        RetEXRegs.Op2Src := Op2Src_Imm;
                        RetEXRegs.WBDst  := WBDst_Rx;
                        RetEXRegs.ALUOp  := ALUOp_SRA;
                        RetWBRegs.WBSrc  := WBSrc_ALURes;
                    when others => null;
                end case;
            when INST_CODE_SW =>
                RetIDRegs.ImmExt  := ImmExt_Sign_4;
                RetEXRegs.Op1Src  := Op1Src_Rx;
                RetEXRegs.Op2Src  := Op2Src_Imm;
                RetEXRegs.ALUOp   := ALUOp_Plus;
                RetEXRegs.MemData := MemData_Ry;
                RetMRegs.MemOp    := MemOp_Write;
            when INST_CODE_SW_SP =>
                RetIDRegs.ImmExt  := ImmExt_Sign_7;
                RetEXRegs.Op1Src  := Op1Src_SP;
                RetEXRegs.Op2Src  := Op2Src_Imm;
                RetEXRegs.ALUOp   := ALUOp_Plus;
                RetEXRegs.MemData := MemData_Rx;
                RetMRegs.MemOp    := MemOp_Write;
            when INST_CODE_CMPI =>
                RetIDRegs.ImmExt := ImmExt_Sign_7;
                RetEXRegs.Op1Src := Op1Src_Rx;
                RetEXRegs.Op2Src := Op2Src_Imm;
                RetEXRegs.WBDst  := WBDst_T;
                RetEXRegs.ALUOp  := ALUOp_Sub;
                RetWBRegs.WBSrc  := WBSrc_ALURes;
            when INST_CODE_MOVE =>
                RetEXRegs.Op1Src := Op1Src_Ry;
                RetEXRegs.Op2Src := Op2Src_0;
                RetEXRegs.WBDst  := WBDst_Rx;
                RetEXRegs.ALUOp  := ALUOp_Or;
                RetWBRegs.WBSrc  := WBSrc_ALURes;
            when others =>
                null;
        end case;
    end process;
end architecture;  -- arch
