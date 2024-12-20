LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY tb_IDEXREG IS
END tb_IDEXREG;

ARCHITECTURE behavior OF tb_IDEXREG IS
	CONSTANT N : INTEGER := 32;
	SIGNAL i_RS, i_RT, i_Inst, i_Imm : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
	SIGNAL i_CLK : STD_LOGIC := '0';
	SIGNAL o_RS, o_RT, o_Inst, o_Imm : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);

	COMPONENT IDEXReg
		GENERIC (N : INTEGER := 32);
		PORT (
			i_RS : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
			i_RT : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
			i_Inst : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
			i_Imm : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
			i_CLK : IN STD_LOGIC;
			o_RS : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
			o_RT : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
			o_Inst : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
			o_Imm : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
		);
	END COMPONENT;

BEGIN
	uut : IDEXReg
	PORT MAP(
		i_RS => i_RS,
		i_RT => i_RT,
		i_Inst => i_Inst,
		i_Imm => i_Imm,
		i_CLK => i_CLK,
		o_RS => o_RS,
		o_RT => o_RT,
		o_Inst => o_Inst,
		o_Imm => o_Imm
	);

	clk_process : PROCESS
	BEGIN
		i_CLK <= '0';
		WAIT FOR 10 ns;
		i_CLK <= '1';
		WAIT FOR 10 ns;
	END PROCESS;

	stim_proc : PROCESS
	BEGIN
		i_RS <= (OTHERS => '0');
		i_RT <= (OTHERS => '0');
		i_Inst <= (OTHERS => '0');
		i_Imm <= (OTHERS => '0');
		WAIT FOR 20 ns;

		i_RS <= X"AAAAAAAA";
		i_RT <= X"55555555";
		i_Inst <= X"FFFFFFFF";
		i_Imm <= X"0000FFFF";
		WAIT FOR 20 ns;

		i_RS <= X"12345678";
		i_RT <= X"87654321";
		i_Inst <= X"0F0F0F0F";
		i_Imm <= X"F0F0F0F0";
		WAIT FOR 20 ns;

		WAIT;
	END PROCESS;

END behavior;

