-------------------------------------------------------------------------
-- Henry Duwe
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- mux2t1_N.vhd
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

entity nadder is
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_A          : in std_logic_vector(N-1 downto 0);
       i_B          : in std_logic_vector(N-1 downto 0);
       i_Cin        : in std_logic;
       o_S          : out std_logic_vector(N-1 downto 0);
       o_Cout       : out std_logic);

end nadder;

architecture structural of nadder is

  component fadder is
  port(i_A          : in std_logic;
       i_B          : in std_logic;
       i_Cin        : in std_logic;
       o_S          : out std_logic;
       o_Cout       : out std_logic);
  end component;

  signal s_Cmid     : std_logic_vector(N-1 downto 0);

begin

  -- Instantiate N fadder instances.
  G_fadder1: fadder port map(
	      i_A      => i_A(0),
	      i_B      => i_B(0),
	      i_Cin    => i_Cin,
	      o_S      => o_S(0),
	      o_Cout   => s_Cmid(0));

  G_fadder2: for i in 1 to N-1 generate
    FadderI: fadder port map(
              i_A      => i_A(i),  -- ith instance's data 1 input hooked up to ith data 1 input.
              i_B      => i_B(i),  -- ith instance's data 1 input hooked up to ith data 1 input.
              i_Cin    => s_Cmid(i-1),  -- ith instance's data 1 input hooked up to ith data 1 input.
              o_S      => o_S(i),  -- ith instance's data output hooked up to ith data output.
              o_Cout   => s_Cmid(i));  -- ith instance's data output hooked up to ith data output.
  end generate G_fadder2;
  

end structural;
