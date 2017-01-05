library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity toplevel is
	port(
		clk: in  std_logic; -- 16 MHz
		rst: in  std_logic;
		sw:  in  std_logic_vector(7 downto 0);
		led: out std_logic_vector(7 downto 0)
	);
end toplevel;

architecture behavioral of toplevel is
	signal clkdiv: unsigned(23 downto 0);
	signal en:     std_logic;
	signal cntr1:  unsigned(3 downto 0);
	signal cntr2:  unsigned(2 downto 0);
begin

	-- orajeloszto
	en<='1' when (clkdiv=15_999_999) else '0';
	process(clk)
	begin
		if(clk'event and clk='1') then
			if(rst='1' or en='1') then
				clkdiv<=(others=>'0');
			else
				clkdiv<=clkdiv+1;
			end if;
		end if;
	end process;
	
	-- also digit
	process(clk)
	begin
		if(clk'event and clk='1') then
			if(rst='1') then
				cntr1<="0000";
			elsif(en='1') then
				if(sw(0)='1') then
					if(cntr1=0) then
						cntr1<="1001";
					else
						cntr1<=cntr1-1;
					end if;
				else
					if(cntr1=9) then
						cntr1<="0000";
					else
						cntr1<=cntr1+1;
					end if;
				end if;
			end if;
		end if;
	end process;

	-- felso digit
	process(clk)
	begin
		if(clk'event and clk='1') then
			if(rst='1') then
				cntr2<="000";
			elsif(en='1' and sw(0)='1' and cntr1=0) then
				if(cntr2=0) then
					cntr2<="101";
				else
					cntr2<=cntr2-1;
				end if;
			elsif(en='1' and sw(0)='0' and cntr1=9) then
				if(cntr2=5) then
					cntr2<="000";
				else
					cntr2<=cntr2+1;
				end if;
			end if;
		end if;
	end process;
	
	-- LED-ek meghajtasa
	led<='0' & std_logic_vector(cntr2) & std_logic_vector(cntr1);

end behavioral;
