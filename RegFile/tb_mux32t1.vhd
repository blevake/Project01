-------------------------------------------------------------------------
-- Henry Duwe
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- tb_TPU_MV_Element.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a testbench for the TPU MAC unit.
--              
-- 01/03/2020 by H3::Design created.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
use std.env.all;                -- For hierarchical/external signals
use std.textio.all;             -- For basic I/O

-- Usually name your testbench similar to below for clarity tb_<name>
-- TODO: change all instances of tb_TPU_MV_Element to reflect the new testbench.
entity tb_mux32t1 is
  generic(gCLK_HPER   : time := 10 ns);   -- Generic for half of the clock cycle period
end tb_mux32t1;

architecture mixed of tb_mux32t1 is

-- Define the total clock period time
constant cCLK_PER  : time := gCLK_HPER * 2;

-- We will be instantiating our design under test (DUT), so we need to specify its
-- component interface.
-- TODO: change component declaration as needed.
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

-- Create signals for all of the inputs and outputs of the file that you are testing
-- := '0' or := (others => '0') just make all the signals start at an initial value of zero
signal CLK, reset : std_logic := '0';

-- TODO: change input and output signals as needed.

signal s_S          : std_logic_vector(4 downto 0);
signal s_D0         : std_logic_vector(31 downto 0);
signal s_D1         : std_logic_vector(31 downto 0);
signal s_D2         : std_logic_vector(31 downto 0);
signal s_D3         : std_logic_vector(31 downto 0);
signal s_D4         : std_logic_vector(31 downto 0);
signal s_D5         : std_logic_vector(31 downto 0);
signal s_D6         : std_logic_vector(31 downto 0);
signal s_D7         : std_logic_vector(31 downto 0);
signal s_D8         : std_logic_vector(31 downto 0);
signal s_D9         : std_logic_vector(31 downto 0);
signal s_D10         : std_logic_vector(31 downto 0);
signal s_D11         : std_logic_vector(31 downto 0);
signal s_D12         : std_logic_vector(31 downto 0);
signal s_D13         : std_logic_vector(31 downto 0);
signal s_D14         : std_logic_vector(31 downto 0);
signal s_D15         : std_logic_vector(31 downto 0);
signal s_D16         : std_logic_vector(31 downto 0);
signal s_D17         : std_logic_vector(31 downto 0);
signal s_D18         : std_logic_vector(31 downto 0);
signal s_D19         : std_logic_vector(31 downto 0);
signal s_D20         : std_logic_vector(31 downto 0);
signal s_D21         : std_logic_vector(31 downto 0);
signal s_D22         : std_logic_vector(31 downto 0);
signal s_D23         : std_logic_vector(31 downto 0);
signal s_D24         : std_logic_vector(31 downto 0);
signal s_D25         : std_logic_vector(31 downto 0);
signal s_D26         : std_logic_vector(31 downto 0);
signal s_D27         : std_logic_vector(31 downto 0);
signal s_D28         : std_logic_vector(31 downto 0);
signal s_D29         : std_logic_vector(31 downto 0);
signal s_D30         : std_logic_vector(31 downto 0);
signal s_D31         : std_logic_vector(31 downto 0);
signal s_O           : std_logic_vector(31 downto 0);

