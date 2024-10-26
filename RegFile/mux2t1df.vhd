-------------------------------------------------------------------------
-- Joseph Zambreno
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- Adder.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a behavioral 
-- adder operating on integer inputs. 
--
--
-- NOTES: Integer data type is not typically useful when doing hardware
-- design. We use it here for simplicity, but in future labs it will be
-- important to switch to std_logic_vector types and associated math
-- libraries (e.g. signed, unsigned). 


-- 8/19/09 by JAZ::Design created.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity mux2t1df is

  port(i_D0               : in std_logic;
       i_D1               : in std_logic;
       i_S                : in std_logic;
       o_O               : out std_logic);

end mux2t1df;

architecture Dataflow of mux2t1df is
begin

    o_O <= i_D0 when (i_S='0') else
          i_D1;


end Dataflow;
