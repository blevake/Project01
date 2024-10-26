library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity extender is
    port (
        input_val  : in  std_logic_vector(15 downto 0);
        control_bit : in std_logic;  
        output_val : out std_logic_vector(31 downto 0)
    );
end extender;

architecture Behavioral of extender is
begin
    process(input_val, control_bit) --for future reference, should not use processes
    begin
        if control_bit = '1' then 
            output_val <= (input_val(15) & input_val(15) & input_val(15) & input_val(15) & --this is a bad way of replicating the most sig value
                           input_val(15) & input_val(15) & input_val(15) & input_val(15) &
                           input_val(15) & input_val(15) & input_val(15) & input_val(15) &
                           input_val(15) & input_val(15) & input_val(15) & input_val(15)) & input_val; 	--need to replicate the most significant bit of provided 16 bit value
        else
            output_val <= ( X"0000" & input_val);			--add in a buncha zeroes
        end if;
    end process;
end Behavioral;

