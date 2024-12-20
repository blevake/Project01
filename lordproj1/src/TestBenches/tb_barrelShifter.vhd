Library ieee;
Use ieee.std_logic_1164.All;
Use ieee.numeric_std.All;

Entity tb_barrelShifter Is
End tb_barrelShifter;

Architecture behavior Of tb_barrelShifter Is

	Component barrelshifter_32
		Generic (N : Integer := 32);
		Port (
			i_d : In std_logic_vector(N - 1 Downto 0);
			o_d : Out std_logic_vector(N - 1 Downto 0);
			i_shiftdir : In std_logic;
			i_shiftamt : In std_logic_vector(4 Downto 0);
			i_shifttype : In std_logic
		);
	End Component;

	Signal i_d : std_logic_vector(31 Downto 0) := (Others => '0'); -- Input data
	Signal o_d : std_logic_vector(31 Downto 0); -- Output data
	Signal i_shiftdir : std_logic := '0'; -- Shift direction: 0 for left, 1 for right
	Signal i_shiftamt : std_logic_vector(4 Downto 0) := "00000"; -- Shift amount (0 to 31)
	Signal i_shifttype : std_logic := '0'; -- Shift type: 0 for logical, 1 for arithmetic

	-- Clock period for simulation
	Constant clk_period : Time := 10 ns;

Begin
	-- Instantiate the barrel shifter
	uut : barrelshifter_32
	Port Map(
		i_d => i_d, 
		o_d => o_d, 
		i_shiftdir => i_shiftdir, 
		i_shiftamt => i_shiftamt, 
		i_shifttype => i_shifttype
	);

	-- Test process
	Process
	Begin
		-- Test case 1: Logical left shift by 1
		i_d <= x"00000001"; -- Input value (binary 1)
		i_shiftdir <= '0'; -- Shift left
		i_shiftamt <= "00001"; -- Shift by 1
		i_shifttype <= '0'; -- Logical shift
		Wait For clk_period;

		-- Test case 2: Logical right shift by 2
		i_d <= x"80000000"; -- Input value (MSB is 1)
		i_shiftdir <= '1'; -- Shift right
		i_shiftamt <= "00010"; -- Shift by 2
		i_shifttype <= '0'; -- Logical shift
		Wait For clk_period;

		-- Test case 3: Arithmetic right shift by 2
		i_d <= x"80000000"; -- Input value (MSB is 1)
		i_shiftdir <= '1'; -- Shift right
		i_shiftamt <= "00010"; -- Shift by 2
		i_shifttype <= '1'; -- Arithmetic shift
		Wait For clk_period;

		-- Test case 4: Logical left shift by 8
		i_d <= x"0000FFFF"; -- Input value
		i_shiftdir <= '0'; -- Shift left
		i_shiftamt <= "01000"; -- Shift by 8
		i_shifttype <= '0'; -- Logical shift
		Wait For clk_period;

		-- Test case 5: Arithmetic right shift by 16
		i_d <= x"F0000000"; -- Input value (negative in two's complement)
		i_shiftdir <= '1'; -- Shift right
		i_shiftamt <= "10000"; -- Shift by 16
		i_shifttype <= '1'; -- Arithmetic shift
		Wait For clk_period;

		-- Stop the simulation after tests
		Wait;
	End Process;

End behavior;
