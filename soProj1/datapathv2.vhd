library IEEE;
use IEEE.std_logic_1164.all;
use work.mypack.all;

entity datapathv2 is
  port(
    clk        : in std_logic;
    reset      : in std_logic;
    nAddSub    : in std_logic;
    ALUSrc     : in std_logic;
    memWrite   : in std_logic;
    loadData   : in std_logic;
    regWrite   : in std_logic;
    i_A        : in std_logic_vector(4 downto 0);
    i_B        : in std_logic_vector(4 downto 0);
    i_C        : in std_logic_vector(4 downto 0);
    imm16      : in std_logic_vector(15 downto 0);
    o_d1       : out std_logic_vector(31 downto 0);
    o_d2       : out std_logic_vector(31 downto 0)
  );
end datapathv2;

architecture structural of datapathv2 is

  component regfile
    port(
      clk   : in std_logic;
      i_wA  : in std_logic_vector(4 downto 0);
      i_wD  : in std_logic_vector(31 downto 0);
      i_wC  : in std_logic;
      i_r1  : in std_logic_vector(4 downto 0);
      i_r2  : in std_logic_vector(4 downto 0);
      reset : in std_logic;
      o_d1  : out std_logic_vector(31 downto 0);
      o_d2  : out std_logic_vector(31 downto 0)
    );
  end component;

  component addersubtractor
    port(
      nAdd_Sub : in std_logic;
      i_A      : in std_logic_vector(31 downto 0);
      i_B      : in std_logic_vector(31 downto 0);
      o_Y      : out std_logic_vector(31 downto 0);
      o_Cout   : out std_logic
    );
  end component;

  component mux2t1_N
    port(
      i_S   : in std_logic;
      i_D0  : in std_logic_vector(31 downto 0);
      i_D1  : in std_logic_vector(31 downto 0);
      o_O   : out std_logic_vector(31 downto 0)
    );
  end component;

  component mem
    generic(
      DATA_WIDTH : natural := 32;
      ADDR_WIDTH : natural := 10
    );  
    port(
      clk  : in std_logic;
      addr : in std_logic_vector((ADDR_WIDTH-1) downto 0);
      data : in std_logic_vector((DATA_WIDTH-1) downto 0);
      we   : in std_logic := '1';
      q    : out std_logic_vector((DATA_WIDTH -1) downto 0)
    );
  end component;

  component extender
    port(
      i_I  : in std_logic_vector(15 downto 0);
      i_C  : in std_logic;
      o_O  : out std_logic_vector(31 downto 0)
    );
  end component;

  signal s1, s2, s3, s4, s6, s7, s8 : std_logic_vector(31 downto 0);
  signal s5 : std_logic;
  signal s9 : std_logic_vector(9 downto 0);

begin
  addsub: addersubtractor port map(nAddSub, s1, s3, s4, s5);
  registers: regfile port map(clk, i_C, s7, regWrite, i_A, i_B, reset, s1, s2);
  ALUMux: mux2t1_N port map(ALUSrc, s2, s8, s3);
  loadDataMux: mux2t1_N port map(loadData, s4, s6, s7);
  imm16t32: extender port map(imm16, '1', s8);
  dmem: mem port map(clk, s9, s2, memWrite, s6);

  process(s4)
  begin
    for i in 0 to 9 loop
      s9(i) <= s4(i+2);
    end loop;
  end process;

  o_d1 <= s1;
  o_d2 <= s2;

end structural;
