library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library work;
use work.common.ALL;

entity MUX_D is 
    Port ( ALURes : in STD_LOGIC_VECTOR (15 downto 0);
           Mem    : in STD_LOGIC_VECTOR (15 downto 0);
           WBSrc  : in WBSrcType;
           Ret    : out STD_LOGIC_VECTOR (15 downto 0)
    );
end MUX_D;

architecture Behaviour of MUX_D is
begin
    process(ALURes, Mem, WBSrc)
    begin
        case WBSrc is
            when WBSRrc_ALURes =>
                Ret <= ALURes;
            when WBSrc_Mem =>
                Ret <= Mem;
            when others =>
                Ret <= HIGH_RESIST;
        end case;
    end process;
end architecture ; -- Behaviour
