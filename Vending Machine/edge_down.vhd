
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity edge_down is
	port (
		IN_i	: in std_logic;
		OUT_o	: out std_logic;		
		CLK_i 	: in std_logic
	);
end edge_down;

architecture behavioral of edge_down is

signal D_s	: std_logic;

begin

pOUT : process(CLK_i)
begin
	if (CLK_i'event and CLK_i='1') then
		D_s <= IN_i;
	end if;
end process;

OUT_o <= '1' when (IN_i='0' and D_s='1') else '0';


end behavioral; 