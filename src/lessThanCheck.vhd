library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;

entity lessThanCheck is
  port(
    i_A : in std_logic_vector(31 downto 0);
    i_B : in std_logic_vector(31 downto 0);
    o_F : out std_logic_vector(31 downto 0)
  );
end lessThanCheck;

architecture dataflow of lessThanCheck is
  signal s_A, s_B : std_logic_vector(31 downto 0);
begin
  s_A <= i_A;
  s_B <= i_B;

  o_F <= "00000000000000000000000000000001" when s_A < s_B else
         "00000000000000000000000000000000";
end dataflow;