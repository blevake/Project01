-------------------------------------------------------------------------
-- Andrew Deick
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- mux2to1.vhd
-------------------------------------------------------------------------
-- NOTES:
-- 1/14/19 by H3::Design created.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;


entity mux2t1 is

  port(i_S 		            : in std_logic;
       i_D0 		        : in std_logic;
       i_D1 		        : in std_logic;
       o_O 		            : out std_logic);

end mux2t1;

architecture dataflow of mux2t1 is
  ------------

begin
	with i_S select
	o_O	<= 
		i_D0 when '0',
		i_D1 when '1',
		'0' when others;

  end dataflow;
