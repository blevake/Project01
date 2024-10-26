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

entity mux2t1 is
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_S          : in std_logic;
       i_D0         : in std_logic;
       i_D1         : in std_logic;
       o_O          : out std_logic);

end mux2t1;

architecture structural of mux2t1 is

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

  component invg
    port(i_A             : in std_logic;
         o_F             : out std_logic);
  end component;

  -- Signal to carry not S
  signal s_SI        : std_logic;
  -- Signals to carry andg2
  signal s_T1        : std_logic;
  -- Signal to carry andg2
  signal s_T2        : std_logic;

begin
u0: invg
port map(
   i_A => i_S,
   o_F => s_SI);
-- and2 component instance
u1: andg2
port map(
   i_A => i_S,
   i_B => i_D1,
   o_F => s_T1);
-- and2 component instance
u2: andg2
port map(
   i_A => i_D0,
   i_B => S_SI,
   o_F => s_T2);
-- or2 component instance
u3: org2
port map(
   i_A => s_T2,
   i_B => s_T1,
   o_F => o_O);
  
end structural;
