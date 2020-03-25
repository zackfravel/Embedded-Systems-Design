
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity debounce is
	generic (
		constant N_g	: integer := 5000000	-- Number of clock cycles to wait 
	);
	port (
		IN_i	: in std_logic;
		OUT_o	: out std_logic;		
		CLK_i 	: in std_logic;
		RST_i	: in std_logic
	);
end debounce;

architecture behavioral of debounce is

signal COUNTER_s	: std_logic_vector(31 downto 0);
signal D_s			: std_logic;
signal EDGE_s		: std_logic;

begin

uEDGE : entity work.edge_updown 
	port map (
		IN_i	=> IN_i,
		OUT_o	=> EDGE_s,
		CLK_i 	=> CLK_i
	);

pCNT : process(CLK_i,RST_i)
begin
	if (RST_i='1') then
		COUNTER_s <= (others=>'0');
	elsif (CLK_i'event and CLK_i='1') then
		if (EDGE_s='1') then
			COUNTER_s <= (others=>'0');
		elsif (COUNTER_s<N_g) then
			COUNTER_s <= COUNTER_s+'1';
		end if;			
	end if;
end process;

pOUT : process(CLK_i,RST_i)
begin
	if (RST_i='1') then
		D_s 	<= '0';
		OUT_o 	<= '0';
	elsif (CLK_i'event and CLK_i='1') then
		D_s	<= IN_i;
		if (COUNTER_s=N_g) then
			OUT_o	<= D_s;
		end if;			
	end if;
end process;


end behavioral; 