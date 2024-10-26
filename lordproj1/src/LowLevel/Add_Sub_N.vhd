-------------------------------------------------------------------------
-- Henry Duwe
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- Add_Sub_N.vhd
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

entity Add_Sub_N is
  generic(N : integer := 32);
	port(
	i_A               : in std_logic_vector(N-1 downto 0);
	i_B               : in std_logic_vector(N-1 downto 0);
	i_Add_Sub		: in std_logic; --set to 1 for subtraction and 0 for addition
	o_O               : out std_logic_vector(N-1 downto 0));

  end Add_Sub_N;

architecture structural of Add_Sub_N is

--START OF COMPONENTS--

  component FullAdder_N is
  generic(N : integer := 32);
	port(i_A               : in std_logic_vector(N-1 downto 0);
       i_B               : in std_logic_vector(N-1 downto 0);
	i_Ci		: in std_logic;
       o_O               : out std_logic_vector(N-1 downto 0));

  end component;

component invg_N is
  generic(N : integer := 32);
  port(i_I          : in std_logic_vector(N-1 downto 0);
       o_O          : out std_logic_vector(N-1 downto 0));
end component;

component mux2t1_N is
  generic(N : integer := 32);
  port(i_S          : in std_logic;
       i_D0         : in std_logic_vector(N-1 downto 0);
       i_D1         : in std_logic_vector(N-1 downto 0);
       o_O          : out std_logic_vector(N-1 downto 0));

end component;
 

--END OF COMPONENTS
  signal s_invtomux         : std_logic_vector(N-1 downto 0);
  signal s_muxtoadd         : std_logic_vector(N-1 downto 0);

begin
 ---------------------------------------------------------------------------
  -- Level 0: Invert
  ---------------------------------------------------------------------------
 
  g_1: invg_N
    port MAP(i_I             => i_B,
		o_O		=> s_invtomux);

  ---------------------------------------------------------------------------
  -- Level 1: MUX
  ---------------------------------------------------------------------------
  g_2: mux2t1_N
    port MAP(i_S             => i_Add_Sub,
		i_D0		=> i_B,
		i_D1		=> s_invtomux,
             o_O               => s_muxtoadd);


  ---------------------------------------------------------------------------
  -- Level 2: Add er up!!
  ---------------------------------------------------------------------------
  g_3: FullAdder_N
    port MAP(i_A             => i_A,
             i_B               => s_muxtoadd,
		i_Ci               => i_Add_Sub,
             o_O               => o_O);


end structural;
