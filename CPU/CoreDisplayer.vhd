library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.common.all;

entity CoreDisplayer is
    port (
        clk                                                        : in  std_logic;
        x_pos                                                      : in  XCoordinate;
        y_pos                                                      : in  YCoordinate;
        PC, SP, IH, reg0, reg1, reg2, reg3, reg4, reg5, reg6, reg7, INS : in  std_logic_vector(15 downto 0);
        T                                                          : in  std_logic;
        rgb                                                        : out std_logic
        ) ;
end entity;  -- CoreDisplayer

architecture arch of CoreDisplayer is

begin
    process(clk)
    begin
        if (rising_edge(clk)) then
            if y_pos >= 0 and y_pos < 40 then
                if x_pos >= 0 and x_pos < 40 then
                    rgb <= PC(15);
                elsif x_pos >= 40 and x_pos < 80 then
                    rgb <= PC(14);
                elsif x_pos >= 80 and x_pos < 120 then
                    rgb <= PC(13);
                elsif x_pos >= 120 and x_pos < 160 then
                    rgb <= PC(12);
                elsif x_pos >= 160 and x_pos < 200 then
                    rgb <= PC(11);
                elsif x_pos >= 200 and x_pos < 240 then
                    rgb <= PC(10);
                elsif x_pos >= 240 and x_pos < 280 then
                    rgb <= PC(9);
                elsif x_pos >= 280 and x_pos < 320 then
                    rgb <= PC(8);
                elsif x_pos >= 320 and x_pos < 360 then
                    rgb <= PC(7);
                elsif x_pos >= 360 and x_pos < 400 then
                    rgb <= PC(6);
                elsif x_pos >= 400 and x_pos < 440 then
                    rgb <= PC(5);
                elsif x_pos >= 440 and x_pos < 480 then
                    rgb <= PC(4);
                elsif x_pos >= 480 and x_pos < 520 then
                    rgb <= PC(3);
                elsif x_pos >= 520 and x_pos < 560 then
                    rgb <= PC(2);
                elsif x_pos >= 560 and x_pos < 600 then
                    rgb <= PC(1);
                elsif x_pos >= 600 and x_pos < 640 then
                    rgb <= PC(0);
                end if;
            elsif y_pos >= 40 and y_pos < 80 then
                if x_pos >= 0 and x_pos < 40 then
                    rgb <= SP(15);
                elsif x_pos >= 40 and x_pos < 80 then
                    rgb <= SP(14);
                elsif x_pos >= 80 and x_pos < 120 then
                    rgb <= SP(13);
                elsif x_pos >= 120 and x_pos < 160 then
                    rgb <= SP(12);
                elsif x_pos >= 160 and x_pos < 200 then
                    rgb <= SP(11);
                elsif x_pos >= 200 and x_pos < 240 then
                    rgb <= SP(10);
                elsif x_pos >= 240 and x_pos < 280 then
                    rgb <= SP(9);
                elsif x_pos >= 280 and x_pos < 320 then
                    rgb <= SP(8);
                elsif x_pos >= 320 and x_pos < 360 then
                    rgb <= SP(7);
                elsif x_pos >= 360 and x_pos < 400 then
                    rgb <= SP(6);
                elsif x_pos >= 400 and x_pos < 440 then
                    rgb <= SP(5);
                elsif x_pos >= 440 and x_pos < 480 then
                    rgb <= SP(4);
                elsif x_pos >= 480 and x_pos < 520 then
                    rgb <= SP(3);
                elsif x_pos >= 520 and x_pos < 560 then
                    rgb <= SP(2);
                elsif x_pos >= 560 and x_pos < 600 then
                    rgb <= SP(1);
                elsif x_pos >= 600 and x_pos < 640 then
                    rgb <= SP(0);
                end if;
            elsif y_pos >= 80 and y_pos < 120 then
                if x_pos >= 0 and x_pos < 40 then
                    rgb <= IH(15);
                elsif x_pos >= 40 and x_pos < 80 then
                    rgb <= IH(14);
                elsif x_pos >= 80 and x_pos < 120 then
                    rgb <= IH(13);
                elsif x_pos >= 120 and x_pos < 160 then
                    rgb <= IH(12);
                elsif x_pos >= 160 and x_pos < 200 then
                    rgb <= IH(11);
                elsif x_pos >= 200 and x_pos < 240 then
                    rgb <= IH(10);
                elsif x_pos >= 240 and x_pos < 280 then
                    rgb <= IH(9);
                elsif x_pos >= 280 and x_pos < 320 then
                    rgb <= IH(8);
                elsif x_pos >= 320 and x_pos < 360 then
                    rgb <= IH(7);
                elsif x_pos >= 360 and x_pos < 400 then
                    rgb <= IH(6);
                elsif x_pos >= 400 and x_pos < 440 then
                    rgb <= IH(5);
                elsif x_pos >= 440 and x_pos < 480 then
                    rgb <= IH(4);
                elsif x_pos >= 480 and x_pos < 520 then
                    rgb <= IH(3);
                elsif x_pos >= 520 and x_pos < 560 then
                    rgb <= IH(2);
                elsif x_pos >= 560 and x_pos < 600 then
                    rgb <= IH(1);
                elsif x_pos >= 600 and x_pos < 640 then
                    rgb <= IH(0);
                end if;
            elsif y_pos >= 120 and y_pos < 160 then
                if x_pos >= 0 and x_pos < 40 then
                    rgb <= reg0(15);
                elsif x_pos >= 40 and x_pos < 80 then
                    rgb <= reg0(14);
                elsif x_pos >= 80 and x_pos < 120 then
                    rgb <= reg0(13);
                elsif x_pos >= 120 and x_pos < 160 then
                    rgb <= reg0(12);
                elsif x_pos >= 160 and x_pos < 200 then
                    rgb <= reg0(11);
                elsif x_pos >= 200 and x_pos < 240 then
                    rgb <= reg0(10);
                elsif x_pos >= 240 and x_pos < 280 then
                    rgb <= reg0(9);
                elsif x_pos >= 280 and x_pos < 320 then
                    rgb <= reg0(8);
                elsif x_pos >= 320 and x_pos < 360 then
                    rgb <= reg0(7);
                elsif x_pos >= 360 and x_pos < 400 then
                    rgb <= reg0(6);
                elsif x_pos >= 400 and x_pos < 440 then
                    rgb <= reg0(5);
                elsif x_pos >= 440 and x_pos < 480 then
                    rgb <= reg0(4);
                elsif x_pos >= 480 and x_pos < 520 then
                    rgb <= reg0(3);
                elsif x_pos >= 520 and x_pos < 560 then
                    rgb <= reg0(2);
                elsif x_pos >= 560 and x_pos < 600 then
                    rgb <= reg0(1);
                elsif x_pos >= 600 and x_pos < 640 then
                    rgb <= reg0(0);
                end if;
            elsif y_pos >= 160 and y_pos < 200 then
                if x_pos >= 0 and x_pos < 40 then
                    rgb <= reg1(15);
                elsif x_pos >= 40 and x_pos < 80 then
                    rgb <= reg1(14);
                elsif x_pos >= 80 and x_pos < 120 then
                    rgb <= reg1(13);
                elsif x_pos >= 120 and x_pos < 160 then
                    rgb <= reg1(12);
                elsif x_pos >= 160 and x_pos < 200 then
                    rgb <= reg1(11);
                elsif x_pos >= 200 and x_pos < 240 then
                    rgb <= reg1(10);
                elsif x_pos >= 240 and x_pos < 280 then
                    rgb <= reg1(9);
                elsif x_pos >= 280 and x_pos < 320 then
                    rgb <= reg1(8);
                elsif x_pos >= 320 and x_pos < 360 then
                    rgb <= reg1(7);
                elsif x_pos >= 360 and x_pos < 400 then
                    rgb <= reg1(6);
                elsif x_pos >= 400 and x_pos < 440 then
                    rgb <= reg1(5);
                elsif x_pos >= 440 and x_pos < 480 then
                    rgb <= reg1(4);
                elsif x_pos >= 480 and x_pos < 520 then
                    rgb <= reg1(3);
                elsif x_pos >= 520 and x_pos < 560 then
                    rgb <= reg1(2);
                elsif x_pos >= 560 and x_pos < 600 then
                    rgb <= reg1(1);
                elsif x_pos >= 600 and x_pos < 640 then
                    rgb <= reg1(0);
                end if;
            elsif y_pos >= 200 and y_pos < 240 then
                if x_pos >= 0 and x_pos < 40 then
                    rgb <= reg2(15);
                elsif x_pos >= 40 and x_pos < 80 then
                    rgb <= reg2(14);
                elsif x_pos >= 80 and x_pos < 120 then
                    rgb <= reg2(13);
                elsif x_pos >= 120 and x_pos < 160 then
                    rgb <= reg2(12);
                elsif x_pos >= 160 and x_pos < 200 then
                    rgb <= reg2(11);
                elsif x_pos >= 200 and x_pos < 240 then
                    rgb <= reg2(10);
                elsif x_pos >= 240 and x_pos < 280 then
                    rgb <= reg2(9);
                elsif x_pos >= 280 and x_pos < 320 then
                    rgb <= reg2(8);
                elsif x_pos >= 320 and x_pos < 360 then
                    rgb <= reg2(7);
                elsif x_pos >= 360 and x_pos < 400 then
                    rgb <= reg2(6);
                elsif x_pos >= 400 and x_pos < 440 then
                    rgb <= reg2(5);
                elsif x_pos >= 440 and x_pos < 480 then
                    rgb <= reg2(4);
                elsif x_pos >= 480 and x_pos < 520 then
                    rgb <= reg2(3);
                elsif x_pos >= 520 and x_pos < 560 then
                    rgb <= reg2(2);
                elsif x_pos >= 560 and x_pos < 600 then
                    rgb <= reg2(1);
                elsif x_pos >= 600 and x_pos < 640 then
                    rgb <= reg2(0);
                end if;
            elsif y_pos >= 240 and y_pos < 280 then
                if x_pos >= 0 and x_pos < 40 then
                    rgb <= reg3(15);
                elsif x_pos >= 40 and x_pos < 80 then
                    rgb <= reg3(14);
                elsif x_pos >= 80 and x_pos < 120 then
                    rgb <= reg3(13);
                elsif x_pos >= 120 and x_pos < 160 then
                    rgb <= reg3(12);
                elsif x_pos >= 160 and x_pos < 200 then
                    rgb <= reg3(11);
                elsif x_pos >= 200 and x_pos < 240 then
                    rgb <= reg3(10);
                elsif x_pos >= 240 and x_pos < 280 then
                    rgb <= reg3(9);
                elsif x_pos >= 280 and x_pos < 320 then
                    rgb <= reg3(8);
                elsif x_pos >= 320 and x_pos < 360 then
                    rgb <= reg3(7);
                elsif x_pos >= 360 and x_pos < 400 then
                    rgb <= reg3(6);
                elsif x_pos >= 400 and x_pos < 440 then
                    rgb <= reg3(5);
                elsif x_pos >= 440 and x_pos < 480 then
                    rgb <= reg3(4);
                elsif x_pos >= 480 and x_pos < 520 then
                    rgb <= reg3(3);
                elsif x_pos >= 520 and x_pos < 560 then
                    rgb <= reg3(2);
                elsif x_pos >= 560 and x_pos < 600 then
                    rgb <= reg3(1);
                elsif x_pos >= 600 and x_pos < 640 then
                    rgb <= reg3(0);
                end if;
            elsif y_pos >= 280 and y_pos < 320 then
                if x_pos >= 0 and x_pos < 40 then
                    rgb <= reg4(15);
                elsif x_pos >= 40 and x_pos < 80 then
                    rgb <= reg4(14);
                elsif x_pos >= 80 and x_pos < 120 then
                    rgb <= reg4(13);
                elsif x_pos >= 120 and x_pos < 160 then
                    rgb <= reg4(12);
                elsif x_pos >= 160 and x_pos < 200 then
                    rgb <= reg4(11);
                elsif x_pos >= 200 and x_pos < 240 then
                    rgb <= reg4(10);
                elsif x_pos >= 240 and x_pos < 280 then
                    rgb <= reg4(9);
                elsif x_pos >= 280 and x_pos < 320 then
                    rgb <= reg4(8);
                elsif x_pos >= 320 and x_pos < 360 then
                    rgb <= reg4(7);
                elsif x_pos >= 360 and x_pos < 400 then
                    rgb <= reg4(6);
                elsif x_pos >= 400 and x_pos < 440 then
                    rgb <= reg4(5);
                elsif x_pos >= 440 and x_pos < 480 then
                    rgb <= reg4(4);
                elsif x_pos >= 480 and x_pos < 520 then
                    rgb <= reg4(3);
                elsif x_pos >= 520 and x_pos < 560 then
                    rgb <= reg4(2);
                elsif x_pos >= 560 and x_pos < 600 then
                    rgb <= reg4(1);
                elsif x_pos >= 600 and x_pos < 640 then
                    rgb <= reg4(0);
                end if;
            elsif y_pos >= 320 and y_pos < 360 then
                if x_pos >= 0 and x_pos < 40 then
                    rgb <= reg5(15);
                elsif x_pos >= 40 and x_pos < 80 then
                    rgb <= reg5(14);
                elsif x_pos >= 80 and x_pos < 120 then
                    rgb <= reg5(13);
                elsif x_pos >= 120 and x_pos < 160 then
                    rgb <= reg5(12);
                elsif x_pos >= 160 and x_pos < 200 then
                    rgb <= reg5(11);
                elsif x_pos >= 200 and x_pos < 240 then
                    rgb <= reg5(10);
                elsif x_pos >= 240 and x_pos < 280 then
                    rgb <= reg5(9);
                elsif x_pos >= 280 and x_pos < 320 then
                    rgb <= reg5(8);
                elsif x_pos >= 320 and x_pos < 360 then
                    rgb <= reg5(7);
                elsif x_pos >= 360 and x_pos < 400 then
                    rgb <= reg5(6);
                elsif x_pos >= 400 and x_pos < 440 then
                    rgb <= reg5(5);
                elsif x_pos >= 440 and x_pos < 480 then
                    rgb <= reg5(4);
                elsif x_pos >= 480 and x_pos < 520 then
                    rgb <= reg5(3);
                elsif x_pos >= 520 and x_pos < 560 then
                    rgb <= reg5(2);
                elsif x_pos >= 560 and x_pos < 600 then
                    rgb <= reg5(1);
                elsif x_pos >= 600 and x_pos < 640 then
                    rgb <= reg5(0);
                end if;
            elsif y_pos >= 360 and y_pos < 400 then
                if x_pos >= 0 and x_pos < 40 then
                    rgb <= reg6(15);
                elsif x_pos >= 40 and x_pos < 80 then
                    rgb <= reg6(14);
                elsif x_pos >= 80 and x_pos < 120 then
                    rgb <= reg6(13);
                elsif x_pos >= 120 and x_pos < 160 then
                    rgb <= reg6(12);
                elsif x_pos >= 160 and x_pos < 200 then
                    rgb <= reg6(11);
                elsif x_pos >= 200 and x_pos < 240 then
                    rgb <= reg6(10);
                elsif x_pos >= 240 and x_pos < 280 then
                    rgb <= reg6(9);
                elsif x_pos >= 280 and x_pos < 320 then
                    rgb <= reg6(8);
                elsif x_pos >= 320 and x_pos < 360 then
                    rgb <= reg6(7);
                elsif x_pos >= 360 and x_pos < 400 then
                    rgb <= reg6(6);
                elsif x_pos >= 400 and x_pos < 440 then
                    rgb <= reg6(5);
                elsif x_pos >= 440 and x_pos < 480 then
                    rgb <= reg6(4);
                elsif x_pos >= 480 and x_pos < 520 then
                    rgb <= reg6(3);
                elsif x_pos >= 520 and x_pos < 560 then
                    rgb <= reg6(2);
                elsif x_pos >= 560 and x_pos < 600 then
                    rgb <= reg6(1);
                elsif x_pos >= 600 and x_pos < 640 then
                    rgb <= reg6(0);
                end if;
            elsif y_pos >= 400 and y_pos < 440 then
                if x_pos >= 0 and x_pos < 40 then
                    rgb <= reg7(15);
                elsif x_pos >= 40 and x_pos < 80 then
                    rgb <= reg7(14);
                elsif x_pos >= 80 and x_pos < 120 then
                    rgb <= reg7(13);
                elsif x_pos >= 120 and x_pos < 160 then
                    rgb <= reg7(12);
                elsif x_pos >= 160 and x_pos < 200 then
                    rgb <= reg7(11);
                elsif x_pos >= 200 and x_pos < 240 then
                    rgb <= reg7(10);
                elsif x_pos >= 240 and x_pos < 280 then
                    rgb <= reg7(9);
                elsif x_pos >= 280 and x_pos < 320 then
                    rgb <= reg7(8);
                elsif x_pos >= 320 and x_pos < 360 then
                    rgb <= reg7(7);
                elsif x_pos >= 360 and x_pos < 400 then
                    rgb <= reg7(6);
                elsif x_pos >= 400 and x_pos < 440 then
                    rgb <= reg7(5);
                elsif x_pos >= 440 and x_pos < 480 then
                    rgb <= reg7(4);
                elsif x_pos >= 480 and x_pos < 520 then
                    rgb <= reg7(3);
                elsif x_pos >= 520 and x_pos < 560 then
                    rgb <= reg7(2);
                elsif x_pos >= 560 and x_pos < 600 then
                    rgb <= reg7(1);
                elsif x_pos >= 600 and x_pos < 640 then
                    rgb <= reg7(0);
                end if;
            elsif y_pos >= 440 and y_pos < 460 then
                if x_pos >= 0 and x_pos < 40 then
                    rgb <= INS(15);
                elsif x_pos >= 40 and x_pos < 80 then
                    rgb <= INS(14);
                elsif x_pos >= 80 and x_pos < 120 then
                    rgb <= INS(13);
                elsif x_pos >= 120 and x_pos < 160 then
                    rgb <= INS(12);
                elsif x_pos >= 160 and x_pos < 200 then
                    rgb <= INS(11);
                elsif x_pos >= 200 and x_pos < 240 then
                    rgb <= INS(10);
                elsif x_pos >= 240 and x_pos < 280 then
                    rgb <= INS(9);
                elsif x_pos >= 280 and x_pos < 320 then
                    rgb <= INS(8);
                elsif x_pos >= 320 and x_pos < 360 then
                    rgb <= INS(7);
                elsif x_pos >= 360 and x_pos < 400 then
                    rgb <= INS(6);
                elsif x_pos >= 400 and x_pos < 440 then
                    rgb <= INS(5);
                elsif x_pos >= 440 and x_pos < 480 then
                    rgb <= INS(4);
                elsif x_pos >= 480 and x_pos < 520 then
                    rgb <= INS(3);
                elsif x_pos >= 520 and x_pos < 560 then
                    rgb <= INS(2);
                elsif x_pos >= 560 and x_pos < 600 then
                    rgb <= INS(1);
                elsif x_pos >= 600 and x_pos < 640 then
                    rgb <= INS(0);
                end if;
            elsif y_pos >= 460 and y_pos < 480 then
                if x_pos >= 0 and x_pos < 40 then
                    rgb <= T;
                elsif x_pos >= 40 and x_pos < 80 then
                    rgb <= '0';
                elsif x_pos >= 80 and x_pos < 120 then
                    rgb <= '1';
                elsif x_pos >= 120 and x_pos < 160 then
                    rgb <= '0';
                elsif x_pos >= 160 and x_pos < 200 then
                    rgb <= '1';
                elsif x_pos >= 200 and x_pos < 240 then
                    rgb <= '0';
                elsif x_pos >= 240 and x_pos < 280 then
                    rgb <= '1';
                elsif x_pos >= 280 and x_pos < 320 then
                    rgb <= '0';
                elsif x_pos >= 320 and x_pos < 360 then
                    rgb <= '1';
                elsif x_pos >= 360 and x_pos < 400 then
                    rgb <= '0';
                elsif x_pos >= 400 and x_pos < 440 then
                    rgb <= '1';
                elsif x_pos >= 440 and x_pos < 480 then
                    rgb <= '0';
                elsif x_pos >= 480 and x_pos < 520 then
                    rgb <= '1';
                elsif x_pos >= 520 and x_pos < 560 then
                    rgb <= '0';
                elsif x_pos >= 560 and x_pos < 600 then
                    rgb <= '1';
                elsif x_pos >= 600 and x_pos < 640 then
                    rgb <= '0';
                end if;
            end if;
        end if;
    end process;

end architecture;  -- arch
