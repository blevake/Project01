--Spencer Opitz

Library IEEE;
Use IEEE.std_logic_1164.All;

Entity FullAdder_N Is
	Generic (N : Integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
	Port (
		i_A : In std_logic_vector(N - 1 Downto 0);
		i_B : In std_logic_vector(N - 1 Downto 0);
		i_Ci : In std_logic;
		o_O : Out std_logic_vector(N - 1 Downto 0);
		o_Overflow : Out std_logic
	);

End FullAdder_N;

Architecture structural Of FullAdder_N Is

	Component FullAdder Is
		Port (
			i_A : In std_logic;
			i_B : In std_logic;
			i_Ci : In std_logic;
			o_Co : Out std_logic;
			o_O : Out std_logic
		);
	End Component;

Component xorg2 is

  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);

End Component;

	Signal carry : std_logic_vector(n Downto 0);

Begin
	carry(0) <= i_Ci;

	-- Instantiate N FullAdder instances.
	G_NBit_MUX : For i In 0 To N - 1 Generate
		MUXI : FullAdder
		Port Map(
			i_A => i_A(i), 
			i_B => i_B(i), 
			i_Ci => carry(i), 
			o_Co => carry(i + 1), 
			o_O => o_O(i)
		);
	End Generate G_NBit_MUX;

g_xorOverflow : xorg2
port map(
i_A          => carry(32),
       i_B         => carry(31),
       o_F          => o_Overflow
);

End structural;
