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

entity AddSubn is
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_A          : in std_logic_vector(N-1 downto 0);
       i_B          : in std_logic_vector(N-1 downto 0);
       i_nAdd_Sub   : in std_logic;
       o_SS         : out std_logic_vector(N-1 downto 0);
       o_Co         : out std_logic);

end AddSubn;

architecture structural of AddSubn is

  signal s_T1 : std_logic_vector(N-1 downto 0);
  signal s_T2 : std_logic_vector(N-1 downto 0);

  component nadder is
  port(i_A          : in std_logic_vector(N-1 downto 0);
       i_B          : in std_logic_vector(N-1 downto 0);
       i_Cin        : in std_logic;
       o_S          : out std_logic_vector(N-1 downto 0);
       o_Cout       : out std_logic);

  end component;

  component onecomp is
  port(i_A          : in std_logic_vector(N-1 downto 0);
       o_F          : out std_logic_vector(N-1 downto 0));
  end component;

  component mux2t1_N is
  port(i_S          : in std_logic;
       i_D0         : in std_logic_vector(N-1 downto 0);
       i_D1         : in std_logic_vector(N-1 downto 0);
       o_O          : out std_logic_vector(N-1 downto 0));
  end component;

begin

  -- Instantiate
  onecomp1: onecomp port map(
	      i_A      => i_B,
	      o_F      => s_T1);

  mux1: mux2t1_N port map(
              i_S      => i_nAdd_Sub,
              i_D0     => i_B,
              i_D1     => s_T1,
              o_O      => s_T2);

  add1: nadder port map(
              i_A      => i_A,
              i_B      => s_T2,
              i_Cin    => i_nAdd_Sub,
              o_S      => o_SS,
              o_Cout   => o_Co);
  

end structural;
