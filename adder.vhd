library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
library work;
use work.common.ALL;

entity adder is
	port(
		pc : in STD_LOGIC_VECTOR(15 downto 0);
		imm : in STD_LOGIC_VECTOR(15 downto 0);
		res : out STD_LOGIC_VECTOR(15 downto 0)
	);
end adder;

architecture Behavioral of adder is
begin
	res <= pc + imm;
end Behavioral;

