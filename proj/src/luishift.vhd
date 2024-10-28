Library IEEE;
Use IEEE.std_logic_1164.All;
Use ieee.numeric_std.All;

Entity luishift Is

	Port (
		i_A : In std_logic_vector(31 Downto 0);
		o_F : Out std_logic_vector(31 Downto 0)
	);

End luishift;

Architecture dataflow Of luishift Is
Begin
	o_F <= std_logic_vector(shift_left(unsigned(i_A), 16));
 
End dataflow;