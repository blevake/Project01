library IEEE;
use IEEE.std_logic_1164.all;

entity onesComp is
    generic (
        N : integer := 32  -- Data width (default 32-bit)
    );
    port (
        i_I : in std_logic_vector(N-1 downto 0);  -- Input vector
        o_O : out std_logic_vector(N-1 downto 0)  -- Output vector (1's complement of input)
    );
end onesComp;

architecture structural of onesComp is

    -- Component for an inverter gate
    component invg is
        port (
            i_A : in std_logic;  -- Input bit
            o_F : out std_logic  -- Output bit (inverted)
        );
    end component;

begin

    -- Generate N instances of the inverter gate to calculate 1's complement
    G_OnesComp: for i in 0 to N-1 generate
        idk: invg port map(
            i_A => i_I(i),  -- Input bit
            o_F => o_O(i)   -- Inverted output bit
        );
    end generate G_OnesComp;

end structural;

