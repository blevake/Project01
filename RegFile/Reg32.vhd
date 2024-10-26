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

entity Reg32 is
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_D          : in std_logic_vector(N-1 downto 0);
       i_RST        : in std_logic;
       i_WE         : in std_logic;
       i_CLK        : in std_logic;
       o_Q          : out std_logic_vector(N-1 downto 0));

end Reg32;

architecture structural of Reg32 is

  component dffg is
  port(i_CLK        : in std_logic;
       i_RST        : in std_logic;
       i_WE         : in std_logic;
       i_D          : in std_logic;
       o_Q          : out std_logic);
  end component;

begin

  G_dffg: for i in 0 to N-1 generate
    dffgI: dffg port map(
              i_CLK      => i_CLK,  -- ith instance's data 1 input hooked up to ith data 1 input.
              i_RST      => i_RST,  -- ith instance's data 1 input hooked up to ith data 1 input.
              i_WE       => i_WE,  -- ith instance's data 1 input hooked up to ith data 1 input.
              i_D        => i_D(i),  -- ith instance's data output hooked up to ith data output.
              o_Q        => o_Q(i));  -- ith instance's data output hooked up to ith data output.
  end generate G_dffg;
  

end structural;
