library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity bcd_incrementor is
generic(
c_birlim		:integer :=9;
c_onlarlim		:integer :=9
);
port(
clk			:in std_logic;
incr_i			:in std_logic;
reset_i			:in std_logic;
birler_o		:out std_logic_vector(3 downto 0);
onlar_o			:out std_logic_vector(3 downto 0)
);
end bcd_incrementor;

architecture Behavioral of bcd_incrementor is

signal s_birler : std_logic_vector(3 downto 0) :=(others=>'0');
signal s_onlar  : std_logic_vector(3 downto 0) :=(others=>'0');

begin

process (clk) begin
if (rising_edge(clk)) then
	if(incr_i = '1') then
	
		if(s_birler = c_birlim) then
		
			if(s_onlar =c_onlarlim) then
				s_onlar <= x"0";
				s_birler <= x"0";
			else 
				s_birler <= x"0";
				s_onlar <= s_onlar + 1;
			end if;
			
		else 
			s_birler <= s_birler +1;
		end if;
		
		
		if(reset_i = '1') then
			s_onlar <= x"0";
			s_birler <= x"0";
		end if;
		
	end if;
end if;
end process;
birler_o <= s_birler;
onlar_o <= s_onlar;

end Behavioral;
