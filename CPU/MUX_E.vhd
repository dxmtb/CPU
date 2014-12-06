library IEEE;
use IEEE.STD_LOGIC_1164.all;
library work;
use work.common.all;

entity MUX_E is
    port (
        Rx      : in  std_logic_vector (15 downto 0);
        Ry      : in  std_logic_vector (15 downto 0);
        MemData : in  MemDataType;
        Ret     : out std_logic_vector (15 downto 0)
        );
end MUX_E;

architecture Behaviour of MUX_E is
begin
    process(Rx, Ry, MemData)
    begin
        case MemData is
            when MemData_Rx =>
                Ret <= Rx;
            when MemData_Ry =>
                Ret <= Ry;
            when others =>
                Ret <= Rx;
                null;
        end case;
    end process;
end architecture;  -- Behaviour
