library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library work;
use work.common.ALL;

entity MUX_B is 
    Port ( Imm : in STD_LOGIC_VECTOR (15 downto 0);
           Ry  : in STD_LOGIC_VECTOR (15 downto 0);
           WriteData : in STD_LOGIC_VECTOR (15 downto 0);
           ALUout    : in STD_LOGIC_VECTOR (15 downto 0);
           Op2Src    : in Op2SrcType;
           ForwardB  : in ForwardBType;
           Ret : out STD_LOGIC_VECTOR (15 downto 0)
    );
end MUX_B;

architecture Behaviour of MUX_B is
begin
    process(Imm, Ry, WriteData, ALUout, Op2Src, ForwardB)
    begin
        case ForwardB is
            when ForwardB_None =>
                case Op2Src is
                    when Op2Src_Imm =>
                        Ret <= Imm;
                    when Op2Src_Ry =>
                        Ret <= Ry;
                    when Op2Src_0 =>
                        Ret <= ZERO;
                    when others =>
                    Ret <= HIGH_RESIST;
                end case;
            when ForwardB_WriteData =>
                Ret <= WriteData;
            when ForwardB_ALUout =>
                Ret <= ALUout;
            when others =>
                Ret <= HIGH_RESIST;
        end case;
    end process;
end architecture ; -- Behaviour
