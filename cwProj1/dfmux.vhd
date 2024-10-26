library IEEE;
use IEEE.std_logic_1164.all;


entity dfmux is

  port(i_S 		     : in std_logic;
       i_D0 		     : in std_logic;
       i_D1 		     : in std_logic;
       o_O 		     : out std_logic);

end dfmux;

architecture dataflow of dfmux is
  begin
  
  o_O <= (((not i_S) and i_D0) or (i_S and i_D1));

end dataflow;
