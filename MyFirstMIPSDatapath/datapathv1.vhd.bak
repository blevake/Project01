-------------------------------------------------------------------------
-- Andrew Deick
-- Department of Software Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- datapathv1.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: 
--
--
-- NOTES:
-- 8/19/16 by JAZ::Design created.
-- 11/25/19 by H3:Changed name to avoid name conflict with Quartus
--          primitives.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

use work.mypack.all;


entity datapathv1 is
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

end datapathv1;

architecture structural of datapathv1 is
 
	component regfile
	 port(clk		: in std_logic;
		i_wA		: in std_logic_vector(4 downto 0);
		i_wD		: in std_logic_vector(31 downto 0);
		i_wC		: in std_logic;
		i_r1		: in std_logic_vector(4 downto 0);
		i_r2		: in std_logic_vector(4 downto 0);
		reset		: in std_logic;
        o_d1        : out std_logic_vector(31 downto 0);
        o_d2        : out std_logic_vector(31 downto 0));
	end component;
	
	component addersubtractor 
	port( nAdd_Sub: in std_logic;
	    i_A 	: in std_logic_vector(31 downto 0);
		i_B		: in std_logic_vector(31 downto 0);
		o_Y		: out std_logic_vector(31 downto 0);
		o_Cout	: out std_logic);
	end component;
	
	component mux2t1_N
	port(i_S          : in std_logic;
       i_D0         : in std_logic_vector(31 downto 0);
       i_D1         : in std_logic_vector(31 downto 0);
       o_O          : out std_logic_vector(31 downto 0));
	end component;
	
	signal s1, s2, s3, s4 : std_logic_vector(31 downto 0);
	signal s5 : std_logic; --output from Cout, ignored
	--s1 and s2 describe output from data1 and data2
	--s3 is ALU Mux output (s2 is mux input)
	--s4 is Add/Sub output and Write Data input
	--signal s2 : TwoDArray;
	
begin 

	--INIT: process
	--begin
	--	s1 <= (others => '0');
	--	s2 <= (others => '0');
	--	s3 <= (others => '0');
	--	s4 <= (others => '0');
	--	s5 <= '0';
	--	wait;
	--end process;
	
	addsub: addersubtractor
    port MAP(nAddSub, s1, s3, s4, s5);
	
	registers: regfile
	port MAP(clk, i_C, s4, wE, i_A, i_B, reset, s1, s2);
	
	ALUMux: mux2t1_N
	port MAP(ALUSrc, s2, immediate, s3);
	
	o_d1 <= s1;
	o_d2 <= s2;
	
end structural;
