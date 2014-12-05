library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library work;
use work.common.ALL;

entity PC is
    Port ( PC_IN : in  STD_LOGIC_VECTOR (15 downto 0) := ZERO;
           WRITE_OR_NOT : in STD_LOGIC := '1';
           CLK : in STD_LOGIC;
           PC_OUT : out STD_LOGIC_VECTOR (15 downto 0) := ZERO;
           NEW_PC_OUT : out STD_LOGIC_VECTOR (15 downto 0) := ZERO
    );
end PC;

architecture Behavioral of PC_Register is
begin
    process (CLK)
    begin
        if (CLK'event and CLK = '1') then
            -- update pc value at up edge
            if (WRITE_OR_NOT = '1') then
                PC_OUT <= PC_IN;
                NEW_PC_OUT <= conv_std_logic_vector(CONV_INTEGER(PC_IN) + 1, 16);
            end if;
        end if;
    end process;
end Behavioral;

