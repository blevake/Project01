library IEEE;
use IEEE.std_logic_1164.all;

entity tb_decoder5t32 is
  generic(gCLK_HPER : time := 50 ns);  -- Clock half-period
end tb_decoder5t32;

architecture behavior of tb_decoder5t32 is
  constant cCLK_PER  : time := gCLK_HPER * 2;

  component decoder5t32
     port(
       i_I : in std_logic_vector(4 downto 0);      -- Input data (5-bit)
       o_O : out std_logic_vector(31 downto 0)     -- Output data (32-bit)
     );
  end component;

  -- Signal declarations for connecting to the decoder
  signal s_I  : std_logic_vector(4 downto 0);
  signal s_O  : std_logic_vector(31 downto 0);
  signal s_CLK : std_logic;

begin
  -- Instantiate the decoder component
  DUT: decoder5t32
    port map(i_I => s_I, o_O => s_O);

  -- Clock generation process
  P_CLK: process
  begin
    s_CLK <= '0';
    wait for gCLK_HPER;
    s_CLK <= '1';
    wait for gCLK_HPER;
  end process;
  
  -- Testbench process to apply test vectors
  P_TB: process
  begin
    -- Test Case 1 --
    s_I <= "00001";
    wait for cCLK_PER;
	
    -- Test Case 2 --
    s_I <= "00100";
    wait for cCLK_PER; 
	
    -- Test Case 3 --
    s_I <= "00011";
    wait for cCLK_PER;
	
    -- Test Case 4 --
    s_I <= "11111";
    wait for cCLK_PER;

    wait;
  end process;
end behavior;
