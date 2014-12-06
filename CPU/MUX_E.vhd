library IEEE;
use IEEE.STD_LOGIC_1164.all;
library work;
use work.common.all;

entity MUX_E is
    port (
        Rx             : in  std_logic_vector (15 downto 0);
        Ry             : in  std_logic_vector (15 downto 0);
        Data_From_M_WB : in  std_logic_vector(15 downto 0);
        Data_From_WB   : in  std_logic_vector(15 downto 0);
        MemData        : in  MemDataType;
        ForwardE       : in  ForwardType;
        Ret            : out std_logic_vector (15 downto 0)
        );
end MUX_E;

architecture Behaviour of MUX_E is
begin
    process(Rx, Ry, Data_From_M_WB, Data_From_WB, MemData)
    begin
        case ForwardE is
            when Forward_None =>
                case MemData is
                    when MemData_Rx =>
                        Ret <= Rx;
                    when MemData_Ry =>
                        Ret <= Ry;
                    when others =>
                        Ret <= Rx;
                        null;
                end case;
            when Forward_From_M_WB =>
                Ret <= Data_From_M_WB;
            when Forward_From_WB =>
                Ret <= Data_From_WB;
            when others =>
                Ret <= Rx;
        end case;
    end process;
end architecture;  -- Behaviour
