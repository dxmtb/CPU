library IEEE;
use IEEE.STD_LOGIC_1164.all;
library work;
use work.common.all;

entity MUX_PC is
    port (PC1    : in  std_logic_vector (15 downto 0);
          RA     : in  std_logic_vector (15 downto 0);
          Branch : in  std_logic_vector (15 downto 0);
          Rx     : in  std_logic_vector (15 downto 0);
          PCSrc  : in  PCSrcType;
          Rx_0   : in  std_logic;
          T_0    : in  std_logic;
          Ret    : out std_logic_vector (15 downto 0)
          );
end MUX_PC;

architecture Behaviour of MUX_PC is
begin
    process(PC1, RA, Branch, Rx, PCSrc, Rx_0, T_0)
    begin
        case PCSrc is
            when PCSrc_PC1 =>
                Ret <= PC1;
            when PCSrc_B =>
                Ret <= Branch;
            when PCSrc_Rx_0 =>
                if Rx_0 = '1' then
                    Ret <= Branch;
                else
                    Ret <= PC1;
                end if;
            when PCSrc_Rx_1 =>
                if Rx_0 = '0' then
                    Ret <= Branch;
                else
                    Ret <= PC1;
                end if;
            when PCSrc_T_0 =>
                if T_0 = '1' then
                    Ret <= Branch;
                else
                    Ret <= PC1;
                end if;
            when PCSrc_Rx =>
                Ret <= Rx;
            when PCSrc_RA =>
                Ret <= RA;
            when others =>
                Ret <= HIGH_RESIST;
        end case;
    end process;
end architecture;  -- Behaviour
