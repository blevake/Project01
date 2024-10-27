Library IEEE;
Use IEEE.std_logic_1164.All;

Entity onesComp Is

	Port (
		i_I : In std_logic;
		o_O : Out std_logic
	);

End onesComp;

Architecture structure Of onesComp Is
	Component invg
		Port (
			i_A : In std_logic;
			o_F : Out std_logic
		);
	End Component;

Begin
	g_Not : invg
	Port Map(
		i_A => i_I, 
		o_F => o_O
	);

End structure;
