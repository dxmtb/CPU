library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
library work;
use work.common.ALL;

entity alu is
	port(
		a : in STD_LOGIC_VECTOR(15 downto 0);
		b : in STD_LOGIC_VECTOR(15 downto 0);
		op : in STD_LOGIC_VECTOR(3 downto 0);

		zf : out STD_LOGIC;
		sf : out STD_LOGIC;
		c : out STD_LOGIC_VECTOR(15 downto 0)
	);
end alu;

architecture Behavioral of alu is
begin
	process (a, b, op)
		variable res : STD_LOGIC_VECTOR(15 downto 0) := ZERO;
	begin
		case op is
			when ALU_ADD =>
				res := a + b;
			when ALU_SUB =>
				res := a - b;
			when ALU_AND =>
				res := a and b;
			when ALU_OR =>
				res := a or b;
			when ALU_XOR =>
				res := a xor b;
			when ALU_NOT =>
				res := not(a);
			when ALU_SLL =>
				res := to_stdlogicvector(to_bitvector(a) sll conv_integer(b));
			when ALU_SRL =>
				res := to_stdlogicvector(to_bitvector(a) srl conv_integer(b));
			when ALU_SLA =>
				res := to_stdlogicvector(to_bitvector(a) sla conv_integer(b));
			when ALU_SRA =>
				res := to_stdlogicvector(to_bitvector(a) sra conv_integer(b));
			when ALU_ROL =>
				res := to_stdlogicvector(to_bitvector(a) rol conv_integer(b));
			when ALU_ROR =>
				res := to_stdlogicvector(to_bitvector(a) ror conv_integer(b));
			when ALU_NEG =>
				res := ZERO - a;
			when others =>
				NULL;
		end case;
			
		c <= res;
			
		if (res = ZERO) then
			zf <= ZF_TRUE;
			sf <= SF_FALSE;
		elsif (conv_integer(res) < 0) then
			zf <= ZF_FALSE;
			sf <= SF_TRUE;
		else
			zf <= ZF_FALSE;
			sf <= SF_FALSE;
		end if;
	end process;
end Behavioral;

