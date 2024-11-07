LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY tb_WBReg IS
END tb_WBReg;

ARCHITECTURE behavior OF tb_WBReg IS
    CONSTANT N : INTEGER := 32;
    SIGNAL i_MEMData, i_ALUOut : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
    SIGNAL i_CLK : STD_LOGIC := '0';
    SIGNAL o_MEMData, o_ALUOut : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);

    COMPONENT WBReg
        GENERIC (N : INTEGER := 32);
        PORT (
            i_MEMData : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
            i_ALUOut : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
            i_CLK : IN STD_LOGIC;
            o_MEMData : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
            o_ALUOut : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
        );
    END COMPONENT;

BEGIN
    uut: WBReg
        PORT MAP (
            i_MEMData => i_MEMData,
            i_ALUOut => i_ALUOut,
            i_CLK => i_CLK,
            o_MEMData => o_MEMData,
            o_ALUOut => o_ALUOut
        );

    clk_process : PROCESS
    BEGIN
        i_CLK <= '0';
        WAIT FOR 10 ns;
        i_CLK <= '1';
        WAIT FOR 10 ns;
    END PROCESS;

    stim_proc: PROCESS
    BEGIN
        i_MEMData <= (OTHERS => '0');
        i_ALUOut <= (OTHERS => '0');
        WAIT FOR 20 ns;

        i_MEMData <= X"AAAAAAAA";
        i_ALUOut <= X"55555555";
        WAIT FOR 20 ns;

        i_MEMData <= X"12345678";
        i_ALUOut <= X"87654321";
        WAIT FOR 20 ns;

        WAIT;
    END PROCESS;

END behavior;
