library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity luishift is

  port(i_A          : in std_logic_vector(31 downto 0);
       o_F          : out std_logic_vector(31 downto 0)
	);

end luishift;

architecture dataflow of luishift is
begin

  o_F <= std_logic_vector(shift_left(unsigned(i_A), 16));
  
end dataflow;