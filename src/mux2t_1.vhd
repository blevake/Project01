Library IEEE;
Use IEEE.std_logic_1164.All;
Entity mux2t1 Is

	Port (
		i_S : In std_logic;
		i_D0 : In std_logic;
		i_D1 : In std_logic;
		o_O : Out std_logic
	);

End mux2t1;

Architecture dataflow Of mux2t1 Is

Begin
	With i_S Select
	o_O <= 
		i_D0 When '0', 
		i_D1 When '1', 
		'0' When Others;

End dataflow;
