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

entity fadder is
  generic(N : integer := 16); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_A          : in std_logic;
       i_B         : in std_logic;
       i_Cin         : in std_logic;
       o_S          : out std_logic;
       o_Cout       :  out std_logic);

end fadder;

architecture structural of fadder is

  component andg2
    port(i_A           : in std_logic;
         i_B             : in std_logic;
         o_F             : out std_logic);
  end component;
  
  component org2
    port(i_A           : in std_logic;
         i_B             : in std_logic;
         o_F             : out std_logic);
  end component;

  component xorg2
    port(i_A           : in std_logic;
         i_B             : in std_logic;
         o_F             : out std_logic);
  end component;

  component invg
    port(i_A             : in std_logic;
         o_F             : out std_logic);
  end component;

  -- Signal to carry not AxorB
  signal s_X1        : std_logic;
  -- Signals to carry andg1
  signal s_T1        : std_logic;
  -- Signal to carry andg2
  signal s_T2        : std_logic;

begin
u0: xorg2
port map(
   i_A => i_A,
   i_B => i_B,
   o_F => s_X1);
-- and2 component instance
u1: andg2
port map(
   i_A => i_A,
   i_B => i_B,
   o_F => s_T1);
-- and2 component instance
u2: andg2
port map(
   i_A => s_X1,
   i_B => i_Cin,
   o_F => s_T2);
-- or2 component instance
u3: org2
port map(
   i_A => s_T2,
   i_B => s_T1,
   o_F => o_Cout);
-- xor2 component instance
u4: xorg2
port map(
   i_A => s_X1,
   i_B => i_Cin,
   o_F => o_S);

end structural;
