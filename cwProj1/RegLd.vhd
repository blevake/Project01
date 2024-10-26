library IEEE;
use IEEE.std_logic_1164.all;

entity RegLd is

  port(iCLK             : in std_logic;
       iD               : in integer;
       iLd              : in integer;
       oQ               : out integer);

end RegLd;

architecture behavior of RegLd is
  signal sQ : integer;
begin

  process(iCLK, iLd, iD)
  begin
    if rising_edge(iCLK) then
      if (iLd = 1) then
        sQ <= iD;
      else
        sQ <= sQ;
      end if;
    end if;
  end process;

  oQ <= sQ; 
  
end behavior;
