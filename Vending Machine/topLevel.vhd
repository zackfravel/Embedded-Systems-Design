-- Zack Fravel    010646947

-- Embedded Systems Fall 2016
-- Vending Machine Module

library ieee;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all; 
use IEEE.std_logic_unsigned.all;

entity topLevel is 
	port (
		clk         : in std_logic;
		reset       : in std_logic;
		N_in        : in std_logic;
		D_in        : in std_logic;
		Candy_in    : in std_logic;
		Cookie_in   : in std_logic;
		Coke_in     : in std_logic;
		Refund_in   : in std_logic;
		Cash_out    : out std_logic_vector(13 downto 0);
		Choice_out  : out std_logic_vector(6 downto 0);
		Result_out  : out std_logic_vector(6 downto 0)
	);
end entity;



architecture behavioral of topLevel is

signal buttonOut : std_logic_vector(3 downto 0);
signal switchOut : std_logic_vector(17 downto 0);

signal choices : std_logic_vector(3 downto 0);
signal choiceOut : std_logic_vector(3 downto 0);

signal CashTemp : std_logic_vector(7 downto 0);
signal ChoiceTemp : std_logic_vector(3 downto 0);
signal ResultTemp : std_logic_vector(3 downto 0);

begin

choices <= not Candy_in & not Cookie_in & not Coke_in & not Refund_in;

choiceselection : process(clk, choices)
begin
	case choices is
		when "1000" => choiceOut <= "0001";
		when "0100" => choiceOut <= "0010";
		when "0010" => choiceOut <= "0011";
		when "0001" => choiceOut <= "0100";
		when others => choiceOut <= "0000";
	end case;
end process;
		
toInputCheck : entity work.input
		port map (
			CLK_i => clk,
			SW_i(0) => reset,
			SW_i(2) => N_in,
			SW_i(1) => D_in,
			KEY_i(3) => Candy_in,
			KEY_i(2) => Cookie_in,
			KEY_i(1) => Coke_in,
			KEY_i(0) => Refund_in,
			SW_i(17 downto 3) => "000000000000000",
			SW_o => switchOut,
			KEY_o => buttonOut
		);
		
toFSM : entity work.vendingFSM
		port map (
			clk    => clk,
			reset  => reset,
			nickle => switchOut(2),
			dime   => switchOut(1),
			candy_in => buttonOut(3),
			cookie_in => buttonOut(2),
			coke_in => buttonOut(1),
			refund_in => buttonOut(0),
			Cash => CashTemp,
			Choice => ChoiceTemp,
			Output => ResultTemp
		);
		
toLED : entity work.fourdisplay
	port map (
			clk_i => clk,
			switch_i(15 downto 12) => CashTemp(7 downto 4),
			switch_i(11 downto 8) => CashTemp(3 downto 0),
			switch_i(7 downto 4) => choiceOut,
			switch_i(3 downto 0) => ResultTemp,
			SSD3_o => Cash_out(13 downto 7),
			SSD2_o => Cash_out(6 downto 0),
			SSD1_o => Choice_out,
			SSD0_o => Result_out
		);

end behavioral;