-------------------------------------------------------------------------
-- Henry Duwe
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- mux2t1_N.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of an N-bit wide 2:1
-- mux using structural VHDL, generics, and generate statements.
--
--
-- NOTES:
-- 1/6/20 by H3::Created.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity regfile is
  port(i_D          : in std_logic_vector(31 downto 0);
       i_R1         : in std_logic_vector(4 downto 0);
       i_R2         : in std_logic_vector(4 downto 0);
       i_WE         : in std_logic;
       i_W          : in std_logic_vector(4 downto 0);
       i_RST        : in std_logic;
       i_CLK        : in std_logic;
       o_O1          : out std_logic_vector(31 downto 0);
       o_O2          : out std_logic_vector(31 downto 0));

end regfile;

architecture structural of regfile is

  component Reg32 is
  port(i_D          : in std_logic_vector(31 downto 0);
       i_RST        : in std_logic;
       i_WE         : in std_logic;
       i_CLK        : in std_logic;
       o_Q          : out std_logic_vector(31 downto 0));
  end component;

  component mux32t1 is
  port(i_S          : in std_logic_vector(4 downto 0);
       i_D0         : in std_logic_vector(31 downto 0);
       i_D1         : in std_logic_vector(31 downto 0);
       i_D2         : in std_logic_vector(31 downto 0);
       i_D3         : in std_logic_vector(31 downto 0);
       i_D4         : in std_logic_vector(31 downto 0);
       i_D5         : in std_logic_vector(31 downto 0);
       i_D6         : in std_logic_vector(31 downto 0);
       i_D7         : in std_logic_vector(31 downto 0);
       i_D8         : in std_logic_vector(31 downto 0);
       i_D9         : in std_logic_vector(31 downto 0);
       i_D10         : in std_logic_vector(31 downto 0);
       i_D11         : in std_logic_vector(31 downto 0);
       i_D12         : in std_logic_vector(31 downto 0);
       i_D13         : in std_logic_vector(31 downto 0);
       i_D14         : in std_logic_vector(31 downto 0);
       i_D15         : in std_logic_vector(31 downto 0);
       i_D16         : in std_logic_vector(31 downto 0);
       i_D17         : in std_logic_vector(31 downto 0);
       i_D18         : in std_logic_vector(31 downto 0);
       i_D19         : in std_logic_vector(31 downto 0);
       i_D20         : in std_logic_vector(31 downto 0);
       i_D21         : in std_logic_vector(31 downto 0);
       i_D22         : in std_logic_vector(31 downto 0);
       i_D23         : in std_logic_vector(31 downto 0);
       i_D24         : in std_logic_vector(31 downto 0);
       i_D25         : in std_logic_vector(31 downto 0);
       i_D26         : in std_logic_vector(31 downto 0);
       i_D27         : in std_logic_vector(31 downto 0);
       i_D28         : in std_logic_vector(31 downto 0);
       i_D29         : in std_logic_vector(31 downto 0);
       i_D30         : in std_logic_vector(31 downto 0);
       i_D31         : in std_logic_vector(31 downto 0);
       o_O           : out std_logic_vector(31 downto 0));
  end component;

  component decoder5t32 is
  port(i_C          : in std_logic_vector(4 downto 0);
       o_O          : out std_logic_vector(31 downto 0));
  end component;

  signal s_WS : std_logic_vector(31 downto 0);
  signal s_O0 : std_logic_vector(31 downto 0);
  signal s_O1 : std_logic_vector(31 downto 0);
  signal s_O2 : std_logic_vector(31 downto 0);
  signal s_O3 : std_logic_vector(31 downto 0);
  signal s_O4 : std_logic_vector(31 downto 0);
  signal s_O5 : std_logic_vector(31 downto 0);
  signal s_O6 : std_logic_vector(31 downto 0);
  signal s_O7 : std_logic_vector(31 downto 0);
  signal s_O8 : std_logic_vector(31 downto 0);
  signal s_O9 : std_logic_vector(31 downto 0);
  signal s_O10 : std_logic_vector(31 downto 0);
  signal s_O11 : std_logic_vector(31 downto 0);
  signal s_O12 : std_logic_vector(31 downto 0);
  signal s_O13 : std_logic_vector(31 downto 0);
  signal s_O14 : std_logic_vector(31 downto 0);
  signal s_O15 : std_logic_vector(31 downto 0);
  signal s_O16 : std_logic_vector(31 downto 0);
  signal s_O17 : std_logic_vector(31 downto 0);
  signal s_O18 : std_logic_vector(31 downto 0);
  signal s_O19 : std_logic_vector(31 downto 0);
  signal s_O20 : std_logic_vector(31 downto 0);
  signal s_O21 : std_logic_vector(31 downto 0);
  signal s_O22 : std_logic_vector(31 downto 0);
  signal s_O23 : std_logic_vector(31 downto 0);
  signal s_O24 : std_logic_vector(31 downto 0);
  signal s_O25 : std_logic_vector(31 downto 0);
  signal s_O26 : std_logic_vector(31 downto 0);
  signal s_O27 : std_logic_vector(31 downto 0);
  signal s_O28 : std_logic_vector(31 downto 0);
  signal s_O29 : std_logic_vector(31 downto 0);
  signal s_O30 : std_logic_vector(31 downto 0);
  signal s_O31 : std_logic_vector(31 downto 0);
  

