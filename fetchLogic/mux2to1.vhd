
--Spencer Opitz



library IEEE;
use IEEE.std_logic_1164.all;

entity mux2to1 is

  port(i_S               : in std_logic;
       i_D0               : in std_logic;
	i_D1		: in std_logic;
       o_O               : out std_logic);

end mux2to1;

architecture mixed of mux2to1 is

component andg2 is

  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);
end component;

component org2 is

  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);

end component;

component invg is

  port(i_A          : in std_logic;
       o_F          : out std_logic);

end component;

  -- Signal after not
  signal s_1         : std_logic;
  -- signal from top and to or
  signal s_2   : std_logic;
  -- Signal from bottom and to or
  signal s_3        : std_logic;

begin

  ---------------------------------------------------------------------------
  -- Level 0: not iz
  ---------------------------------------------------------------------------
 
  g_notinput: invg
    port MAP(i_A             => i_S,
             o_F               => s_1);


  ---------------------------------------------------------------------------
  -- Level 1: x&!z; y&z
  ---------------------------------------------------------------------------
  g_topand: andg2
    port MAP(i_A             => i_D0,
             i_B               => s_1,
             o_F               => s_2);
  
  g_botand: andg2
    port MAP(i_A             => i_D1,
             i_B               => i_S,
             o_F               => s_3);

  ---------------------------------------------------------------------------
  -- Level 2: or the remaining 2
  ---------------------------------------------------------------------------
  g_or: org2
    port MAP(i_A             => s_2,
             i_B               => s_3,
             o_F               => o_O);

 end mixed;