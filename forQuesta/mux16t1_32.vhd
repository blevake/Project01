Library IEEE;
Use IEEE.std_logic_1164.All;

Entity mux16t1_32 Is
	Port (
		i_S : In std_logic_vector(3 Downto 0); --d signals are in octal
		i_D00 : In std_logic_vector(31 Downto 0);
		i_D01 : In std_logic_vector(31 Downto 0);
		i_D02 : In std_logic_vector(31 Downto 0);
		i_D03 : In std_logic_vector(31 Downto 0);
		i_D04 : In std_logic_vector(31 Downto 0);
		i_D05 : In std_logic_vector(31 Downto 0);
		i_D06 : In std_logic_vector(31 Downto 0);
		i_D07 : In std_logic_vector(31 Downto 0);
		i_D10 : In std_logic_vector(31 Downto 0);
		i_D11 : In std_logic_vector(31 Downto 0);
		i_D12 : In std_logic_vector(31 Downto 0);
		i_D13 : In std_logic_vector(31 Downto 0);
		i_D14 : In std_logic_vector(31 Downto 0);
		i_D15 : In std_logic_vector(31 Downto 0);
		i_D16 : In std_logic_vector(31 Downto 0);
		i_D17 : In std_logic_vector(31 Downto 0);
		o_O : Out std_logic_vector(31 Downto 0)
	);
End mux16t1_32;
Architecture structural Of mux16t1_32 Is

	Signal s1 : std_logic_vector(31 Downto 0);
	Signal s2 : std_logic_vector(31 Downto 0);
	Component mux8t1_32 Is
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
	End Component;

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
	MUX1 : mux8t1_32
	Port Map(
		i_S => i_S (2 Downto 0), 
		i_D0 => i_D00, 
		i_D1 => i_D01, 
		i_D2 => i_D02, 
		i_D3 => i_D03, 
		i_D4 => i_D04, 
		i_D5 => i_D05, 
		i_D6 => i_D06, 
		i_D7 => i_D07, 
		o_O => s1
	);

	MUX2 : mux8t1_32
	Port Map(
		i_S => i_S (2 Downto 0), 
		i_D0 => i_D10, 
		i_D1 => i_D11, 
		i_D2 => i_D12, 
		i_D3 => i_D13, 
		i_D4 => i_D14, 
		i_D5 => i_D15, 
		i_D6 => i_D16, 
		i_D7 => i_D17, 
		o_O => s2
	);

	MUX3 : mux2t1_N
	Port Map(
		i_D0 => s1, 
		i_D1 => s2, 
		i_S => i_S(3), 
		o_O => o_O
	);

End structural;