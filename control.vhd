library IEEE;
use IEEE.std_logic_1164.all;

entity control is

  port(iIn                   : in std_logic_vector(11 downto 0);	-- Instuctions 31-26 + 5-0
       oALUSrc               : out std_logic;
       oALUCtl               : out std_logic_vector(3 downto 0);
       oMemtoReg             : out std_logic;
       oDMemWr               : out std_logic;
       oRegWr                : out std_logic;
       oRegDst               : out std_logic);

end control;

architecture behavior of control is
signal sIn : std_logic_vector(11 downto 0);
begin

process(iIn)
begin
    if ((iIn and x"FC0") = x"000") then
	sIn <= iIn;
    else 
	sIn <= iIn and x"03F";
    end if;
    case sIn is
	when x"200" =>	-- addi
		oALUSrc   <= '1';  -- Immediate
		oALUCtl   <= x"6"; -- Add
		oMemtoReg <= '0';  -- Read from ALU out
                oDMemWr   <= '0';  -- Does not write to mem
                oRegWr    <= '1';  -- Writes to register
                oRegDst   <= '0';  -- rt is destination register, not rd
	when x"020" =>	-- add
		oALUSrc   <= '0';
		oALUCtl   <= x"6"; -- Add
		oMemtoReg <= '0';
                oDMemWr   <= '0';
                oRegWr    <= '1';
                oRegDst   <= '1';
	when x"009" =>	-- addiu
		oALUSrc   <= '1';
		oALUCtl   <= x"6"; -- add
		oMemtoReg <= '0';
                oDMemWr   <= '0';
                oRegWr    <= '1';
                oRegDst   <= '0';
	when x"021" => 	-- addu
		oALUSrc   <= '0';
		oALUCtl   <= x"6"; -- add
		oMemtoReg <= '0';
                oDMemWr   <= '0';
                oRegWr    <= '1';
                oRegDst   <= '1';
	when x"024" => 	-- and
		oALUSrc   <= '0';
		oALUCtl   <= x"0"; -- add
		oMemtoReg <= '0';
                oDMemWr   <= '0';
                oRegWr    <= '1';
                oRegDst   <= '0';
	when x"300" => 	-- andi
		oALUSrc   <= '1';
		oALUCtl   <= x"0"; -- and
		oMemtoReg <= '0';
                oDMemWr   <= '0';
                oRegWr    <= '1';
                oRegDst   <= '0';
	when x"3B0" => 	-- lui
		oALUSrc   <= '1';
		oALUCtl   <= x"0"; -- and?? (and imm with top 16 bits?)
		oMemtoReg <= '0';
                oDMemWr   <= '0';
                oRegWr    <= '1';
                oRegDst   <= '0';
	when x"8B0" => 	-- lw
		oALUSrc   <= '1';
		oALUCtl   <= x"6"; -- add
		oMemtoReg <= '1';
                oDMemWr   <= '0';
                oRegWr    <= '1';
                oRegDst   <= '0';
	when x"027" => 	-- nor
		oALUSrc   <= '0';
		oALUCtl   <= x"3"; -- nor
		oMemtoReg <= '0';
                oDMemWr   <= '0';
                oRegWr    <= '1';
                oRegDst   <= '1';
	when x"026" => 	-- xor
		oALUSrc   <= '0';
		oALUCtl   <= x"2"; -- xor
		oMemtoReg <= '0';
                oDMemWr   <= '0';
                oRegWr    <= '1';
                oRegDst   <= '1';
	when x"380" => 	-- xori
		oALUSrc   <= '1';
		oALUCtl   <= x"2"; -- xor
		oMemtoReg <= '0';
                oDMemWr   <= '0';
                oRegWr    <= '1';
                oRegDst   <= '0';
	when x"025" => 	-- or
		oALUSrc   <= '0';
		oALUCtl   <= x"1"; -- or
		oMemtoReg <= '0';
                oDMemWr   <= '0';
                oRegWr    <= '1';
                oRegDst   <= '1';
	when x"340" => 	-- ori
		oALUSrc   <= '1';
		oALUCtl   <= x"1"; -- or
		oMemtoReg <= '0';
                oDMemWr   <= '0';
                oRegWr    <= '1';
                oRegDst   <= '0';
	when x"02A" => 	-- slt
		oALUSrc   <= '0';
		oALUCtl   <= x"F"; -- set less than
		oMemtoReg <= '0';
                oDMemWr   <= '0';
                oRegWr    <= '1';
                oRegDst   <= '1';
	when x"280" => 	-- slti
		oALUSrc   <= '1';
		oALUCtl   <= x"F"; -- set less than
		oMemtoReg <= '0';
                oDMemWr   <= '0';
                oRegWr    <= '1';
                oRegDst   <= '0';
	when x"000" => 	-- sll
		oALUSrc   <= '0';
		oALUCtl   <= x"7"; -- sll
		oMemtoReg <= '0';
                oDMemWr   <= '0';
                oRegWr    <= '1';
                oRegDst   <= '1';
	when x"002" => 	-- srl
		oALUSrc   <= '0';
		oALUCtl   <= x"8"; -- srl
		oMemtoReg <= '0';
                oDMemWr   <= '0';
                oRegWr    <= '1';
                oRegDst   <= '1';
	when x"003" => 	-- sra
		oALUSrc   <= '0';
		oALUCtl   <= x"9"; -- sra
		oMemtoReg <= '0';
                oDMemWr   <= '0';
                oRegWr    <= '1';
                oRegDst   <= '1';
	when x"AC0" => 	-- sw
		oALUSrc   <= '1';
		oALUCtl   <= x"6"; -- add
		oMemtoReg <= '0';
                oDMemWr   <= '1';
                oRegWr    <= '0';
                oRegDst   <= '0';
	when x"022" => 	-- sub
		oALUSrc   <= '0';
		oALUCtl   <= x"E"; -- sub
		oMemtoReg <= '0';
                oDMemWr   <= '0';
                oRegWr    <= '1';
                oRegDst   <= '1';
	when x"023" => 	-- subu
		oALUSrc   <= '0';
		oALUCtl   <= x"E"; -- sub
		oMemtoReg <= '0';
                oDMemWr   <= '0';
                oRegWr    <= '1';
                oRegDst   <= '1';
	when x"100" => 	-- beq
		oALUSrc   <= '1';
		oALUCtl   <= x"E"; -- sub
		oMemtoReg <= '0';
                oDMemWr   <= '0';
                oRegWr    <= '0';
                oRegDst   <= '0';
	when x"140" => 	-- bne
		oALUSrc   <= '1';
		oALUCtl   <= x"E"; -- sub
		oMemtoReg <= '0';
                oDMemWr   <= '0';
                oRegWr    <= '0';
                oRegDst   <= '0';
	when x"080" => 	-- j
		oALUSrc   <= '0';
		oALUCtl   <= x"0"; -- ???? probably nothing because there is another adder for this
		oMemtoReg <= '0';
                oDMemWr   <= '0';
                oRegWr    <= '0';
                oRegDst   <= '0';
	when x"0C0" => 	-- jal
		oALUSrc   <= '0';
		oALUCtl   <= x"0"; -- ???? probably nothing because there is another adder for this
		oMemtoReg <= '0';
                oDMemWr   <= '0';
                oRegWr    <= '0';
                oRegDst   <= '0';
	when x"008" => 	-- jr
		oALUSrc   <= '1';
		oALUCtl   <= x"0"; -- ???? probably nothing because there is another adder for this
		oMemtoReg <= '0';
                oDMemWr   <= '0';
                oRegWr    <= '0';
                oRegDst   <= '0';
	when others => 	-- OTHER no writing
		oALUSrc   <= '0';
		oALUCtl   <= x"0";
		oMemtoReg <= '0';
                oDMemWr   <= '0';
                oRegWr    <= '0';
                oRegDst   <= '0';
    end case;
end process;


end behavior;
