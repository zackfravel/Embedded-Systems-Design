
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity input_tb is
end input_tb;

architecture testbench of input_tb is

signal CLK_s		: std_logic := '0';
signal SW_s		: std_logic_vector(17 downto 0);
signal KEY_s		: std_logic_vector(3 downto 0);


begin

CLK_s <= not CLK_s after 10 ns;

pDUT : process
begin
	SW_s 	<= (others=>'0');
	KEY_s	<= (others=>'0');

	lblIT_SW : for I in 0 to 17 loop
		SW_s(I) <= '0';
		wait for 1 us;

		SW_s(I) <= '1';
		wait for 30 ns;
		SW_s(I) <= '0';
		wait for 50 ns;
		SW_s(I) <= '1';
		wait for 40 ns;
		SW_s(I) <= '0';
		wait for 40 ns;
		SW_s(I) <= '1';
		wait for 100 ns;
		SW_s(I) <= '0';
		wait for 75 ns;
		SW_s(I) <= '1';

		wait for 600 ns;

		SW_s(I) <= '0';
		wait for 10 ns;
		SW_s(I) <= '1';
		wait for 30 ns;
		SW_s(I) <= '0';
		wait for 50 ns;
		SW_s(I) <= '1';
		wait for 40 ns;
		SW_s(I) <= '0';
		wait for 40 ns;
		SW_s(I) <= '1';
		wait for 100 ns;
		SW_s(I) <= '0';
		wait for 200 ns;
	end loop;

	lblIT_KEY : for I in 0 to 3 loop
		KEY_s(I) <= '1';
		wait for 50 ns;
		KEY_s(I) <= '0';
		wait for 50 ns;
	end loop;


	wait;
end process;


uINPUT : entity work.input
	generic map (
		N_g => 15
	)
	port map (
		SW_i	=> SW_s,
		SW_o	=> open,
		KEY_i	=> KEY_s,
		KEY_o	=> open,
		CLK_i 	=> CLK_s
	);




end testbench; 