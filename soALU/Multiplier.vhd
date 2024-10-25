library IEEE;
use IEEE.std_logic_1164.all;

entity Multiplier is

  port(iCLK             : in std_logic;
       iA               : in integer;
       iB               : in integer;
       oC               : out integer);

end Multiplier;

architecture behavior of Multiplier is
begin

  process(iCLK, iA, iB)
  begin
    if rising_edge(iCLK) then
	   oC <= iA * iB;
    end if;
  end process;
  
end behavior;
