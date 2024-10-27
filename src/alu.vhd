LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY alu IS

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

	GENERIC (N : INTEGER := 32);
	PORT (
		i_A : IN std_logic_vector(31 DOWNTO 0);
		i_B : IN std_logic_vector(31 DOWNTO 0);
		i_aluOp : IN std_logic_vector(3 DOWNTO 0);
		i_shamt : IN std_logic_vector(4 DOWNTO 0);
		o_F : OUT std_logic_vector(31 DOWNTO 0);
		o_overFlow : OUT std_logic; -- Overflow signal need to implement to handle errors in future
		o_zero : OUT std_logic -- Zero for branching
	);
END alu;
ARCHITECTURE structural OF alu IS
	
	--signals for final output mux
	SIGNAL adderOutput, barrelOutput, andOutput, orOutput, xorOutput, norOutput, sltOutput : std_logic_vector(31 DOWNTO 0);
	SIGNAL s_maybezero : std_logic;
	SIGNAL s_invertedzero : std_logic;
	SIGNAL s_invAluOp : std_logic_vector(3 DOWNTO 0);
	SIGNAL s_luiOut : std_logic_vector(31 DOWNTO 0);
	SIGNAL s_luiShift : std_logic_vector(31 DOWNTO 0);

	COMPONENT Add_Sub_N IS
		PORT (
			i_A : IN std_logic_vector(N - 1 DOWNTO 0);
			i_B : IN std_logic_vector(N - 1 DOWNTO 0);
			i_Add_Sub : IN std_logic; --set to 1 for subtraction and 0 for addition
			o_O : OUT std_logic_vector(N - 1 DOWNTO 0)
		);

	END COMPONENT;

	COMPONENT invg_N IS
		PORT (
			i_I : IN std_logic_vector(31 DOWNTO 0);
			o_O : OUT std_logic_vector(31 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT barrelShifter_32 IS
		PORT (
			i_d : IN std_logic_vector(31 DOWNTO 0); --input data
			o_d : OUT std_logic_vector(31 DOWNTO 0); --output data
			i_shiftdir : IN std_logic; --0 for left, 1 for right
			i_shiftamt : IN std_logic_vector(4 DOWNTO 0); --shift amount is 0 to 31
			i_shifttype : IN std_logic --shift type 0 for logical, 1 for arithmetic, arithmetic for shift left does nothing
		);
	END COMPONENT;

	COMPONENT andg2
		PORT (
			i_A : IN std_logic;
			i_B : IN std_logic;
			o_F : OUT std_logic
		);
	END COMPONENT;

	COMPONENT org2
		PORT (
			i_A : IN std_logic;
			i_B : IN std_logic;
			o_F : OUT std_logic
		);
	END COMPONENT;

	COMPONENT xorg2
		PORT (
			i_A : IN std_logic;
			i_B : IN std_logic;
			o_F : OUT std_logic
		);
	END COMPONENT;

	COMPONENT invg
		PORT (
			i_A : IN std_logic;
			o_F : OUT std_logic
		);
	END COMPONENT;

	COMPONENT onesComp_N IS
		PORT (
			i_I : IN std_logic_vector(3 DOWNTO 0);
			o_O : OUT std_logic_vector(3 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT mux2t1_N IS
		PORT (
			i_S : IN std_logic;
			i_D0 : IN std_logic_vector(31 DOWNTO 0);
			i_D1 : IN std_logic_vector(31 DOWNTO 0);
			o_O : OUT std_logic_vector(31 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT mux8t1_32 IS
		PORT (
			i_S : IN std_logic_vector(2 DOWNTO 0);
			i_D0 : IN std_logic_vector(31 DOWNTO 0);
			i_D1 : IN std_logic_vector(31 DOWNTO 0);
			i_D2 : IN std_logic_vector(31 DOWNTO 0);
			i_D3 : IN std_logic_vector(31 DOWNTO 0);
			i_D4 : IN std_logic_vector(31 DOWNTO 0);
			i_D5 : IN std_logic_vector(31 DOWNTO 0);
			i_D6 : IN std_logic_vector(31 DOWNTO 0);
			i_D7 : IN std_logic_vector(31 DOWNTO 0);
			o_O : OUT std_logic_vector(31 DOWNTO 0)
		);
	END COMPONENT;

	-- Equality and comparison
	COMPONENT equalityModule IS
		PORT (
			i_A : IN std_logic_vector(31 DOWNTO 0);
			i_B : IN std_logic_vector(31 DOWNTO 0);
			o_F : OUT std_logic
		);
	END COMPONENT;

	COMPONENT lessThanCheck IS
		PORT (
			i_A : IN std_logic_vector(31 DOWNTO 0);
			i_B : IN std_logic_vector(31 DOWNTO 0);
			o_F : OUT std_logic_vector(31 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT mux16t1_32 IS
		PORT (
			i_S : IN std_logic_vector(3 DOWNTO 0); --d signals are in octal because im evil
			i_D00 : IN std_logic_vector(31 DOWNTO 0);
			i_D01 : IN std_logic_vector(31 DOWNTO 0);
			i_D02 : IN std_logic_vector(31 DOWNTO 0);
			i_D03 : IN std_logic_vector(31 DOWNTO 0);
			i_D04 : IN std_logic_vector(31 DOWNTO 0);
			i_D05 : IN std_logic_vector(31 DOWNTO 0);
			i_D06 : IN std_logic_vector(31 DOWNTO 0);
			i_D07 : IN std_logic_vector(31 DOWNTO 0);
			i_D10 : IN std_logic_vector(31 DOWNTO 0);
			i_D11 : IN std_logic_vector(31 DOWNTO 0);
			i_D12 : IN std_logic_vector(31 DOWNTO 0);
			i_D13 : IN std_logic_vector(31 DOWNTO 0);
			i_D14 : IN std_logic_vector(31 DOWNTO 0);
			i_D15 : IN std_logic_vector(31 DOWNTO 0);
			i_D16 : IN std_logic_vector(31 DOWNTO 0);
			i_D17 : IN std_logic_vector(31 DOWNTO 0);
			o_O : OUT std_logic_vector(31 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT mux2t1 IS

		PORT (
			i_S : IN std_logic;
			i_D0 : IN std_logic;
			i_D1 : IN std_logic;
			o_O : OUT std_logic
		);
	END COMPONENT;

	COMPONENT luishift IS --shifts left 16 for lui operations
		PORT (
			i_A : IN std_logic_vector(31 DOWNTO 0);
			o_F : OUT std_logic_vector(31 DOWNTO 0)
		);
	END COMPONENT;
	
BEGIN
	lui : luishift
	PORT MAP(
		i_A => i_B, 
		o_F => s_luiShift
	);
	
	process (s_luiShift, i_A, i_B) is
		begin
			s_luiOut(31 downto 16) <= s_luiShift(31 downto 16);
			s_luiOut(15 downto 0)  <= i_A(15 downto 0);
		end process;

	invzero : invg
	PORT MAP(
		i_A => s_maybezero, 
		o_F => s_invertedzero
	);

	zeromux : mux2t1
	PORT MAP(
		i_S => i_AluOp(1), 
		i_D0 => s_invertedzero, 
		i_D1 => s_maybezero, 
		o_O => o_zero
	);

	invforshift : onesComp_N
	PORT MAP(
		i_I => i_AluOp, 
		o_O => s_invAluOp
	);

	e_eqModule : equalityModule
	PORT MAP(
		i_A => i_A, 
		i_B => i_B, 
		o_F => s_maybezero
	);

	adder : Add_Sub_N
	PORT MAP(
		i_A => i_A, 
		i_B => i_B, 
		i_Add_Sub => i_aluOp(3), -- Add/Subtract control bit
		o_O => adderOutput
	);

	-- Bitwise AND operation
	G_NBit_AND : FOR i IN 0 TO 31 GENERATE
		andGate : andg2
		PORT MAP(
			i_A => i_A(i), 
			i_B => i_B(i), 
			o_F => andOutput(i)
		);
	END GENERATE;

	-- Bitwise OR operation
	G_NBit_OR : FOR i IN 0 TO 31 GENERATE
		orGate : org2
		PORT MAP(
			i_A => i_A(i), 
			i_B => i_B(i), 
			o_F => orOutput(i)
		);
	END GENERATE;

	-- Bitwise XOR operation
	G_NBit_XOR : FOR i IN 0 TO 31 GENERATE
		xorGate : xorg2
		PORT MAP(
			i_A => i_A(i), 
			i_B => i_B(i), 
			o_F => xorOutput(i)
		);
	END GENERATE;

	-- NOR operation using one's complement
	invertComp : invg_N
	PORT MAP(
		i_I => orOutput, 
		o_O => norOutput
	);

	-- Less-than comparison (slt)
	sltModule : lessThanCheck
	PORT MAP(
		i_A => i_A, 
		i_B => i_B, 
		o_F => sltOutput
	);

	-- Shift operations (right and left)
	shiftModule : barrelShifter_32
	PORT MAP(
		i_shifttype => i_AluOp(0), -- Type selection based on ALU control
		i_shiftdir => i_AluOp(3), -- Direction control based on ALU control
		i_shiftamt => i_shamt, 
		i_d => i_B, 
		o_d => barrelOutput --shift type 0 for logical, 1 for arithmetic, arithmetic for shift left does nothing
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


	aluOutMux : mux16t1_32
	PORT MAP(--d signals are in octal
		i_S => i_aluOp, 
		i_D00 => andOutput, 
		i_D01 => orOutput, 
		i_D02 => xorOutput, 
		i_D03 => norOutput, 
		i_D04 => X"00000000", --no output
		i_D05 => X"00000000", --no output
		i_D06 => adderOutput, 
		i_D07 => barrelOutput, 
		i_D10 => barrelOutput, 
		i_D11 => barrelOutput, 
		i_D12 => X"00000000", --no output
		i_D13 => s_luiOut, 
		i_D14 => X"00000000", --bne no output needed
		i_D15 => X"00000000", --no output
		i_D16 => adderOutput, 
		i_D17 => sltOutput, 
		o_O => o_F
	);

END structural;
