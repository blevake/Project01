library IEEE;
use IEEE.std_logic_1164.all;

entity tb_extender is
  generic(gCLK_HPER : time := 50 ns);  
end tb_extender;

architecture behavior of tb_extender is

  constant cCLK_PER : time := gCLK_HPER * 2;

  -- Extender component declaration
  component extender
    port (
      i_I : in std_logic_vector(15 downto 0);     -- 16-bit Data input
      i_C : in std_logic;                         -- Control (0: zero extend, 1: sign extend)
      o_O : out std_logic_vector(31 downto 0)     -- 32-bit Data output
    );
  end component;

  -- Signal declarations to connect to the DUT (Device Under Test)
  signal s_C, s_clk : std_logic;
  signal s_I : std_logic_vector(15 downto 0);
  signal s_O : std_logic_vector(31 downto 0);

begin
  -- Instantiate the extender component
  DUT: extender
    port map (
      i_I => s_I,       -- Connect 16-bit input
      i_C => s_C,       -- Connect control signal
      o_O => s_O        -- Connect 32-bit output
    );

  -- Clock generation process: toggles clock signal every gCLK_HPER
  P_CLK: process
  begin
    s_clk <= '0';
    wait for gCLK_HPER;
    s_clk <= '1';
    wait for gCLK_HPER;
  end process;

  -- Testbench process: applies test inputs to the extender
  P_TB: process
  begin
    -- Test case 1: Zero extend 0x0000 -> 0x00000000
    s_I <= x"0000";
    s_C <= '0';
    wait for cCLK_PER;

    -- Test case 2: Sign extend 0x0000 -> 0x00000000
    s_I <= x"0000";
    s_C <= '1';
    wait for cCLK_PER;

    -- Test case 3: Zero extend 0xFFFF -> 0x0000FFFF
    s_I <= x"FFFF";
    s_C <= '0';
    wait for cCLK_PER;

    -- Test case 4: Sign extend 0xFFFF -> 0xFFFFFFFF
    s_I <= x"FFFF";
    s_C <= '1';
    wait for cCLK_PER;

    -- Test case 5: Sign extend 0x7FFF -> 0x00007FFF
    s_I <= x"7FFF";
    s_C <= '1';
    wait for cCLK_PER;

    -- Test case 6: Sign extend 0x8000 -> 0xFFFF8000
    s_I <= x"8000";
    s_C <= '1';
    wait for cCLK_PER;

    -- End simulation
    wait;
  end process;

end behavior;
