library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity toplevel is
	port(
		clk: in  std_logic; -- 16 MHz
		rst: in  std_logic;
		led: out std_logic_vector(7 downto 0)
	);
end toplevel;

architecture behavioral of toplevel is
	signal clkdiv: unsigned(19 downto 0);
	signal en:     std_logic;
	signal shr:    std_logic_vector(7 downto 0);
	signal dir:    std_logic;
begin

	-- orajeloszto
	en<='1' when (clkdiv=999_999) else '0';
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
	
	-- iranyvaltas
	process(clk)
	begin
		if(clk'event and clk='1') then
			if(rst='1' or shr="00000001") then
				dir<='0';
			elsif(shr="10000000") then
				dir<='1';
			end if;
		end if;
	end process;

	-- leptetes
	process(clk)
	begin
		if(clk'event and clk='1') then
			if(rst='1') then
				shr<="00000001";
			elsif(en='1') then
				if(dir='1') then
					shr<='0' & shr(7 downto 1);
				else
					shr<=shr(6 downto 0) & '0';
				end if;
			end if;
		end if;
	end process;
	
	-- LED-ek meghajtasa
	led<=shr;

end behavioral;
