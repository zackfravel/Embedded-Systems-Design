

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity input is
	generic (
		constant N_g	: integer := 1
	);
	port (
		SW_i	: in  std_logic_vector(17 downto 0);
		SW_o	: out std_logic_vector(17 downto 0);
		KEY_i	: in  std_logic_vector(3 downto 0);
		KEY_o	: out std_logic_vector(3 downto 0);	
		CLK_i 	: in std_logic
	);
end input;

architecture behavioral of input is

signal RST_CNT_s	: std_logic_vector(3 downto 0) := x"0";
signal RST_s		: std_logic;

signal DEB_s		: std_logic_vector(17 downto 0);

begin

pRST_CNT : process(CLK_i)
begin
	if (CLK_i'event and CLK_i='1') then
		if (RST_CNT_s/=(RST_CNT_s'range=>'1')) then
			RST_CNT_s <= RST_CNT_s+'1';
		end if;			
	end if;
end process;

RST_s <= '1' when (RST_CNT_s/=(RST_CNT_s'range=>'1')) else '0';

lblSW : for I in 0 to 17 generate
	uDEB : entity work.debounce
		generic map (
			N_g		=> N_g
		)
		port map (
			IN_i	=> SW_i(I),
			OUT_o	=> DEB_s(I),
			CLK_i 	=> CLK_i,
			RST_i	=> RST_s
		);
	
	uSW_EDGE : entity work.edge_up
		port map (
			IN_i	=> DEB_s(I),
			OUT_o	=> SW_o(I),
			CLK_i 	=> CLK_i
		);
end generate;


lblKEYS: for I in 0 to 3 generate	
	uKEYS_EDGE : entity work.edge_down
		port map (
			IN_i	=> KEY_i(I),
			OUT_o	=> KEY_o(I),
			CLK_i 	=> CLK_i
		);
end generate;




end behavioral; 