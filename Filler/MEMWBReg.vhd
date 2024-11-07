-- Author: Spencer Opitz

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY MEMWBReg IS
	GENERIC (N : INTEGER := 32);
	PORT (
		i_ALUOut : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
		i_IBAround : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
		i_ControlBus : IN STD_LOGIC_VECTOR(14 DOWNTO 0);
		i_CLK : IN STD_LOGIC;
		o_ALUOut : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
		o_IBAround : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
		o_ControlBus : OUT STD_LOGIC_VECTOR(14 DOWNTO 0));

END MEMWBReg;

ARCHITECTURE structural OF MEMWBReg IS

	COMPONENT Reg32 IS
		GENERIC (N : INTEGER := 32); -- Generic of type integer for input/output data width. Default value is 32.
		PORT (
			i_D : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
			i_RST : IN STD_LOGIC;
			i_WE : IN STD_LOGIC;
			i_CLK : IN STD_LOGIC;
			o_Q : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0));

	END COMPONENT;

BEGIN
	-- need to pass through ALU output and IB pass around (for sw data) (all 32 bits)

	g_BUS : Reg32
		GENERIC MAP (15)
		PORT MAP (
			i_D => i_ControlBus,
			i_RST => '0',
			i_WE => '1',
			i_CLK => i_CLK,
			o_Q => o_ControlBus
		);


	g_ALUOut : Reg32
		PORT MAP (
			i_D => i_ALUOut,
			i_RST => '0',
			i_WE => '1',
			i_CLK => i_CLK,
			o_Q => o_ALUOut
		);

	g_IBAround : Reg32
		PORT MAP (
			i_D => i_IBAround,
			i_RST => '0',
			i_WE => '1',
			i_CLK => i_CLK,
			o_Q => o_IBAround
		);

END structural;
