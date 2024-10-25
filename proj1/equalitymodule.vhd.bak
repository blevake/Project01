
library IEEE;
use IEEE.std_logic_1164.all;

entity equalityModule is

  port(i_A          : in std_logic_vector(31 downto 0);
       i_B          : in std_logic_vector(31 downto 0);
       o_F          : out std_logic);

end equalityModule;

architecture dataflow of equalityModule is

begin
UNLABELED:
	for i in 31 downto 0 loop
    o_F <= '1' when i_A(i) = i_B(i) else '0';

  
end dataflow;
