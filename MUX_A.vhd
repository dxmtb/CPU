library IEEE;
use IEEE.STD_LOGIC_1164.all;
library work;
use work.common.all;

entity MUX_A is
    port (Rx         : in  std_logic_vector (15 downto 0);
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
end MUX_A;

architecture Behaviour of MUX_A is
begin
    process(Rx, Ry, SP, Imm, IH, PC1, WriteData, ALUout, Op1Src, ForwardA)
    begin
        case ForwardA is
            when ForwardA_Un =>
                case Op1Src is
                    when Op1Src_Rx =>
                        Ret <= Rx;
                    when Op1Src_Ry =>
                        Ret <= Ry;
                    when Op1Src_SP =>
                        Ret <= SP;
                    when Op1Src_Imm =>
                        Ret <= Imm;
                    when Op1Src_IH =>
                        Ret <= IH;
                    when Op1Src_PC1 =>
                        Ret <= PC1;
                    when others =>
                        Ret <= HIGH_RESIST;
                end case;
            when ForwardA_WriteData =>
                Ret <= WriteData;
            when ForwardA_ALUout =>
                Ret <= ALUout;
            when others =>
                Ret <= HIGH_RESIST;
        end case;
    end process;
end architecture;  -- Behaviour
