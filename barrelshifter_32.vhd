--Author is Spencer Opitz 10/9/2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity barrelshifter_32 is
port (
	i_d	:	in std_logic_vector(31 downto 0);	--input data
	o_d	:	out std_logic_vector(31 downto 0);	--output data
	i_shiftdir:	in std_logic;				--0 for left, 1 for right
	i_shiftamt:	in std_logic_vector(4 downto 0);	--shift amount is 0 to 31
	i_shifttype:	in std_logic;				--shift type 0 for logical, 1 for arithmetic, arithmetic for shift left does nothing
	i_EN	:	in std_logic;				--1 for enable
	i_r	:	in std_logic				--1 for reset
);end barrelshifter_32;



architecture mixed of barrelshifter_32 is

component decoder5to32 is
	port(
	i_I : in std_logic_vector(4 downto 0);
        o_O : out std_logic_vector(31 downto 0)
	);
end component;

signal s_decsignal : std_logic_vector(31 downto 0); --decoded signal



begin

	dec : decoder5to32				--decoder will be used in bitwise operation for each bit based on amount shifted
    	port MAP(
		i_I => i_shiftamt,
        	o_O => s_decsignal
	);
	
	pdiddy: process (i_d, i_shiftdir, i_shiftamt, i_EN, i_r, i_shifttype, s_decsignal)
		begin

		if (i_r = '1') then 
			o_d <= X"00000000"; 

		else
			for i in 0 to 31 loop
			--bits of o_d
				for j in 0 to 31 loop
				--shift amount of each bit
					if (s_decsignal(j) = '1') then
						if (i_shiftdir = '1') then
							if (i+j <= 31) then
								o_d(i) <= i_d(i+j);	--add index for shifting right
							end if;
						else
							if (i-j >= 0) then
								o_d(i) <= i_d(i-j);	--sub index for shifting left
							end if;
						end if;
					end if;
				end loop;
			end loop;
		end if;
	end process pdiddy;
end mixed;
