library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.common.all;

entity CPU is
    port (
        clk            : in    std_logic;
        RAM1_Addr      : out   std_logic_vector (17 downto 0);
        RAM1_EN        : out   std_logic;
        RAM1_WE        : out   std_logic;
        RAM1_OE        : out   std_logic;
        RAM1_Data      : inout std_logic_vector (15 downto 0);
        RAM2_Addr      : out   std_logic_vector (17 downto 0);
        RAM2_EN        : out   std_logic;
        RAM2_WE        : out   std_logic;
        RAM2_OE        : out   std_logic;
        RAM2_Data      : inout std_logic_vector (15 downto 0);
        com_data_ready : in    std_logic;
        com_rdn        : out   std_logic;
        com_tbre       : in    std_logic;
        com_tsre       : in    std_logic;
        com_wrn        : out   std_logic;
        LED            : out   std_logic_vector (15 downto 0) := "0101010101010101"
        );
end entity;  -- CPU

architecture arch of CPU is

--Controller.vhd
    component Controller is
        port (
            INS    : in  std_logic_vector(15 downto 0);
            IFRegs : out IFRegsType;
            IDRegs : out IDRegsType;
            EXRegs : out EXRegsType;
            MRegs  : out MRegsType;
            WBRegs : out WBRegsType
            ) ;
    end component;  -- Controller

--EX_M_WB_Registers.vhd
    component EX_M_WB_Registers is
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
            out_data   : out EX_M_WB_Data
            ) ;
    end component;  -- EX_WB_M_Registers

--Forward_Unit.vhd
    component Forward_Unit is
        port (  -- current instruction info, if use reg as alu src, conflict may exist
            CUR_RS_REG_NUM : in std_logic_vector (2 downto 0) := "ZZZ";
            CUR_RT_REG_NUM : in std_logic_vector (2 downto 0) := "ZZZ";
            Op1Src         : in Op1SrcType;
            Op2Src         : in Op2SrcType;

            -- last instruction info, if write regs, conflict may exist, if read DM, must stall
            LAST_WRITE_REG_OR_NOT : in std_logic                     := '0';
            LAST_WRITE_REG_TARGET : in std_logic_vector (2 downto 0) := "ZZZ";
            LAST_DM_READ_WRITE    : in MemOpType;

            -- last last instruction info, if write regs, conflict may exist
            LAST_LAST_WRITE_REG_OR_NOT : in std_logic                     := '0';
            LAST_LAST_WRITE_REG_TARGET : in std_logic_vector (2 downto 0) := "ZZZ";

            STALL_OR_NOT : out std_logic    := '0';
            ForwardA     : out ForwardAType := ForwardA_None;
            ForwardB     : out ForwardBType := ForwardB_None
            );
    end component;

--ID_Registers.vhd
    component ID_Registers is
        port (
            clk       : in  std_logic;
            in_PC1    : in  std_logic_vector(15 downto 0);
            in_INS    : in  std_logic_vector(15 downto 0);
            in_hazard : in  std_logic;
            out_PC1   : out std_logic_vector(15 downto 0);
            out_INS   : out std_logic_vector(15 downto 0)
            ) ;
    end component;

--MUX_A.vhd
    component MUX_A is
        port (Rx        : in  std_logic_vector (15 downto 0);
              Ry        : in  std_logic_vector (15 downto 0);
              SP        : in  std_logic_vector (15 downto 0);
              Imm       : in  std_logic_vector (15 downto 0);
              IH        : in  std_logic_vector (15 downto 0);
              PC1       : in  std_logic_vector (15 downto 0);
              WriteData : in  std_logic_vector (15 downto 0);
              ALUout    : in  std_logic_vector (15 downto 0);
              Op1Src    : in  Op1SrcType;
              ForwardA  : in  ForwardAType;
              Ret       : out std_logic_vector (15 downto 0)
              );
    end component;

