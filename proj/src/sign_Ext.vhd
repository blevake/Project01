library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std_unsigned.all;
use IEEE.numeric_std.all;



entity sign_Ext is

  generic(	INPUT_BIT_LENGTH : integer := 16;
		OUTPUT_BIT_LENGTH  : integer := 32); 

  port(		i_signSel : in std_logic;
		i_imm : in std_logic_vector(INPUT_BIT_LENGTH-1 downto 0);
		o_imm : out std_logic_vector(OUTPUT_BIT_LENGTH-1 downto 0)
		);


end sign_Ext;


architecture dataflow of sign_Ext is

begin

	SIGN_EXT_PROC: process(i_signSel, i_imm)
	
		variable Extend_Vec : std_logic_vector(OUTPUT_BIT_LENGTH - INPUT_BIT_LENGTH - 1 downto 0) := (others => '0');

	begin

		if i_signSel = '1' then
			Extend_Vec := (others => i_imm(INPUT_BIT_LENGTH - 1));
		else
			Extend_Vec := (others => '0');
		end if;

		o_imm <= Extend_Vec & i_imm;

	end process SIGN_EXT_PROC;


end dataflow;
