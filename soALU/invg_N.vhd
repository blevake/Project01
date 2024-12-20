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

entity invg_N is
  generic(N : integer := 4); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_I          : in std_logic_vector(N-1 downto 0);
       o_O          : out std_logic_vector(N-1 downto 0));
end invg_N;

architecture structural of invg_N is

 component invg is
  port(i_A          : in std_logic;
       o_F          : out std_logic);
end component;

begin

  -- Instantiate N mux instances.
  G_NBit_INVG: for i in 0 to N-1 generate
    INV: invg port map(
              i_A      => i_I(i),      -- All instances share the same select input.
              o_F      => o_O(i));  -- ith instance's data output hooked up to ith data output.
  end generate G_NBit_INVG;
  
end structural;
