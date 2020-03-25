-- Zack Fravel
-- Lab 4

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL; 

entity uart_rx_tb is
end uart_rx_tb;

architecture testbench of uart_rx_tb is

	signal Clk 		: std_logic := '0';
	signal Serial_in 	: std_logic := '1';
	signal Data_out 	: std_logic_vector(7 downto 0);
	signal Data_valid 	: std_logic := '0';

begin

	Clk <= not Clk after 10 ns;			-- instantiate 50 MHz clk rate (20 ns period)
	
	tb : process 
	begin
	
		wait for 8680 ns; 			
		Serial_in <= '0';		-- START (sends 8'h65)
		wait for 8680 ns;
		Serial_in <= '1';		-- 0 (1)
		wait for 8680 ns; 			
		Serial_in <= '0';		-- 1 (0)
		wait for 8680 ns;
		Serial_in <= '1';		-- 2 (1)
		wait for 8680 ns; 			
		Serial_in <= '0';		-- 3 (0)
		wait for 8680 ns;
		Serial_in <= '0';		-- 4 (0)
		wait for 8680 ns; 			
		Serial_in <= '1';		-- 5 (1)
		wait for 8680 ns;
		Serial_in <= '1';		-- 6 (1)
		wait for 8680 ns; 			
		Serial_in <= '0';		-- 7 (0)
		wait for 8680 ns;
		Serial_in <= '1';		-- STOP

		wait for 26040 ns;
	
	end process; 
	
	connect : entity work.uart_rx
		port map(
			CLK_i => Clk,
			RX_SERIAL_i => Serial_in,
			RX_DATA_o => Data_out,
			RX_DATA_VALID_o => Data_valid
		);

end testbench;