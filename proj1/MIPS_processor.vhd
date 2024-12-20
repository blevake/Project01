
library IEEE;
use IEEE.std_logic_1164.all;


library work;
use work.MIPS_types.all;


entity MIPS_Processor is
  generic(N : integer := DATA_WIDTH);
    port(
        iCLK        : in std_logic;                          -- Clock signal
        iRST        : in std_logic;                          -- Reset signal
        iInstLd     : in std_logic;                          -- Instruction load signal
        iInstAddr   : in std_logic_vector(N-1 downto 0);     -- Instruction address
        iInstExt    : in std_logic_vector(N-1 downto 0);     -- Instruction extension for immediate values
        oALUOut     : out std_logic_vector(N-1 downto 0)     -- ALU output
    );
end MIPS_Processor;


architecture structure of MIPS_Processor is

 -- Required data memory signals
  signal s_DMemWr       : std_logic; -- TODO: use this signal as the final active high data memory write enable signal
  signal s_DMemAddr     : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory address input
  signal s_DMemData     : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory data input
  signal s_DMemOut      : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the data memory output
 
  -- Required register file signals 
  signal s_RegWr        : std_logic; -- TODO: use this signal as the final active high write enable input to the register file
  signal s_RegWrAddr    : std_logic_vector(4 downto 0); -- TODO: use this signal as the final destination register address input
  signal s_RegWrData    : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory data input

  -- Required instruction memory signals
  signal s_IMemAddr     : std_logic_vector(N-1 downto 0); -- Do not assign this signal, assign to s_NextInstAddr instead
  signal s_NextInstAddr : std_logic_vector(N-1 downto 0); -- TODO: use this signal as your intended final instruction memory address input.
  signal s_Inst         : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the instruction signal 

  -- Required halt signal -- for simulation
  signal s_Halt         : std_logic;  -- TODO: this signal indicates to the simulation that intended program execution has completed. (Opcode: 01 0100)

  -- Required overflow signal -- for overflow exception detection
  signal s_Ovfl         : std_logic;  -- TODO: this signal indicates an overflow exception would have been initiated


    component mem is
        generic(
            DATA_WIDTH : natural := 32;    -- Data width of memory
            ADDR_WIDTH : natural := 10     -- Address width of memory
        );
        port(
            clk   : in std_logic;                          	 -- Clock signal
            addr  : in std_logic_vector(ADDR_WIDTH-1 downto 0);  -- Address input
            data  : in std_logic_vector(DATA_WIDTH-1 downto 0);  -- Data input
            we    : in std_logic := '1';                  	 -- Write enable
            q     : out std_logic_vector(DATA_WIDTH-1 downto 0)  -- Data output
        );
    end component;

  -- TODO: You may add any additional signals or components your implementation 
  --       requires below this comment

    component control is
        port(
            iOp       : in std_logic_vector(5 downto 0);    -- Opcode field
            iFunc     : in std_logic_vector(5 downto 0);    -- Function field for R-type instructions
            oALUSrc   : out std_logic;                      -- ALU source selection
            oALUCtl   : out std_logic_vector(3 downto 0);   -- ALU control signals
            oMemtoReg : out std_logic;                      -- Memory to register selection
            oDMemWr   : out std_logic;                      -- Data memory write enable
            oRegWr    : out std_logic;                      -- Register file write enable
            oBr       : out std_logic;                      -- Branch control signal
            oJ        : out std_logic;                      -- Jump control signal
            oSE       : out std_logic;                      -- Sign extension enable
            oJR       : out std_logic;
            oRegDst   : out std_logic                       -- Register destination selection
);

    end component;


    component regfile is
        port(
            clk    : in std_logic;                          -- Clock signal
            i_wA   : in std_logic_vector(4 downto 0);       -- Write address
            i_wD   : in std_logic_vector(31 downto 0);      -- Write data
            i_wC   : in std_logic;                          -- Write enable signal
            i_r1   : in std_logic_vector(4 downto 0);       -- First read address
            i_r2   : in std_logic_vector(4 downto 0);       -- Second read address
            reset  : in std_logic;                          -- Reset signal
            o_d1   : out std_logic_vector(31 downto 0);     -- First read data output
            o_d2   : out std_logic_vector(31 downto 0)      -- Second read data output
        );
    end component;


    component mux2t1_N is
        port(
            i_S   : in std_logic;                          -- Select signal
            i_D0  : in std_logic_vector(31 downto 0);      -- First input
            i_D1  : in std_logic_vector(31 downto 0);      -- Second input
            o_O   : out std_logic_vector(31 downto 0)      -- Multiplexer output
        );
    end component;


    component alu is
        port(
            i_A       : in std_logic_vector(31 downto 0);  -- First operand
            i_B       : in std_logic_vector(31 downto 0);  -- Second operand
            i_aluOp   : in std_logic_vector(3 downto 0);   -- ALU operation control signal
            i_shamt   : in std_logic_vector(4 downto 0);   -- Shift amount
            o_F       : out std_logic_vector(31 downto 0); -- ALU result
            overFlow  : out std_logic;                     -- Overflow flag
            zero      : out std_logic                      -- Zero flag
        );
    end component;


    component andg2 is
         port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);
    end component;

