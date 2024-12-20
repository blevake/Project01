library IEEE;
use IEEE.std_logic_1164.all;

entity mux16t1_32 is
  port (
    i_S  : in  std_logic_vector(3 downto 0); --d signals are in octal
    i_D00 : in  std_logic_vector(31 downto 0);
    i_D01 : in  std_logic_vector(31 downto 0);
    i_D02 : in  std_logic_vector(31 downto 0);
    i_D03 : in  std_logic_vector(31 downto 0);
    i_D04 : in  std_logic_vector(31 downto 0);
    i_D05 : in  std_logic_vector(31 downto 0);
    i_D06 : in  std_logic_vector(31 downto 0);
    i_D07 : in  std_logic_vector(31 downto 0);
	i_D10 : in  std_logic_vector(31 downto 0);
    i_D11 : in  std_logic_vector(31 downto 0);
    i_D12 : in  std_logic_vector(31 downto 0);
    i_D13 : in  std_logic_vector(31 downto 0);
    i_D14 : in  std_logic_vector(31 downto 0);
    i_D15 : in  std_logic_vector(31 downto 0);
    i_D16 : in  std_logic_vector(31 downto 0);
    i_D17 : in  std_logic_vector(31 downto 0);
    o_O  : out std_logic_vector(31 downto 0)
  );
end mux16t1_32;


architecture structural of mux16t1_32 is

signal s1 : std_logic_vector(31 downto 0);
signal s2 : std_logic_vector(31 downto 0);


component mux8t1_32 is
  port (
    i_S  : in  std_logic_vector(2 downto 0);
    i_D0 : in  std_logic_vector(31 downto 0);
    i_D1 : in  std_logic_vector(31 downto 0);
    i_D2 : in  std_logic_vector(31 downto 0);
    i_D3 : in  std_logic_vector(31 downto 0);
    i_D4 : in  std_logic_vector(31 downto 0);
    i_D5 : in  std_logic_vector(31 downto 0);
    i_D6 : in  std_logic_vector(31 downto 0);
    i_D7 : in  std_logic_vector(31 downto 0);
    o_O  : out std_logic_vector(31 downto 0)
  );
end component;

component mux2t1_N is
    port (
      i_S  : in  std_logic;
      i_D0 : in  std_logic_vector(31 downto 0);
      i_D1 : in  std_logic_vector(31 downto 0);
      o_O  : out std_logic_vector(31 downto 0)
    );
  end component;

  signal s_muxOut1, s_muxOut2, s_muxOut3, s_muxOut4, s_muxOut5, s_muxOut6 : std_logic_vector(31 downto 0);

begin

  MUX1: mux8t1_32
    port map (
	i_S  => i_S (2 downto 0),
    i_D0 => i_D00,
    i_D1 => i_D01,
    i_D2 => i_D02,
    i_D3 => i_D03,
    i_D4 => i_D04,
    i_D5 => i_D05,
    i_D6 => i_D06,
    i_D7 => i_D07,
    o_O  => s1
    );

    MUX2: mux8t1_32
    port map (
	i_S  => i_S (2 downto 0),
    i_D0 => i_D10,
    i_D1 => i_D11,
    i_D2 => i_D12,
    i_D3 => i_D13,
    i_D4 => i_D14,
    i_D5 => i_D15,
    i_D6 => i_D16,
    i_D7 => i_D17,
    o_O  => s2
    );

  MUX3: mux2t1_N
    port map (
      i_D0 => s1,
      i_D1 => s2,
      i_S  => i_S(3),
      o_O  => o_O
    );

end structural;