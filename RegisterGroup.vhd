library ieee ;
	use ieee.std_logic_1164.all ;
	use work.common.all;

entity RegisterGroup is
  port (
	clk : in std_logic;
	read_reg1 : in std_logic_vector(2 downto 0) ;
	read_reg2 : in std_logic_vector(2 downto 0) ;
	write_enable : in WBEnableType;
	write_reg : in std_logic_vector(3 downto 0);
	write_data : in std_logic_vector(15 downto 0) ;
	reg1_data : out  std_logic_vector(15 downto 0) ;
	reg2_data : out std_logic_vector(15 downto 0);
  regIH_out : out std_logic_vector(15 downto 0);
  regSP_out : out std_logic_vector(15 downto 0);
  regT_out : out std_logic
  ) ;
end entity ; -- RegisterGroup

architecture arch of RegisterGroup is
	
	subtype RegType is std_logic_vector(15 downto 0);
	signal reg0, reg1, reg2, reg3, reg4, reg5, reg6, reg7 : RegType;
	signal regIH, regSP : RegType;
  signal regT : std_logic;
begin
  regIH_out <= regIH;
  regSP_out <= regSP;
  regT_out <= regT;

	process (read_reg1)
	begin
		case read_reg1 is
			when "000" => reg1_data <= reg0;
			when "001" => reg1_data <= reg1;
			when "010" => reg1_data <= reg2;
			when "011" => reg1_data <= reg3;
			when "100" => reg1_data <= reg4;
			when "101" => reg1_data <= reg5;
			when "110" => reg1_data <= reg6;
			when "111" => reg1_data <= reg7;
      when others => null;
		end case;
	end process;

	process (read_reg2)
	begin
		case read_reg2 is
			when "000" => reg2_data <= reg0;
			when "001" => reg2_data <= reg1;
			when "010" => reg2_data <= reg2;
			when "011" => reg2_data <= reg3;
			when "100" => reg2_data <= reg4;
			when "101" => reg2_data <= reg5;
			when "110" => reg2_data <= reg6;
			when "111" => reg2_data <= reg7;
      when others => null;
		end case;
	end process;

  process (clk)
  begin
    if (rising_edge(clk) and write_enable = WBEnable_Yes) then
      case write_reg is
        when "0000" => reg0 <= write_data;
        when "0001" => reg1 <= write_data;
        when "0010" => reg2 <= write_data;
        when "0011" => reg3 <= write_data;
        when "0100" => reg4 <= write_data;
        when "0101" => reg5 <= write_data;
        when "0110" => reg6 <= write_data;
        when "0111" => reg7 <= write_data;
        when T_index => 
          if write_data = ZERO then
            regT <= '0';
          else
            regT <= '1';
          end if;
        when SP_index => regSP <= write_data;
        when IH_index => regIH <= write_data;
        when others => null;
      end case;
    end if;
  end process;

end architecture ; -- arch
