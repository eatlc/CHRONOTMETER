library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity bcd_to_sevensegment is
port(
bcd_i		:in std_logic_vector(3 downto 0);
seg_o		:out std_logic_vector(7 downto 0)
);
end bcd_to_sevensegment;

architecture Behavioral of bcd_to_sevensegment is

begin
process (bcd_i) begin
	
	case bcd_i is
		
		when "0000" =>
			seg_o <= "11101011";
		
		when "0001" =>
			seg_o <= "00101000";
			
		when "0010" =>
			seg_o <= "10110011";
			
		when "0011" =>
			seg_o <= "10111010";
			
		when "0100" =>
			seg_o <= "01111000";
		
		when "0101" =>
			seg_o <= "11011010";
		
		when "0110" =>
			seg_o <= "11011011";
			
		when "0111" =>
			seg_o <= "10101000";
		
		when "1000" =>
			seg_o <= "11111011";
		
		when "1001" =>
			seg_o <= "11111010";
		
		when others =>
			seg_o <= "11111111";
	
	end case;
	
end process;
end Behavioral;
