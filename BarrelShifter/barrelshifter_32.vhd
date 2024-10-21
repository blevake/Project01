--Author is Spencer Opitz 10/9/2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity barrelshifter_32 is
generic(N : integer := 32);
port (
	i_d	:	in std_logic_vector(N-1 downto 0);	--input data
	o_d	:	out std_logic_vector(N-1 downto 0);	--output data
	i_shiftdir:	in std_logic;				--0 for left, 1 for right
	i_shiftamt:	in std_logic_vector(4 downto 0);	--shift amount is 0 to 31
	i_shifttype:	in std_logic				--shift type 0 for logical, 1 for arithmetic, arithmetic for shift left does nothing
);end barrelshifter_32;



architecture mixed of barrelshifter_32 is

component mux2t1_N is --should be using 32 bit mux instead of 32 1 bit muxes!!
  port(i_S          : in std_logic;
       i_D0         : in std_logic_vector(N-1 downto 0);
       i_D1         : in std_logic_vector(N-1 downto 0);
       o_O          : out std_logic_vector(N-1 downto 0));

end component;

--  suffix guide:
--  l = left shift of level's signal sent to amount mux
--  r = logical right shift of level's signal sent to amount mux
--  ra = arithmetic right shift of level's signal sent to amount mux
--  ol = post amount decision for each level sent to dir mux
--  or = post amount decision for each level sent to type mux (arithmetic or logical)
--  ora = post amount decision for each level sent to type mux (arithmetic or logical)
--  oro = type decision for each level sent to dir mux
--  nothing = the input to each stage or output to previous stage


signal s_0l		:		std_logic_vector(N-1 downto 0);
signal s_0r		:		std_logic_vector(N-1 downto 0);
signal s_0ra		:		std_logic_vector(N-1 downto 0);
signal s_0ol		:		std_logic_vector(N-1 downto 0);
signal s_0or		:		std_logic_vector(N-1 downto 0);
signal s_0ora		:		std_logic_vector(N-1 downto 0);
signal s_0oro		:		std_logic_vector(N-1 downto 0);

signal s_1		:		std_logic_vector(N-1 downto 0);
signal s_1l		:		std_logic_vector(N-1 downto 0);
signal s_1r		:		std_logic_vector(N-1 downto 0);
signal s_1ra		:		std_logic_vector(N-1 downto 0);
signal s_1ol		:		std_logic_vector(N-1 downto 0);
signal s_1or		:		std_logic_vector(N-1 downto 0);
signal s_1ora		:		std_logic_vector(N-1 downto 0);
signal s_1oro		:		std_logic_vector(N-1 downto 0);

signal s_2		:		std_logic_vector(N-1 downto 0);
signal s_2l		:		std_logic_vector(N-1 downto 0);
signal s_2r		:		std_logic_vector(N-1 downto 0);
signal s_2ra		:		std_logic_vector(N-1 downto 0);
signal s_2ol		:		std_logic_vector(N-1 downto 0);
signal s_2or		:		std_logic_vector(N-1 downto 0);
signal s_2ora		:		std_logic_vector(N-1 downto 0);
signal s_2oro		:		std_logic_vector(N-1 downto 0);

signal s_3		:		std_logic_vector(N-1 downto 0);
signal s_3l		:		std_logic_vector(N-1 downto 0);
signal s_3r		:		std_logic_vector(N-1 downto 0);
signal s_3ra		:		std_logic_vector(N-1 downto 0);
signal s_3ol		:		std_logic_vector(N-1 downto 0);
signal s_3or		:		std_logic_vector(N-1 downto 0);
signal s_3ora		:		std_logic_vector(N-1 downto 0);
signal s_3oro		:		std_logic_vector(N-1 downto 0);

signal s_4		:		std_logic_vector(N-1 downto 0);
signal s_4l		:		std_logic_vector(N-1 downto 0);
signal s_4r		:		std_logic_vector(N-1 downto 0);
signal s_4ra		:		std_logic_vector(N-1 downto 0);
signal s_4ol		:		std_logic_vector(N-1 downto 0);
signal s_4or		:		std_logic_vector(N-1 downto 0);
signal s_4ora		:		std_logic_vector(N-1 downto 0);
signal s_4oro		:		std_logic_vector(N-1 downto 0);

