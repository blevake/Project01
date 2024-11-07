-- Author: Spencer Opitz

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY IDEXReg IS
	GENERIC (N : INTEGER := 32);
	PORT (
		i_RS : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
		i_RT : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
		i_Inst : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
		i_Imm : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
		i_Bus	: IN STD_LOGIC_VECTOR(14 DOWNTO 0);
		i_CLK : IN STD_LOGIC;
		o_RS : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
		o_RT : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
		o_Inst : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
		o_Imm : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
		o_Bus	: OUT STD_LOGIC_VECTOR(14 DOWNTO 0));

END IDEXReg;

ARCHITECTURE structural OF IDEXReg IS

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
	-- need to pass through RA, RB, instruction, sign extended immediate (all 32 bits)


	g_RS : Reg32
		PORT MAP (
			i_D => i_RS,
			i_RST => '0',
			i_WE => '1',
			i_CLK => i_CLK,
			o_Q => o_RS
		);
	g_BUS : Reg32
		GENERIC MAP (15)
		PORT MAP (
			i_D => i_Bus,
			i_RST => '0',
			i_WE => '1',
			i_CLK => i_CLK,
			o_Q => o_Bus
		);

	g_RT : Reg32
		PORT MAP (
			i_D => i_RT,
			i_RST => '0',
			i_WE => '1',
			i_CLK => i_CLK,
			o_Q => o_RT
		);

	g_INST : Reg32
		PORT MAP (
			i_D => i_Inst,
			i_RST => '0',
			i_WE => '1',
			i_CLK => i_CLK,
			o_Q => o_Inst
		);

	g_IMM : Reg32
		PORT MAP (
			i_D => i_Imm,
			i_RST => '0',
			i_WE => '1',
			i_CLK => i_CLK,
			o_Q => o_Imm
		);

END structural;

