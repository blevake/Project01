library IEEE;
use IEEE.std_logic_1164.all;

entity alu is
  generic (N : integer := 32); -- Generic to set bit-width
  port(
    i_A         : in std_logic_vector(31 downto 0);   -- First operand
    i_B         : in std_logic_vector(31 downto 0);   -- Second operand
    i_aluOp     : in std_logic_vector(3 downto 0);    -- ALU operation control signal
    i_shamt     : in std_logic_vector(4 downto 0);    -- Shift amount
    o_F         : out std_logic_vector(31 downto 0);   -- ALU result
    o_C         : out std_logic;                       -- Carry signal
    overFlow     : out std_logic;                     -- Overflow signal
    zero        : out std_logic                       -- Zero flag
  );
end alu;


architecture structural of alu is

  signal adderOutput, barrelOutput, s_out : std_logic_vector(31 downto 0); -- Intermediate signals
  signal temp_or : std_logic_vector(31 downto 0);                          -- Temporary signal for NOR
  signal s_overflowControl, s_addSuboverFlow : std_logic;                   -- Overflow control signals
  signal carryOut : std_logic;    
  signal eqOut : std_logic;                                                 -- Equality output
  signal neqOut : std_logic;                                                -- Negation of equality
  signal andOutput : std_logic_vector(31 downto 0);                        -- Bitwise AND output
  signal orOutput : std_logic_vector(31 downto 0);                         -- Bitwise OR output
  signal xorOutput : std_logic_vector(31 downto 0);                        -- Bitwise XOR output
  signal norOutput : std_logic_vector(31 downto 0);                        -- NOR output
  signal sltOutput : std_logic_vector(31 downto 0);                        -- Set Less Than output
  signal notAluOp0 : std_logic;                                           -- Control signal for ALU operation
  signal notAluOp2 : std_logic;                                           -- Control signal for ALU operation
signal eqMux : std_logic_vector(31 downto 0);
signal Pdiddy : std_logic_vector(31 downto 0); --select between or and nor

component Add_Sub_N is
	port(
	i_A               : in std_logic_vector(N-1 downto 0);
	i_B               : in std_logic_vector(N-1 downto 0);
	i_Add_Sub		: in std_logic; --set to 1 for subtraction and 0 for addition
	o_O               : out std_logic_vector(N-1 downto 0));

  end component;


component invg_N is
  port(i_I          : in std_logic_vector(3 downto 0);
       o_O          : out std_logic_vector(3 downto 0));
end component;


    component barrelShifter_32 is
    port(
      i_d	:	in std_logic_vector(31 downto 0);	--input data
	o_d	:	out std_logic_vector(31 downto 0);	--output data
	i_shiftdir:	in std_logic;				--0 for left, 1 for right
	i_shiftamt:	in std_logic_vector(4 downto 0);	--shift amount is 0 to 31
	i_shifttype:	in std_logic				--shift type 0 for logical, 1 for arithmetic, arithmetic for shift left does nothing
	);
  end component;

  component andg2
    port(i_A          : in std_logic;
         i_B          : in std_logic;
         o_F          : out std_logic);
  end component;

  component org2
    port(i_A          : in std_logic;
         i_B          : in std_logic;
         o_F          : out std_logic);
  end component;

  component xorg2
    port(i_A          : in std_logic;
         i_B          : in std_logic;
         o_F          : out std_logic);
  end component;

  component invg
    port(i_A          : in std_logic;
         o_F          : out std_logic);
  end component;

  component onesComp_N is
    port(i_I          : in std_logic_vector(31 downto 0);
         o_O          : out std_logic_vector(31 downto 0));
  end component;

  component mux2t1_N is
    port(i_S          : in std_logic;
         i_D0         : in std_logic_vector(31 downto 0);
         i_D1         : in std_logic_vector(31 downto 0);
         o_O          : out std_logic_vector(31 downto 0));
  end component;

  component mux8t1_32 is
    port(i_S          : in std_logic_vector(2 downto 0);
         i_D0         : in std_logic_vector(31 downto 0);
         i_D1         : in std_logic_vector(31 downto 0);
         i_D2         : in std_logic_vector(31 downto 0);
         i_D3         : in std_logic_vector(31 downto 0);
         i_D4         : in std_logic_vector(31 downto 0);
         i_D5         : in std_logic_vector(31 downto 0);
         i_D6         : in std_logic_vector(31 downto 0);
         i_D7         : in std_logic_vector(31 downto 0);
         o_O          : out std_logic_vector(31 downto 0));
  end component;

  -- Equality and comparison
  component equalityModule is
    port(i_A          : in std_logic_vector(31 downto 0);
         i_B          : in std_logic_vector(31 downto 0);
         o_F          : out std_logic);
  end component;

  component lessThanCheck is
    port(i_A          : in std_logic_vector(31 downto 0);
         i_B          : in std_logic_vector(31 downto 0);
         o_F          : out std_logic_vector(31 downto 0));
  end component;

 component equality_check is
  port(i_A          : in std_logic_vector(31 downto 0);
       i_B          : in std_logic_vector(31 downto 0);
       o_F          : out std_logic_vector(31 downto 0));
