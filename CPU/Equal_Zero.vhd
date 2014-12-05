library IEEE;
use IEEE.STD_LOGIC_1164.all;
library work;
use work.common.all;

entity Equal_Zero is
    port(
        input : in  std_logic_vector(15 downto 0);
        ret   : out std_logic
        );
end Equal_Zero;

architecture Behavioral of Equal_Zero is
begin
    process(input)
    begin
        if (input = "0000000000000000") then
            ret <= '1';
        else
            ret <= '0';
        end if;
    end process;
end Behavioral;

