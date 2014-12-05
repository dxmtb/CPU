library IEEE;
use IEEE.STD_LOGIC_1164.all;
library work;
use work.common.all;

entity Equal is
    port(
        input1 : in  std_logic_vector(15 downto 0);
        input2 : in  std_logic_vector(15 downto 0);
        ret    : out std_logic
        );
end Equal;

architecture Behavioral of Equal is
begin
    if (input1 = input2) then
        ret <= '1';
    else
        ret <= '0';
    end if;
end Behavioral;