--MUX_B.vhd
    component MUX_B is
        port (Imm       : in  std_logic_vector (15 downto 0);
              Ry        : in  std_logic_vector (15 downto 0);
              WriteData : in  std_logic_vector (15 downto 0);
              ALUout    : in  std_logic_vector (15 downto 0);
              Op2Src    : in  Op2SrcType;
              ForwardB  : in  ForwardBType;
              Ret       : out std_logic_vector (15 downto 0)
              );
    end component;

--MUX_C.vhd
    component MUX_C is
        port (Rx    : in  std_logic_vector (2 downto 0);
              Ry    : in  std_logic_vector (2 downto 0);
              Rz    : in  std_logic_vector (2 downto 0);
              WBDst : in  WBDstType;
              Ret   : out std_logic_vector (3 downto 0)
              );
    end component;

--MUX_D.vhd
    component MUX_D is
        port (ALURes : in  std_logic_vector (15 downto 0);
              Mem    : in  std_logic_vector (15 downto 0);
              WBSrc  : in  WBSrcType;
              Ret    : out std_logic_vector (15 downto 0)
              );
    end component;

--MUX_E.vhd
    component MUX_E is
        port (Rx      : in  std_logic_vector (15 downto 0);
              Ry      : in  std_logic_vector (15 downto 0);
              MemData : in  MemDataType;
              Ret     : out std_logic_vector (15 downto 0)
              );
    end component;

--MUX_PC.vhd
    component MUX_PC is
        port (PC1    : in  std_logic_vector (15 downto 0);
              RA     : in  std_logic_vector (15 downto 0);
              Branch : in  std_logic_vector (15 downto 0);
              Rx     : in  std_logic_vector (15 downto 0);
              PCSrc  : in  PCSrcType;
              Rx_0   : in  std_logic;
              T_0    : in  std_logic;
              Ret    : out std_logic_vector (15 downto 0)
              );
    end component;

--M_WB_Registers.vhd
    component M_WB_Registers is
        port (
            clk        : in  std_logic;
            in_MRegs   : in  MRegsType;
            in_WBRegs  : in  WBRegsType;
            in_data    : in  M_WB_Data;
            out_MRegs  : out MRegsType;
            out_WBRegs : out WBRegsType;
            out_data   : out M_WB_Data
            ) ;
    end component;

--RegisterGroup.vhd
    component RegisterGroup is
        port (
            clk          : in  std_logic;
            read_reg1    : in  std_logic_vector(2 downto 0);
            read_reg2    : in  std_logic_vector(2 downto 0);
            write_enable : in  WBEnableType;
            write_reg    : in  std_logic_vector(3 downto 0);
            write_data   : in  std_logic_vector(15 downto 0);
            reg1_data    : out std_logic_vector(15 downto 0);
            reg2_data    : out std_logic_vector(15 downto 0);
            regIH_out    : out std_logic_vector(15 downto 0);
            regSP_out    : out std_logic_vector(15 downto 0);
            regT_out     : out std_logic
            ) ;
    end component;  -- RegisterGroup

--SignExtend.vhd
    component SignExtend is
        port (
            imm_in  : in  std_logic_vector(10 downto 0);
            ImmExt  : in  ImmExtType;
            imm_out : out std_logic_vector(15 downto 0)
            ) ;
    end component;

--WB_Registers.vhd
    component WB_Registers is
        port (
            clk        : in  std_logic;
            in_WBRegs  : in  WBRegsType;
            in_data    : in  WB_Data;
            out_WBRegs : out WBRegsType;
            out_data   : out WB_Data
            ) ;
    end component;

--adder.vhd
    component adder is
        port(
            pc  : in  std_logic_vector(15 downto 0);
            imm : in  std_logic_vector(15 downto 0);
            res : out std_logic_vector(15 downto 0)
            );
    end component;

