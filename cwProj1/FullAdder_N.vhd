-------------------------------------------------------------------------
-- Henry Duwe
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- FullAdder_N.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of an N-bit wide 2:1
-- mux using structural VHDL, generics, and generate statements.
--
--
-- NOTES:
-- 1/6/20 by H3::Created.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity FullAdder_N is
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
	port(i_A               : in std_logic_vector(N-1 downto 0);
       i_B               : in std_logic_vector(N-1 downto 0);
	i_Ci		: in std_logic;
       o_O               : out std_logic_vector(N-1 downto 0));

  end FullAdder_N;

architecture structural of FullAdder_N is

  component FullAdder is
    port(i_A               : in std_logic;
       i_B               : in std_logic;
	i_Ci		: in std_logic;
	o_Co		: out std_logic;
       o_O               : out std_logic);
  end component;

signal carry : std_logic_vector(n downto 0);

begin

carry(0) <= i_Ci;

  -- Instantiate N FullAdder instances.
  G_NBit_MUX: for i in 0 to N-1 generate
    MUXI: FullAdder port map(
              i_A     => i_A(i),
              i_B     => i_B(i),
		i_Ci     => carry(i),
		o_Co     => carry(i+1),
              o_O      => o_O(i)); 
  end generate G_NBit_MUX;

end structural;
