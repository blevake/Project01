library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Mux16t1 is
    Port (
        sel : in STD_LOGIC_VECTOR(3 downto 0);  
        d   : in STD_LOGIC_VECTOR(15 downto 0); 
        y   : out STD_LOGIC                    
    );
end Mux16t1;

architecture Behavioral of Mux16t1 is
begin
    -- Mux implementation using with-select statement
    process(sel, d)
    begin
        case sel is
            when "0000" => y <= d(0);
            when "0001" => y <= d(1);
            when "0010" => y <= d(2);
            when "0011" => y <= d(3);
            when "0100" => y <= d(4);
            when "0101" => y <= d(5);
            when "0110" => y <= d(6);
            when "0111" => y <= d(7);
            when "1000" => y <= d(8);
            when "1001" => y <= d(9);
            when "1010" => y <= d(10);
            when "1011" => y <= d(11);
            when "1100" => y <= d(12);
            when "1101" => y <= d(13);
            when "1110" => y <= d(14);
            when "1111" => y <= d(15);
            when others => y <= '0'; 
        end case;
    end process;
end Behavioral;