--alu.vhd
    component alu is
        port(
            Op1    : in  std_logic_vector(15 downto 0);
            Op2    : in  std_logic_vector(15 downto 0);
            ALUOp  : in  ALUOpType;
            ALURes : out std_logic_vector(15 downto 0)
            );
    end component;

    signal Controller_IFRegs            : IFRegsType;
    signal Controller_IDRegs            : IDRegsType;
    signal Controller_EXRegs            : EXRegsType;
    signal Controller_MRegs             : MRegsType;
    signal Controller_WBRegs            : WBRegsType;
    signal EX_M_WB_Registers_out_EXRegs : EXRegsType;
    signal EX_M_WB_Registers_out_MRegs  : MRegsType;
    signal EX_M_WB_Registers_out_WBRegs : WBRegsType;
    signal EX_M_WB_Registers_out_data   : EX_M_WB_Data;
    signal Forward_Unit_STALL_OR_NOT    : std_logic    := '0';
    signal Forward_Unit_ForwardA        : ForwardAType := ForwardA_None;
    signal Forward_Unit_ForwardB        : ForwardBType := ForwardB_None;
    signal ID_Registers_out_PC1         : std_logic_vector(15 downto 0);
    signal ID_Registers_out_INS         : std_logic_vector(15 downto 0);
    signal MUX_A_ALUout                 : std_logic_vector (15 downto 0);
    signal MUX_A_Ret                    : std_logic_vector (15 downto 0);
    signal MUX_B_ALUout                 : std_logic_vector (15 downto 0);
    signal MUX_B_Ret                    : std_logic_vector (15 downto 0);
    signal MUX_C_Ret                    : std_logic_vector (3 downto 0);
    signal MUX_D_Ret                    : std_logic_vector (15 downto 0);
    signal MUX_E_Ret                    : std_logic_vector (15 downto 0);
    signal MUX_PC_Ret                   : std_logic_vector (15 downto 0);
    signal M_WB_Registers_out_MRegs     : MRegsType;
    signal M_WB_Registers_out_WBRegs    : WBRegsType;
    signal M_WB_Registers_out_data      : M_WB_Data;
    signal RegisterGroup_reg1_data      : std_logic_vector(15 downto 0);
    signal RegisterGroup_reg2_data      : std_logic_vector(15 downto 0);
    signal RegisterGroup_regIH_out      : std_logic_vector(15 downto 0);
    signal RegisterGroup_regSP_out      : std_logic_vector(15 downto 0);
    signal RegisterGroup_regT_out       : std_logic;
    signal SignExtend_imm_out           : std_logic_vector(15 downto 0);
    signal WB_Registers_out_WBRegs      : WBRegsType;
    signal WB_Registers_out_data        : WB_Data;
    signal adder_res                    : std_logic_vector(15 downto 0);
    signal alu_ALURes                   : std_logic_vector(15 downto 0);

begin

--Controller.vhd
    One_Controller : Controller port map (
        INS    => ,
        IFRegs => Controller_IFRegs,
        IDRegs => Controller_IDRegs,
        EXRegs => Controller_EXRegs,
        MRegs  => Controller_MRegs,
        WBRegs => Controller_WBRegs
        );
--EX_M_WB_Registers.vhd
    One_EX_M_WB_Registers : EX_M_WB_Registers port map (
        clk        => ,
        force_nop  => ,
        in_EXRegs  => ,
        in_MRegs   => ,
        in_WBRegs  => ,
        in_data    => ,
        out_EXRegs => EX_M_WB_Registers_out_EXRegs,
        out_MRegs  => EX_M_WB_Registers_out_MRegs,
        out_WBRegs => EX_M_WB_Registers_out_WBRegs,
        out_data   => EX_M_WB_Registers_out_data
        );
