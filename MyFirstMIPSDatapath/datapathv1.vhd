library IEEE;
use IEEE.std_logic_1164.all;
use work.mypack.all;

entity datapathv1 is
  port(
    clk        : in std_logic;
    reset      : in std_logic;
    nAddSub    : in std_logic;
    ALUSrc     : in std_logic;
    wE         : in std_logic;
    i_A        : in std_logic_vector(4 downto 0);
    i_B        : in std_logic_vector(4 downto 0);
    i_C        : in std_logic_vector(4 downto 0);
    immediate  : in std_logic_vector(31 downto 0);
    o_d1       : out std_logic_vector(31 downto 0);
    o_d2       : out std_logic_vector(31 downto 0)
  );
end datapathv1;

architecture structural of datapathv1 is

  -- Component declarations
  component regfile
    port(
      clk     : in std_logic;
      i_wA    : in std_logic_vector(4 downto 0);
      i_wD    : in std_logic_vector(31 downto 0);
      i_wC    : in std_logic;
      i_r1    : in std_logic_vector(4 downto 0);
      i_r2    : in std_logic_vector(4 downto 0);
      reset   : in std_logic;
      o_d1    : out std_logic_vector(31 downto 0);
      o_d2    : out std_logic_vector(31 downto 0)
    );
  end component;

  component addersubtractor
    port(
      nAdd_Sub : in std_logic;
      i_A      : in std_logic_vector(31 downto 0);
      i_B      : in std_logic_vector(31 downto 0);
      o_Y      : out std_logic_vector(31 downto 0);
      o_Cout   : out std_logic
    );
  end component;

  component mux2t1_N
    port(
      i_S   : in std_logic;
      i_D0  : in std_logic_vector(31 downto 0);
      i_D1  : in std_logic_vector(31 downto 0);
      o_O   : out std_logic_vector(31 downto 0)
    );
  end component;

  -- Internal signals
  signal s1, s2, s3, s4 : std_logic_vector(31 downto 0);
  signal s5 : std_logic; -- Output from Cout, ignored

begin 

  -- Adder-subtractor component instantiation
  addsub: addersubtractor
    port map(nAddSub, s1, s3, s4, s5);
  
  -- Register file component instantiation
  registers: regfile
    port map(clk, i_C, s4, wE, i_A, i_B, reset, s1, s2);

  -- Multiplexer component instantiation
  ALUMux: mux2t1_N
    port map(ALUSrc, s2, immediate, s3);

  -- Outputs
  o_d1 <= s1;
  o_d2 <= s2;

end structural;

