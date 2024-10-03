-------------------------------------------------------------------------
-- Andrew Deick
-- Department of Software Engineering
-- Iowa State University
-------------------------------------------------------------------------


--fullAdder_n.vhd
-------------------------------------------------------------------------
--
-- NOTES:
-- 2/8/21 Created.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity fullAdder_n is
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_X0 	: in std_logic_vector(N-1 downto 0);
	   i_X1		: in std_logic_vector(N-1 downto 0);
	   i_Cin	: in std_logic;
	   o_Y		: out std_logic_vector(N-1 downto 0);
	   o_Cout	: out std_logic);

end fullAdder_n;

architecture structural of fullAdder_n is

  component fullAdder is
     port(i_X0 	: in std_logic;
	   i_X1		: in std_logic;
	   i_Cin	: in std_logic;
	   o_Y		: out std_logic;
	   o_Cout	: out std_logic);
  end component;
  
  signal c : std_logic_vector(N downto 0);

begin	
  -- Instantiate N mux instances.
	c(0) <= i_Cin;
	G_fullAdder: for i in 0 to N-1 generate
	fullAdderlist: fullAdder port map(
	   i_X0 	=> i_X0(i),
	   i_X1 	=> i_X1(i),
	   i_Cin	=> c(i),
	   o_Y 		=> o_Y(i),
	   o_Cout	=> c(i+1));
	end generate G_fullAdder;
	o_Cout <= c(N-1);

  
end structural;
