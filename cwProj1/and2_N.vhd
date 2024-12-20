--Author: Spencer Opitz

library IEEE;
use IEEE.std_logic_1164.all;

entity and2_N is
	generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  	port(
		i_D0         : in std_logic_vector(N-1 downto 0);
       		i_D1         : in std_logic_vector(N-1 downto 0);
       		o_O          : out std_logic_vector(N-1 downto 0));

end and2_N;

architecture structural of and2_N is

component andg2 is
    	port(
	i_A          : in std_logic;
       	i_B          : in std_logic;
       	o_F          : out std_logic);
end component;

begin

  -- Instantiate N and instances.
  G_NBit_AND2: for i in 0 to N-1 generate
    AND2I: andg2 port map(
              i_A     => i_D0(i),
              i_B     => i_D1(i),
              o_F      => o_O(i));
  end generate G_NBit_AND2;
  
end structural;