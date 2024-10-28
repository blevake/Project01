
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
USE ieee.numeric_std.ALL; 

entity decoder5t32 is
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_C          : in std_logic_vector(4 downto 0);
       o_O          : out std_logic_vector(31 downto 0));

end decoder5t32;

architecture Dataflow of decoder5t32 is

begin

    process(i_C) --should probably change this from a process in the future
    begin
        o_O <= (others => '0');
        case i_C is
            when "00000" => o_O(0) <= '1';
            when "00001" => o_O(1) <= '1';
            when "00010" => o_O(2) <= '1';
            when "00011" => o_O(3) <= '1';
            when "00100" => o_O(4) <= '1';
            when "00101" => o_O(5) <= '1';
            when "00110" => o_O(6) <= '1';
            when "00111" => o_O(7) <= '1';
            when "01000" => o_O(8) <= '1';
            when "01001" => o_O(9) <= '1';
            when "01010" => o_O(10) <= '1';
            when "01011" => o_O(11) <= '1';
            when "01100" => o_O(12) <= '1';
            when "01101" => o_O(13) <= '1';
            when "01110" => o_O(14) <= '1';
            when "01111" => o_O(15) <= '1';
            when "10000" => o_O(16) <= '1';
            when "10001" => o_O(17) <= '1';
            when "10010" => o_O(18) <= '1';
            when "10011" => o_O(19) <= '1';
            when "10100" => o_O(20) <= '1';
            when "10101" => o_O(21) <= '1';
            when "10110" => o_O(22) <= '1';
            when "10111" => o_O(23) <= '1';
            when "11000" => o_O(24) <= '1';
            when "11001" => o_O(25) <= '1';
            when "11010" => o_O(26) <= '1';
            when "11011" => o_O(27) <= '1';
            when "11100" => o_O(28) <= '1';
            when "11101" => o_O(29) <= '1';
            when "11110" => o_O(30) <= '1';
            when "11111" => o_O(31) <= '1';
            when others => null;
        end case;
    end process;
  

end Dataflow;
