library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
library work;
use work.common.all;

entity adder is
    port(
        pc  : in  std_logic_vector(15 downto 0);
        imm : in  std_logic_vector(15 downto 0);
        res : out std_logic_vector(15 downto 0)
        );
end adder;

architecture Behavioral of adder is
begin
    res <= pc + imm;
end Behavioral;

