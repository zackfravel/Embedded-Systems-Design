-- Zack Fravel
-- Lab 5 (Top Level)

library ieee;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity Top is
   	port( 
		CLK_i : in std_logic;
		CLR_i : in std_logic;
		SW_i  : in std_logic_vector(15 downto 0);
		UART_RXD_i : in std_logic;
		UART_TXD_o : out std_logic;
		SSD_o : out std_logic_vector(27 downto 0)
	);

end Top;

architecture behavioral of Top is

	signal ADR_s   : std_logic_vector(31 downto 0);
	signal DAT_i_s : std_logic_vector(7 downto 0);
	signal DAT_o_s : std_logic_vector(7 downto 0);
	signal WE_s  :  std_logic;
	signal STB_s :  std_logic;
	signal CYC_s :  std_logic;
	signal ACK_s :  std_logic;

begin

-- connect uart2wb module

	UARTToWishBone : entity work.uart2wb
		port map(
		-- UART
      			UART_RXD_i => UART_RXD_i,
     			UART_TXD_o => UART_TXD_o,
      		-- Wishbone
     			WB_ADR_o  =>  ADR_s,
			WB_WDAT_o =>  DAT_i_s,
      			WB_RDAT_i =>  DAT_o_s,
      			WB_WE_o   =>  WE_s,
      			WB_STB_o  =>  STB_s,
      			WB_CYC_o  =>  CYC_s,
     			WB_ACK_i  =>  ACK_s,
      			WB_RTY_i  =>  '0',
     			WB_ERR_i  =>  '0',
     		-- Clocks
      			CLK_i  =>  CLK_i,
      			CLR_i  =>  CLR_i
		);

-- connect wb_regs module

	WishboneSlave : entity work.wb_regs
		port map(
		-- Switch inputs and SSD outputs
			SW_i     => SW_i,
			SSEG_0_o => SSD_o(6 downto 0),
			SSEG_1_o => SSD_o(13 downto 7),
			SSEG_2_o => SSD_o(20 downto 14),
			SSEG_3_o => SSD_o(27 downto 21),
		-- Wishbone interface (slave)
			WB_ADR_i => ADR_s,
			WB_DAT_i => DAT_i_s,
			WB_DAT_o => DAT_o_s,
			WB_WE_i  => WE_s,
			WB_STB_i => STB_s,
			WB_CYC_i => CYC_s,
			WB_ACK_o => ACK_s,
		-- Clock
			CLK_i => CLK_i
		);

end behavioral;