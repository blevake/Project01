library IEEE;
use IEEE.std_logic_1164.all;
use work.mypack.all;

entity regfile is
    port (
        clk    : in std_logic;                        -- Clock signal
        i_wA   : in std_logic_vector(4 downto 0);     -- Write address
        i_wD   : in std_logic_vector(31 downto 0);    -- Write data
        i_wC   : in std_logic;                        -- Write control signal (write enable)
        i_r1   : in std_logic_vector(4 downto 0);     -- Read address 1
        i_r2   : in std_logic_vector(4 downto 0);     -- Read address 2
        reset  : in std_logic;                        -- Reset signal
        o_d1   : out std_logic_vector(31 downto 0);   -- Read data 1
        o_d2   : out std_logic_vector(31 downto 0)    -- Read data 2
    );
end regfile;

architecture structural of regfile is

    -- Components used in this architecture
    component mux32t1 is
        port (
            i_I : in TwoDArray;   -- Data input (32 registers)
            i_S : in std_logic_vector(4 downto 0);  -- Select input
            o_O : out std_logic_vector(31 downto 0) -- Data output
        );
    end component;

    component decoder5t32 is
        port (
            i_I : in std_logic_vector(4 downto 0);  -- Input address (5-bit)
            o_O : out std_logic_vector(31 downto 0) -- Decoded output (32-bit one-hot)
        );
    end component;

    component dffg_n is
        port (
            i_CLK : in std_logic;                       -- Clock signal
            i_RST : in std_logic;                       -- Reset signal
            i_WE  : in std_logic;                       -- Write enable signal
            i_D   : in std_logic_vector(31 downto 0);   -- Data input
            o_Q   : out std_logic_vector(31 downto 0)   -- Data output
        );
    end component;

    -- Signals for internal connections
    signal s1, s3 : std_logic_vector(31 downto 0);
    signal s2     : TwoDArray;

begin

    -- Decoder to select the write register based on the write address (i_wA)
    writeDecoder: decoder5t32
        port map(i_I => i_wA, o_O => s1);

    -- Register 0 is hardwired to 0 (does not change)
    REG0: dffg_n port map(
        i_CLK => clk,
        i_RST => reset,
        i_WE  => '0',                 -- No write enable for register 0
        i_D   => x"00000000",          -- Register 0 always holds the value 0
        o_Q   => s2(0)
    );

    -- AND gate to mask the write enable signals for the other registers
    ANDGATE: process(s1)
    begin
        for i in 0 to 31 loop
            s3(i) <= s1(i) and i_wC;  -- Write enable is conditioned on the control signal
        end loop;
    end process;

    -- Generate registers 1 to 31
    RegisterList: for i in 1 to 31 generate
        REGI: dffg_n port map(
            i_CLK => clk,
            i_RST => reset,
            i_WE  => s3(i),           -- Write enable for this register
            i_D   => i_wD,            -- Write data
            o_Q   => s2(i)            -- Output data
        );
    end generate RegisterList;

    -- MUX for Read 1
    Read1: mux32t1
        port map(i_I => s2, i_S => i_r1, o_O => o_d1);

    -- MUX for Read 2
    Read2: mux32t1
        port map(i_I => s2, i_S => i_r2, o_O => o_d2);

end structural;

