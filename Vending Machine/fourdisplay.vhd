library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity fourdisplay is
		port( 
			clk_i      : in  std_logic;
			switch_i  : in  std_logic_vector(15 downto 0);
			SSD0_o    : out std_logic_vector(6 downto 0);
			SSD1_o    : out std_logic_vector(6 downto 0);
			SSD2_o    : out std_logic_vector(6 downto 0);
			SSD3_o    : out std_logic_vector(6 downto 0)
		);
		
end fourdisplay; 

architecture behavioral of fourdisplay is

	signal mux_out : std_logic_vector(3 downto 0); 
	signal mux_en : std_logic_vector(1 downto 0);
	
	signal SSD_output : std_logic_vector(6 downto 0);
	
	signal SS0_out : std_logic_vector(6 downto 0);
	signal SS1_out : std_logic_vector(6 downto 0);
	signal SS2_out : std_logic_vector(6 downto 0);
	signal SS3_out : std_logic_vector(6 downto 0);

begin

	switch : process(clk_i, mux_en, switch_i)
	begin
	
		case mux_en is
			when "00" => mux_out <= switch_i(3 downto 0);
			when "01" => mux_out <= switch_i(7 downto 4);
			when "10" => mux_out <= switch_i(11 downto 8);
			when "11" => mux_out <= switch_i(15 downto 12);
		end case;
		

		
		if(clk_i'event and clk_i = '1') then
			mux_en <= mux_en + '1';
			case mux_en is 
				when "00" => SS0_out <= SSD_output;
				when "01" => SS1_out <= SSD_output;
				when "10" => SS2_out <= SSD_output;
				when "11" => SS3_out <= SSD_output;
			end case; 
		end if;
		
	end process;
	
	SSD0_o <= SS0_out;
	SSD1_o <= SS1_out;
	SSD2_o <= SS2_out;
	SSD3_o <= SS3_out;
	
	SSD : entity work.sevensegment
		PORT MAP(
			sw_i => mux_out,
			SSD_o => SSD_output
		);

end behavioral;