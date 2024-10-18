library IEEE;
use IEEE.std_logic_1164.all;


entity alu is
  port(
    i_A         : in std_logic_vector(31 downto 0);   -- First operand
    i_B         : in std_logic_vector(31 downto 0);   -- Second operand
    i_aluOp     : in std_logic_vector(3 downto 0);    -- ALU operation control signal
    i_shamt     : in std_logic_vector(4 downto 0);    -- Shift amount
    o_F         : out std_logic_vector(31 downto 0);  -- ALU result
    overFlow    : out std_logic;                      -- Overflow signal
    zero        : out std_logic                       -- Zero flag
  );
end alu;


architecture mixed of alu is

  signal adderOutput, barrelOutput, s_out : std_logic_vector(31 downto 0); -- Intermediate signals
  signal s_overflowControl, s_addSuboverFlow : std_logic;                   -- Overflow control signals

  component barrelshifter_32 is
    port(
      i_d         : in std_logic_vector(31 downto 0);  -- Input data
      o_d         : out std_logic_vector(31 downto 0); -- Output data
      i_shiftdir  : in std_logic;                      -- Shift direction (0: left, 1: right)
      i_shiftamt  : in std_logic_vector(4 downto 0);   -- Shift amount (0 to 31)
      i_shifttype : in std_logic                       -- Shift type (0: logical, 1: arithmetic)
    );
  end component;

  component beq_bne is
    port(
      i_F         : in std_logic_vector(31 downto 0);  -- Input data for equality comparison
      i_equal_type: in std_logic;                      -- 0: BNE, 1: BEQ
      o_zero      : out std_logic                      -- Zero flag output
    );
  end component;

  component alu_addersubtractor is
    generic(N : integer := 32); -- Generic for input/output data width, default 32
    port(
      nAdd_Sub   : in std_logic;                      -- Control signal for add/subtract
      i_A        : in std_logic_vector(N-1 downto 0); -- First operand
      i_B        : in std_logic_vector(N-1 downto 0); -- Second operand
      o_Y        : out std_logic_vector(N-1 downto 0);-- ALU result
      o_Overflow : out std_logic                      -- Overflow signal
    );
  end component;

  component andg2 is
    port(
      i_A : in std_logic; -- Input A for AND gate
      i_B : in std_logic; -- Input B for AND gate
      o_F : out std_logic -- Output for AND gate
    );
  end component;

begin
  -- Overflow control logic for specific ALU operations (overflow for "1110" and "1111")
  with i_aluOp select 
    s_overflowControl <=
      '1' when "1110",
      '1' when "1111",
      '0' when others;

  shifter: barrelshifter_32
    port map(
      i_d        => i_B,
      i_shiftamt => i_shamt,
      i_shiftdir => i_aluOp(0),
      i_shifttype=> i_aluOp(1),
      o_d        => barrelOutput
    );

  -- BEQ/BNE block for equality checking
  beq_bne_block: beq_bne
    port map(
      i_F         => s_out,
      i_equal_type=> i_aluOp(0),
      o_zero      => zero
    );

  -- ALU adder/subtractor instance
  addsub: alu_addersubtractor
    generic map(N => 32)
    port map(
      nAdd_Sub   => i_aluOp(0),
      i_A        => i_A,
      i_B        => i_B,
      o_Y        => adderOutput,
      o_Overflow => s_addSuboverFlow
    );

  -- Overflow control logic using AND gate
  overflow_control: andg2
    port map(
      i_A => s_overflowControl,
      i_B => s_addSuboverFlow,
      o_F => overFlow
    );

  -- ALU operation process
  process(i_aluOp, i_A, i_B, adderOutput, barrelOutput, s_addSuboverFlow)
  begin
    -- Logic for various ALU operations based on i_aluOp
    case i_aluOp is
      when "0010" =>  -- AND operation
        for i in 0 to 31 loop
          s_out(i) <= i_A(i) AND i_B(i);
        end loop;
        
      when "0011" =>  -- OR operation
        for i in 0 to 31 loop
          s_out(i) <= i_A(i) OR i_B(i);
        end loop;

      when "0100" | "1011" | "1100" =>  -- XOR operation (BEQ/BNE cases)
        for i in 0 to 31 loop
          s_out(i) <= i_A(i) XOR i_B(i);
        end loop;

      when "0101" =>  -- NOR operation
        for i in 0 to 31 loop
          s_out(i) <= i_A(i) NOR i_B(i);
        end loop;

      when "0111" =>  -- Set less than (slt)
        s_out(0) <= adderOutput(31) XOR s_addSuboverFlow; -- Copy sign bit XOR overflow
        for i in 1 to 31 loop
          s_out(i) <= '0';
        end loop;

      when "0110" =>  -- Load upper immediate (lui)
        for i in 0 to 15 loop
          s_out(i) <= '0';
        end loop;
        for i in 16 to 31 loop
          s_out(i) <= i_B(i-16);
        end loop;

      when "1001" | "1000" | "1010" =>  -- Shift operations (SRL, SRA, SLL)
        s_out <= barrelOutput;

      when "0000" | "0001" | "1110" | "1111" =>  -- Add, Subtract, Add unsigned, Subtract unsigned
        s_out <= adderOutput;

      when others =>  -- Default case for unrecognized ALU operations
        s_out <= (others => '0');
    end case;
  end process;

  o_F <= s_out;

end mixed;