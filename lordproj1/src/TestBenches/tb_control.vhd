Library IEEE;
Use IEEE.std_logic_1164.All;
Use IEEE.numeric_std.All; 

Entity tb_control Is

End tb_control;

Architecture behavior Of tb_control Is
 
	Constant ClkWait : Time := 20 ns;
	Component control
		Port (
			iOp : In std_logic_vector(5 Downto 0);
			iFunc : In std_logic_vector(5 Downto 0);
			oALUSrc : Out std_logic;
			oALUCtl : Out std_logic_vector(3 Downto 0);
			oMemtoReg : Out std_logic;
			oDMemWr : Out std_logic;
			oRegWr : Out std_logic;
			oBr : Out std_logic;
			oJ : Out std_logic;
			oSE : Out std_logic;
			oJR : Out std_logic;
			oRegDst : Out std_logic
		);
	End Component;

	-- Signals to connect to control
	Signal s_CLK : std_logic := '0';
	Signal s_opcode : std_logic_vector(5 Downto 0) := (Others => '0');
	Signal s_funct : std_logic_vector(5 Downto 0) := (Others => '0');
	Signal expected_out : std_logic_vector(14 Downto 0) := (Others => '0');
 
	-- Output signals from control
	Signal s_ALUSrc : std_logic;
	Signal s_ALUCtl : std_logic_vector(3 Downto 0);
	Signal s_MemtoReg : std_logic;
	Signal s_DMemWr : std_logic;
	Signal s_RegWr : std_logic;
	Signal s_Br : std_logic;
	Signal s_J : std_logic;
	Signal s_SE : std_logic;
	Signal s_JR : std_logic;
	Signal s_RegDst : std_logic;

Begin
	DUT : control
	Port Map(
		iOp => s_opcode, 
		iFunc => s_funct, 
		oALUSrc => s_ALUSrc, 
		oALUCtl => s_ALUCtl, 
		oMemtoReg => s_MemtoReg, 
		oDMemWr => s_DMemWr, 
		oRegWr => s_RegWr, 
		oBr => s_Br, 
		oJ => s_J, 
		oSE => s_SE, 
		oJR => s_JR, 
		oRegDst => s_RegDst
	);
	P_CLK : Process
	Begin
		s_CLK <= '0';
		Wait For ClkWait;
		s_CLK <= '1';
		Wait For ClkWait;
	End Process;
	P_TB : Process
	Begin
		-- Test add
		s_opcode <= "000000";
		s_funct <= "100000";
		expected_out <= "000111000110100";
		Wait For ClkWait/2;

		-- Test addu
		s_opcode <= "000000";
		s_funct <= "100001";
		expected_out <= "000000000110100";
		Wait For ClkWait/2;

		-- Test and
		s_opcode <= "000000";
		s_funct <= "100100";
		expected_out <= "000001000110100";
		Wait For ClkWait/2;

		-- Test nor
		s_opcode <= "000000";
		s_funct <= "100111";
		expected_out <= "000010100110100";
		Wait For ClkWait/2;

		-- Test xor
		s_opcode <= "000000";
		s_funct <= "100110";
		expected_out <= "000010000110100";
		Wait For ClkWait/2;

		-- Test or
		s_opcode <= "000000";
		s_funct <= "100101";
		expected_out <= "000001100110100";
		Wait For ClkWait/2;

		-- Test slt
		s_opcode <= "000000";
		s_funct <= "101010";
		expected_out <= "000011100110100";
		Wait For ClkWait/2;

		-- Test sll
		s_opcode <= "000000";
		s_funct <= "000000";
		expected_out <= "000100100110100";
		Wait For ClkWait/2;

		-- Test srl
		s_opcode <= "000000";
		s_funct <= "000010";
		expected_out <= "000100000110000";
		Wait For ClkWait/2;

		-- Test sra
		s_opcode <= "000000";
		s_funct <= "000011";
		expected_out <= "000101000110100";
		Wait For ClkWait/2;

		-- Test sub
		s_opcode <= "000000";
		s_funct <= "100010";
		expected_out <= "000111100110100";
		Wait For ClkWait/2;

		-- Test subu
		s_opcode <= "000000";
		s_funct <= "100011";
		expected_out <= "000000100110100";
		Wait For ClkWait/2;

		-- Test addi
		s_opcode <= "001000";
		s_funct <= "000000";
		expected_out <= "001111000100100";
		Wait For ClkWait/2;

		-- Test addiu
		s_opcode <= "001001";
		expected_out <= "001000000100100";
		Wait For ClkWait/2;
		-- Test xori
		s_opcode <= "001110";
		expected_out <= "001010000100000";
		Wait For ClkWait/2;

		-- Test ori
		s_opcode <= "001101";
		expected_out <= "001001100100000";
		Wait For ClkWait/2;

		-- Test slti
		s_opcode <= "001010";
		expected_out <= "001011100100100";
		Wait For ClkWait/2;

		-- Test lui
		s_opcode <= "001111";
		expected_out <= "001011000100100";
		Wait For ClkWait/2;

		-- Test beq
		s_opcode <= "000100";
		expected_out <= "000101100001100";
		Wait For ClkWait/2;

		-- Test bne
		s_opcode <= "000101";
		expected_out <= "000110000001100";
		Wait For ClkWait/2;

		-- Test lw
		s_opcode <= "100011";
		expected_out <= "001000010100100";
		Wait For ClkWait/2;

		-- Test sw
		s_opcode <= "101011";
		expected_out <= "001000001000100";
		Wait For ClkWait/2;

		-- Test j
		s_opcode <= "000010";
		expected_out <= "000000000000110";
		Wait For ClkWait/2;

		-- Test jal
		s_opcode <= "000011";
		expected_out <= "010000000100110";
		Wait For ClkWait/2;

		-- Test jr
		s_opcode <= "000000";
		s_funct <= "001000";
		expected_out <= "100000000000110";
		Wait For ClkWait/2;

		Wait;
	End Process;

End behavior;
