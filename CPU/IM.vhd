library IEEE;
use IEEE.STD_LOGIC_1164.all;
library work;
use work.common.all;
use IEEE.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.STD_LOGIC_ARITH.all;

entity IM is
    port (clk         : in    std_logic;
          im_addr     : in    std_logic_vector(15 downto 0);
          im_data_out : inout std_logic_vector(15 downto 0) := high_resist;
          ram2_addr   : out   std_logic_vector(17 downto 0);
          ram2_en     : out   std_logic                     := '1';
          ram2_we     : out   std_logic                     := '1';
          ram2_oe     : out   std_logic                     := '1');
end IM;

architecture behavioral of IM is
begin
    process (im_addr)
    begin
        ram2_addr <= "00" & im_addr;
    end process;
    process (clk)
    begin
        if (clk'event and clk = '0') then
            -- always read im (ram2)
            ram2_en     <= '0';
            ram2_oe     <= '0';
            ram2_we     <= '1';
            im_data_out <= high_resist;
        end if;
        if (clk = '1') then
            ram2_en <= '1';
            ram2_oe <= '1';
            ram2_we <= '1';
        end if;
    end process;
end behavioral;
