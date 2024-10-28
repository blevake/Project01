library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;	

entity tb_control is
  generic(gCLK_HPER   : time := 50 ns);
end tb_control;

architecture behavior of tb_control is
  
  constant cCLK_PER  : time := gCLK_HPER * 2;


  component control
    port(iOp        : in std_logic_vector(5 downto 0);
         iFunc      : in std_logic_vector(5 downto 0);
         oALUSrc    : out std_logic;
         oALUCtl    : out std_logic_vector(3 downto 0);
         oMemtoReg  : out std_logic;
         oDMemWr    : out std_logic;
         oRegWr     : out std_logic;
         oBr        : out std_logic;
       oJ                    : out std_logic;
       oSE                   : out std_logic;	-- sign extension
       oJR                   : out std_logic;
halt : out std_logic;
         oRegDst    : out std_logic);
  end component;

  -- Signals to connect to control
  signal s_CLK       : std_logic := '0';
  signal s_opcode    : std_logic_vector(5 downto 0) := (others => '0');
  signal s_funct     : std_logic_vector(5 downto 0) := (others => '0');
  signal expected_out: std_logic_vector(14 downto 0):= (others => '0');
  signal s_Ctrl      : std_logic_vector(14 downto 0);
  
  -- Output signals from control 
  signal s_ALUSrc    : std_logic;
  signal s_ALUCtl    : std_logic_vector(3 downto 0);
  signal s_MemtoReg  : std_logic;
  signal s_DMemWr    : std_logic;
  signal s_RegWr     : std_logic;
  signal s_Br        : std_logic;
  signal s_RegDst    : std_logic;
    signal   s_J                    : std_logic;
    signal   s_SE                   : std_logic;	-- sign extension
    signal   s_JR                   : std_logic;
signal shalt : std_logic;

begin


  DUT: control 
    port map(iOp => s_opcode,
             iFunc => s_funct,
             oALUSrc => s_ALUSrc,
             oALUCtl => s_ALUCtl,
             oMemtoReg => s_MemtoReg,
             oDMemWr => s_DMemWr,
             oRegWr => s_RegWr,
             oBr => s_Br,
             oRegDst => s_RegDst);


  P_CLK: process
  begin
    s_CLK <= '0';
    wait for gCLK_HPER;
    s_CLK <= '1';
    wait for gCLK_HPER;
  end process;


  P_TB: process
  begin
    
    -- Test add
    s_opcode <= "000000";
    s_funct  <= "100000";
    wait for cCLK_PER/2;

    -- Test addu
    s_opcode <= "000000";
    s_funct  <= "100001";
    wait for cCLK_PER/2;

    -- Test and
    s_opcode <= "000000";
    s_funct  <= "100100";
     
    wait for cCLK_PER/2;

    -- Test nor
    s_opcode <= "000000";
    s_funct  <= "100111";
     
    wait for cCLK_PER/2;

    -- Test xor
    s_opcode <= "000000";
    s_funct  <= "100110";
     
    wait for cCLK_PER/2;

    -- Test or
    s_opcode <= "000000";
    s_funct  <= "100101";
     
    wait for cCLK_PER/2;

    -- Test slt
    s_opcode <= "000000";
    s_funct  <= "101010";
     
    wait for cCLK_PER/2;

    -- Test sll
    s_opcode <= "000000";
    s_funct  <= "000000";
     
    wait for cCLK_PER/2;

    -- Test srl
    s_opcode <= "000000";
    s_funct  <= "000010";
     
    wait for cCLK_PER/2;

    -- Test sra
    s_opcode <= "000000";
    s_funct  <= "000011";
     
    wait for cCLK_PER/2;

    -- Test sub
    s_opcode <= "000000";
    s_funct  <= "100010";
     
    wait for cCLK_PER/2;

    -- Test subu
    s_opcode <= "000000";
    s_funct  <= "100011";
     
    wait for cCLK_PER/2;

    -- Test addi
    s_opcode <= "001000";
    s_funct  <= "000000";
     
    wait for cCLK_PER/2;

    -- Test addiu
    s_opcode <= "001001";
     
    wait for cCLK_PER/2;


    -- Test xori
    s_opcode <= "001110";
     
    wait for cCLK_PER/2;

    -- Test ori
    s_opcode <= "001101";
     
    wait for cCLK_PER/2;

    -- Test slti
    s_opcode <= "001010";
     
    wait for cCLK_PER/2;

    -- Test lui
    s_opcode <= "001111";
     
    wait for cCLK_PER/2;

    -- Test beq
    s_opcode <= "000100";
     
    wait for cCLK_PER/2;

    -- Test bne
    s_opcode <= "000101";
     
    wait for cCLK_PER/2;

    -- Test lw
    s_opcode <= "100011";
     
    wait for cCLK_PER/2;

    -- Test sw
    s_opcode <= "101011";
     
    wait for cCLK_PER/2;

    -- Test j
    s_opcode <= "000010";
     
    wait for cCLK_PER/2;

    -- Test jal
    s_opcode <= "000011";
     
    wait for cCLK_PER/2;

    -- Test jr
    s_opcode <= "000000";
    s_funct  <= "001000";
     
    wait for cCLK_PER/2;

    -- Test halt
    s_opcode <= "010100";
     
    wait for cCLK_PER/2;
    wait;
  end process;

end behavior;
