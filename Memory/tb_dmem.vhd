library IEEE;
use IEEE.std_logic_1164.all;

entity tb_dmem is
  generic(gCLK_HPER   : time := 50 ns);  -- Clock half-period (default is 50 ns)
end tb_dmem;

architecture behavior of tb_dmem is
  constant cCLK_PER  : time := gCLK_HPER * 2;

  component mem
    generic 
    (
      DATA_WIDTH : natural := 32;       -- Data width (32 bits by default)
      ADDR_WIDTH : natural := 10        -- Address width (10 bits by default)
    );
    port 
    (
      clk   : in std_logic;                                   -- Clock signal
      addr  : in std_logic_vector((ADDR_WIDTH-1) downto 0);   -- Address input
      data  : in std_logic_vector((DATA_WIDTH-1) downto 0);   -- Data input
      we    : in std_logic := '1';                            -- Write enable signal
      q     : out std_logic_vector((DATA_WIDTH -1) downto 0)  -- Data output
    );
  end component;

  signal s_clk, s_we : std_logic;  -- Clock and write enable signals
  signal s_data, s_q : std_logic_vector(31 downto 0);  -- Data signals
  signal s_addr      : std_logic_vector(9 downto 0);   -- Address signal

begin

  dmem: mem
    port map(s_clk, s_addr, s_data, s_we, s_q);  -- Mapping the signals to the memory component

  P_CLK: process
  begin
    s_clk <= '0';                      -- Set clock low
    wait for gCLK_HPER;                -- Wait for half clock period
    s_clk <= '1';                      -- Set clock high
    wait for gCLK_HPER;                -- Wait for half clock period
  end process;
  
  P_TB: process
  begin
    -- Initial read operations from memory addresses 0 to 9 without writing
    s_addr <= "0000000000";  -- Address 0
    s_data <= x"00000001";   -- Data value (irrelevant since we are not writing)
    s_we   <= '0';           -- Disable writing (read mode)
    wait for cCLK_PER;       -- Wait for one clock period (read data)

    -- Loop to read subsequent memory addresses
    s_addr <= "0000000001";  
    wait for cCLK_PER;       
    s_addr <= "0000000010";  
    wait for cCLK_PER;       
    s_addr <= "0000000011";  
    wait for cCLK_PER;       
    s_addr <= "0000000100"; 
    wait for cCLK_PER;      
    s_addr <= "0000000101";
    wait for cCLK_PER;      
    s_addr <= "0000000110";  
    wait for cCLK_PER;       
    s_addr <= "0000000111"; 
    wait for cCLK_PER;      
    s_addr <= "0000001000";  
    wait for cCLK_PER;       
    s_addr <= "0000001001"; 
    wait for cCLK_PER;     

    -- Start writing the read values from the first 10 addresses to new memory locations (0x100 - 0x109)
    s_we <= '1';             -- Enable writing
    s_addr <= "0000000000";   -- Read from address 0
    wait for cCLK_PER;
    s_data <= s_q;           -- Store the read value from address 0
    s_addr <= "0100000000";   -- Write the value to address 0x100
    wait for cCLK_PER;

    -- Repeat for the next addresses
    s_we <= '1';  
    s_addr <= "0000000001";  -- Read from address 1
    wait for cCLK_PER;
    s_data <= s_q;
    s_addr <= "0100000001";  -- Write to address 0x101
    wait for cCLK_PER;

    -- Continue for the remaining addresses
    s_we <= '1';  
    s_addr <= "0000000010";  -- Read from address 2
    wait for cCLK_PER;
    s_data <= s_q;
    s_addr <= "0100000010";  -- Write to address 0x102
    wait for cCLK_PER;

    -- Continue for the remaining addresses
    s_we <= '1';  
    s_addr <= "0000000011";  -- Read from address 3
    wait for cCLK_PER;
    s_data <= s_q;
    s_addr <= "0100000011";  -- Write to address 0x103
    wait for cCLK_PER;

    -- Continue for the remaining addresses
    s_we <= '1';  
    s_addr <= "0000000100";  -- Read from address 4
    wait for cCLK_PER;
    s_data <= s_q;
    s_addr <= "0100000100";  -- Write to address 0x104
    wait for cCLK_PER;

    -- Continue for the remaining addresses
    s_we <= '1';  
    s_addr <= "0000000101";  -- Read from address 5
    wait for cCLK_PER;
    s_data <= s_q;
    s_addr <= "0100000101";  -- Write to address 0x105
    wait for cCLK_PER;

    -- Continue for the remaining addresses
    s_we <= '1';  
    s_addr <= "0000000110";  -- Read from address 6
    wait for cCLK_PER;
    s_data <= s_q;
    s_addr <= "0100000110";  -- Write to address 0x106
    wait for cCLK_PER;

    -- Continue for the remaining addresses
    s_we <= '1';  
    s_addr <= "0000000111";  -- Read from address 7
    wait for cCLK_PER;
    s_data <= s_q;
    s_addr <= "0100000111";  -- Write to address 0x107
    wait for cCLK_PER;

    -- Continue for the remaining addresses
    s_we <= '1';  
    s_addr <= "0000001000";  -- Read from address 8
    wait for cCLK_PER;
    s_data <= s_q;
    s_addr <= "0100001000";  -- Write to address 0x108
    wait for cCLK_PER;

    -- Continue for the remaining addresses
    s_we <= '1';  
    s_addr <= "0000001001";  -- Read from address 9
    wait for cCLK_PER;
    s_data <= s_q;
    s_addr <= "0100001001";  -- Write to address 0x109
    wait for cCLK_PER;

    -- Final reads from the new addresses (0x100 - 0x109)
    s_we <= '0';            -- Disable writing (read mode)
    s_addr <= "0100000000"; -- Read from 0x100
    wait for cCLK_PER;

    -- Repeat for the next addresses
    s_addr <= "0100000001"; -- Read from 0x101
    wait for cCLK_PER;
    s_addr <= "0100000010"; -- Read from 0x102
    wait for cCLK_PER;
    s_addr <= "0100000011"; -- Read from 0x103
    wait for cCLK_PER;
    s_addr <= "0100000100"; -- Read from 0x104
    wait for cCLK_PER;
    s_addr <= "0100000101"; -- Read from 0x105
    wait for cCLK_PER;
    s_addr <= "0100000110"; -- Read from 0x106
    wait for cCLK_PER;
    s_addr <= "0100000111"; -- Read from 0x107
    wait for cCLK_PER;
    s_addr <= "0100001000"; -- Read from 0x108
    wait for cCLK_PER;
    s_addr <= "0100001001"; -- Read from 0x109
    wait for cCLK_PER;

    wait; 
  end process;
  
end behavior;