begin

--  authors note: these could be components to make this vhdl fully structural, but the components
--  would just be implementing the same process statements, so I'm gonna leave these in this file
--  so that I don't have to add 5 barebones shifting components to the project
----------------------------------------------------------------------------------------------
	process (i_d) is
	begin
		s_0l <= std_logic_vector(shift_left(unsigned(i_d), 1));
		s_0r <= std_logic_vector(shift_right(unsigned(i_d), 1));
		s_0ra <= std_logic_vector(shift_right(unsigned(i_d), 1));
		if (i_d(31) = '1') then
			s_0ra(31) <= '1';
		end if;
	end process;
----------------------------------------------------------------------------------------------
	process (s_1) is
	begin
		s_1l <= std_logic_vector(shift_left(unsigned(s_1), 2));
		s_1r <= std_logic_vector(shift_right(unsigned(s_1), 2));
		s_1ra <= std_logic_vector(shift_right(unsigned(s_1), 2));
		if (s_1(31) = '1') then
			for i in 31 downto 30 loop
				s_1ra(i) <= '1';
			end loop;
		end if;
	end process;
----------------------------------------------------------------------------------------------
	process (s_2) is
	begin
		s_2l <= std_logic_vector(shift_left(unsigned(s_2), 4));
		s_2r <= std_logic_vector(shift_right(unsigned(s_2), 4));
		s_2ra <= std_logic_vector(shift_right(unsigned(s_2), 4));
		if (s_2(31) = '1') then
			for i in 31 downto 28 loop
				s_2ra(i) <= '1';
			end loop;
		end if;
	end process;
----------------------------------------------------------------------------------------------
	process (s_3) is
	begin
		s_3l <= std_logic_vector(shift_left(unsigned(s_3), 8));
		s_3r <= std_logic_vector(shift_right(unsigned(s_3), 8));
		s_3ra <= std_logic_vector(shift_right(unsigned(s_3), 8));
		if (s_3(31) = '1') then
			for i in 31 downto 24 loop
				s_3ra(i) <= '1';
			end loop;
		end if;
	end process;
----------------------------------------------------------------------------------------------
	process (s_4) is
	begin
		s_4l <= std_logic_vector(shift_left(unsigned(s_4), 16));
		s_4r <= std_logic_vector(shift_right(unsigned(s_4), 16));
		s_4ra <= std_logic_vector(shift_right(unsigned(s_4), 16));
		if (s_4(31) = '1') then
			for i in 31 downto 16 loop
				s_4ra(i) <= '1';
			end loop;
		end if;
	end process;
----------------------------------------------------------------------------------------------

--decide between no shift and left shift by binary amount

	MUX0l: mux2t1_N port map(			--shift bit left by 1
		i_S      => i_shiftamt(0),
		i_D0     => i_d,
		i_D1     => s_0l,
		o_O      => s_0ol);

	MUX1l: mux2t1_N port map(			--shift bit left by 2
		i_S      => i_shiftamt(1),
		i_D0     => s_1,
		i_D1     => s_1l,
		o_O      => s_1ol);

	MUX2l: mux2t1_N port map(			--shift bit left by 4
		i_S      => i_shiftamt(2),
		i_D0     => s_2,
		i_D1     => s_2l,
		o_O      => s_2ol);

	MUX3l: mux2t1_N port map(			--shift bit left by 8
		i_S      => i_shiftamt(3),
		i_D0     => s_3,
		i_D1     => s_3l,
		o_O      => s_3ol);

	MUX4l: mux2t1_N port map(			--shift bit left by 16
		i_S      => i_shiftamt(4),
		i_D0     => s_4,
		i_D1     => s_4l,
		o_O      => s_4ol);

----------------------------------------------------------------------------------------------

