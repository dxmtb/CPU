library ieee;
use ieee.std_logic_1164.all;
library work;
use work.common.all;

entity Ram_Handler is
    port (
        clk            : in    std_logic;
        memop          : in    MemOpType;
        dm_addr        : in    std_logic_vector(15 downto 0);
        im_addr        : in    std_logic_vector(15 downto 0);
        data_in        : in    std_logic_vector(15 downto 0);
        ram1_data_out    : inout   std_logic_vector(15 downto 0);
        ram2_data_out    : inout   std_logic_vector(15 downto 0);
        dm_data_out     :  out std_logic_vector(15 downto 0);
        ram2_addr      : out   std_logic_vector(17 downto 0);
        ram1_en        : out   std_logic;
        ram1_we        : out   std_logic;
        ram1_oe        : out   std_logic;
        ram2_en        : out   std_logic := '1';
        ram2_we        : out   std_logic := '1';
        ram2_oe        : out   std_logic := '1';
        com_data_ready : in    std_logic;
        com_rdn        : out   std_logic := '1';
        com_wrn        : out   std_logic := '1';
        com_tbre       : in    std_logic;
        com_tsre       : in    std_logic;
        stop_clk       : out   std_logic := '0';
        status_out     : out   StatusType
        );
end Ram_Handler;

architecture behavioral of Ram_Handler is
    signal status : StatusType := Normal;
    signal cache  : std_logic_vector(15 downto 0);
begin
    ram1_en <= '1';
    ram1_we <= '1';
    ram1_oe <= '1';
    status_out <= status;
    stop_clk <= '0' when status = Normal else '1';
    process (im_addr, dm_addr, memop)
    begin
        if (memop = memop_none or (dm_addr = com_data_addr or dm_addr = com_status_addr)) then
            ram2_addr <= "00" & im_addr;
        else
            ram2_addr <= "00" & dm_addr;
        end if;
    end process;
    process (ram1_data_out, ram2_data_out, memop, dm_addr)
    begin
        if (memop = memop_read and dm_addr /= com_data_addr and dm_addr /= com_status_addr) then
            dm_data_out <= ram2_data_out;
        else
            dm_data_out <= ram1_data_out;
        end if;
    end process;

    process(clk, status)
    begin
        if (clk'event and clk = '0') then
            if (status = Normal and memop /= memop_write) or 
						(memop = memop_write and (dm_addr = com_status_addr or dm_addr = com_data_addr)) then
                ram2_en  <= '0';
                ram2_oe  <= '0';
                ram2_data_out <= high_resist;
            else
                    --write im/dm (ram2)
                ram2_en  <= '0';
                ram2_we  <= '0';
                ram2_data_out <= data_in;
            end if;
        end if;
        if (clk = '1') then
            if status = Normal then
                ram2_en <= '1';
                ram2_oe <= '1';
                ram2_we <= '1';
            end if;
        end if;
    end process;

    process (clk)
    begin
        if (clk'event and clk = '0') then
            case status is
                when Normal =>
                    case memop is
                        when memop_read =>
                            case dm_addr is
                                when com_status_addr =>
                                -- visit com status
                                    ram1_data_out(1) <= com_data_ready;
                                    ram1_data_out(0) <= com_tsre and com_tbre;
                                    com_rdn <= '1';
                                    com_wrn <= '1';
                                when com_data_addr =>
                                    -- visit com data
                                    ram1_data_out <= high_resist;
                                    com_rdn <= '0';
                                    com_wrn <= '1';
                                when others =>
                                    com_rdn <= '1';
                                    com_wrn <= '1';
                            end case;
                        when memop_write =>
                            if (dm_addr = com_data_addr) then
                                -- visti com data
                                com_rdn <= '1';
                                com_wrn <= '1';
                                status  <= Send1;
                                cache   <= data_in;
                            end if;
                        when memop_none =>
                            com_rdn <= '1';
                            com_wrn <= '1';
                    end case;
                when Send1 =>
                    com_rdn <= '1';
                    com_wrn  <= '0';
                    ram1_data_out <= cache;
                    status   <= Send2;
                when others =>
                    com_rdn <= '1';
                    com_wrn <= '1';
                    status  <= Normal;
            end case;
        end if;
    end process;
end behavioral;