end component;

  -- Additional signals for zero and overflow
  signal muxOutput : std_logic_vector(31 downto 0);
signal s_invi_AluOp : std_logic_vector(3 downto 0);


begin

invforshift: invg_N
	port map(
		i_I => i_AluOp,
		o_O => s_invi_AluOp
	);

  -- Equality check for beq/bne
  e_eqModule: equalityModule
    port map(
      i_A  => i_A,
      i_B  => i_B,
      o_F  => eqOut
    );

e_eqMuxModule: equality_check
  port map(
            i_A  => i_A,
      	    i_B  => i_B,
      	    o_F  => eqMux
);

MUXORNOR: mux2t1_N
	port map (
	i_S => i_AluOp(0),
       	i_D0 => norOutput,
       	i_D1 => orOutput,
       	o_O => Pdiddy
	);

  -- Generate negated version of equality output
  g_inverter: invg
    port map(
      i_A => eqOut,
      o_F => neqOut
    );

  -- Overflow and add/subtract control logic
  c_carryAdder: Add_Sub_N
    port map(
      i_A       => i_A,
      i_B       => i_B,
      i_Add_Sub => i_aluOp(0),  -- Add/Subtract control bit
      o_O       => adderOutput
    );

  -- Bitwise AND operation
  G_NBit_AND: for i in 0 to 31 generate
    andGate: andg2 
      port map(
        i_A => i_A(i), 
        i_B => i_B(i), 
        o_F => andOutput(i)
      );
  end generate;

  -- Bitwise OR operation
  G_NBit_OR: for i in 0 to 31 generate
    orGate: org2 
      port map(
        i_A => i_A(i), 
        i_B => i_B(i), 
        o_F => orOutput(i)
      );
  end generate;

  -- Bitwise XOR operation
  G_NBit_XOR: for i in 0 to 31 generate
    xorGate: xorg2 
      port map(
        i_A => i_A(i), 
        i_B => i_B(i), 
        o_F => xorOutput(i)
      );
  end generate;

  -- NOR operation using one's complement
  onesComp: onesComp_N
    port map(
      i_I  => orOutput,
      o_O  => norOutput
    );

  -- Less-than comparison (slt)
  sltModule: lessThanCheck
    port map(
      i_A => i_A,
      i_B => i_B,
      o_F => sltOutput
    );

  -- Shift operations (right and left)
  shiftModule: barrelShifter_32
    port map(
      i_shifttype => s_invi_AluOp(0),  -- Type selection based on ALU control
      i_shiftdir      => s_invi_AluOp(2),  -- Direction control based on ALU control
      i_shiftamt      => i_shamt,    
      i_d            => i_A,
      o_d            => barrelOutput			--shift type 0 for logical, 1 for arithmetic, arithmetic for shift left does nothing
);

--   |    ALU control
--   |  ______________________________
--   |     0  |   0  |   0   |   0   |  nor
--   |     0  |   0  |   0   |   1   |  or, ori
--   |     0  |   0  |   1   |   0   |  add, addi, addu, addiu, lw, sw, 
--   |     0  |   0  |   1   |   1   |  sub, subu 
--   |     0  |   1  |   0   |   0   |  xor, xori
--   |     0  |   1  |   0   |   1   |  
--   |     0  |   1  |   1   |   0   |  
--   |     0  |   1  |   1   |   1   |  slt, slti
--   |     1  |   0  |   0   |   0   |  sra
--   |     1  |   0  |   0   |   1   |  srl
--   |     1  |   0  |   1   |   0   |  bne
--   |     1  |   0  |   1   |   1   |  beq
--   |     1  |   1  |   0   |   0   | 
--   |     1  |   1  |   0   |   1   |  sll
--   |     1  |   1  |   1   |   0   |  and, andi
--   |     1  |   1  |   1   |   1   |  

  -- ALU operation selection using MUX
  aluOutMux: mux8t1_32
    port map(
      i_D0 => Pdiddy,     -- NOR
      i_D1 => adderOutput,   -- ADD/SUB
      i_D2 => xorOutput,     -- XOR
      i_D3 => sltOutput,     -- SLT
      i_D4 => barrelOutput,  -- SHIFT
      i_D5 => eqMux,   -- beq or not beq
      i_D6 => barrelOutput,  -- SHIFT other direction
      i_D7 => andOutput,     -- AND
      i_S  => i_aluOp(3 downto 1),
      o_O  => o_F
    );

  -- Zero flag output
  zero <= '1' when adderOutput = "00000000000000000000000000000000" else '0';

o_C <= carryOut;  

end structural;