--decide between no shift and logical right shift by binary amount

	MUX0r: mux2t1_N port map(			--shift bit right by 1
		i_S      => i_shiftamt(0),
		i_D0     => i_d,
		i_D1     => s_0r,
		o_O      => s_0or);

	MUX1r: mux2t1_N port map(			--shift bit right by 2
		i_S      => i_shiftamt(1),
		i_D0     => s_1,
		i_D1     => s_1r,
		o_O      => s_1or);

	MUX2r: mux2t1_N port map(			--shift bit right by 4
		i_S      => i_shiftamt(2),
		i_D0     => s_2,
		i_D1     => s_2r,
		o_O      => s_2or);

	MUX3r: mux2t1_N port map(			--shift bit right by 8
		i_S      => i_shiftamt(3),
		i_D0     => s_3,
		i_D1     => s_3r,
		o_O      => s_3or);

	MUX4r: mux2t1_N port map(			--shift bit right by 16
		i_S      => i_shiftamt(4),
		i_D0     => s_4,
		i_D1     => s_4r,
		o_O      => s_4or);

----------------------------------------------------------------------------------------------

--decide between no shift and arithmetic right shift by binary amount

	MUX0ra: mux2t1_N port map(			--shift bit right by 1 arithmetic
		i_S      => i_shiftamt(0),
		i_D0     => i_d,
		i_D1     => s_0ra,
		o_O      => s_0ora);

	MUX1ra: mux2t1_N port map(			--shift bit right by 2 arithmetic
		i_S      => i_shiftamt(1),
		i_D0     => s_1,
		i_D1     => s_1ra,
		o_O      => s_1ora);

	MUX2ra: mux2t1_N port map(			--shift bit right by 4 arithmetic
		i_S      => i_shiftamt(2),
		i_D0     => s_2,
		i_D1     => s_2ra,
		o_O      => s_2ora);

	MUX3ra: mux2t1_N port map(			--shift bit right by 8 arithmetic
		i_S      => i_shiftamt(3),
		i_D0     => s_3,
		i_D1     => s_3ra,
		o_O      => s_3ora);

	MUX4ra: mux2t1_N port map(			--shift bit right by 16 arithmetic
		i_S      => i_shiftamt(4),
		i_D0     => s_4,
		i_D1     => s_4ra,
		o_O      => s_4ora);

----------------------------------------------------------------------------------------------

--decide between arithmetic and logical shift

	MUX0t: mux2t1_N port map(
		i_S      => i_shifttype,
		i_D0     => s_0or,
		i_D1     => s_0ora,
		o_O      => s_0oro);

	MUX1t: mux2t1_N port map(
		i_S      => i_shifttype,
		i_D0     => s_1or,
		i_D1     => s_1ora,
		o_O      => s_1oro);

	MUX2t: mux2t1_N port map(
		i_S      => i_shifttype,
		i_D0     => s_2or,
		i_D1     => s_2ora,
		o_O      => s_2oro);

	MUX3t: mux2t1_N port map(
		i_S      => i_shifttype,
		i_D0     => s_3or,
		i_D1     => s_3ora,
		o_O      => s_3oro);

	MUX4t: mux2t1_N port map(
		i_S      => i_shifttype,
		i_D0     => s_4or,
		i_D1     => s_4ora,
		o_O      => s_4oro);

----------------------------------------------------------------------------------------------

--decide between left and right mux outputs

	MUX0o: mux2t1_N port map(
		i_S      => i_shiftdir,
		i_D0     => s_0ol,
		i_D1     => s_0oro,
		o_O      => s_1);

	MUX1o: mux2t1_N port map(
		i_S      => i_shiftdir,
		i_D0     => s_1ol,
		i_D1     => s_1oro,
		o_O      => s_2);

	MUX2o: mux2t1_N port map(
		i_S      => i_shiftdir,
		i_D0     => s_2ol,
		i_D1     => s_2oro,
		o_O      => s_3);

	MUX3o: mux2t1_N port map(
		i_S      => i_shiftdir,
		i_D0     => s_3ol,
		i_D1     => s_3oro,
		o_O      => s_4);

	MUX4o: mux2t1_N port map(
		i_S      => i_shiftdir,
		i_D0     => s_4ol,
		i_D1     => s_4oro,
		o_O      => o_d);

----------------------------------------------------------------------------------------------

end mixed;