LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY tb_alu IS
END tb_alu;

ARCHITECTURE behavior OF tb_alu IS

	COMPONENT alu
		GENERIC (N : INTEGER := 32);
		PORT (
			i_A : IN std_logic_vector(31 DOWNTO 0);
			i_B : IN std_logic_vector(31 DOWNTO 0);
			i_aluOp : IN std_logic_vector(3 DOWNTO 0);
			i_shamt : IN std_logic_vector(4 DOWNTO 0);
			o_F : OUT std_logic_vector(31 DOWNTO 0);
			o_overFlow : OUT std_logic;
			o_zero : OUT std_logic
		);
	END COMPONENT;
 
	SIGNAL i_A : std_logic_vector(31 DOWNTO 0) := (OTHERS => '0');
	SIGNAL i_B : std_logic_vector(31 DOWNTO 0) := (OTHERS => '0');
	SIGNAL i_aluOp : std_logic_vector(3 DOWNTO 0) := "0000";
	SIGNAL i_shamt : std_logic_vector(4 DOWNTO 0) := (OTHERS => '0');
	SIGNAL o_F : std_logic_vector(31 DOWNTO 0);
	SIGNAL o_overFlow : std_logic;
	SIGNAL o_zero : std_logic;

BEGIN
	UUT : alu
	PORT MAP(
		i_A => i_A, 
		i_B => i_B, 
		i_aluOp => i_aluOp, 
		i_shamt => i_shamt, 
		o_F => o_F, 
		o_overFlow => o_overFlow, 
		o_zero => o_zero
	);

	-- | ALU control guide
	-- | ______________________________
	-- | 0 | 0 | 0 | 0 | and, andi
	-- | 0 | 0 | 0 | 1 | or, ori
	-- | 0 | 0 | 1 | 0 | xor, xori
	-- | 0 | 0 | 1 | 1 | nor
	-- | 0 | 1 | 0 | 0 |
	-- | 0 | 1 | 0 | 1 | 
	-- | 0 | 1 | 1 | 0 | addi, add, addiu, lw, sw
	-- | 0 | 1 | 1 | 1 | sll
	-- | 1 | 0 | 0 | 0 | srl
	-- | 1 | 0 | 0 | 1 | sra
	-- | 1 | 0 | 1 | 0 | 
	-- | 1 | 0 | 1 | 1 | LUI
	-- | 1 | 1 | 0 | 0 | bne
	-- | 1 | 1 | 0 | 1 | 
	-- | 1 | 1 | 1 | 0 | sub, subu, beq
	-- | 1 | 1 | 1 | 1 | slti, slt

	testbench : PROCESS
	BEGIN
		i_A <= X"FFFF000F";
		i_B <= X"0000FF0F";
		i_shamt <= "00100";

		-- and
		i_aluOp <= "0000";
		WAIT FOR 10 ns;

		-- or
		i_aluOp <= "0001";
		WAIT FOR 10 ns;

		-- xor
		i_aluOp <= "0010";
		WAIT FOR 10 ns;

		-- nor
		i_aluOp <= "0011";
		WAIT FOR 10 ns;

		-- add
		i_aluOp <= "0110";
		WAIT FOR 10 ns;

		-- sll
		i_aluOp <= "0111";
		WAIT FOR 10 ns;

		-- srl
		i_aluOp <= "1000";
		WAIT FOR 10 ns;

		-- sra
		i_aluOp <= "1001";
		WAIT FOR 10 ns;

		-- lui
		i_aluOp <= "1011";
		WAIT FOR 10 ns;

		-- bne
		i_aluOp <= "1100";
		WAIT FOR 10 ns;

		-- sub/beq
		i_aluOp <= "1110";
		WAIT FOR 10 ns;

		-- slt
		i_aluOp <= "1111";
		WAIT FOR 10 ns;

		WAIT;
	END PROCESS;

END behavior;