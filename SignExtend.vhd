library ieee;
use ieee.std_logic_1164.all;
use work.common.all;

entity SignExtend is
    port (
        imm_in  : in  std_logic_vector(10 downto 0);
        ImmExt  : in  ImmExtType;
        imm_out : out std_logic_vector(15 downto 0)
        ) ;
end entity;  -- RegisterGroup

architecture arch of SignExtend is
begin
    process (imm_in, ImmExt)
    begin
        case ImmExt is
            when ImmExt_Sign_7 =>
                if imm_in(7) = '1' then
                    imm_out <= "11111111" & imm_in(7 downto 0);
                else
                    imm_out <= "00000000" & imm_in(7 downto 0);
                end if;
            when ImmExt_Sign_3 =>
                if imm_in(3) = '1' then
                    imm_out <= "111111111111" & imm_in(3 downto 0);
                else
                    imm_out <= "000000000000" & imm_in(3 downto 0);
                end if;
            when ImmExt_Sign_10 =>
                if imm_in(10) = '1' then
                    imm_out <= "11111" & imm_in(10 downto 0);
                else
                    imm_out <= "00000" & imm_in(10 downto 0);
                end if;
            when ImmExt_Sign_4 =>
                if imm_in(4) = '1' then
                    imm_out <= "11111111111" & imm_in(4 downto 0);
                else
                    imm_out <= "00000000000" & imm_in(4 downto 0);
                end if;
            when ImmExt_Shift_4_2 =>
                if imm_in(4 downto 2) = "000" then
                    imm_out <= "0000000000001000";
                else
                    imm_out <= "0000000000000" & imm_in(4 downto 2);
                end if;
            when ImmExt_Zero_7 =>
                imm_out <= "00000000" & imm_in(7 downto 0);
        end case;
    end process;
end architecture;  -- arch

