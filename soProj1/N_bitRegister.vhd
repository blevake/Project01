library IEEE;
use IEEE.std_logic_1164.all;

entity N_bitRegister is
  generic(N: integer := 32);
  port(
    i_CLK  : in std_logic;
    i_RST  : in std_logic;
    i_WE   : in std_logic;
    i_D    : in std_logic_vector(N-1 downto 0);
    o_Q    : out std_logic_vector(N-1 downto 0)
  );
end N_bitRegister;

architecture mixed of N_bitRegister is
  signal s_D, s_Q : std_logic_vector(N-1 downto 0);

begin
  o_Q <= s_Q;

  with i_WE select
    s_D <= i_D when '1',
           s_Q when others;

  process(i_CLK, i_RST)
  begin
    if i_RST = '1' then
      s_Q <= (others => '0');
    elsif rising_edge(i_CLK) then
      s_Q <= s_D;
    end if;
  end process;

end mixed;