library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sign_Ext is
    port (
        i_imm  : in  std_logic_vector(15 downto 0);
        i_signSel : in std_logic;  
        o_imm : out std_logic_vector(31 downto 0)
    );
end sign_Ext;

architecture Behavioral of sign_Ext is
begin
    process(i_imm, i_signSel) --for future reference, should not use processes
    begin
        if i_signSel = '1' then 
            o_imm <= (i_imm(15) & i_imm(15) & i_imm(15) & i_imm(15) & --this is a bad way of replicating the most sig value
                           i_imm(15) & i_imm(15) & i_imm(15) & i_imm(15) &
                           i_imm(15) & i_imm(15) & i_imm(15) & i_imm(15) &
                           i_imm(15) & i_imm(15) & i_imm(15) & i_imm(15)) & i_imm; 	--need to replicate the most significant bit of provided 16 bit value
        else
            o_imm <= ( X"0000" & i_imm);			--add in a buncha zeroes
        end if;
    end process;
end Behavioral;