component mux2t1_5 is 
generic(N : integer := 5); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_S          : in std_logic;
       i_D0         : in std_logic_vector(N-1 downto 0);
       i_D1         : in std_logic_vector(N-1 downto 0);
       o_O          : out std_logic_vector(N-1 downto 0));

end component;

    component sign_Ext is
        generic(
            INPUT_BIT_LENGTH : integer := 16;              -- Input bit width
            OUTPUT_BIT_LENGTH : integer := 32              -- Output bit width
        );
        port(
            i_signSel : in std_logic;                      -- Sign select: '1' for sign extension, '0' for zero extension
            i_imm     : in std_logic_vector(INPUT_BIT_LENGTH-1 downto 0); -- Immediate input
            o_imm     : out std_logic_vector(OUTPUT_BIT_LENGTH-1 downto 0) -- Extended output
        );
    end component;

    component fetchLogic is 
	port (
	i_PC		:	in std_logic_vector(N-1 downto 0);	--input program counter
	i_JumpReg	:	in std_logic;			
	i_Jump		:	in std_logic;
	i_Branch	:	in std_logic;
	i_ALUComp	:	in std_logic;
	i_JumpInstrImm	:	in std_logic_vector(25 downto 0);	--will be shifted left, then take top 4 bits from PC
	i_BranchInstrImm:	in std_logic_vector(N-1 downto 0);	--will be shifted left then added to PC, already sign extended
	i_RSInput	:	in std_logic_vector(N-1 downto 0);
	o_PC4		:	out std_logic_vector(N-1 downto 0);
	o_PC		:	out std_logic_vector(N-1 downto 0)	--output program counter
);
end component;


signal s_RF_rd1, s_RF_rd2, s_aluResult, s_ialu2, s_aluWriteData, s_PC4, s_imm : std_logic_vector(31 downto 0);  
signal s_aluCtl : std_logic_vector(3 downto 0);
signal s_aluScr, s_memToReg, s_j, s_jr, s_regDst, s_signExtSel, s_Br, s_zero, s_jal : std_logic;
signal s_regjalMux, s_regjalMux2 : std_logic_vector(4 downto 0);


begin

