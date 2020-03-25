-- Zack Fravel
-- Lab 4

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL; 

entity uart_rx is
	port (
		CLK_i 			: in  std_logic; 	-- 50 MHz clock
		RX_SERIAL_i 		: in  std_logic;
		RX_DATA_o 		: out std_logic_vector(7 downto 0);
		RX_DATA_VALID_o 	: out std_logic
	);
end uart_rx;

architecture behavioral of uart_rx is

	signal Pulse_s : std_logic := '0';					-- Pulse Signal
	signal CLK_c   : std_logic_vector(8 downto 0) := "000000000";   	-- Clock Counter (9 bits represent up to 512)
	signal bitCount : std_logic_vector(4 downto 0) := "00000";

	signal dataBuffer : std_logic_vector(7 downto 0); 

	type STATE is (Waiting, ReadByte, DisplayByte);

	signal current_state : STATE := Waiting;
-----------------------------------------------------------------------------------------------------------------------------------------------	
	begin

	nextState : process(CLK_i, RX_SERIAL_i)		-- Next State Logic
	begin
	   if (CLK_i'event and CLK_i = '1') then
		case current_state is	

			when Waiting =>

				CLK_c <= "000000000";
				bitCount <= "00000";

				if(RX_SERIAL_i = '0') then 
					current_state <= ReadByte;
				end if;

			when ReadByte =>

				Clk_c <= Clk_c + 1;			
				case CLK_C is
				   when "011011001" => Pulse_s <= '1'; 
						       CLK_c <= "000000000"; 
	   		  			       bitCount <= bitCount + 1; -- Incriment every 217 clock cycles
				   when others => Pulse_s <= '0';
				end case;
				
				if (bitCount = "10011") then
					current_state <= DisplayByte;
				end if;

			when DisplayByte => current_state <= Waiting;

		end case;
	   end if;
	end process;

	createOutputBuffer : process(CLK_i)
	begin
	   if (CLK_i'event and CLK_i = '1') then
		if(Pulse_s = '1' and bitCount(0) = '1' and bitCount < "10011") then
			dataBuffer <= RX_SERIAL_i & dataBuffer(7 downto 1);
		end if;
	   end if;
	end process;

	pOut : process(current_state, CLK_i)
	begin
	   if (CLK_i'event and CLK_i = '1') then
		case current_state is

			when Waiting =>     RX_DATA_VALID_o <= '0';

			when ReadByte =>    RX_DATA_VALID_o <= '0';

			when DisplayByte => RX_DATA_VALID_o <= '1';
 					    RX_DATA_o <= dataBuffer;
		end case;
	   end if;
	end process;

end behavioral;