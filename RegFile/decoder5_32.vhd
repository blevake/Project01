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
USE ieee.numeric_std.ALL; 

entity decoder5_32 is
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_C          : in std_logic_vector(4 downto 0);
       o_O          : out std_logic_vector(31 downto 0));

end decoder5_32;

architecture Dataflow of decoder5_32 is

begin

  G_decoder: for i in 0 to 31 generate
    o_O(i) <= '1' when (i=(to_integer(unsigned(i_C)))) else '0';
  end generate G_decoder;
  

end Dataflow;
