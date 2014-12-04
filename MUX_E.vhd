library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library work;
use work.common.ALL;

entity MUX_E is 
    Port ( Rx : in STD_LOGIC_VECTOR (15 downto 0);
           Ry : in STD_LOGIC_VECTOR (15 downto 0);
           MemData : in MemDataType;
           Ret    : out STD_LOGIC_VECTOR (15 downto 0)
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
                Ret <= HIGH_RESIST;
        end case;
    end process;
end architecture ; -- Behaviour
