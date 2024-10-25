library IEEE;
use IEEE.std_logic_1164.all;

entity tb_alu is
end tb_alu;

architecture test of tb_alu is
  -- Component Declaration of the ALU
  component alu is
    port(
      i_A         : in std_logic_vector(31 downto 0);
      i_B         : in std_logic_vector(31 downto 0);
      i_aluOp     : in std_logic_vector(3 downto 0);
      i_shamt     : in std_logic_vector(4 downto 0);
      o_F         : out std_logic_vector(31 downto 0);
      o_C         : out std_logic;
      overFlow    : out std_logic;
      zero        : out std_logic
    );
  end component;

  -- Testbench Signals
  signal tb_A, tb_B : std_logic_vector(31 downto 0);
  signal tb_aluOp   : std_logic_vector(3 downto 0);
  signal tb_shamt   : std_logic_vector(4 downto 0);
  signal tb_F       : std_logic_vector(31 downto 0);
  signal tb_C, tb_overFlow, tb_zero : std_logic;

  -- Clock period and half-period for timing
  constant clk_period : time := 100 ns;

begin
  -- DUT instance
  DUT: alu
    port map(
      i_A => tb_A,
      i_B => tb_B,
      i_aluOp => tb_aluOp,
      i_shamt => tb_shamt,
      o_F => tb_F,
      o_C => tb_C,
      overFlow => tb_overFlow,
      zero => tb_zero
    );

  -- Test process
  process
  begin
    -- Test case 1: NOR - 00000000 NOR 00000000 = FFFFFFFF
    tb_A <= (others => '0');
    tb_B <= (others => '0');
    tb_shamt <= "00000";
    tb_aluOp <= "0000"; -- NOR operation
    wait for clk_period;

    -- Test case 2: NOR - 00000000 NOR FFFFFFFF = 00000000
    tb_A <= (others => '0');
    tb_B <= (others => '1');
    tb_aluOp <= "0000"; -- NOR operation
    wait for clk_period;

    -- Test case 3: NOR - AAAA5555 NOR 00000000 = 5555AAAA
    tb_A <= x"AAAA5555";
    tb_B <= (others => '0');
    tb_aluOp <= "0000"; -- NOR operation
    wait for clk_period;

    -- Test case 4: OR - 00000000 OR 00000000 = 00000000
    tb_A <= (others => '0');
    tb_B <= (others => '0');
    tb_aluOp <= "0001"; -- OR operation
    wait for clk_period;

    -- Test case 5: OR - FFFFFFFF OR FFFFFFFF = FFFFFFFF
    tb_A <= (others => '1');
    tb_B <= (others => '1');
    tb_aluOp <= "0001"; -- OR operation
    wait for clk_period;

    -- Test case 6: OR - AAAA5555 OR 55555555 = FFFF5555
    tb_A <= x"AAAA5555";
    tb_B <= x"55555555";
    tb_aluOp <= "0001"; -- OR operation
    wait for clk_period;

    -- Test case 7: ADD - 00000000 + 00000000 = 00000000
    tb_A <= (others => '0');
    tb_B <= (others => '0');
    tb_aluOp <= "0010"; -- ADD operation
    wait for clk_period;

    -- Test case 8: ADD - FFFFFFFF + FFFFFFFF = FFFFFFFE (carry and overflow expected)
    tb_A <= (others => '1');
    tb_B <= (others => '1');
    tb_aluOp <= "0010"; -- ADD operation
    wait for clk_period;

    -- End of test
    wait;
  end process;

end test;