-- TODO: This is required to be your final input to your instruction memory. This provides a feasible method to externally load the memory module which means that the synthesis tool must assume it knows nothing about the values stored in the instruction memory. If this is not included, much, if not all of the design is optimized out because the synthesis tool will believe the memory to be all zeros.
  with iInstLd select
    s_IMemAddr <= s_NextInstAddr when '0',
      iInstAddr when others;

   IMem: mem
    generic map(ADDR_WIDTH => ADDR_WIDTH,
                DATA_WIDTH => N)
    port map(clk  => iCLK,
             addr => s_IMemAddr(11 downto 2),
             data => iInstExt,
             we   => iInstLd,
             q    => s_Inst);
  
  DMem: mem
    generic map(ADDR_WIDTH => ADDR_WIDTH,
                DATA_WIDTH => N)
    port map(clk  => iCLK,
             addr => s_DMemAddr(11 downto 2),
             data => s_DMemData,
             we   => s_DMemWr,
             q    => s_DMemOut);

  -- TODO: Ensure that s_Halt is connected to an output control signal produced from decoding the Halt instruction (Opcode: 01 0100)
  -- TODO: Ensure that s_Ovfl is connected to the overflow output of your ALU

  -- TODO: Implement the rest of your processor below this comment! 

  g_SIGNEXT: sign_Ext port map(
		i_signSel 	=> s_signExtSel,
		i_imm 		=> s_Inst, 
		o_imm 		=> s_imm 
		);


  g_REGFILE: regfile port map(
		clk        => iCLK, 
       		i_wA        => s_RegWrAddr, 
                i_wD   => s_RegWrData,
		i_wC   => s_RegWr, 
       		i_r1     => s_Inst(25 downto 21),
       		i_r2     => s_Inst(20 downto 16),
       		reset     => iRST, 
       		o_d1	     => s_RF_rd1, 
       		o_d2       => s_RF_rd2
		);

  g_CONTROL : control port map(
	    iOp       => s_Inst(31 downto 26),
            iFunc     => s_Inst(5 downto 0),
            oALUSrc   => s_aluScr,
            oALUCtl   => s_aluCtl,
            oMemtoReg => s_memToReg,
            oDMemWr   => s_DMemWr,
            oRegWr    => s_RegWr,
            oBr       => s_Br,
            oJ        => s_j,
            oSE       => s_signExtSel,
	    oJR       => s_jr,
            oRegDst   => s_regDst
		);

  g_ALU : alu port map(
		i_A		=> s_RF_rd1,
		i_B		=> s_ialu2, 
		i_aluOp		=> s_aluCtl,
		i_shamt		=> s_Inst(10 downto 6),
		o_F		=> s_aluResult, 
		overFlow	=> s_Ovfl,
		zero		=> s_zero 
		);

g_FETCHLOGIC : fetchLogic port map(
	i_PC       		=> s_NextInstAddr, 
       	i_JumpReg       	=> s_jr, 
	i_Jump  		=> s_j,
	i_Branch  		=> s_Br,
	i_ALUComp  		=> s_zero,
	i_JumpInstrImm  	=> s_Inst(25 downto 0),
	i_BranchInstrImm    	=> s_imm, 
	i_RSInput    		=> s_RF_rd1, 
        o_PC4			=> s_PC4,
	o_PC    		=> s_NextInstAddr
);

g_jal_AND: andg2 port map (
	i_A  =>      s_RegWr,
       	i_B    =>           s_j,
       	o_F      =>      s_jal
);


g_Regjal_MUX: mux2t1_5 port map (
		i_S => s_jal,	
		i_D0(4 downto 0) => s_Inst(20 downto 16),  
		i_D1 => s_regjalMux, 
		o_O => s_regjalMux
		);

g_RegDst_MUX: mux2t1_5 port map (
		i_S => s_regDst,	
		i_D0(4 downto 0) => s_Inst(15 downto 11),  
		i_D1 => s_regjalMux, 
		o_O => s_regjalMux2
		);

g_Regjal2_MUX: mux2t1_5 port map (
		i_S => s_jal,	
		i_D0 => s_regjalMux2, 
		i_D1 => "11111", 
		o_O => s_RegWrAddr
		);


g_RegWriteData1_MUX: mux2t1_N port map (
		i_S => s_jal,	
		i_D0 => s_aluResult, 
		i_D1 => s_PC4,	 
		o_O => s_aluWriteData
		);

g_RegWriteData2_MUX: mux2t1_N port map (
		i_S => s_memToReg,	
		i_D0 => s_aluWriteData, 
		i_D1 => s_DMemOut,		
		o_O => s_RegWrData
		);


g_ALUI2_MUX: mux2t1_N port map (
		i_S => s_aluScr,	
		i_D0 => s_RF_rd2, 
		i_D1 => s_imm,		
		o_O => s_ialu2
		);


end structure;