begin

  -- TODO: Actually instantiate the component to test and wire all signals to the corresponding
  -- input or output. Note that DUT0 is just the name of the instance that can be seen 
  -- during simulation. What follows DUT0 is the entity name that will be used to find
  -- the appropriate library component during simulation loading.
  DUT0: mux32t1
  port map(
       i_S          => s_S,
       i_D0         => s_D0,
       i_D1         => s_D1,
       i_D2         => s_D2,
       i_D3         => s_D3,
       i_D4         => s_D4,
       i_D5         => s_D5,
       i_D6         => s_D6,
       i_D7         => s_D7,
       i_D8         => s_D8,
       i_D9         => s_D9,
       i_D10         => s_D10,
       i_D11         => s_D11,
       i_D12         => s_D12,
       i_D13         => s_D13,
       i_D14         => s_D14,
       i_D15         => s_D15,
       i_D16         => s_D16,
       i_D17         => s_D17,
       i_D18         => s_D18,
       i_D19         => s_D19,
       i_D20         => s_D20,
       i_D21         => s_D21,
       i_D22         => s_D22,
       i_D23         => s_D23,
       i_D24         => s_D24,
       i_D25         => s_D25,
       i_D26         => s_D26,
       i_D27         => s_D27,
       i_D28         => s_D28,
       i_D29         => s_D29,
       i_D30         => s_D30,
       i_D31         => s_D31,
       o_O           => s_O);
  --You can also do the above port map in one line using the below format: http://www.ics.uci.edu/~jmoorkan/vhdlref/compinst.html

  
  --This first process is to setup the clock for the test bench
  P_CLK: process
  begin
    CLK <= '1';         -- clock starts at 1
    wait for gCLK_HPER; -- after half a cycle
    CLK <= '0';         -- clock becomes a 0 (negative edge)
    wait for gCLK_HPER; -- after half a cycle, process begins evaluation again
  end process;

  -- This process resets the sequential components of the design.
  -- It is held to be 1 across both the negative and positive edges of the clock
  -- so it works regardless of whether the design uses synchronous (pos or neg edge)
  -- or asynchronous resets.
  P_RST: process
  begin
  	reset <= '0';   
    wait for gCLK_HPER/2;
	reset <= '1';
    wait for gCLK_HPER*2;
	reset <= '0';
	wait;
  end process;  
  
  -- Assign inputs for each test case.
  -- TODO: add test cases as needed.
  P_TEST_CASES: process
  begin
    wait for gCLK_HPER/2; -- for waveform clarity, I prefer not to change inputs on clk edges

    -- Test case 1:

       s_S <= b"11111";
       s_D0 <= x"BEEFBEEF";
       s_D1 <= x"10101010";
       s_D2 <= x"10101010";
       s_D3 <= x"10101010";
       s_D4 <= x"10101010";
       s_D5 <= x"10101010";
       s_D6 <= x"10101010";
       s_D7 <= x"10101010";
       s_D8 <= x"10101010";
       s_D9 <= x"10101010";
       s_D10 <= x"10101010";
       s_D11 <= x"10101010";
       s_D12 <= x"10101010";
       s_D13 <= x"10101010";
       s_D14 <= x"10101010";
       s_D15 <= x"10101010";
       s_D16 <= x"10101010";
       s_D17 <= x"10101010";
       s_D18 <= x"10101010";
       s_D19 <= x"10101010";
       s_D20 <= x"10101010";
       s_D21 <= x"10101010";
       s_D22 <= x"10101010";
       s_D23 <= x"10101010";
       s_D24 <= x"10101010";
       s_D25 <= x"10101010";
       s_D26 <= x"10101010";
       s_D27 <= x"10101010";
       s_D28 <= x"10101010";
       s_D29 <= x"10101010";
       s_D30 <= x"10101010";
       s_D31 <= x"BAADACDC";
    wait for gCLK_HPER*2;
    -- Expect: Output is BAADACDC

    -- Test case 2:

       s_S <= b"00000";
       s_D0 <= x"BEEFBEEF";
       s_D1 <= x"10101010";
       s_D2 <= x"10101010";
       s_D3 <= x"10101010";
       s_D4 <= x"10101010";
       s_D5 <= x"10101010";
       s_D6 <= x"10101010";
       s_D7 <= x"10101010";
       s_D8 <= x"10101010";
       s_D9 <= x"10101010";
       s_D10 <= x"10101010";
       s_D11 <= x"10101010";
       s_D12 <= x"10101010";
       s_D13 <= x"10101010";
       s_D14 <= x"10101010";
       s_D15 <= x"10101010";
       s_D16 <= x"10101010";
       s_D17 <= x"10101010";
       s_D18 <= x"10101010";
       s_D19 <= x"10101010";
       s_D20 <= x"10101010";
       s_D21 <= x"10101010";
       s_D22 <= x"10101010";
       s_D23 <= x"10101010";
       s_D24 <= x"10101010";
       s_D25 <= x"10101010";
       s_D26 <= x"10101010";
       s_D27 <= x"10101010";
       s_D28 <= x"10101010";
       s_D29 <= x"10101010";
       s_D30 <= x"10101010";
       s_D31 <= x"BAADACDC";
    wait for gCLK_HPER*2;
    wait for gCLK_HPER*2;
    -- Expect: Output is BEEFBEEF

    -- Test case 3:

       s_S <= b"00111";
       s_D0 <= x"BEEFBEEF";
       s_D1 <= x"10101010";
       s_D2 <= x"10101010";
       s_D3 <= x"10101010";
       s_D4 <= x"10101010";
       s_D5 <= x"10101010";
       s_D6 <= x"10101010";
       s_D7 <= x"12345678";
       s_D8 <= x"10101010";
       s_D9 <= x"10101010";
       s_D10 <= x"10101010";
       s_D11 <= x"10101010";
       s_D12 <= x"10101010";
       s_D13 <= x"10101010";
       s_D14 <= x"10101010";
       s_D15 <= x"10101010";
       s_D16 <= x"10101010";
       s_D17 <= x"10101010";
       s_D18 <= x"10101010";
       s_D19 <= x"10101010";
       s_D20 <= x"10101010";
       s_D21 <= x"10101010";
       s_D22 <= x"10101010";
       s_D23 <= x"10101010";
       s_D24 <= x"10101010";
       s_D25 <= x"10101010";
       s_D26 <= x"10101010";
       s_D27 <= x"10101010";
       s_D28 <= x"10101010";
       s_D29 <= x"10101010";
       s_D30 <= x"10101010";
       s_D31 <= x"BAADACDC";
    wait for gCLK_HPER*2;
    wait for gCLK_HPER*2;
    -- Expect: Output is 12345678

    -- TODO: add test cases as needed (at least 3 more for this lab)
  end process;

end mixed;