begin

  dec1: decoder5t32 port map(
       i_C          => i_W,
       o_O          => s_WS);


  Reg0: Reg32 port map( 
       i_D          => i_D,
       i_RST        => i_RST,
       i_WE         => i_WE and s_WS(0),
       i_CLK        => i_CLK,
       o_Q          => s_O0);

  Reg1: Reg32 port map( 
       i_D          => i_D,
       i_RST        => i_RST,
       i_WE         => i_WE and s_WS(1),
       i_CLK        => i_CLK,
       o_Q          => s_O1);

  Reg2: Reg32 port map( 
       i_D          => i_D,
       i_RST        => i_RST,
       i_WE         => i_WE and s_WS(2),
       i_CLK        => i_CLK,
       o_Q          => s_O2);

  Reg3: Reg32 port map( 
       i_D          => i_D,
       i_RST        => i_RST,
       i_WE         => i_WE and s_WS(3),
       i_CLK        => i_CLK,
       o_Q          => s_O3);

  Reg4: Reg32 port map( 
       i_D          => i_D,
       i_RST        => i_RST,
       i_WE         => i_WE and s_WS(4),
       i_CLK        => i_CLK,
       o_Q          => s_O4);

  Reg5: Reg32 port map( 
       i_D          => i_D,
       i_RST        => i_RST,
       i_WE         => i_WE and s_WS(5),
       i_CLK        => i_CLK,
       o_Q          => s_O5);

  Reg6: Reg32 port map( 
       i_D          => i_D,
       i_RST        => i_RST,
       i_WE         => i_WE and s_WS(6),
       i_CLK        => i_CLK,
       o_Q          => s_O6);

  Reg7: Reg32 port map( 
       i_D          => i_D,
       i_RST        => i_RST,
       i_WE         => i_WE and s_WS(7),
       i_CLK        => i_CLK,
       o_Q          => s_O7);

  Reg8: Reg32 port map( 
       i_D          => i_D,
       i_RST        => i_RST,
       i_WE         => i_WE and s_WS(8),
       i_CLK        => i_CLK,
       o_Q          => s_O8);

  Reg9: Reg32 port map( 
       i_D          => i_D,
       i_RST        => i_RST,
       i_WE         => i_WE and s_WS(9),
       i_CLK        => i_CLK,
       o_Q          => s_O9);

  Reg10: Reg32 port map( 
       i_D          => i_D,
       i_RST        => i_RST,
       i_WE         => i_WE and s_WS(10),
       i_CLK        => i_CLK,
       o_Q          => s_O10);

  Reg11: Reg32 port map( 
       i_D          => i_D,
       i_RST        => i_RST,
       i_WE         => i_WE and s_WS(11),
       i_CLK        => i_CLK,
       o_Q          => s_O11);

  Reg12: Reg32 port map( 
       i_D          => i_D,
       i_RST        => i_RST,
       i_WE         => i_WE and s_WS(12),
       i_CLK        => i_CLK,
       o_Q          => s_O12);

  Reg13: Reg32 port map( 
       i_D          => i_D,
       i_RST        => i_RST,
       i_WE         => i_WE and s_WS(13),
       i_CLK        => i_CLK,
       o_Q          => s_O13);

  Reg14: Reg32 port map( 
       i_D          => i_D,
       i_RST        => i_RST,
       i_WE         => i_WE and s_WS(14),
       i_CLK        => i_CLK,
       o_Q          => s_O14);

  Reg15: Reg32 port map( 
       i_D          => i_D,
       i_RST        => i_RST,
       i_WE         => i_WE and s_WS(15),
       i_CLK        => i_CLK,
       o_Q          => s_O15);

  Reg16: Reg32 port map( 
       i_D          => i_D,
       i_RST        => i_RST,
       i_WE         => i_WE and s_WS(16),
       i_CLK        => i_CLK,
       o_Q          => s_O16);

  Reg17: Reg32 port map( 
       i_D          => i_D,
       i_RST        => i_RST,
       i_WE         => i_WE and s_WS(17),
       i_CLK        => i_CLK,
       o_Q          => s_O17);

  Reg18: Reg32 port map( 
       i_D          => i_D,
       i_RST        => i_RST,
       i_WE         => i_WE and s_WS(18),
       i_CLK        => i_CLK,
       o_Q          => s_O18);

  Reg19: Reg32 port map( 
       i_D          => i_D,
       i_RST        => i_RST,
       i_WE         => i_WE and s_WS(19),
       i_CLK        => i_CLK,
       o_Q          => s_O19);

  Reg20: Reg32 port map( 
       i_D          => i_D,
       i_RST        => i_RST,
       i_WE         => i_WE and s_WS(20),
       i_CLK        => i_CLK,
       o_Q          => s_O20);

  Reg21: Reg32 port map( 
       i_D          => i_D,
       i_RST        => i_RST,
       i_WE         => i_WE and s_WS(21),
       i_CLK        => i_CLK,
       o_Q          => s_O21);

  Reg22: Reg32 port map( 
       i_D          => i_D,
       i_RST        => i_RST,
       i_WE         => i_WE and s_WS(22),
       i_CLK        => i_CLK,
       o_Q          => s_O22);

  Reg23: Reg32 port map( 
       i_D          => i_D,
       i_RST        => i_RST,
       i_WE         => i_WE and s_WS(23),
       i_CLK        => i_CLK,
       o_Q          => s_O23);

  Reg24: Reg32 port map( 
       i_D          => i_D,
       i_RST        => i_RST,
       i_WE         => i_WE and s_WS(24),
       i_CLK        => i_CLK,
       o_Q          => s_O24);

  Reg25: Reg32 port map( 
       i_D          => i_D,
       i_RST        => i_RST,
       i_WE         => i_WE and s_WS(25),
       i_CLK        => i_CLK,
       o_Q          => s_O25);

  Reg26: Reg32 port map( 
       i_D          => i_D,
       i_RST        => i_RST,
       i_WE         => i_WE and s_WS(26),
       i_CLK        => i_CLK,
       o_Q          => s_O26);

  Reg27: Reg32 port map( 
       i_D          => i_D,
       i_RST        => i_RST,
       i_WE         => i_WE and s_WS(27),
       i_CLK        => i_CLK,
       o_Q          => s_O27);

  Reg28: Reg32 port map( 
       i_D          => i_D,
       i_RST        => i_RST,
       i_WE         => i_WE and s_WS(28),
       i_CLK        => i_CLK,
       o_Q          => s_O28);

  Reg29: Reg32 port map( 
       i_D          => i_D,
       i_RST        => i_RST,
       i_WE         => i_WE and s_WS(29),
       i_CLK        => i_CLK,
       o_Q          => s_O29);

  Reg30: Reg32 port map( 
       i_D          => i_D,
       i_RST        => i_RST,
       i_WE         => i_WE and s_WS(30),
       i_CLK        => i_CLK,
       o_Q          => s_O30);

  Reg31: Reg32 port map( 
       i_D          => i_D,
       i_RST        => i_RST,
       i_WE         => i_WE and s_WS(31),
       i_CLK        => i_CLK,
       o_Q          => s_O31);

  mux1: mux32t1 port map(
       i_S          => i_R1,
       i_D0         => s_O0,
       i_D1         => s_O1,
       i_D2         => s_O2,
       i_D3         => s_O3,
       i_D4         => s_O4,
       i_D5         => s_O5,
       i_D6         => s_O6,
       i_D7         => s_O7,
       i_D8         => s_O8,
       i_D9         => s_O9,
       i_D10         => s_O10,
       i_D11         => s_O11,
       i_D12         => s_O12,
       i_D13         => s_O13,
       i_D14         => s_O14,
       i_D15         => s_O15,
       i_D16         => s_O16,
       i_D17         => s_O17,
       i_D18         => s_O18,
       i_D19         => s_O19,
       i_D20         => s_O20,
       i_D21         => s_O21,
       i_D22         => s_O22,
       i_D23         => s_O23,
       i_D24         => s_O24,
       i_D25         => s_O25,
       i_D26         => s_O26,
       i_D27         => s_O27,
       i_D28         => s_O28,
       i_D29         => s_O29,
       i_D30         => s_O30,
       i_D31         => s_O31,
       o_O           => o_O1);

  mux2: mux32t1 port map(
       i_S          => i_R2,
       i_D0         => s_O0,
       i_D1         => s_O1,
       i_D2         => s_O2,
       i_D3         => s_O3,
       i_D4         => s_O4,
       i_D5         => s_O5,
       i_D6         => s_O6,
       i_D7         => s_O7,
       i_D8         => s_O8,
       i_D9         => s_O9,
       i_D10         => s_O10,
       i_D11         => s_O11,
       i_D12         => s_O12,
       i_D13         => s_O13,
       i_D14         => s_O14,
       i_D15         => s_O15,
       i_D16         => s_O16,
       i_D17         => s_O17,
       i_D18         => s_O18,
       i_D19         => s_O19,
       i_D20         => s_O20,
       i_D21         => s_O21,
       i_D22         => s_O22,
       i_D23         => s_O23,
       i_D24         => s_O24,
       i_D25         => s_O25,
       i_D26         => s_O26,
       i_D27         => s_O27,
       i_D28         => s_O28,
       i_D29         => s_O29,
       i_D30         => s_O30,
       i_D31         => s_O31,
       o_O           => o_O2);
  

end structural;
