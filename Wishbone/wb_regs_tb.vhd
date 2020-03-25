-- Zack Fravel
-- Lab 5 Wishbone

library ieee;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all; 
use IEEE.std_logic_unsigned.all;

entity wb_regs_tb is
end wb_regs_tb; 

architecture testbench of wb_regs_tb is 

	signal CLK_s : std_logic := '0';
	signal SW_s  : std_logic_vector(15 downto 0);
	
	signal SSEG0_s : std_logic_vector(6 downto 0);
	signal SSEG1_s : std_logic_vector(6 downto 0);
	signal SSEG2_s : std_logic_vector(6 downto 0);
	signal SSEG3_s : std_logic_vector(6 downto 0);
	
	signal	WB_ADR_s   : std_logic_vector(31 downto 0);
	signal	WB_DAT_i_s : std_logic_vector(7 downto 0);
	signal	WB_DAT_o_s : std_logic_vector(7 downto 0);
	signal	WB_WE_s    : std_logic;
	signal	WB_STB_s   : std_logic;
	signal	WB_CYC_s   : std_logic;
	signal	WB_ACK_s   : std_logic;

begin

	CLK_s <= not CLK_s after 10 ns;

	tb : process
	begin
		SW_s <= "0100001100100001";
		WB_CYC_s <= '0';
		WB_STB_s <= '0';
		WB_ADR_s <= x"00000000";
		WB_WE_s <= '0';
		
		wait for 30 ns;
		-- Read from address 0
		WB_ADR_s <= x"00000000";
		WB_WE_s <= '0';
		WB_CYC_s <= '1';
		WB_STB_s <= '1';
		wait until CLK_s'event and CLK_s='1' and WB_ACK_s='1';
		WB_CYC_s <= '0';
		WB_STB_s <= '0';
		wait for 100 ns;
		-- Read from address 1
		WB_ADR_s <= x"00000001";
		WB_WE_s <= '0';
		WB_CYC_s <= '1';
		WB_STB_s <= '1';
		wait until CLK_s'event and CLK_s='1' and WB_ACK_s='1';
		WB_CYC_s <= '0';
		WB_STB_s <= '0';
		wait for 100 ns;
		-- Read from address 2
		WB_ADR_s <= x"00000002";
		WB_WE_s <= '0';
		WB_CYC_s <= '1';
		WB_STB_s <= '1';
		wait until CLK_s'event and CLK_s='1' and WB_ACK_s='1';
		WB_CYC_s <= '0';
		WB_STB_s <= '0';
		wait for 100 ns;	
		-- Read from address 3
		WB_ADR_s <= x"00000003";
		WB_WE_s <= '0';
		WB_CYC_s <= '1';
		WB_STB_s <= '1';
		wait until CLK_s'event and CLK_s='1' and WB_ACK_s='1';
		WB_CYC_s <= '0';
		WB_STB_s <= '0';
		wait for 100 ns;
		-- Write x”0A” to address 4
		WB_ADR_s <= x"00000004";
		WB_DAT_o_s <= x"0A";
		WB_WE_s <= '1';
		WB_CYC_s <= '1';
		WB_STB_s <= '1';
		wait until CLK_s'event and CLK_s='1' and WB_ACK_s='1';
		WB_CYC_s <= '0';
		WB_STB_s <= '0';
		WB_WE_s <= '0'; 
		wait for 100 ns;
		-- Write x”0B to address 5
		WB_ADR_s <= x"00000005";
		WB_DAT_o_s <= x"0B";
		WB_WE_s <= '1';
		WB_CYC_s <= '1';
		WB_STB_s <= '1';
		wait until CLK_s'event and CLK_s='1' and WB_ACK_s='1';
		WB_CYC_s <= '0';
		WB_STB_s <= '0';
		WB_WE_s <= '0'; 
		wait for 100 ns;
		-- Write x”0C” to address 6
		WB_ADR_s <= x"00000006";
		WB_DAT_o_s <= x"0C";
		WB_WE_s <= '1';
		WB_CYC_s <= '1';
		WB_STB_s <= '1';
		wait until CLK_s'event and CLK_s='1' and WB_ACK_s='1';
		WB_CYC_s <= '0';
		WB_STB_s <= '0';
		WB_WE_s <= '0'; 
		wait for 100 ns;
		-- Write x”0D to address 7
		WB_ADR_s <= x"00000007";
		WB_DAT_o_s <= x"0D";
		WB_WE_s <= '1';
		WB_CYC_s <= '1';
		WB_STB_s <= '1';
		wait until CLK_s'event and CLK_s='1' and WB_ACK_s='1';
		WB_CYC_s <= '0';
		WB_STB_s <= '0';
		WB_WE_s <= '0'; 
		wait for 100 ns;

		wait for 100 ns;
		
	end process;
	
	connect : entity work.wb_regs
		port map (
			SW_i     => SW_s,
			SSEG_0_o => SSEG0_s,
			SSEG_1_o => SSEG1_s,
			SSEG_2_o => SSEG2_s,
			SSEG_3_o => SSEG3_s,
			WB_ADR_i => WB_ADR_s,
			WB_DAT_i => WB_DAT_o_s,
			WB_DAT_o => open,
			WB_WE_i  => WB_WE_s,
			WB_STB_i => WB_STB_s,
			WB_CYC_i => WB_CYC_s, 
			WB_ACK_o => WB_ACK_s,
			CLK_i    => CLK_s
		);

end testbench;