-- Zack Fravel
-- Lab 5 (Wishbone Slave)

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL; 

entity wb_regs is
 port (
	-- Switch inputs and SSD outputs
		SW_i : in std_logic_vector(15 downto 0);
		SSEG_0_o : out std_logic_vector(6 downto 0);
		SSEG_1_o : out std_logic_vector(6 downto 0);
		SSEG_2_o : out std_logic_vector(6 downto 0);
		SSEG_3_o : out std_logic_vector(6 downto 0);
	-- Wishbone interface (slave)
		WB_ADR_i : in std_logic_vector(31 downto 0);
		WB_DAT_i : in std_logic_vector(7 downto 0);
		WB_DAT_o : out std_logic_vector(7 downto 0);
		WB_WE_i  : in std_logic;
		WB_STB_i : in std_logic;
		WB_CYC_i : in std_logic;
		WB_ACK_o : out std_logic;
	-- Clock
		CLK_i    : in std_logic
	);
end wb_regs; 

architecture behavioral of wb_regs is

	signal SSDreg1 : std_logic_vector(7 downto 0) := "00000000";
	signal SSDreg2 : std_logic_vector(7 downto 0) := "00000000";
	signal SSDreg3 : std_logic_vector(7 downto 0) := "00000000";
	signal SSDreg4 : std_logic_vector(7 downto 0) := "00000000";

	signal tempAck : std_logic;

begin

	process(CLK_i)
	begin
		if(CLK_i'event and CLK_i = '1') then

		   tempAck <= '0';

 			if(WB_STB_i = '1' and WB_CYC_i = '1' and WB_WE_i = '0') then -- Read
			   tempAck <= '1';
			   case WB_ADR_i is
				when x"00000000" => WB_DAT_o  <= "0000" & SW_i(3 downto 0);
				when x"00000001" => WB_DAT_o  <= "0000" & SW_i(7 downto 4);
				when x"00000002" => WB_DAT_o  <= "0000" & SW_i(11 downto 8);
				when x"00000003" => WB_DAT_o  <= "0000" & SW_i(15 downto 12);
				when x"00000004" => WB_DAT_o  <= SSDreg1;
				when x"00000005" => WB_DAT_o  <= SSDreg2;
				when x"00000006" => WB_DAT_o  <= SSDreg3;
				when x"00000007" => WB_DAT_o  <= SSDreg4;
				when others => 	    null;
			   end case;
			end if;

			if(WB_STB_i = '1' and WB_CYC_i = '1' and WB_WE_i = '1') then -- Write
			   tempAck <= '1';
			   case WB_ADR_i is
				when x"00000000" => null;
				when x"00000001" => null;
				when x"00000002" => null;
				when x"00000003" => null;
				when x"00000004" => SSDreg1  <= WB_DAT_i;
						    WB_DAT_o <= WB_DAT_i;
				when x"00000005" => SSDreg2  <= WB_DAT_i;
						    WB_DAT_o <= WB_DAT_i;
				when x"00000006" => SSDreg3  <= WB_DAT_i;
						    WB_DAT_o <= WB_DAT_i;
				when x"00000007" => SSDreg4  <= WB_DAT_i;
						    WB_DAT_o <= WB_DAT_i;
				when others => 	    null;
			   end case;
			end if;

		end if;
	end process;

	WB_ACK_o <= tempAck and WB_CYC_i and WB_STB_i;

	SSD : entity work.lab3
		port map(
			SS_0_o => SSEG_0_o,
			SS_1_o => SSEG_1_o,
			SS_2_o => SSEG_2_o,
			SS_3_o => SSEG_3_o,
			HEX_i(3 downto 0)   => SSDreg1(3 downto 0),
			HEX_i(7 downto 4)   => SSDreg2(3 downto 0), 
			HEX_i(11 downto 8)  => SSDreg3(3 downto 0),
			HEX_i(15 downto 12) => SSDreg4(3 downto 0),
			CLK_i  => CLK_i
		);

end behavioral;