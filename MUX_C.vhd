library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library work;
use work.common.ALL;

entity MUX_C is 
    Port ( Rx : in STD_LOGIC_VECTOR (2 downto 0);
           Ry : in STD_LOGIC_VECTOR (2 downto 0);
           Rz : in STD_LOGIC_VECTOR (2 downto 0);
           WBDst    : in WBDstType;
           Ret : out STD_LOGIC_VECTOR (15 downto 0)
    );
end MUX_C;

architecture Behaviour of MUX_C is
begin
    process(Rx, Ry, Rz, WBDst)
    begin
        case WBDst is
            when WBDst_Rx =>
                -- Zero extend
                Ret (2 downto 0) <= Rx;
                Ret (15 downto 3) <= "0000000000000";
            when WBDst_Ry =>
                -- Zero extend
                Ret (2 downto 0) <= Ry;
                Ret (15 downto 3) <= "0000000000000";
            when WBDst_Rz =>
                -- Zero extend
                Ret (2 downto 0) <= Rz;
                Ret (15 downto 3) <= "0000000000000";
            when WBDst_SP =>
                -- Zero extend
                Ret (2 downto 0) <= SP_index;
                Ret (15 downto 3) <= "0000000000000";
            when WBDst_T =>
                -- Zero extend
                Ret (2 downto 0) <= T_index;
                Ret (15 downto 3) <= "0000000000000";
            when WBDst_IH =>
                -- Zero extend
                Ret (2 downto 0) <= IH_index;
                Ret (15 downto 3) <= "0000000000000";
            when others =>
                Ret <= HIGH_RESIST;
        end case ;
    end process;
end architecture ; -- Behaviour
