library IEEE;
use IEEE.std_logic_1164.all;

entity addersubtractor is
  generic(
    N : integer := 32  -- Generic to define the width of input/output data. Default is 32 bits.
  );
  port(
    nAdd_Sub : in std_logic;                     -- Control signal: '0' for addition, '1' for subtraction
    i_A      : in std_logic_vector(N-1 downto 0); -- Input A (N-bit)
    i_B      : in std_logic_vector(N-1 downto 0); -- Input B (N-bit)
    o_Y      : out std_logic_vector(N-1 downto 0); -- Output result (N-bit)
    o_Cout   : out std_logic                      -- Carry out/borrow out signal
  );
end addersubtractor;

architecture structural of addersubtractor is

  -- Component declaration for a 2-to-1 multiplexer
  component mux2t1_N is
    generic(N : integer := 32); -- Generic N-bit multiplexer
    port(
      i_S   : in std_logic;                      -- Select signal
      i_D0  : in std_logic_vector(N-1 downto 0); -- Input 0 (N-bit)
      i_D1  : in std_logic_vector(N-1 downto 0); -- Input 1 (N-bit)
      o_O   : out std_logic_vector(N-1 downto 0) -- Output (N-bit)
    );
  end component;

  -- Component declaration for a 1?s complement inverter
  component onesComp is
    generic(N : integer := 32); -- Generic N-bit inverter (1?s complement)
    port(
      i_I : in std_logic_vector(N-1 downto 0);  -- Input to be inverted
      o_O : out std_logic_vector(N-1 downto 0)  -- Output (inverted result)
    );
  end component;

  -- Component declaration for a 1-bit full adder
  component fullAdder is
    port(
      i_X0   : in std_logic; -- Input 1 (1-bit)
      i_X1   : in std_logic; -- Input 2 (1-bit)
      i_Cin  : in std_logic; -- Carry-in (1-bit)
      o_Y    : out std_logic; -- Sum output (1-bit)
      o_Cout : out std_logic  -- Carry-out (1-bit)
    );
  end component;

  -- Internal signals
  signal c : std_logic_vector(N downto 0);        -- Carry chain (N+1 bits for carry)
  signal s1, s2 : std_logic_vector(N-1 downto 0); -- Signals for the inverted and selected input

begin
  -- Invert the second input (i_B) when doing subtraction
  inverter: onesComp
    port map(
      i_I => i_B,
      o_O => s1
    );

  -- Choose between original i_B (for addition) or inverted i_B (for subtraction)
  addsubctrl: mux2t1_N
    port map(
      i_S   => nAdd_Sub,  -- Control signal to switch between addition (0) or subtraction (1)
      i_D0  => i_B,       -- Original input for addition
      i_D1  => s1,        -- Inverted input for subtraction
      o_O   => s2         -- Selected input based on control signal
    );

  -- Initialize carry-in for LSB: '0' for addition, '1' for subtraction
  c(0) <= nAdd_Sub;

  -- Generate full adder for each bit
  G_fullAdder: for i in 0 to N-1 generate
    fullAdderlist: fullAdder 
      port map(
        i_X0  => i_A(i),  -- Input A bit
        i_X1  => s2(i),   -- Selected input B bit (original or inverted)
        i_Cin => c(i),    -- Carry-in from previous stage
        o_Y   => o_Y(i),  -- Output sum bit
        o_Cout => c(i+1)  -- Carry-out to next stage
      );
  end generate G_fullAdder;

  -- Output the final carry-out (or borrow-out in subtraction)
  o_Cout <= c(N);

end structural;

