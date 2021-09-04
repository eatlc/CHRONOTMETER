
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity top is
generic(
c_clkfreq		:integer :=100_000_000
);
port(
clk				:in std_logic;
reset_i			:in std_logic;
start_i			:in std_logic;
seven_seg_o		:out std_logic_vector(11 downto 0)
--anodes_o		:out std_logic_vector(7 downto 0)
);
end top;

architecture Behavioral of top is

----------------------------------------------------
--Componentler:
----------------------------------------------------

--Debounce:
component debounce is
generic (
c_clkfreq	: integer := 100_000_000;
c_debtime	: integer := 1000;
c_initval	: std_logic	:= '0'
);
port (
clk			: in std_logic;
signal_i	: in std_logic;
signal_o	: out std_logic
);
end component;

--incrementor:
component bcd_incrementor is
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
end component;

--bcd sevenseg:
component bcd_to_sevensegment is
port(
bcd_i		:in std_logic_vector(3 downto 0);
seg_o		:out std_logic_vector(7 downto 0)
);
end component;


----------------------------------------------------
--Constantlar:
----------------------------------------------------
constant c_timer1mslim	:integer := c_clkfreq/1000;
constant c_saniyelim	:integer := c_clkfreq/1000000;
constant c_dakikalim	:integer := 60;

----------------------------------------------------
--Sinyaller:
----------------------------------------------------
signal saniye_increment			: std_logic := '0';
signal dakika_increment			: std_logic := '0';
signal start_deb				: std_logic := '0';
signal reset_deb				: std_logic := '0';
signal continue					: std_logic := '0';
signal start_deb_prev			: std_logic := '0';

signal saniye_birler		:std_logic_vector(3 downto 0):=(others=>'0');
signal saniye_onlar			:std_logic_vector(3 downto 0):=(others=>'0');
signal dakika_birler		:std_logic_vector(3 downto 0):=(others=>'0');
signal dakika_onlar			:std_logic_vector(3 downto 0):=(others=>'0');
signal saniye_birler_seg	:std_logic_vector(7 downto 0):=(others =>'1');
signal saniye_onlar_seg		:std_logic_vector(7 downto 0):=(others =>'1');
signal dakika_birler_seg	:std_logic_vector(7 downto 0):=(others =>'1');
signal dakika_onlar_seg		:std_logic_vector(7 downto 0):=(others =>'1');
signal segment				:std_logic_vector(7 downto 0):=(others =>'1');
signal anodes				:std_logic_vector(11 downto 0):=(others =>'1');

signal saniye_counter		:integer range 0 to c_saniyelim :=0;
signal dakika_counter		:integer range 0 to c_dakikalim :=0;

begin


--Debounce:-------------------------------
i_start_deb : debounce
generic map(
c_clkfreq	=> c_clkfreq,
c_debtime	=> 1000,
c_initval	=> '0'
)
port map(
clk			=> clk,
signal_i	=> start_i,
signal_o	=> start_deb
);

i_reset_deb : debounce
generic map(
c_clkfreq	=> c_clkfreq,
c_debtime	=> 1000,
c_initval	=> '0'
)
port map(
clk			=> clk,
signal_i	=> reset_i,
signal_o	=> reset_deb
);
----------------------------------------

--İncrementor:--------------------------
i_saniye_incrementor: bcd_incrementor
generic map( 
c_birlim		=>9,
c_onlarlim		=>5
)
port map(
clk				=> clk,
incr_i			=> saniye_increment,
reset_i			=> reset_deb,
birler_o		=> saniye_birler,
onlar_o			=> saniye_onlar
);

i_dakika_incrementor: bcd_incrementor
generic map( 
c_birlim		=>9,
c_onlarlim		=>5
)
port map(
clk				=> clk,
incr_i			=> saniye_increment,
reset_i			=> reset_deb,
birler_o		=> dakika_birler,
onlar_o			=> dakika_onlar
);

--Sevenseg:----------------------------
i_saniye_birler_seg : bcd_to_sevensegment
port map(
bcd_i		=> saniye_birler,
seg_o		=> saniye_birler_seg
);

i_saniye_onlar_seg: bcd_to_sevensegment
port map(
bcd_i		=> saniye_onlar,
seg_o		=> saniye_onlar_seg
);

i_dakika_birler_seg: bcd_to_sevensegment
port map(
bcd_i		=> dakika_birler,
seg_o		=> dakika_birler_seg
);

i_dakika_onlar_seg: bcd_to_sevensegment
port map(
bcd_i		=> dakika_onlar,
seg_o		=> dakika_onlar_seg
);


--MAİN-------------------------------------
P_Main: process(clk) begin
if(rising_edge(clk)) then
	
	start_deb_prev <= start_deb;
	
	if(start_deb ='1' and start_deb_prev ='0') then
		continue <= not continue;
	end if;
	
	saniye_increment<= '0';
	dakika_increment<='0';
	
	if(continue='1') then
		if(saniye_counter = c_saniyelim-1) then
			saniye_counter <=0;
			saniye_increment <='1';
			dakika_counter <= dakika_counter +1;
		else 
			saniye_counter <= saniye_counter + 1;
		end if;
		
		if(dakika_counter = c_dakikalim-1) then
			dakika_counter <=0;
			dakika_increment <='1';
		end if;
		
	end if;

	if(reset_deb = '1') then
	saniye_counter <=0;
	dakika_counter <=0;
	end if;
	
end if;
end process;

-------------------------------
P_anode: process (clk) begin
if(rising_edge(clk)) then


end if;
end process;

end Behavioral;
