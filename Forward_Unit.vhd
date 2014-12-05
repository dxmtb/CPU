library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library work;
use work.common.ALL;

entity Forward_Unit is
    Port ( -- current instruction info, if use reg as alu src, conflict may exist
           CUR_RS_REG_NUM : in  STD_LOGIC_VECTOR (2 downto 0) := "ZZZ";
           CUR_RT_REG_NUM : in  STD_LOGIC_VECTOR (2 downto 0) := "ZZZ";
           Op1Src : in Op1SrcType;
           Op2Src : in Op2SrcType;
           
           -- last instruction info, if write regs, conflict may exist, if read DM, must stall
           LAST_WRITE_REG_OR_NOT : in  STD_LOGIC := '0';
           LAST_WRITE_REG_TARGET : in  STD_LOGIC_VECTOR (2 downto 0) := "ZZZ";
           LAST_DM_READ_WRITE : in MemOpType;
           
           -- last last instruction info, if write regs, conflict may exist
           LAST_LAST_WRITE_REG_OR_NOT : in  STD_LOGIC := '0';
           LAST_LAST_WRITE_REG_TARGET : in  STD_LOGIC_VECTOR (2 downto 0) := "ZZZ";
           
           STALL_OR_NOT : out  STD_LOGIC := '0';
           ForwardA : out ForwardAType := ForwardA_None;
           ForwardB : out ForwardBType := ForwardB_None
    );
end Forward_Unit;

architecture Behavior of Forward_Unit is

begin
    process(CUR_RS_REG_NUM, CUR_RT_REG_NUM, Op1Src, Op2Src, 
            LAST_WRITE_REG_OR_NOT, LAST_WRITE_REG_TARGET, LAST_DM_READ_WRITE,
            LAST_LAST_WRITE_REG_OR_NOT, LAST_LAST_WRITE_REG_TARGET)
    begin
        -- current instruction info, if use reg as alu src, conflict may exist
        if (Op1Src /= Op1Src_Imm and Op1Src /= Op1Src_PC1) or (Op2Src = Op2Src_Ry) then
            if (LAST_WRITE_REG_OR_NOT = '1' and LAST_DM_READ_WRITE = MemOp_Read) then
                -- A conflict, must stall
                if (LAST_WRITE_REG_TARGET = CUR_RS_REG_NUM) then
                    STALL_OR_NOT <= '1';
                    ForwardA <= ForwardA_None;
                    ForwardB <= ForwardB_None;
                -- B conflict, must stall
                elsif (LAST_WRITE_REG_TARGET = CUR_RT_REG_NUM) then
                    STALL_OR_NOT <= '1';
                    ForwardA <= ForwardA_None;
                    ForwardB <= ForwardB_None;
                else
                    STALL_OR_NOT <= '0';
                    ForwardA <= ForwardA_None;
                    ForwardB <= ForwardB_None;
                end if;             

            elsif (LAST_WRITE_REG_OR_NOT = '1') then
                -- A conflict, need not stall, select exe/mem reg value
                if (LAST_WRITE_REG_TARGET = CUR_RS_REG_NUM) then
                    STALL_OR_NOT <= '0';
                    ForwardA <= ForwardA_ALUout ;
                    ForwardB <= ForwardB_None;
                -- B conflict, need not stall, select exe/mem reg value
                elsif (LAST_WRITE_REG_TARGET = CUR_RT_REG_NUM) then
                    STALL_OR_NOT <= '0';
                    ForwardA <= ForwardA_None ;
                    ForwardB <= ForwardB_ALUout ;
                else
                    STALL_OR_NOT <= '0';
                    ForwardA <= ForwardA_None ;
                    ForwardB <= ForwardB_None ;
                end if;
            elsif (LAST_LAST_WRITE_REG_OR_NOT = '1') then
                -- A conflict, need not stall, select mem/wb reg value
                if (LAST_LAST_WRITE_REG_TARGET = CUR_RS_REG_NUM) then
                    STALL_OR_NOT <= '0';
                    ForwardA <= ForwardA_WriteData;
                    ForwardB <= ForwardB_None ;
                -- B conflict, need not stall, select mem/wb reg value
                elsif (LAST_LAST_WRITE_REG_TARGET = CUR_RT_REG_NUM) then
                    STALL_OR_NOT <= '0';
                    ForwardA <= ForwardA_None  ;
                    ForwardB <= ForwardB_WriteData  ;
                else
                    STALL_OR_NOT <= '0';
                    ForwardA <= ForwardA_None ;
                    ForwardB <= ForwardB_None ;
                end if;
            else
                STALL_OR_NOT <= '0';
                ForwardA <= ForwardA_None ;
                ForwardB <= ForwardB_None ;
            end if;
        else
            STALL_OR_NOT <= '0';
            ForwardA <= ForwardA_None ;
            ForwardB <= ForwardB_None ;
        end if;
    end process;
end Behavior;

