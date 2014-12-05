library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
library work;
use work.common.all;

entity alu is
    port(
        Op1    : in  std_logic_vector(15 downto 0);
        Op2    : in  std_logic_vector(15 downto 0);
        ALUOp  : in  ALUOpType;
        ALURes : out std_logic_vector(15 downto 0)
        );
end alu;

architecture Behavioral of alu is
begin
    process (Op1, Op2, ALUOp)
        variable res : std_logic_vector(15 downto 0) := ZERO;
    begin
        case ALUOp is
            when ALUOp_Plus =>
                res := Op1 + Op2;
            when ALUOp_And =>
                res := Op1 and Op2;
            when ALUOp_Sub =>
                res := Op1 - Op2;
            when ALUOp_Or =>
                res := Op1 or Op2;
            when ALUOp_SLL =>
                res := to_stdlogicvector(to_bitvector(Op1) sll conv_integer(Op2));
            when ALUOp_SRA =>
                res := to_stdlogicvector(to_bitvector(Op1) sra conv_integer(Op2));
            when ALUOp_If_Less =>
                if (conv_integer(Op1) < conv_integer(Op2)) then
                    res := (others => '1');
                else
                    res := (others => '0');
                end if;
            when others =>
                null;
        end case;

        ALURes <= res;
    end process;

end Behavioral;
