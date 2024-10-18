library IEEE;
use IEEE.std_logic_1164.all;

entity mux2t1_N is
    generic (
        N : integer := 32  -- Data width for input/output signals (default 32-bit)
    );
    port (
        i_S  : in std_logic;                        -- Select signal
        i_D0 : in std_logic_vector(N-1 downto 0);   -- Data input 0
        i_D1 : in std_logic_vector(N-1 downto 0);   -- Data input 1
        o_O  : out std_logic_vector(N-1 downto 0)   -- Output signal
    );
end mux2t1_N;

architecture structural of mux2t1_N is

    -- Declare a component for 1-bit 2-to-1 multiplexer
    component mux2t1 is
        port (
            i_S  : in std_logic;  -- Select signal
            i_D0 : in std_logic;  -- Data input 0
            i_D1 : in std_logic;  -- Data input 1
            o_O  : out std_logic  -- Output signal
        );
    end component;

begin

    -- Generate N instances of 1-bit 2-to-1 multiplexers
    G_NBit_MUX: for i in 0 to N-1 generate
        MUXI: mux2t1 port map(
            i_S  => i_S,      -- All instances share the same select input
            i_D0 => i_D0(i),  -- Data input 0 for ith instance
            i_D1 => i_D1(i),  -- Data input 1 for ith instance
            o_O  => o_O(i)    -- Output for ith instance
        );
    end generate G_NBit_MUX;

end structural;

