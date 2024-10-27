--Author is Spencer Opitz 10/9/2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity fetchLogic is
generic(N : integer := 32);
port (
	i_PC		:	in std_logic_vector(N-1 downto 0);	--input program counter
	i_JumpReg	:	in std_logic;			
	i_Jump		:	in std_logic;
	i_Branch	:	in std_logic;
	i_ALUComp	:	in std_logic;
	i_JumpInstrImm	:	in std_logic_vector(25 downto 0);	--will be shifted left, then take top 4 bits from PC
	i_BranchInstrImm:	in std_logic_vector(N-1 downto 0);	--will be shifted left then added to PC, already sign extended
	i_RSInput	:	in std_logic_vector(N-1 downto 0);
	i_Clk		:	in std_logic;
	i_Rst		:	in std_logic;
	o_PC4		:	out std_logic_vector(N-1 downto 0);
	o_PC		:	out std_logic_vector(N-1 downto 0)	--output program counter
);end fetchLogic;

--  operations key:
--  JAL : JR=0, Jump=1, XXXX outside of the fetch logic, we need an and gate and mux to write the PC value to the registers
--  J : JR = 0, Jump=1, XXXX "XXXX" means that other inputs don't matter
--  BEQ/BNE : Branch=1, ALUComp=1, Jump=0, XXXX
--  JR : JR=1, Jump=1, XXXX
--  Next Instr : Branch||ALUComp=0, Jump=0, XXXX

architecture mixed of fetchLogic is

component add_sub_n is
  	port(
	i_A               	: in std_logic_vector(N-1 downto 0);
	i_B               	: in std_logic_vector(N-1 downto 0);
	i_Add_Sub		: in std_logic; --set to 1 for subtraction and 0 for addition
	o_O               	: out std_logic_vector(N-1 downto 0));
end component;

component mux2t1_N is
  	port(
	i_S          : in std_logic;
       	i_D0         : in std_logic_vector(N-1 downto 0);
       	i_D1         : in std_logic_vector(N-1 downto 0);
       	o_O          : out std_logic_vector(N-1 downto 0));
end component;

component and2_N is
  	port(
	i_D0         : in std_logic_vector(N-1 downto 0);
       	i_D1         : in std_logic_vector(N-1 downto 0);
       	o_O          : out std_logic_vector(N-1 downto 0));
end component;

component andg2 is
  	port(
	i_A          : in std_logic;
       	i_B          : in std_logic;
       	o_F          : out std_logic);
end component;

component Reg32 is	--will hold PC value
  	port(
	i_D          : in std_logic_vector(31 downto 0);
       	i_RST        : in std_logic;
       	i_WE         : in std_logic;
       	i_CLK        : in std_logic;
       	o_Q          : out std_logic_vector(31 downto 0));
end component;


signal s_BranchAndZero	:	std_logic;
signal s_UpdatedPC	:	std_logic_vector(31 downto 0); --input PC + 4
signal s_JRMux0		:	std_logic_vector(31 downto 0);
signal s_JRMux0temp	:	std_logic_vector(27 downto 0); --used to 0 extend immediate
signal s_JumpMux0	:	std_logic_vector(31 downto 0);
signal s_JumpMux1	:	std_logic_vector(31 downto 0);
signal s_BranchAddertemp:	std_logic_vector(31 downto 0);
signal s_BranchMux1	:	std_logic_vector(31 downto 0);
signal s_oldPC		:	std_logic_vector(31 downto 0);
signal s_test		:	std_logic_vector(31 downto 0);
signal s_PC		:	std_logic_vector(31 downto 0);
begin


process (i_JumpInstrImm, s_UpdatedPC) is
	begin
		o_PC4 <= s_UpdatedPC;
		s_JRMux0(31 downto 28) <= s_UpdatedPC(31 downto 28);
		s_JRMux0temp <= (others => '0');
		s_JRMux0temp(25 downto 0) <= i_JumpInstrImm;
		s_JRMux0(27 downto 0) <= std_logic_vector(shift_left(unsigned(s_JRMux0temp), 2));
	end process;

process (i_BranchInstrImm) is --sll branch immediate 2 spots
	begin
		s_BranchAddertemp <= std_logic_vector(shift_left(unsigned(i_BranchInstrImm), 2));
	end process;

--  Diagram of fetch logic is uploaded to github

ah:mux2t1_N
	port map(
		i_S => i_Rst,
       		i_D0 => i_PC,
       		i_D1 => x"003FFFFC",
       		o_O => s_PC);
PCDFFG : Reg32
	port map(
		i_D => s_PC,
       		i_RST => '0',
       		i_WE => '1',
       		i_CLK => i_Clk,
       		o_Q => s_oldPC);
	


BranchAndZero:andg2
	port map(
		i_A     => i_Branch,
		i_B     => i_ALUComp,
		o_F      => s_BranchAndZero);


AddPCto4:add_sub_n
	port map(
		i_A     => s_oldPC,
		i_B     => X"00000004", --add 4 to PC
		i_Add_Sub => '0', --will only add
		o_O      => s_UpdatedPC);

JRMux32Bit:mux2t1_N
	port map(
		i_S => i_JumpReg,
       		i_D0 => s_JRMux0,
       		i_D1 => i_RSInput,
       		o_O => s_JumpMux1);

BranchAddressAdder:add_sub_n
	port map(
		i_A     => s_UpdatedPC,
		i_B     => s_BranchAdderTemp,
		i_Add_Sub => '0', --will only add
		o_O      => s_BranchMux1);

BranchMux:mux2t1_N
	port map(
		i_S => s_BranchAndZero,
       		i_D0 => s_UpdatedPC,
       		i_D1 => s_BranchMux1,
       		o_O => s_JumpMux0);

JumpMux:mux2t1_N
	port map(
		i_S => i_Jump,
       		i_D0 => s_JumpMux0,
       		i_D1 => s_JumpMux1,
       		o_O => o_PC);


end mixed;
