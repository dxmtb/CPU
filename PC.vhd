library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.std_logic_arith.all;
library work;
use work.common.all;

entity PC is
    port (PC_IN        : in  std_logic_vector (15 downto 0) := ZERO;
          WRITE_OR_NOT : in  std_logic                      := '1';
          CLK          : in  std_logic;
          PC_OUT       : out std_logic_vector (15 downto 0) := ZERO;
          NEW_PC_OUT   : out std_logic_vector (15 downto 0) := ZERO
          );
end PC;

architecture Behavioral of PC is
begin
    process (CLK)
    begin
        if (CLK'event and CLK = '1') then
            -- update pc value at up edge
            if (WRITE_OR_NOT = '1') then
                PC_OUT     <= PC_IN;
                NEW_PC_OUT <= conv_std_logic_vector(CONV_INTEGER(PC_IN) + 1, 16);
            end if;
        end if;
    end process;
end Behavioral;

