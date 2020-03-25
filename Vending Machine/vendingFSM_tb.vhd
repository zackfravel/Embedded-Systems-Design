-- Zack Fravel    010646947

-- Embedded Systems Fall 2016
-- Vending Machine Testbench

library ieee;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all; 
use IEEE.std_logic_unsigned.all;

entity vendingFSM_tb is
end vendingFSM_tb;

architecture testbench of vendingFSM_tb is
							-- Declare Input Signals
	signal Clk	: std_logic := '0';
	signal Reset	: std_logic := '0';
	signal Nickle	: std_logic := '0';
	signal Dime	: std_logic := '0';
	signal Candy	: std_logic := '0';
	signal Cookie	: std_logic := '0';
	signal Coke	: std_logic := '0';
	signal Refund	: std_logic := '0';

begin

	Clk <= not Clk after 10 ns;

	tester : entity work.vendingFSM
		port map ( 
			clk => Clk,
			reset => Reset,
			nickle => Nickle,
			dime => Dime,
			candy_in => Candy,
			cookie_in => Cookie,
			coke_in => Coke, 
			refund_in => Refund
		);	

test : process
begin

	wait for 20 ns;

	Nickle <= '1';
	wait for 5 ns;	-- Insert Nickle
	Nickle <= '0';

	wait for 20 ns; -- Wait 20 ns

	Nickle <= '1';
	wait for 5 ns; 	-- Insert Nickle
	Nickle <= '0';

	wait for 20 ns;

	Dime <= '1';
	wait for 5 ns;	-- Insert Dime
	Dime <= '0';

	wait for 20 ns;

	Coke <= '1';
	wait for 10 ns;	-- Request Coke


	wait;		-- Wait forever

end process;

end testbench;