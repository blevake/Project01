library IEEE;
use IEEE.std_logic_1164.all;

entity alu is
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

-- Declare intermediate signals
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

  -- ALU component declarations
  component cla_adder is
    port(
      i_A        : in std_logic_vector(31 downto 0); -- First operand
      i_B        : in std_logic_vector(31 downto 0); -- Second operand
      i_nAddSub  : in std_logic;                     -- Add/Subtract control
      o_C        : out std_logic;                    -- Carry output
      o_O        : out std_logic;                    -- Overflow output
      o_S        : out std_logic_vector(31 downto 0) -- Result
    );
  end component;

    component barrelShifter is
    port(
      i_Shft_Type_Sel    : in std_logic;                              
      i_Shft_Dir         : in std_logic;                              
      i_Shft_Amt         : in std_logic_vector(4 downto 0);           
      i_D                : in std_logic_vector(31 downto 0);          
      o_O                : out std_logic_vector(31 downto 0));       
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

  component lessThanModule is
    port(i_A          : in std_logic_vector(31 downto 0);
         i_B          : in std_logic_vector(31 downto 0);
         o_F          : out std_logic_vector(31 downto 0));
  end component;

  -- Additional signals for zero and overflow
  signal muxOutput : std_logic_vector(31 downto 0);

begin

  -- Equality check for beq/bne
  e_eqModule: equalityModule
    port map(
      i_A  => i_A,
      i_B  => i_B,
      o_F  => eqOut
    );

  -- Generate negated version of equality output
  g_inverter: invg
    port map(
      i_A => eqOut,
      o_F => neqOut
    );

  -- Overflow and add/subtract control logic
  c_carryAdder: cla_adder
    port map(
      i_A       => i_A,
      i_B       => i_B,
      i_nAddSub => i_aluOp(0),  -- Add/Subtract control bit
      o_C       => carryOut,
      o_O       => overFlow,
      o_S       => adderOutput
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
  sltModule: lessThanModule
    port map(
      i_A => i_A,
      i_B => i_B,
      o_F => sltOutput
    );

  -- Shift operations (right and left)
  shiftModule: barrelShifter
    port map(
      i_Shft_Type_Sel => notAluOp0,  -- Type selection based on ALU control
      i_Shft_Dir      => notAluOp2,  -- Direction control based on ALU control
      i_Shft_Amt      => i_shamt,    
      i_D            => i_B,
      o_O            => barrelOutput
    );

  -- ALU operation selection using MUX
  aluOutMux: mux8t1_32
    port map(
      i_D0 => norOutput,     -- NOR
      i_D1 => adderOutput,   -- ADD/SUB
      i_D2 => xorOutput,     -- XOR
      i_D3 => sltOutput,     -- SLT
      i_D4 => barrelOutput,  -- SHIFT
      i_D5 => adderOutput,   -- Could be used for equality
      i_D6 => barrelOutput,  -- SHIFT other direction
      i_D7 => andOutput,     -- AND
      i_S  => i_aluOp(3 downto 1),
      o_O  => o_F
    );

  -- Zero flag output
  zero <= '1' when o_F = "00000000000000000000000000000000" else '0';

end structural;

