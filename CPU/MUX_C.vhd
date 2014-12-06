library IEEE;
use IEEE.STD_LOGIC_1164.all;
library work;
use work.common.all;

entity MUX_C is
    port (
        Rx    : in  std_logic_vector (2 downto 0);
        Ry    : in  std_logic_vector (2 downto 0);
        Rz    : in  std_logic_vector (2 downto 0);
        WBDst : in  WBDstType;
        Ret   : out std_logic_vector (3 downto 0)
        );
end MUX_C;

architecture Behaviour of MUX_C is
begin
    process(Rx, Ry, Rz, WBDst)
    begin
        case WBDst is
            when WBDst_Rx =>
                -- Zero extend
                Ret <= "0" & Rx;
            when WBDst_Ry =>
                -- Zero extend
                Ret  <= "0" & Ry;
            when WBDst_Rz =>
                -- Zero extend
                Ret  <= "0" & Rz;
            when WBDst_SP =>
                Ret <= SP_index;
            when WBDst_T =>
                Ret <= T_index;
            when WBDst_IH =>
                Ret <= IH_index;
            when others =>
              -- To avoid latch
                Ret <= (others => '0');
                null;
        end case;
    end process;
end architecture;  -- Behaviour
