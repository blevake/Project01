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
entity tb_Reg32 is
  generic(gCLK_HPER   : time := 10 ns);   -- Generic for half of the clock cycle period
end tb_Reg32;

architecture mixed of tb_Reg32 is

-- Define the total clock period time
constant cCLK_PER  : time := gCLK_HPER * 2;

-- We will be instantiating our design under test (DUT), so we need to specify its
-- component interface.
-- TODO: change component declaration as needed.
component Reg32 is
  port(i_CLK                        : in std_logic;
       i_WE 		            : in std_logic;
       i_RST 		            : in std_logic;
       i_D 		            : in std_logic_vector(31 downto 0);
       o_Q                          : out std_logic_vector(31 downto 0));
end component;

-- Create signals for all of the inputs and outputs of the file that you are testing
-- := '0' or := (others => '0') just make all the signals start at an initial value of zero
signal CLK, reset : std_logic := '0';

-- TODO: change input and output signals as needed.

signal s_WE 		            : std_logic;
signal s_RST 		            : std_logic;
signal s_D 		            : std_logic_vector(31 downto 0);
signal s_Q                          : std_logic_vector(31 downto 0);

begin

  -- TODO: Actually instantiate the component to test and wire all signals to the corresponding
  -- input or output. Note that DUT0 is just the name of the instance that can be seen 
  -- during simulation. What follows DUT0 is the entity name that will be used to find
  -- the appropriate library component during simulation loading.
  DUT0: Reg32
  port map(
       i_CLK          => CLK,
       i_WE 	      => s_WE,
       i_RST          => s_RST,
       i_D 	      => s_D,
       o_Q            => s_Q);
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

    s_WE   <= '1';
    s_RST <= '0';
    s_D <= x"01130345";
    wait for gCLK_HPER*2;
    -- Expect: Output is A017

    -- Test case 2:

    s_WE   <= '0';
    s_RST   <= '0';
    s_D <= x"00000000";
    wait for gCLK_HPER*2;
    wait for gCLK_HPER*2;
    -- Expect: Output is 0B01

    -- Test case 3:

    s_WE   <= '0';
    s_RST   <= '1';
    s_D <= x"13450375";
    wait for gCLK_HPER*2;
    wait for gCLK_HPER*2;

    -- TODO: add test cases as needed (at least 3 more for this lab)
  end process;

end mixed;
