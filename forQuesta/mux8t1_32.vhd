Library IEEE;
Use IEEE.std_logic_1164.All;

Entity mux8t1_32 Is
	Port (
		i_S : In std_logic_vector(2 Downto 0);
		i_D0 : In std_logic_vector(31 Downto 0);
		i_D1 : In std_logic_vector(31 Downto 0);
		i_D2 : In std_logic_vector(31 Downto 0);
		i_D3 : In std_logic_vector(31 Downto 0);
		i_D4 : In std_logic_vector(31 Downto 0);
		i_D5 : In std_logic_vector(31 Downto 0);
		i_D6 : In std_logic_vector(31 Downto 0);
		i_D7 : In std_logic_vector(31 Downto 0);
		o_O : Out std_logic_vector(31 Downto 0)
	);
End mux8t1_32;

Architecture structural Of mux8t1_32 Is

	Component mux2t1_N Is
		Port (
			i_S : In std_logic;
			i_D0 : In std_logic_vector(31 Downto 0);
			i_D1 : In std_logic_vector(31 Downto 0);
			o_O : Out std_logic_vector(31 Downto 0)
		);
	End Component;

	Signal s_muxOut1, s_muxOut2, s_muxOut3, s_muxOut4, s_muxOut5, s_muxOut6 : std_logic_vector(31 Downto 0);

Begin
	MUX1 : mux2t1_N
	Port Map(
		i_D0 => i_D0, 
		i_D1 => i_D1, 
		i_S => i_S(0), 
		o_O => s_muxOut1
	);

	MUX2 : mux2t1_N
	Port Map(
		i_D0 => i_D2, 
		i_D1 => i_D3, 
		i_S => i_S(0), 
		o_O => s_muxOut2
	);

	MUX3 : mux2t1_N
	Port Map(
		i_D0 => i_D4, 
		i_D1 => i_D5, 
		i_S => i_S(0), 
		o_O => s_muxOut3
	);

	MUX4 : mux2t1_N
	Port Map(
		i_D0 => i_D6, 
		i_D1 => i_D7, 
		i_S => i_S(0), 
		o_O => s_muxOut4
	);

	MUX5 : mux2t1_N
	Port Map(
		i_D0 => s_muxOut1, 
		i_D1 => s_muxOut2, 
		i_S => i_S(1), 
		o_O => s_muxOut5
	);

	MUX6 : mux2t1_N
	Port Map(
		i_D0 => s_muxOut3, 
		i_D1 => s_muxOut4, 
		i_S => i_S(1), 
		o_O => s_muxOut6
	);

	MUX7 : mux2t1_N
	Port Map(
		i_D0 => s_muxOut5, 
		i_D1 => s_muxOut6, 
		i_S => i_S(2), 
		o_O => o_O
	);

End structural;
