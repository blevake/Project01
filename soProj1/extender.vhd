library IEEE;
use IEEE.std_logic_1164.all;

entity extender is
  port(
    i_I  : in std_logic_vector(15 downto 0);
    i_C  : in std_logic;
    o_O  : out std_logic_vector(31 downto 0)
  );
end extender;

architecture behavior of extender is
begin
  process(i_I, i_C)
  begin
    for i in 0 to 15 loop
      o_O(i) <= i_I(i);
    end loop;
    for i in 16 to 31 loop
      o_O(i) <= (i_I(15) and i_C);
    end loop;
  end process;
end behavior;