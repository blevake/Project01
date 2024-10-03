library IEEE;
use IEEE.std_logic_1164.all;

entity fullAdder is
  port(
    i_X0   : in std_logic;
    i_X1   : in std_logic;
    i_Cin  : in std_logic;
    o_Y    : out std_logic;
    o_Cout : out std_logic
  );
end fullAdder;

architecture structural of fullAdder is
  component xorg2
    port(i_A, i_B : in std_logic; o_F : out std_logic);
  end component;
  
  component andg2
    port(i_A, i_B : in std_logic; o_F : out std_logic);
  end component;
  
  component org2
    port(i_A, i_B : in std_logic; o_F : out std_logic);
  end component;

  signal s1, s2, s3 : std_logic;

begin
  xor1: xorg2 port map(i_X0, i_X1, s1);
  xor2: xorg2 port map(s1, i_Cin, o_Y);
  and1: andg2 port map(s1, i_Cin, s2);
  and2: andg2 port map(i_X0, i_X1, s3);
  or1: org2 port map(s2, s3, o_Cout);
end structural;

