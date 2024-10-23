
library IEEE;
use IEEE.std_logic_1164.all;

entity cla_adder is
  port (
    i_A       : in  std_logic_vector(31 downto 0);  -- Input A (32-bit)
    i_B       : in  std_logic_vector(31 downto 0);  -- Input B (32-bit)
    i_nAddSub : in  std_logic;                      -- Add/Subtract control
    o_C       : out std_logic;                      -- Carry out
    o_O       : out std_logic;                      -- Overflow
    o_S       : out std_logic_vector(31 downto 0)   -- Sum output (32-bit)
  );
end cla_adder;

architecture mixed of cla_adder is

  -- Component declarations
  component fullAdder is
    port (
      i_X0  : in  std_logic;
      i_X1  : in  std_logic;
      i_Cin : in  std_logic;
      o_Y : out std_logic;
      o_Cout  : out std_logic
    );
  end component;

  component xorg2 is
    port (
      i_A : in  std_logic;
      i_B : in  std_logic;
      o_F : out std_logic
    );
  end component;

  component mux2t1_N is
    port (
      i_S  : in  std_logic;
      i_D0 : in  std_logic_vector(31 downto 0);
      i_D1 : in  std_logic_vector(31 downto 0);
      o_O  : out std_logic_vector(31 downto 0)
    );
  end component;

  component onesComp_N is
    port (
      i_I : in  std_logic_vector(31 downto 0);
      o_O : out std_logic_vector(31 downto 0)
    );
  end component;

  -- Signals
  signal w_G, w_P, w_C, w_SUM : std_logic_vector(31 downto 0);  -- Intermediate signals
  signal s_NOTB, s_PMB        : std_logic_vector(31 downto 0);  -- Complement and Post Mux B signals

begin

  -- One's complement of i_B for subtraction
  g_onesComp: onesComp_N
    port map(
      i_I => i_B,      
      o_O => s_NOTB
    );

  -- 2-to-1 MUX for selecting between i_B or one's complement of i_B based on add/subtract control
  m_mux2t1: mux2t1_N
    port map(
      i_S  => i_nAddSub,      
      i_D0 => i_B,  
      i_D1 => s_NOTB,  
      o_O  => s_PMB
    );

  -- Full adder implementation for 32 bits
  G_NBit_FULL: for i in 0 to 31 generate
    FULLI: fullAdder 
      port map(
        i_X0  => i_A(i),
        i_X1  => s_PMB(i),
        i_Cin => w_C(i),
        o_Y => open,     
        o_Cout  => w_SUM(i)
      );
  end generate G_NBit_FULL;

  -- Generate Carry Lookahead logic for bits 0 to 30
  GEN_CLA : for j in 0 to 30 generate
    w_G(j)   <= i_A(j) and s_PMB(j);                -- Generate term: Gi = Ai * Bi
    w_P(j)   <= i_A(j) or s_PMB(j);                 -- Propagate term: Pi = Ai + Bi
    w_C(j+1) <= w_G(j) or (w_P(j) and w_C(j));      -- Carry term: C(j+1) = Gi + Pi * Cj
  end generate GEN_CLA;

  -- Final carry calculation for the last bit (31st bit)
  GEN_CLAEND : for j in 31 to 31 generate
    w_G(j)   <= i_A(j) and s_PMB(j);                -- Generate term for 31st bit
    w_P(j)   <= i_A(j) or s_PMB(j);                 -- Propagate term for 31st bit
    o_C      <= w_G(j) or (w_P(j) and w_C(j));      -- Final carry out
  end generate GEN_CLAEND;

  -- Overflow calculation by XOR-ing C31 (w_C(31)) and Cout (o_C)
  g_Xor: xorg2
    port map(
      i_A => w_C(31),
      i_B => o_C,
      o_F => o_O
    );

  -- Assign sum output
  w_C(0) <= i_nAddSub;  -- Initial carry input (0 for addition, 1 for subtraction)
  o_S <= w_SUM;         -- Assign final sum

end mixed;
