-------------------------------------------------------------------------
-- Andrew Deick
-- Department of Software Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- tb_datapathv1.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a simple VHDL testbench for the
-- edge-triggered flip-flop with parallel access and reset.
--
--
-- NOTES:
-- 8/19/16 by JAZ::Design created.
-- 11/25/19 by H3:Changed name to avoid name conflict with Quartus
--          primitives.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity tb_datapathv1 is
  generic(gCLK_HPER   : time := 50 ns);
end tb_datapathv1;

architecture behavior of tb_datapathv1 is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;


  component datapathv1
     port(clk			: in std_logic;
		reset		: in std_logic;
		nAddSub		: in std_logic;
		ALUSrc		: in std_logic;
		wE			: in std_logic;
		i_A			: in std_logic_vector(4 downto 0);
		i_B			: in std_logic_vector(4 downto 0);
		i_C			: in std_logic_vector(4 downto 0);
        immediate	: in std_logic_vector(31 downto 0);
		o_d1        : out std_logic_vector(31 downto 0);
        o_d2        : out std_logic_vector(31 downto 0));
  end component;

  -- Temporary signals to connect to the dff component.
  signal s_clk, s_reset, s_addsub, s_alu, s_WE: std_logic;
  signal s_imm, s_d1, s_d2 : std_logic_vector(31 downto 0);
  signal s_A, s_B, s_C : std_logic_vector(4 downto 0);
begin

  DUT: datapathv1
  port map(s_clk, s_reset, s_addsub, s_alu, s_WE, s_A, s_B, s_C, s_imm, s_d1, s_d2);

  -- This process sets the clock value (low for gCLK_HPER, then high
  -- for gCLK_HPER). Absent a "wait" command, processes restart 
  -- at the beginning once they have reached the final statement.
  P_CLK: process
  begin
    s_clk <= '0';
    wait for gCLK_HPER;
    s_clk <= '1';
    wait for gCLK_HPER;
  end process;
  
  -- Testbench process  
  P_TB: process
  begin
    -- Reset the Registers
    s_reset <= '1';
	s_WE 	<= '0';
	s_addsub <= '0';
	s_alu 	<= '0';
	s_C		<= "00000";
	s_A		<= "00000";
	s_B		<= "00000";
	s_imm	<= x"00000000";
		-- Expect d1 and d2 to both read the zero register (0x00000000)
    wait for cCLK_PER;
	s_reset <= '0';
	s_WE 	<= '1';
	-----------------MIPS---
	s_addsub <= '0';
	s_alu 	<= '1';
	s_A		<= "00000";
	s_B		<= "00001";
	s_C		<= "00001";
	s_imm	<= x"00000001";
	wait for cCLK_PER; --addi $1, $0, 1 
	s_C		<= "00010";
	s_imm	<= x"00000002";
	wait for cCLK_PER; --addi $2, $0, 2
	s_C		<= "00011";
	s_imm	<= x"00000003";
	wait for cCLK_PER; --addi $3, $0, 3
	s_C		<= "00100";
	s_imm	<= x"00000004";
	wait for cCLK_PER; --addi $4, $0, 4
	s_C		<= "00101";
	s_imm	<= x"00000005";
	wait for cCLK_PER; --addi $5, $0, 5
	s_C		<= "00110";
	s_imm	<= x"00000006";
	wait for cCLK_PER; --addi $6, $0, 6
	s_C		<= "00111";
	s_imm	<= x"00000007";
	wait for cCLK_PER; --addi $7, $0, 7
	s_C		<= "01000";
	s_imm	<= x"00000008";
	wait for cCLK_PER; --addi $8, $0, 8
	s_C		<= "01001";
	s_imm	<= x"00000009";
	wait for cCLK_PER; --addi $9, $0, 9
	s_C		<= "01010";
	s_imm	<= x"0000000A";
	wait for cCLK_PER; --addi $10, $0, 10
	s_alu 	<= '0';
	s_A		<= "00001";
	s_B		<= "00010";
	s_C		<= "01011";
	s_imm	<= x"00000000";
	wait for cCLK_PER; --add $11, $1, $2 
	s_addsub <= '1';
	s_A		<= "01011";
	s_B		<= "00011";
	s_C		<= "01100";
	wait for cCLK_PER; --sub $12, $11, $3
	s_addsub 	<= '0';
	s_A		<= "01100";
	s_B		<= "00100";
	s_C		<= "01101";
	wait for cCLK_PER; --add $13, $12, $4
	s_addsub 	<= '1';
	s_A		<= "01101";
	s_B		<= "00101";
	s_C		<= "01110";
	wait for cCLK_PER; --sub $14, $13, $5
	s_addsub 	<= '0';
	s_A		<= "01110";
	s_B		<= "00110";
	s_C		<= "01111";
	wait for cCLK_PER; --add $15, $114, $6
	s_addsub 	<= '1';
	s_A		<= "01111";
	s_B		<= "00111";
	s_C		<= "10000";
	s_imm	<= x"00000000";
	wait for cCLK_PER; --sub $16, $15, $7 -^done
	s_addsub 	<= '0';
	s_A		<= "10000";
	s_B		<= "01000";
	s_C		<= "10001";
	wait for cCLK_PER; --add $17, $16, $8
	s_addsub 	<= '1';
	s_A		<= "10001";
	s_B		<= "01001";
	s_C		<= "10010";
	wait for cCLK_PER; --sub $18, $17, $9
	s_addsub 	<= '0';
	s_A		<= "10010";
	s_B		<= "01010";
	s_C		<= "10011";
	wait for cCLK_PER; --add $19, $18, $10
	s_addsub 	<= '1';
	s_alu 	<= '1';
	s_A		<= "00000";
	s_C		<= "10100";
	s_imm	<= x"00000023";
	wait for cCLK_PER; --addi $20, $0, -35 --subi $20, $0, 35
	s_addsub 	<= '0';
	s_alu 	<= '0';
	s_A		<= "10011";
	s_B		<= "10100";
	s_C		<= "10101";
	s_imm	<= x"00000000";
	wait for cCLK_PER; --add $21, $19, $20
	

    wait;
  end process;
  
end behavior;