--Forward_Unit.vhd
    One_Forward_Unit : Forward_Unit port map (
        CUR_RS_REG_NUM             => ,
        CUR_RT_REG_NUM             => ,
        Op1Src                     => ,
        Op2Src                     => ,
-- => ,
        LAST_WRITE_REG_OR_NOT      => ,
        LAST_WRITE_REG_TARGET      => ,
        LAST_DM_READ_WRITE         => ,
-- => ,
        LAST_LAST_WRITE_REG_OR_NOT => ,
        LAST_LAST_WRITE_REG_TARGET => ,
        STALL_OR_NOT               => Forward_Unit_STALL_OR_NOT,
        ForwardA                   => Forward_Unit_ForwardA,
        ForwardB                   => Forward_Unit_ForwardB
        );
--ID_Registers.vhd
    One_ID_Registers : ID_Registers port map (
        clk       => ,
        in_PC1    => ,
        in_INS    => ,
        in_hazard => ,
        out_PC1   => ID_Registers_out_PC1,
        out_INS   => ID_Registers_out_INS
        );
--MUX_A.vhd
    One_MUX_A : MUX_A port map (
        Ry        => ,
        SP        => ,
        Imm       => ,
        IH        => ,
        PC1       => ,
        WriteData => ,
        ALUout    => MUX_A_ALUout,
        Op1Src    => ,
        ForwardA  => ,
        Ret       => MUX_A_Ret
        );
--MUX_B.vhd
    One_MUX_B : MUX_B port map (
        Ry        => ,
        WriteData => ,
        ALUout    => MUX_B_ALUout,
        Op2Src    => ,
        ForwardB  => ,
        Ret       => MUX_B_Ret
        );
--MUX_C.vhd
    One_MUX_C : MUX_C port map (
        Ry    => ,
        Rz    => ,
        WBDst => ,
        Ret   => MUX_C_Ret
        );
--MUX_D.vhd
    One_MUX_D : MUX_D port map (
        Mem   => ,
        WBSrc => ,
        Ret   => MUX_D_Ret
        );
--MUX_E.vhd
    One_MUX_E : MUX_E port map (
        Ry      => ,
        MemData => ,
        Ret     => MUX_E_Ret
        );
--MUX_PC.vhd
    One_MUX_PC : MUX_PC port map (
        RA     => ,
        Branch => ,
        Rx     => ,
        PCSrc  => ,
        Rx_0   => ,
        T_0    => ,
        Ret    => MUX_PC_Ret
        );
--M_WB_Registers.vhd
    One_M_WB_Registers : M_WB_Registers port map (
        clk        => ,
        in_MRegs   => ,
        in_WBRegs  => ,
        in_data    => ,
        out_MRegs  => M_WB_Registers_out_MRegs,
        out_WBRegs => M_WB_Registers_out_WBRegs,
        out_data   => M_WB_Registers_out_data
        );
--RegisterGroup.vhd
    One_RegisterGroup : RegisterGroup port map (
        clk          => ,
        read_reg1    => ,
        read_reg2    => ,
        write_enable => ,
        write_reg    => ,
        write_data   => ,
        reg1_data    => RegisterGroup_reg1_data,
        reg2_data    => RegisterGroup_reg2_data,
        regIH_out    => RegisterGroup_regIH_out,
        regSP_out    => RegisterGroup_regSP_out,
        regT_out     => RegisterGroup_regT_out
        );
--SignExtend.vhd
    One_SignExtend : SignExtend port map (
        imm_in  => ,
        ImmExt  => ,
        imm_out => SignExtend_imm_out
        );
--WB_Registers.vhd
    One_WB_Registers : WB_Registers port map (
        clk        => ,
        in_WBRegs  => ,
        in_data    => ,
        out_WBRegs => WB_Registers_out_WBRegs,
        out_data   => WB_Registers_out_data
        );
--adder.vhd
    One_adder : adder port map (
        pc  => ,
        imm => ,
        res => adder_res
        );
--alu.vhd
    One_alu : alu port map (
        Op1    => ,
        Op2    => ,
        ALUOp  => ,
        ALURes => alu_ALURes
        );
end architecture;  -- arch
