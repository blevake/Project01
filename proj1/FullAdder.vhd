
--Spencer Opitz



library IEEE;
use IEEE.std_logic_1164.all;

entity FullAdder is

  port(i_A               : in std_logic;
       i_B               : in std_logic;
	i_Ci		: in std_logic;
	o_Co		: out std_logic;
       o_O               : out std_logic);

end FullAdder;

architecture mixed of FullAdder is

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

component xorg2 is

  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);

end component;

  -- graph of logic contains numbered logic gates
  signal s_1to3and4         : std_logic;
  signal s_2to5        : std_logic;
  signal s_4to5		:std_logic;

begin

  ---------------------------------------------------------------------------
  -- Level 0: logic gates 1 & 2
  ---------------------------------------------------------------------------
 
  g_1: xorg2
    port MAP(i_A             => i_A,
		i_B		=> i_B,
             o_F               => s_1to3and4);

g_2: andg2
     port MAP(i_A             => i_A,
		i_B		=> i_B,
             o_F               => s_2to5);


  ---------------------------------------------------------------------------
  -- Level 1: logic gates 3 and 4
  ---------------------------------------------------------------------------
  g_3: xorg2
    port MAP(i_A             => s_1to3and4,
		i_B		=> i_Ci,
             o_F               => o_O);
  
g_4: andg2
     port MAP(i_A             => s_1to3and4,
		i_B		=> i_Ci,
             o_F               => s_4to5);

  ---------------------------------------------------------------------------
  -- Level 2: logic gate 5
  ---------------------------------------------------------------------------
  g_5: org2
    port MAP(i_A             => s_4to5,
             i_B               => s_2to5,
             o_F               => o_Co);

 end mixed;