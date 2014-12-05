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


--DM.vhd
    component DM is
        port (
            clk            : in    std_logic;
            memop          : in    MemOpType;
            dm_addr        : in    std_logic_vector(15 downto 0);
            dm_data_in     : in    std_logic_vector(15 downto 0);
            dm_data_out    : inout std_logic_vector(15 downto 0);
            ram1_addr      : out   std_logic_vector(17 downto 0);
            ram1_en        : out   std_logic := '1';
            ram1_we        : out   std_logic := '1';
            ram1_oe        : out   std_logic := '1';
            com_data_ready : in    std_logic;
            com_rdn        : out   std_logic := '1';
            com_wrn        : out   std_logic := '1';
            com_tbre       : in    std_logic;
            com_tsre       : in    std_logic);
    end component;

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


--Equal_Zero.vhd
    component Equal_Zero is
        port(
            input : in  std_logic_vector(15 downto 0);
            ret   : out std_logic
            );
    end component;

--Forward_Unit.vhd
    component Forward_Unit is
        port (
            op1src      : in  Op1SrcType;
            op2src      : in  Op2SrcType;
            rx          : in  std_logic_vector(2 downto 0);
            ry          : in  std_logic_vector(2 downto 0);
            wbregister1 : in  std_logic_vector(3 downto 0);
            wbsrc1      : in  WBSrcType;
            wbenable1   : in  WBEnableType;
            wbregister2 : in  std_logic_vector(3 downto 0);
            wbsrc2      : in  WBSrcType;
            wbenable2   : in  WBEnableType;
            forwarda    : out ForwardType := Forward_None;
            forwardb    : out ForwardType := Forward_None
            );
    end component;

