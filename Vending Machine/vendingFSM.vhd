-- Zack Fravel    010646947

-- Embedded Systems Fall 2016
-- Vending Machine Module

library ieee;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all; 
use IEEE.std_logic_unsigned.all;

entity vendingFSM is

	port (
		clk       : in std_logic;
		reset     : in std_logic;
		nickle    : in std_logic;
		dime      : in std_logic;
		coke_in   : in std_logic;			-- Inputs  [come from switches and buttons on the DEB2 board]
		cookie_in : in std_logic;
		candy_in  : in std_logic;
		refund_in : in std_logic;
		
		Cash   : out std_logic_vector(7 downto 0);
		Choice : out std_logic_vector(3 downto 0);	-- Outputs [to LED module input, each LED takes 4 bits for 16 configurations]
		Output : out std_logic_vector(3 downto 0)
	);

end vendingFSM;

architecture behavioral of vendingFSM is

-- Vending machine takes in a maximum of 20 cents and it's refund option is stricly for full amounts
-- Current design has the Cash on 2 displays, the choice on 1 display, and the output on the final display

-- Cash is represented in the amount of cents (0, 5, 10, 15, 20) with 20 also representing > 20

-- Choices are represented in the following way
	-- Candy   :  1
	-- Cookie  :  2
	-- Coke    :  3
	-- Refund  :  r (requires slight modification to LED module)
	-- Initial :  0/8 (or blank if possible to modify LED module)

-- Outputs are represented as
	-- Candy   :  A
	-- Cookie  :  B
	-- Coke    :  C
	-- Refund  :  r (requires slight modification to LED module)
	-- Invalid :  0/8 (or blank if possible to modify LED module)

-- State Declaration

type STATE is (Initial, Five, Ten, Fifteen, Twenty, Candy_out, Cookie_out, Coke_out, Refund_out);

signal current_state : STATE;
signal next_state : STATE;
signal choices : std_logic_vector(3 downto 0);

begin


choices <= candy_in & cookie_in & coke_in & refund_in;					-- Set Choices Signal


currentState : process(clk, reset)							-- Current State Transisition Process
begin		
								
	if(reset = '1') then
		current_state <= Initial;
	elsif(clk'event and clk = '1') then
		current_state <= next_state;
	end if;

end process;


nextState : process(clk, reset, nickle, dime, candy_in, cookie_in, coke_in, refund_in)	-- Next State Transition Process
begin

	case current_state is 

		when Initial =>
					if(nickle = '1') then
						next_state <= Five;
					elsif(dime = '1') then
						next_state <= Ten;
					else 
						next_state <= Initial;
					end if;
	--===============================
		when Five =>
					if(nickle = '1') then
						next_state <= Ten;
					elsif(dime = '1') then
						next_state <= Fifteen;
					elsif(candy_in = '1') then
						next_state <= Candy_out;
					elsif(refund_in = '1') then
						next_state <= Refund_out;
					else
						next_state <= Five;
					end if;
	--===============================
		when Ten =>
					if(nickle = '1') then
						next_state <= Fifteen;
					elsif(dime = '1') then
						next_state <= Twenty;

					elsif(candy_in = '1') then
						next_state <= Candy_out;
					elsif(refund_in = '1') then
						next_state <= Refund_out;
					else
						next_state <= Ten;
					end if;
	--===============================
		when Fifteen =>
					if(nickle = '1') then
						next_state <= Twenty;
					elsif(dime = '1') then
						next_state <= Twenty;

					elsif(candy_in = '1') then
						next_state <= Candy_out;
					elsif(cookie_in = '1') then
						next_state <= Cookie_out;
					elsif(refund_in = '1') then
						next_state <= Refund_out;
					else
						next_state <= Fifteen;
					end if;
	--===============================
		when Twenty =>
					if(candy_in = '1') then
						next_state <= Candy_out;
					elsif(cookie_in = '1') then
						next_state <= Cookie_out;
					elsif(coke_in = '1') then
						next_state <= Coke_out;
					elsif(refund_in = '1') then
						next_state <= Refund_out;
					else
						next_state <= Twenty;
					end if;
	--===============================
		when Candy_out =>

					next_state <= Initial;
	--===============================
		when Cookie_out =>

					next_state <= Initial;
	--===============================
		when Coke_out =>

					next_state <= Initial;
	--===============================
		when Refund_out =>

					next_state <= Initial;

	end case;

end process;
								

LEDoutputs : process(clk,reset)		-- Outputs Process
begin

	if (reset='1') then
				Cash <= "00000000";
				Choice <= "0000";
				Output <= "0000";
	elsif(clk'event and clk = '1') then
		case current_state is 
	--===============================
	
		when Initial => 			-- Blank Screens
				Cash <= "00000000";
				Choice <= "0000";
				--Output <= "0000"; 
	--===============================

		when Five => 				-- 5, choice, blank
				Cash <= "00000101";
	--===============================

		when Ten => 				-- 10, choice, blank
				Cash <= "00010000";
	--===============================

		when Fifteen => 			-- 15, choice, blank
				Cash <= "00010101";
	--===============================

		when Twenty => 				-- 20, choice, blank
				Cash <= "00100000";
	--===============================

		when Candy_out => 			-- Cash, 1, A
				Output <= "1010"; 
	--===============================

		when Cookie_out => 			-- Cash, 2, B
				Output <= "1011"; 
	--===============================

		when Coke_out => 			-- Cash, 3, C
				Output <= "1100"; 
	--===============================

		when Refund_out => 			-- Cash, r, F/r
				Output <= "1101"; 
	--===============================
		end case;

		case choices is 				-- Handle choice output
	--===============================

		when "1000" =>
				Choice <= "0010";	-- output 1
	--===============================

		when "0100" =>
				Choice <= "0011";	-- output 2
	--===============================

		when "0010" =>
				Choice <= "0100";	-- output 3
	--===============================

		when "0001" =>
				Choice <= "0101";	-- output 4
	--===============================
		when others => null;
	--===============================
		end case;
	end if;
end process;
											
	
end behavioral;