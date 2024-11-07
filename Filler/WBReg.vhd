-- Author: Spencer Opitz

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY WBReg IS
	GENERIC (N : INTEGER := 32);
	PORT (
		i_MEMData : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
		i_ALUOut : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
		i_ControlBus : IN STD_LOGIC_VECTOR(14 DOWNTO 0);
		i_CLK : IN STD_LOGIC;
		o_MEMData : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
		o_ALUOut : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
		o_ControlBus : OUT STD_LOGIC_VECTOR(14 DOWNTO 0));

END WBReg;

ARCHITECTURE structural OF WBReg IS

	COMPONENT Reg32 IS
		GENERIC (N : INTEGER := 32);
		PORT (
			i_D : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
			i_RST : IN STD_LOGIC;
			i_WE : IN STD_LOGIC;
			i_CLK : IN STD_LOGIC;
			o_Q : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0));

	END COMPONENT;

BEGIN
	-- need to pass through MEM Data and ALUout

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
			i_D => i_MEMData,
			i_RST => '0',
			i_WE => '1',
			i_CLK => i_CLK,
			o_Q => o_MEMData
		);

	g_IBAround : Reg32
		PORT MAP (
			i_D => i_ALUOut,
			i_RST => '0',
			i_WE => '1',
			i_CLK => i_CLK,
			o_Q => o_ALUOut
		);

END structural;