--Hazard_detector.vhd
    component Hazard_Detector is
        port (
            wbenable   : in  WBEnableType;
            memop      : in  MemOpType;
            idrx       : in  std_logic_vector(2 downto 0);
            idry       : in  std_logic_vector(2 downto 0);
            wbregister : in  std_logic_vector(3 downto 0);
            exmwbclear : out std_logic := '0';
            idhold     : out std_logic := '0';
            pchold     : out std_logic := '0'
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


--IM.vhd
    component IM is
        port (clk         : in    std_logic;
              im_addr     : in    std_logic_vector(15 downto 0);
              im_data_out : inout std_logic_vector(15 downto 0) := high_resist;
              ram2_addr   : out   std_logic_vector(17 downto 0);
              ram2_en     : out   std_logic                     := '1';
              ram2_we     : out   std_logic                     := '1';
              ram2_oe     : out   std_logic                     := '1');
    end component;

--MUX_A.vhd
    component MUX_A is
        port (
            Rx        : in  std_logic_vector (15 downto 0);
            Ry        : in  std_logic_vector (15 downto 0);
            SP        : in  std_logic_vector (15 downto 0);
            Imm       : in  std_logic_vector (15 downto 0);
            IH        : in  std_logic_vector (15 downto 0);
            PC1       : in  std_logic_vector (15 downto 0);
            WriteData : in  std_logic_vector (15 downto 0);
            ALUout    : in  std_logic_vector (15 downto 0);
            Op1Src    : in  Op1SrcType;
            ForwardA  : in  ForwardType;
            Ret       : out std_logic_vector (15 downto 0)
            );
    end component;

--MUX_B.vhd
    component MUX_B is
        port (
            Imm       : in  std_logic_vector (15 downto 0);
            Ry        : in  std_logic_vector (15 downto 0);
            WriteData : in  std_logic_vector (15 downto 0);
            ALUout    : in  std_logic_vector (15 downto 0);
            Op2Src    : in  Op2SrcType;
            ForwardB  : in  ForwardType;
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
        port (
            ALURes : in  std_logic_vector (15 downto 0);
            Mem    : in  std_logic_vector (15 downto 0);
            WBSrc  : in  WBSrcType;
            Ret    : out std_logic_vector (15 downto 0)
            );
    end component;

--MUX_E.vhd
    component MUX_E is
        port (
            Rx      : in  std_logic_vector (15 downto 0);
            Ry      : in  std_logic_vector (15 downto 0);
            MemData : in  MemDataType;
            Ret     : out std_logic_vector (15 downto 0)
            );
    end component;

--MUX_PC.vhd
    component MUX_PC is
        port (
            PC1    : in  std_logic_vector (15 downto 0);
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


--PC.vhd
    component PC is
        port (
            PC_IN      : in  std_logic_vector (15 downto 0);
            pchold     : in  std_logic;
            CLK        : in  std_logic;
            PC_OUT     : out std_logic_vector (15 downto 0) := ZERO;
            NEW_PC_OUT : out std_logic_vector (15 downto 0) := ZERO
            );
    end component;

--RA.vhd
    component RA is
        port (
            clk        : in  std_logic;
            RAWrite    : in  RAWriteType;
            write_data : in  std_logic_vector(15 downto 0);
            RA         : out std_logic_vector(15 downto 0)
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
    end component;  -- RegisterGroup


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
    signal DM_dm_data_out               : std_logic_vector(15 downto 0);
    signal DM_ram1_addr                 : std_logic_vector(17 downto 0);
    signal DM_ram1_en                   : std_logic;
    signal DM_ram1_we                   : std_logic;
    signal DM_ram1_oe                   : std_logic;
    signal DM_com_rdn                   : std_logic;
    signal DM_com_wrn                   : std_logic;
    signal EX_M_WB_Registers_out_EXRegs : EXRegsType;
    signal EX_M_WB_Registers_out_MRegs  : MRegsType;
    signal EX_M_WB_Registers_out_WBRegs : WBRegsType;
    signal EX_M_WB_Registers_out_data   : EX_M_WB_Data;
    signal Equal_Zero_ret               : std_logic;
    signal Forward_Unit_forwarda        : ForwardType;
    signal Forward_Unit_forwardb        : ForwardType;
    signal Hazard_Detector_exmwbclear   : std_logic;
    signal Hazard_Detector_idhold       : std_logic;
    signal Hazard_Detector_pchold       : std_logic;
    signal ID_Registers_out_PC1         : std_logic_vector(15 downto 0);
    signal ID_Registers_out_INS         : std_logic_vector(15 downto 0);
    signal IM_im_data_out               : std_logic_vector(15 downto 0) := high_resist;
    signal IM_ram2_addr                 : std_logic_vector(17 downto 0);
    signal IM_ram2_en                   : std_logic;
    signal IM_ram2_we                   : std_logic;
    signal IM_ram2_oe                   : std_logic;
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
    signal PC_PC_OUT                    : std_logic_vector (15 downto 0);
    signal PC_NEW_PC_OUT                : std_logic_vector (15 downto 0);
    signal RA_RA                        : std_logic_vector(15 downto 0);
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

    signal EX_M_WB_Registers_in_data : EX_M_WB_Data;
    signal M_WB_Registers_in_data    : M_WB_Data;
    signal WB_Registers_in_data      : WB_Data;

    signal ID_Registers_out_Rx, ID_Registers_out_Ry, ID_Registers_out_Rz : std_logic_vector(2 downto 0);

    signal my_clk                     : std_logic;
    signal not_RegisterGroup_regT_out : std_logic;

begin
    ID_Registers_out_Rx <= ID_Registers_out_INS(10 downto 8);
    ID_Registers_out_Ry <= ID_Registers_out_INS(7 downto 5);
    ID_Registers_out_Rz <= ID_Registers_out_INS(4 downto 2);

    EX_M_WB_Registers_in_data.PC1   <= ID_Registers_out_PC1;
    EX_M_WB_Registers_in_data.SP    <= RegisterGroup_regSP_out;
    EX_M_WB_Registers_in_data.IH    <= RegisterGroup_regIH_out;
    EX_M_WB_Registers_in_data.T     <= RegisterGroup_regT_out;
    EX_M_WB_Registers_in_data.Rx    <= RegisterGroup_reg1_data;
    EX_M_WB_Registers_in_data.Ry    <= RegisterGroup_reg2_data;
    EX_M_WB_Registers_in_data.Imm   <= SignExtend_imm_out;
    EX_M_WB_Registers_in_data.Rx_WB <= ID_Registers_out_Rx;
    EX_M_WB_Registers_in_data.Ry_WB <= ID_Registers_out_Ry;
    EX_M_WB_Registers_in_data.Rz_WB <= ID_Registers_out_Rz;

    M_WB_Registers_in_data.ALURes  <= alu_ALURes;
    M_WB_Registers_in_data.MemData <= MUX_E_Ret;
    M_WB_Registers_in_data.WBDst   <= MUX_C_Ret;

    WB_Registers_in_data.ALURes  <= M_WB_Registers_out_data.ALURes;
    WB_Registers_in_data.MemData <= RAM1_Data;
    WB_Registers_in_data.WBDst   <= M_WB_Registers_out_data.WBDst;

    my_clk                     <= clk;
    not_RegisterGroup_regT_out <= not RegisterGroup_regT_out;

--DM.vhd
    One_DM : DM port map (
        clk            => clk,
        memop          => M_WB_Registers_out_MRegs.MemOp,
        dm_addr        => M_WB_Registers_out_data.ALURes,
        dm_data_in     => M_WB_Registers_out_data.MemData,
        dm_data_out    => RAM1_Data,
        ram1_addr      => DM_ram1_addr,
        ram1_en        => DM_ram1_en,
        ram1_we        => DM_ram1_we,
        ram1_oe        => DM_ram1_oe,
        com_data_ready => com_data_ready,
        com_rdn        => DM_com_rdn,
        com_wrn        => DM_com_wrn,
        com_tbre       => com_tbre,
        com_tsre       => com_tsre
        );
--IM.vhd
    One_IM : IM port map (
        clk         => clk,
        im_addr     => PC_PC_OUT,
        im_data_out => RAM2_Data,
        ram2_addr   => IM_ram2_addr,
        ram2_en     => IM_ram2_en,
        ram2_we     => IM_ram2_we,
        ram2_oe     => IM_ram2_oe
        );

--PC.vhd
    One_PC : PC port map (
        PC_IN      => MUX_PC_Ret,
        pchold     => Hazard_Detector_pchold,
        CLK        => clk,
        PC_OUT     => PC_PC_OUT,
        NEW_PC_OUT => PC_NEW_PC_OUT
        );
--RA.vhd
    One_RA : RA port map (
        clk        => clk,
        RAWrite    => Controller_IDRegs.RAWrite,
        write_data => ID_Registers_out_PC1,
        RA         => RA_RA
        );
--Hazard_detector.vhd
    One_Hazard_Detector : Hazard_Detector port map (
        wbenable   => EX_M_WB_Registers_out_WBRegs.WBEnable,
        memop      => EX_M_WB_Registers_out_MRegs.MemOp,
        idrx       => ID_Registers_out_Rx,
        idry       => ID_Registers_out_Ry,
        wbregister => MUX_C_Ret,
        exmwbclear => Hazard_Detector_exmwbclear,
        idhold     => Hazard_Detector_idhold,
        pchold     => Hazard_Detector_pchold
        );

--Controller.vhd
    One_Controller : Controller port map (
        INS    => ID_Registers_out_INS,
        IFRegs => Controller_IFRegs,
        IDRegs => Controller_IDRegs,
        EXRegs => Controller_EXRegs,
        MRegs  => Controller_MRegs,
        WBRegs => Controller_WBRegs
        );
--EX_M_WB_Registers.vhd
    One_EX_M_WB_Registers : EX_M_WB_Registers port map (
        clk        => my_clk,
        force_nop  => Hazard_Detector_exmwbclear,
        in_EXRegs  => Controller_EXRegs,
        in_MRegs   => Controller_MRegs,
        in_WBRegs  => Controller_WBRegs,
        in_data    => EX_M_WB_Registers_in_data,
        out_EXRegs => EX_M_WB_Registers_out_EXRegs,
        out_MRegs  => EX_M_WB_Registers_out_MRegs,
        out_WBRegs => EX_M_WB_Registers_out_WBRegs,
        out_data   => EX_M_WB_Registers_out_data
        );
--ID_Registers.vhd
    One_ID_Registers : ID_Registers port map (
        clk       => my_clk,
        in_PC1    => PC_NEW_PC_OUT,
        in_INS    => RAM2_Data,
        in_hazard => Hazard_Detector_idhold,
        out_PC1   => ID_Registers_out_PC1,
        out_INS   => ID_Registers_out_INS
        );
--MUX_A.vhd
    One_MUX_A : MUX_A port map (
        Rx        => EX_M_WB_Registers_in_data.Rx,
        Ry        => EX_M_WB_Registers_in_data.Ry,
        SP        => EX_M_WB_Registers_in_data.SP,
        Imm       => EX_M_WB_Registers_in_data.Imm,
        IH        => EX_M_WB_Registers_in_data.IH,
        PC1       => EX_M_WB_Registers_in_data.PC1,
        WriteData => MUX_D_Ret,
        ALUout    => M_WB_Registers_out_data.ALURes,
        Op1Src    => EX_M_WB_Registers_out_EXRegs.Op1Src,
        ForwardA  => Forward_Unit_forwarda,
        Ret       => MUX_A_Ret
        );
--MUX_B.vhd
    One_MUX_B : MUX_B port map (
        Imm       => EX_M_WB_Registers_out_data.Imm,
        Ry        => EX_M_WB_Registers_in_data.Ry,
        WriteData => MUX_D_Ret,
        ALUout    => M_WB_Registers_out_data.ALURes,
        Op2Src    => EX_M_WB_Registers_out_EXRegs.Op2Src,
        ForwardB  => Forward_Unit_forwardb,
        Ret       => MUX_B_Ret
        );
--MUX_C.vhd
    One_MUX_C : MUX_C port map (
        Rx    => EX_M_WB_Registers_in_data.Rx_WB,
        Ry    => EX_M_WB_Registers_in_data.Ry_WB,
        Rz    => EX_M_WB_Registers_in_data.Rz_WB,
        WBDst => EX_M_WB_Registers_out_EXRegs.WBDst,
        Ret   => MUX_C_Ret
        );
--MUX_D.vhd
    One_MUX_D : MUX_D port map (
        ALURes => WB_Registers_out_data.ALURes,
        Mem    => WB_Registers_out_data.MemData,
        WBSrc  => WB_Registers_out_WBRegs.WBSrc,
        Ret    => MUX_D_Ret
        );
--MUX_E.vhd
    One_MUX_E : MUX_E port map (
        Rx      => EX_M_WB_Registers_in_data.Rx,
        Ry      => EX_M_WB_Registers_in_data.Ry,
        MemData => Controller_EXRegs.MemData,
        Ret     => MUX_E_Ret
        );
--Equal_Zero.vhd
    One_Equal_Zero : Equal_Zero port map (
        input => RegisterGroup_reg1_data,
        ret   => Equal_Zero_ret
        );
--adder.vhd
    One_adder : adder port map (
                                   pc => ID_Registers_out_PC1,
                                   imm => SignExtend_imm_out,
                                   res => adder_res
                               );
--MUX_PC.vhd
    One_MUX_PC : MUX_PC port map (
        PC1    => PC_NEW_PC_OUT,
        RA     => RA_RA,
        Branch => adder_res,
        Rx     => RegisterGroup_reg1_data,
        PCSrc  => Controller_IFRegs.PCSrc,
        Rx_0   => Equal_Zero_ret,
        T_0    => not_RegisterGroup_regT_out,
        Ret    => MUX_PC_Ret
        );
--M_WB_Registers.vhd
    One_M_WB_Registers : M_WB_Registers port map (
        clk        => my_clk,
        in_MRegs   => Controller_MRegs,
        in_WBRegs  => Controller_WBRegs,
        in_data    => M_WB_Registers_in_data,
        out_MRegs  => M_WB_Registers_out_MRegs,
        out_WBRegs => M_WB_Registers_out_WBRegs,
        out_data   => M_WB_Registers_out_data
        );
--RegisterGroup.vhd
    One_RegisterGroup : RegisterGroup port map (
        clk          => clk,
        read_reg1    => ID_Registers_out_Rx,
        read_reg2    => ID_Registers_out_Ry,
        write_enable => WB_Registers_out_WBRegs.WBEnable,
        write_reg    => WB_Registers_out_data.WBDst,
        write_data   => MUX_D_Ret,
        reg1_data    => RegisterGroup_reg1_data,
        reg2_data    => RegisterGroup_reg2_data,
        regIH_out    => RegisterGroup_regIH_out,
        regSP_out    => RegisterGroup_regSP_out,
        regT_out     => RegisterGroup_regT_out
        );
--SignExtend.vhd
    One_SignExtend : SignExtend port map (
        imm_in  => ID_Registers_out_INS(10 downto 0),
        ImmExt  => Controller_IDRegs.ImmExt,
        imm_out => SignExtend_imm_out
        );
--WB_Registers.vhd
    One_WB_Registers : WB_Registers port map (
        clk        => clk,
        in_WBRegs  => M_WB_Registers_out_WBRegs,
        in_data    => WB_Registers_in_data,
        out_WBRegs => WB_Registers_out_WBRegs,
        out_data   => WB_Registers_out_data
        );
--alu.vhd
    One_alu : alu port map (
        Op1    => MUX_A_Ret,
        Op2    => MUX_B_Ret,
        ALUOp  => EX_M_WB_Registers_out_EXRegs.ALUOp,
        ALURes => alu_ALURes
        );
--Forward_Unit.vhd
    One_Forward_Unit : Forward_Unit port map (
        op1src      => EX_M_WB_Registers_out_EXRegs.Op1Src,
        op2src      => EX_M_WB_Registers_out_EXRegs.Op2Src,
        rx          => EX_M_WB_Registers_out_data.Rx_WB,
        ry          => EX_M_WB_Registers_out_data.Ry_WB,
        wbregister1 => M_WB_Registers_out_data.WBDst,
        wbsrc1      => M_WB_Registers_out_WBRegs.WBSrc,
        wbenable1   => M_WB_Registers_out_WBRegs.WBEnable,
        wbregister2 => WB_Registers_out_data.WBDst,
        wbsrc2      => WB_Registers_out_WBRegs.WBSrc,
        wbenable2   => WB_Registers_out_WBRegs.WBEnable,
        forwarda    => Forward_Unit_forwarda,
        forwardb    => Forward_Unit_forwardb
        );
end architecture;  -- arch
