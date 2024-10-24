library IEEE;
use IEEE.std_logic_1164.all;

entity MIPS_processor is
  generic(N : integer := 32);
  port(
    iCLK        : in std_logic;
    iRST        : in std_logic;
    iInstLd     : in std_logic;
    iInstAddr   : in std_logic_vector(N-1 downto 0);
    iInstExt    : in std_logic_vector(N-1 downto 0);
    oALUOut     : out std_logic_vector(N-1 downto 0)
  ); 
end MIPS_processor;

architecture structure of MIPS_processor is

  -- Data Memory Signals
  signal s_DMemWr       : std_logic; 
  signal s_DMemAddr     : std_logic_vector(N-1 downto 0); 
  signal s_DMemData     : std_logic_vector(N-1 downto 0); 
  signal s_DMemOut      : std_logic_vector(N-1 downto 0); 

  -- Register File Signals 
  signal s_RegWr        : std_logic; 
  signal s_RegWrAddr    : std_logic_vector(4 downto 0); 
  signal s_RegWrData    : std_logic_vector(N-1 downto 0); 

  -- Instruction Memory Signals
  signal s_IMemAddr     : std_logic_vector(N-1 downto 0); 
  signal s_NextInstAddr : std_logic_vector(N-1 downto 0); 
  signal s_Inst         : std_logic_vector(N-1 downto 0); 

  -- Halt Signal
  signal s_Halt         : std_logic;  

  -- Overflow Signal
  signal s_Ovfl         : std_logic;  

  -- Additional Signals
  signal s_RegOutReadData1 : std_logic_vector(N-1 downto 0);
  signal s_RegInReadData1, s_RegInReadData2, s_RegD : std_logic_vector(4 downto 0);
  signal s_shamt        : std_logic_vector(4 downto 0);
  signal s_imm16        : std_logic_vector(15 downto 0);
  signal s_imm32        : std_logic_vector(31 downto 0); 
  signal s_imm32x4      : std_logic_vector(31 downto 0); 
  signal s_immMuxOut    : std_logic_vector(N-1 downto 0); 
  signal s_opCode       : std_logic_vector(5 downto 0);
  signal s_funcCode     : std_logic_vector(5 downto 0); 
  signal s_inputPC      : std_logic_vector(31 downto 0); 
  signal s_Ctrl         : std_logic_vector(14 downto 0);

  -- Control Signals
  signal s_ALUSrc       : std_logic; 
  signal s_jr           : std_logic; 
  signal s_jal          : std_logic; 
  signal s_ALUOp        : std_logic_vector(3 downto 0); 
  signal s_MemtoReg     : std_logic; 
  signal s_RegDst       : std_logic; 
  signal s_Branch       : std_logic;
  signal s_SignExt      : std_logic; 
  signal s_jump         : std_logic; 

  -- Addressing Signals
  signal s_PCPlusFour   : std_logic_vector(N-1 downto 0);
  signal s_jumpAddress  : std_logic_vector(N-1 downto 0);
  signal s_branchAddress: std_logic_vector(N-1 downto 0);
  signal s_MemToReg0    : std_logic_vector(31 downto 0);
  signal s_RegDst0      : std_logic_vector(4 downto 0);
  signal s_normalOrBranch, s_finalJumpAddress : std_logic_vector(31 downto 0);

  -- ALU Signals
  signal s_ALUBranch    : std_logic;

  signal s1, s2, s3     : std_logic; -- Temporary signals

  -- Component Declarations
  component mem is
    generic(ADDR_WIDTH : integer;
            DATA_WIDTH : integer);
    port(
      clk      : in std_logic;
      addr     : in std_logic_vector((ADDR_WIDTH-1) downto 0);
      data     : in std_logic_vector((DATA_WIDTH-1) downto 0);
      we       : in std_logic := '1';
      q        : out std_logic_vector((DATA_WIDTH -1) downto 0)
    );
  end component;

  component control_unit is
    port( 
      i_opcode  : in std_logic_vector(5 downto 0);
      i_funct   : in std_logic_vector(5 downto 0);
      o_Ctrl_Unt: out std_logic_vector(14 downto 0)
    );
  end component;

  component regfile is 
    port(
      clk    : in std_logic;
      i_wA   : in std_logic_vector(4 downto 0);
      i_wD   : in std_logic_vector(31 downto 0);
      i_wC   : in std_logic;
      i_r1   : in std_logic_vector(4 downto 0);
      i_r2   : in std_logic_vector(4 downto 0);
      reset  : in std_logic;
      o_d1   : out std_logic_vector(31 downto 0);
      o_d2   : out std_logic_vector(31 downto 0)
    );
  end component;

  component extender is
    port(
      i_I   : in std_logic_vector(15 downto 0);
      i_C   : in std_logic;
      o_O   : out std_logic_vector(31 downto 0)
    );
  end component;

  component mux2t1_N is
    generic(N : integer := 16);
    port(
      i_S   : in std_logic;
      i_D0  : in std_logic_vector(N-1 downto 0);
      i_D1  : in std_logic_vector(N-1 downto 0);
      o_O   : out std_logic_vector(N-1 downto 0)
    );
  end component;

  component addersubtractor is
    generic(N : integer := 32);
    port(
      nAdd_Sub : in std_logic;
      i_A      : in std_logic_vector(N-1 downto 0);
      i_B      : in std_logic_vector(N-1 downto 0);
      o_Y      : out std_logic_vector(N-1 downto 0);
      o_Cout   : out std_logic
    );
  end component;

  component alu is
    port(
      i_A        : in std_logic_vector(31 downto 0);
      i_B        : in std_logic_vector(31 downto 0);
      i_aluOp    : in std_logic_vector(3 downto 0);
      i_shamt    : in std_logic_vector(4 downto 0);
      o_F        : out std_logic_vector(31 downto 0);
      overFlow   : out std_logic;
      zero       : out std_logic
    );
  end component;

  component MIPS_pc is 
    port(
      i_CLK : in std_logic;
      i_RST : in std_logic;
      i_D   : in std_logic_vector(31 downto 0);
      o_Q   : out std_logic_vector(31 downto 0)
    );
  end component;

begin

  -- Instruction Memory Multiplexing
  with iInstLd select
    s_IMemAddr <= s_NextInstAddr when '0',
                  iInstAddr when others;

  -- Instruction Memory
  IMem: mem
    generic map(ADDR_WIDTH => 10, DATA_WIDTH => N)
    port map(
      clk  => iCLK,
      addr => s_IMemAddr(11 downto 2),
      data => iInstExt,
      we   => iInstLd,
      q    => s_Inst
    );

  -- Data Memory
  DMem: mem
    generic map(ADDR_WIDTH => 10, DATA_WIDTH => N)
    port map(
      clk  => iCLK,
      addr => s_DMemAddr(11 downto 2),
      data => s_DMemData,
      we   => s_DMemWr,
      q    => s_DMemOut
    );

  -- Control Unit
  control: control_unit
    port map(
      i_opcode   => s_opCode,
      i_funct    => s_funcCode,
      o_Ctrl_Unt => s_Ctrl
    );

  -- Additional processes, muxes, and components 
  -- TODO
  
end structure;

