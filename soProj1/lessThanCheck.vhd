
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;

-- Entity declaration for the lessThanCheck module
entity lessThanCheck is
    port(
        i_A : in std_logic_vector(31 downto 0);  -- Input A (32-bit vector)
        i_B : in std_logic_vector(31 downto 0);  -- Input B (32-bit vector)
        o_F : out std_logic_vector(31 downto 0)  -- Output Flag (1 if A < B, else 0)
    );
end lessThanCheck;

-- Architecture using dataflow to implement the less-than comparison
architecture dataflow of lessThanCheck is
    signal s_A, s_B : std_logic_vector(31 downto 0);  -- Internal signals for input vectors
begin
    -- Assign input vectors to internal signals
    s_A <= i_A;
    s_B <= i_B;

    -- Perform the signed less-than comparison
    o_F <= "00000000000000000000000000000001" when s_A < s_B else
           "00000000000000000000000000000000";  -- Set output flag based on comparison result
end dataflow;
