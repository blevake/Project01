
library IEEE;
use IEEE.std_logic_1164.all;

entity slt_equality_check is
  port (
    i_A : in  std_logic_vector(31 downto 0); -- Input A (32-bit)
    i_B : in  std_logic_vector(31 downto 0); -- Input B (32-bit)
    o_F : out std_logic_vector(31 downto 0)  -- Output Flag (32-bit)
  );
end slt_equality_check;

architecture dataflow of slt_equality_check is
begin
  -- Compare i_A and i_B
  -- Set o_F to 1 (all bits as "00000001") if i_A equals i_B,
  -- otherwise set o_F to 0 (all bits as "00000000").
  UNLABELED:
    o_F <= "00000000000000000000000000000001" 
           when i_A(31) = i_B(31) else 
           "00000000000000000000000000000000";
end dataflow;

