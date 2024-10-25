library IEEE;
use IEEE.std_logic_1164.all;

entity beq_bne is
  port (
    i_F         : in  std_logic_vector(31 downto 0); -- 32-bit input
    i_equal_type: in  std_logic;                    -- 0 for BNE, 1 for BEQ
    o_zero      : out std_logic                     -- Output zero flag
  );
end beq_bne;


architecture structural of beq_bne is

  component org2 is
    port (
      i_A : in  std_logic;                           -- OR input A
      i_B : in  std_logic;                           -- OR input B
      o_F : out std_logic                            -- OR output
    );
  end component;

  component xorg2 is
    port (
      i_A : in  std_logic;                           -- XOR input A
      i_B : in  std_logic;                           -- XOR input B
      o_F : out std_logic                            -- XOR output
    );
  end component;

  -- Internal signals for the OR tree structure
  signal s_oOR1         : std_logic_vector(15 downto 0);  -- OR results of 32 bits down to 16 bits
  signal s_oOR2         : std_logic_vector(7 downto 0);   -- OR results of 16 bits down to 8 bits
  signal s_oOR3         : std_logic_vector(3 downto 0);   -- OR results of 8 bits down to 4 bits
  signal s_oOR4         : std_logic_vector(1 downto 0);   -- OR results of 4 bits down to 2 bits
  signal s_or_tree_out_bne : std_logic;                   -- Final OR result for BNE

begin

  -- Instantiate 16 OR gates to reduce 32 input bits to 16 bits
  FIRST_OR: for i in 0 to 15 generate
    OR1: org2
      port map(
        i_A => i_F(i*2),         -- OR the even-indexed bits
        i_B => i_F(i*2+1),       -- OR the odd-indexed bits
        o_F => s_oOR1(i)         -- Output is the OR result
      );
  end generate FIRST_OR;
  
  -- Instantiate 8 OR gates to reduce 16 bits to 8 bits
  SECOND_OR: for i in 0 to 7 generate
    OR2: org2
      port map(
        i_A => s_oOR1(i*2),      -- OR the results from s_oOR1
        i_B => s_oOR1(i*2+1),
        o_F => s_oOR2(i)
      );
  end generate SECOND_OR;

  -- Instantiate 4 OR gates to reduce 8 bits to 4 bits
  THIRD_OR: for i in 0 to 3 generate
    OR3: org2
      port map(
        i_A => s_oOR2(i*2),      -- OR the results from s_oOR2
        i_B => s_oOR2(i*2+1),
        o_F => s_oOR3(i)
      );
  end generate THIRD_OR;

  -- Instantiate 2 OR gates to reduce 4 bits to 2 bits
  FOURTH_OR: for i in 0 to 1 generate
    OR4: org2
      port map(
        i_A => s_oOR3(i*2),      -- OR the results from s_oOR3
        i_B => s_oOR3(i*2+1),
        o_F => s_oOR4(i)
      );
  end generate FOURTH_OR;

  -- Final OR gate to reduce 2 bits to 1 bit
  output_or: org2
    port map(
      i_A => s_oOR4(0),          -- OR the 2 remaining bits
      i_B => s_oOR4(1),
      o_F => s_or_tree_out_bne
    );

  -- XOR the final OR result with the equal type (BEQ/BNE control)
  output: xorg2
    port map(
      i_A => s_or_tree_out_bne,  -- OR tree output
      i_B => i_equal_type,       -- Control for BEQ/BNE
      o_F => o_zero              -- Output zero flag
    );

end structural;
