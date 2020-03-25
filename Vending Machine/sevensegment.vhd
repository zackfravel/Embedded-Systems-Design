library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity sevensegment is
		port( 
			sw_i  : in  std_logic_vector(3 downto 0);
			SSD_o : out std_logic_vector(6 downto 0)
		);
end sevensegment; 

architecture behavioral of sevensegment is 

	signal SSD_temp : std_logic_vector(6 downto 0);

begin

	switch : process (sw_i)
	begin 
			case sw_i is
				when "0000" => SSD_temp <= "1000000"; -- 0 	( 1 off : 0 on )
				when "0001" => SSD_temp <= "1111001"; -- 1
				when "0010" => SSD_temp <= "0100100"; -- 2
				when "0011" => SSD_temp <= "0110000"; -- 3
				when "0100" => SSD_temp <= "0011001"; -- 4
				when "0101" => SSD_temp <= "0010010"; -- 5 
				when "0110" => SSD_temp <= "0000010"; -- 6 
				when "0111" => SSD_temp <= "1111000"; -- 7 
				when "1000" => SSD_temp <= "0000000"; -- 8 
				when "1001" => SSD_temp <= "0011000"; -- 9 
				when "1010" => SSD_temp <= "0001000"; -- A 
				when "1011" => SSD_temp <= "0000011"; -- B 
				when "1100" => SSD_temp <= "1000110"; -- C 
				when "1101" => SSD_temp <= "0100001"; -- D 
				when "1110" => SSD_temp <= "0000110"; -- E 
				when others => SSD_temp <= "0001110"; -- F 
			end case; 
	end process;
	
	SSD_o <= SSD_temp;

end behavioral;