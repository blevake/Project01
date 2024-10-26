library IEEE;
use IEEE.std_logic_1164.all;

entity alu_addersubtractor is
  generic (N : integer := 32); -- Generic to set bit-width
  port (
    nAdd_Sub   : in  std_logic;                          -- Control signal (0 for addition, 1 for subtraction)
    i_A        : in  std_logic_vector(N-1 downto 0);     -- Input A (N-bit)
    i_B        : in  std_logic_vector(N-1 downto 0);     -- Input B (N-bit)
    o_Y        : out std_logic_vector(N-1 downto 0);     -- Result (N-bit)
    o_Overflow : out std_logic                           -- Overflow flag
  );
end alu_addersubtractor;

architecture structural of alu_addersubtractor is

  -- Component declarations
  component mux2t1_n is
    generic (N : integer := 32);
    port (
      i_S  : in  std_logic;                             -- Select signal for MUX
      i_D0 : in  std_logic_vector(N-1 downto 0);        -- Data input 0
      i_D1 : in  std_logic_vector(N-1 downto 0);        -- Data input 1
      o_O  : out std_logic_vector(N-1 downto 0)         -- Output
    );
  end component;

  component onescomp is
    generic (N : integer := 32);
    port (
      i_I : in  std_logic_vector(N-1 downto 0);         -- Input
      o_O : out std_logic_vector(N-1 downto 0)          -- Output (One's complement)
    );
  end component;

  component fullAdder is
    port (
      i_X0   : in  std_logic;                           -- Input bit 1
      i_X1   : in  std_logic;                           -- Input bit 2
      i_Cin  : in  std_logic;                           -- Carry-in
      o_Y    : out std_logic;                           -- Sum output
      o_Cout : out std_logic                            -- Carry-out
    );
  end component;

  component xorg2 is
    port (
      i_A : in  std_logic;                              -- XOR input A
      i_B : in  std_logic;                              -- XOR input B
      o_F : out std_logic                               -- XOR output (Overflow detection)
    );
  end component;

  component andg2 is
    port (
      i_A : in  std_logic;                              -- AND input A
      i_B : in  std_logic;                              -- AND input B
      o_F : out std_logic                               -- AND output
    );
  end component;

  -- Internal signals
  signal c   : std_logic_vector(N downto 0);            -- Carry signals (N+1 bits for N-bit addition)
  signal s1, s2 : std_logic_vector(N-1 downto 0);       -- Signals for inversion and selection

begin

  -- Invert the second input B (one's complement)
  inverter: onescomp
    port map(
      i_I => i_B,
      o_O => s1
    );

  -- Choose whether to use original B or the inverted B (for subtraction)
  addsubctrl: mux2t1_n 
    port map(
      i_S  => nAdd_Sub,                                 -- Select signal (0 for addition, 1 for subtraction)
      i_D0 => i_B,                                      -- Original B
      i_D1 => s1,                                       -- Inverted B
      o_O  => s2
    );

  -- Initial carry is the Add/Sub control (1 for subtraction, 0 for addition)
  c(0) <= nAdd_Sub;

  -- Full Adder Array for N-bit addition/subtraction
  G_fullAdder: for i in 0 to N-1 generate
    fullAdderlist: fullAdder
      port map(
        i_X0   => i_A(i),                               -- Bit from A
        i_X1   => s2(i),                                -- Bit from selected B or ~B
        i_Cin  => c(i),                                 -- Carry-in
        o_Y    => o_Y(i),                               -- Sum output
        o_Cout => c(i+1)                                -- Carry-out to the next bit
      );
  end generate G_fullAdder;

  -- Overflow detection: XOR the last two carry bits
  overflow: xorg2
    port map(
      i_A => c(N),
      i_B => c(N-1),
      o_F => o_Overflow
    );

end structural;
