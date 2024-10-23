library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_barrelShifter is
end tb_barrelShifter;

architecture behavior of tb_barrelShifter is

    -- Component declaration for the barrel shifter
    component barrelshifter_32
    generic (N: integer := 32);
    port (
        i_d        : in  std_logic_vector(N-1 downto 0);
        o_d        : out std_logic_vector(N-1 downto 0);
        i_shiftdir : in  std_logic;
        i_shiftamt : in  std_logic_vector(4 downto 0);
        i_shifttype: in  std_logic
    );
    end component;

    -- Signals to connect to the barrel shifter
    signal i_d        : std_logic_vector(31 downto 0) := (others => '0'); -- Input data
    signal o_d        : std_logic_vector(31 downto 0);                     -- Output data
    signal i_shiftdir : std_logic := '0';                                  -- Shift direction: 0 for left, 1 for right
    signal i_shiftamt : std_logic_vector(4 downto 0) := "00000";           -- Shift amount (0 to 31)
    signal i_shifttype: std_logic := '0';                                  -- Shift type: 0 for logical, 1 for arithmetic

    -- Clock period for simulation (not really needed since there's no clock in this design)
    constant clk_period : time := 10 ns;

begin

    -- Instantiate the barrel shifter
    uut: barrelshifter_32
    port map (
        i_d        => i_d,
        o_d        => o_d,
        i_shiftdir => i_shiftdir,
        i_shiftamt => i_shiftamt,
        i_shifttype=> i_shifttype
    );

    -- Test process
    process
    begin
        -- Test case 1: Logical left shift by 1
        i_d <= x"00000001";  -- Input value (binary 1)
        i_shiftdir <= '0';   -- Shift left
        i_shiftamt <= "00001"; -- Shift by 1
        i_shifttype <= '0';  -- Logical shift
        wait for clk_period;

        -- Test case 2: Logical right shift by 2
        i_d <= x"80000000";  -- Input value (MSB is 1)
        i_shiftdir <= '1';   -- Shift right
        i_shiftamt <= "00010"; -- Shift by 2
        i_shifttype <= '0';  -- Logical shift
        wait for clk_period;

        -- Test case 3: Arithmetic right shift by 2
        i_d <= x"80000000";  -- Input value (MSB is 1)
        i_shiftdir <= '1';   -- Shift right
        i_shiftamt <= "00010"; -- Shift by 2
        i_shifttype <= '1';  -- Arithmetic shift
        wait for clk_period;

        -- Test case 4: Logical left shift by 8
        i_d <= x"0000FFFF";  -- Input value
        i_shiftdir <= '0';   -- Shift left
        i_shiftamt <= "01000"; -- Shift by 8
        i_shifttype <= '0';  -- Logical shift
        wait for clk_period;

        -- Test case 5: Arithmetic right shift by 16
        i_d <= x"F0000000";  -- Input value (negative in two's complement)
        i_shiftdir <= '1';   -- Shift right
        i_shiftamt <= "10000"; -- Shift by 16
        i_shifttype <= '1';  -- Arithmetic shift
        wait for clk_period;

        -- Stop the simulation after tests
        wait;
    end process;

end behavior;
