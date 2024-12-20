
library IEEE;
use IEEE.std_logic_1164.all;

entity onesComp_N is
  generic(N : integer := 32);  -- Generic for input/output data width, default is 32 bits.
  port (
    i_I : in  std_logic_vector(N-1 downto 0);  -- Input vector (N bits)
    o_O : out std_logic_vector(N-1 downto 0)   -- Output vector (N bits), one's complement of input
  );
end onesComp_N;

architecture structural of onesComp_N is

  -- Component declaration for 1-bit one's complementor
  component onesComp is
    port (
      i_I : in  std_logic;  -- 1-bit input
      o_O : out std_logic   -- 1-bit output (inverted input)
    );
  end component;

begin

  G_NBit_ONES: for i in 0 to N-1 generate
    ONESI: onesComp 
      port map(
        i_I => i_I(i),  -- Map each bit of the input
        o_O => o_O(i)   -- Map each bit of the output (one's complement)
      );
  end generate G_NBit_ONES;
  
end structural;
