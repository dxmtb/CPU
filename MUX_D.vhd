library IEEE;
use IEEE.STD_LOGIC_1164.all;
library work;
use work.common.all;

entity MUX_D is
    port (ALURes : in  std_logic_vector (15 downto 0);
          Mem    : in  std_logic_vector (15 downto 0);
          WBSrc  : in  WBSrcType;
          Ret    : out std_logic_vector (15 downto 0)
          );
end MUX_D;

architecture Behaviour of MUX_D is
begin
    process(ALURes, Mem, WBSrc)
    begin
        case WBSrc is
            when WBSrc_ALURes =>
                Ret <= ALURes;
            when WBSrc_Mem =>
                Ret <= Mem;
            when others =>
                Ret <= HIGH_RESIST;
        end case;
    end process;
end architecture;  -- Behaviour
