------------------------------------------------------------------------
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
entity tb_fetchLogic is
  generic(gCLK_HPER   : time := 10 ns);   -- Generic for half of the clock cycle period
end tb_fetchLogic;

architecture mixed of tb_fetchLogic is

-- Define the total clock period time
constant cCLK_PER  : time := gCLK_HPER * 2;

-- We will be instantiating our design under test (DUT), so we need to specify its
-- component interface.
-- TODO: change component declaration as needed.
component fetchLogic is
generic(N : integer := 32);
  port(
	i_PC		:	in std_logic_vector(31 downto 0);	--input program counter
	i_JumpReg	:	in std_logic;			
	i_Jump		:	in std_logic;
	i_Branch	:	in std_logic;
	i_ALUComp	:	in std_logic;
	i_JumpInstrImm	:	in std_logic_vector(25 downto 0);	--will be shifted left, then take top 4 bits from PC
	i_BranchInstrImm:	in std_logic_vector(31 downto 0);	--will be shifted left then added to PC, already sign extended
	i_RSInput	:	in std_logic_vector(31 downto 0);
	o_PC4		:	out std_logic_vector(N-1 downto 0);
	o_PC		:	out std_logic_vector(31 downto 0)	--output program counter
	);
end component;

-- Create signals for all of the inputs and outputs of the file that you are testing
-- := '0' or := (others => '0') just make all the signals start at an initial value of zero
signal CLK, reset : std_logic := '0';

-- TODO: change input and output signals as needed.
 signal s_PC              : std_logic_vector(31 downto 0);
 signal s_JumpReg         : std_logic;
 signal s_Jump            : std_logic;
 signal s_Branch	  : std_logic;
 signal s_ALUComp         : std_logic;
 signal s_JumpInstrImm    : std_logic_vector(25 downto 0);
 signal s_BranchInstrImm  : std_logic_vector(31 downto 0);
 signal s_RSInput         : std_logic_vector(31 downto 0);
signal s_OPC4              : std_logic_vector(31 downto 0);
signal s_OPC              : std_logic_vector(31 downto 0);


begin

  -- TODO: Actually instantiate the component to test and wire all signals to the corresponding
  -- input or output. Note that DUT0 is just the name of the instance that can be seen 
  -- during simulation. What follows DUT0 is the entity name that will be used to find
  -- the appropriate library component during simulation loading.
  DUT0: fetchLogic
  port map(
      	i_PC             => s_PC,         
 	i_JumpReg        => s_JumpReg,         
 	i_Jump           => s_Jump, 
	i_Branch	 => s_Branch,       
 	i_ALUComp        => s_ALUComp,       
 	i_JumpInstrImm   => s_JumpInstrImm,        
 	i_BranchInstrImm => s_BranchInstrImm,         
 	i_RSInput        => s_RSInput,
o_PC4 => s_OPC4,
	o_PC             => s_OPC);
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

 s_PC              <= x"00000004";
 s_JumpReg         <= '0';
 s_Jump            <= '0';
 s_Branch	   <= '0';
 s_ALUComp         <= '0';
 s_JumpInstrImm    <= "00000000000000000000000000";
 s_BranchInstrImm  <= x"00000000";
 s_RSInput         <= x"00000000";


    wait for gCLK_HPER/2; -- for waveform clarity, I prefer not to change inputs on clk edges

 s_PC              <= s_OPC;
 s_JumpReg         <= '0';
 s_Jump            <= '0';
 s_Branch	   <= '0';
 s_ALUComp         <= '0';
 s_JumpInstrImm    <= "00000000000000000010000000";
 s_BranchInstrImm  <= x"00010000";
 s_RSInput         <= x"00000010";

wait for gCLK_HPER/2;
 s_PC              <= s_OPC;
 s_JumpReg         <= '0';
 s_Jump            <= '0';
 s_Branch	   <= '0';
 s_ALUComp         <= '0';
 s_JumpInstrImm    <= "00000000000000000010000000";
 s_BranchInstrImm  <= x"00010000";
 s_RSInput         <= x"00000010";

wait for gCLK_HPER/2;
 s_PC              <= s_OPC;
 s_JumpReg         <= '0';
 s_Jump            <= '0';
 s_Branch	   <= '0';
 s_ALUComp         <= '0';
 s_JumpInstrImm    <= "00000000000000000010000000";
 s_BranchInstrImm  <= x"00010000";
 s_RSInput         <= x"00000010";
-- Random instructions

wait for gCLK_HPER/2;
	
 s_PC              <= s_OPC;
 s_JumpReg         <= '0';
 s_Jump            <= '1';		-- First jump
 s_Branch	   <= '0';
 s_ALUComp         <= '0';
 s_JumpInstrImm    <= "00001000000000000010000000";
 s_BranchInstrImm  <= x"00010010";
 s_RSInput         <= x"00000010";

wait for gCLK_HPER/2;
	
 s_PC              <= s_OPC;
 s_JumpReg         <= '0';
 s_Jump            <= '0';		-- normal
 s_Branch	   <= '0';
 s_ALUComp         <= '0';
 s_JumpInstrImm    <= "00000000000000000010000000";
 s_BranchInstrImm  <= x"00010010";
 s_RSInput         <= x"00000010";

wait for gCLK_HPER/2;

	
 s_PC              <= s_OPC;
 s_JumpReg         <= '1';
 s_Jump            <= '1';		-- jr
 s_Branch	   <= '0';
 s_ALUComp         <= '0';
 s_JumpInstrImm    <= "00000000000000000010000000";
 s_BranchInstrImm  <= x"FFFFFF9C";
 s_RSInput         <= x"01000000";

wait for gCLK_HPER/2;

 s_PC              <= s_OPC;
 s_JumpReg         <= '0';
 s_Jump            <= '0';
 s_Branch	   <= '0';		-- normal
 s_ALUComp         <= '0';
 s_JumpInstrImm    <= "00000000000000000010000000";
 s_BranchInstrImm  <= x"FFFFFF9C";
 s_RSInput         <= x"00000010";

wait for gCLK_HPER/2;

 s_PC              <= s_OPC;
 s_JumpReg         <= '0';
 s_Jump            <= '0';
 s_Branch	   <= '1';		-- Branch, but ALU says no
 s_ALUComp         <= '0';
 s_JumpInstrImm    <= "00000000000000000010000000";
 s_BranchInstrImm  <= x"FFFFFF9C";
 s_RSInput         <= x"00000010";

wait for gCLK_HPER/2;

 s_PC              <= s_OPC;
 s_JumpReg         <= '0';
 s_Jump            <= '0';
 s_Branch	   <= '0';		-- normal
 s_ALUComp         <= '0';
 s_JumpInstrImm    <= "00000010000000000010000000";
 s_BranchInstrImm  <= x"FFFFFF9C";
 s_RSInput         <= x"00000010";

wait for gCLK_HPER*2;

 s_PC              <= s_OPC;
 s_JumpReg         <= '0';
 s_Jump            <= '0';
 s_Branch	   <= '1';		-- Branch
 s_ALUComp         <= '1';
 s_JumpInstrImm    <= "00000000000000000010000000";
 s_BranchInstrImm  <= x"FFFFFF9C";
 s_RSInput         <= x"00000010";

wait for gCLK_HPER*2;
wait for gCLK_HPER*2;
wait for gCLK_HPER*2;
  end process;

end mixed;
