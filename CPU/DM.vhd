library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned."<";
library work;
use work.common.all;
--use ieee.numeric.all;

entity DM is
    port (
        clk            : in    std_logic;
        memop          : in    MemOpType;
        dm_addr        : in    std_logic_vector(15 downto 0);
        dm_data_in     : in    std_logic_vector(15 downto 0);
        dm_data_out    : inout std_logic_vector(15 downto 0);
        ram1_addr      : out   std_logic_vector(17 downto 0);
        ram1_en        : out   std_logic := '1';
        ram1_we        : out   std_logic := '1';
        ram1_oe        : out   std_logic := '1';
        com_data_ready : in    std_logic;
        com_rdn        : out   std_logic := '1';
        com_wrn        : out   std_logic := '1';
        com_tbre       : in    std_logic;
        com_tsre       : in    std_logic;
        stop_clk        : out std_logic := '0';
        status_out        : out StatusType
        );
end DM;

architecture behavioral of DM is
    signal status : StatusType := Normal;
    signal cache : std_logic_vector(15 downto 0);
begin
    stop_clk <= '0' when status = Normal else '1';
	 status_out <= status;
    process (dm_addr)
    begin
        ram1_addr <= "00" & dm_addr;
    end process;
    process (clk)
    begin
        if (clk'event and clk = '0') then
            case Status is
                when Normal =>
                    case memop is
                        when memop_read =>
                            if (ieee.std_logic_unsigned."<"(dm_addr, im_dm_separation)) then
                                ram1_en <= '1';
                            elsif (dm_addr = com_status_addr) then
                                -- visit com status
                                ram1_en        <= '1';
                                dm_data_out(1) <= com_data_ready;
                                dm_data_out(0) <= com_tsre;
                            elsif (dm_addr = com_data_addr) then
                                -- visit com data
                                ram1_en     <= '1';
                                com_rdn     <= '0';
                                dm_data_out <= high_resist;
                            else
                                -- visti ram1
                                com_rdn     <= '1';
                                com_wrn     <= '1';
                                ram1_en     <= '0';
                                ram1_oe     <= '0';
                                dm_data_out <= high_resist;
                            end if;
                        when memop_write =>
                            if (ieee.std_logic_unsigned."<"(dm_addr, im_dm_separation)) then
                                ram1_en <= '1';
                            elsif (dm_addr = com_status_addr) then
                                -- never happen
                                ram1_en <= '1';
                            elsif (dm_addr = com_data_addr) then
                                -- visti com data
                                ram1_en <= '1';
                                ram1_we <= '1';
                                ram1_oe <= '1';
                                com_rdn <= '1';
                                com_wrn <= '1';
                                status <= Send1;
                                --com_wrn     <= '0';
                                --dm_data_out <= dm_data_in;
                                cache <= dm_data_in;
                            else
                                com_rdn     <= '1';
                                com_wrn     <= '1';
                                ram1_en     <= '0';
                                ram1_we     <= '0';
                                dm_data_out <= dm_data_in;
                            end if;
                        when others =>
                            ram1_en <= '1';
                    end case;
                if (clk = '1') then
                    ram1_en <= '1';
                    ram1_we <= '1';
                    ram1_oe <= '1';
                    com_rdn <= '1';
                    com_wrn <= '1';
                end if;
            when Send1 =>
                com_wrn <= '0';
                dm_data_out <= cache;
                status <= Send2;
            when Send2 =>
                com_wrn <= '1';
                status <= Send3;
            when Send3 =>
                if com_tbre = '1' then
                    status <= Normal;
                else
                    status <= Send3;
                end if;
            when others =>
                status <= Normal;
        end case;
    end if;
    end process;
end behavioral;
