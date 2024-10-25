library IEEE;
use IEEE.std_logic_1164.all;

-- Entity declaration for the beq (branch if equal) module
entity beq is
    port (
        i_A : in std_logic_vector(31 downto 0);  -- Input A (32-bit vector)
        i_B : in std_logic_vector(31 downto 0);  -- Input B (32-bit vector)
        o_F : out std_logic                     -- Output Flag (1 if A == B, else 0)
    );
end beq;

-- Architecture using dataflow to implement the equality check
architecture dataflow of beq is
begin
    -- Compare input vectors i_A and i_B
    -- Set o_F to '1' if they are equal, otherwise set it to '0'
    COMPARE: 
        o_F <= '1' when i_A = i_B else '0';
end dataflow;
