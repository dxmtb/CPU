library IEEE;
use IEEE.STD_LOGIC_1164.all;
library work;
use work.common.all;

entity MUX_B is
    port (Imm       : in  std_logic_vector (15 downto 0);
          Ry        : in  std_logic_vector (15 downto 0);
          WriteData : in  std_logic_vector (15 downto 0);
          ALUout    : in  std_logic_vector (15 downto 0);
          Op2Src    : in  Op2SrcType;
          ForwardB  : in  ForwardBType;
          Ret       : out std_logic_vector (15 downto 0)
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
end architecture;  -- Behaviour
