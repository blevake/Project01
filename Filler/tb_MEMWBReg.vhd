LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY tb_MEMWBReg IS
END tb_MEMWBReg;

ARCHITECTURE behavior OF tb_MEMWBReg IS
	CONSTANT N : INTEGER := 32;
	SIGNAL i_ALUOut, i_IBAround : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
	SIGNAL i_CLK : STD_LOGIC := '0';
	SIGNAL o_ALUOut, o_IBAround : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);

	COMPONENT MEMWBReg
		GENERIC (N : INTEGER := 32);
		PORT (
			i_ALUOut : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
			i_IBAround : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
			i_CLK : IN STD_LOGIC;
			o_ALUOut : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
			o_IBAround : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
		);
	END COMPONENT;

BEGIN
	uut : MEMWBReg
	PORT MAP(
		i_ALUOut => i_ALUOut,
		i_IBAround => i_IBAround,
		i_CLK => i_CLK,
		o_ALUOut => o_ALUOut,
		o_IBAround => o_IBAround
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
		i_ALUOut <= (OTHERS => '0');
		i_IBAround <= (OTHERS => '0');
		WAIT FOR 20 ns;

		i_ALUOut <= X"AAAAAAAA";
		i_IBAround <= X"55555555";
		WAIT FOR 20 ns;

		i_ALUOut <= X"12345678";
		i_IBAround <= X"87654321";
		WAIT FOR 20 ns;

		WAIT;
	END PROCESS;

END behavior;
