Library IEEE;
Use IEEE.std_logic_1164.All;

Entity onesComp_N Is
	Generic (N : Integer := 4); -- Generic for input/output data width, default is 32 bits.
	Port (
		i_I : In std_logic_vector(N - 1 Downto 0); -- Input vector (N bits)
		o_O : Out std_logic_vector(N - 1 Downto 0) -- Output vector (N bits), one's complement of input
	);
End onesComp_N;

Architecture structural Of onesComp_N Is

	-- Component declaration for 1-bit one's complementor
	Component onesComp Is
		Port (
			i_I : In std_logic; -- 1-bit input
			o_O : Out std_logic -- 1-bit output (inverted input)
		);
	End Component;

Begin
	G_NBit_ONES : For i In 0 To N - 1 Generate
		ONESI : onesComp
		Port Map(
			i_I => i_I(i), -- Map each bit of the input
			o_O => o_O(i) -- Map each bit of the output (one's complement)
		);
	End Generate G_NBit_ONES;
 
End structural;
