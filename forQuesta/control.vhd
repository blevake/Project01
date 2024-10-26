library IEEE;
use IEEE.std_logic_1164.all;

entity control is

  port(iOp                   : in std_logic_vector(5 downto 0);	-- Instuctions 31-26
       iFunc                 : in std_logic_vector(5 downto 0);	-- Instuctions 5-0
       oALUSrc               : out std_logic;
       oALUCtl               : out std_logic_vector(3 downto 0);
       oMemtoReg             : out std_logic;
       oDMemWr               : out std_logic;
       oRegWr                : out std_logic;
       oBr		     : out std_logic;
       oJ                    : out std_logic;
       oSE                   : out std_logic;	-- sign extension
       oJR                   : out std_logic;
       oRegDst               : out std_logic;
       halt 		     : out std_logic);

end control;

architecture behavior of control is
signal s_halt : std_logic := '0';

begin

process(iOp, iFunc)
begin
    case iOp is
	when "000000" =>      	-- R
		case iFunc is 
				when "100000" =>	-- add
					oALUSrc   <= '0';
					oALUCtl   <= x"6"; -- Add
					oMemtoReg <= '0';
					oDMemWr   <= '0';
					oRegWr    <= '1';
					oRegDst   <= '1';
                                        oBr       <= '0';
					oJ        <= '0';
                                        oSE       <= '1';
                                        oJR       <= '0';
				when "100001" => 	-- addu
					oALUSrc   <= '0';
					oALUCtl   <= x"6"; -- add
					oMemtoReg <= '0';
					oDMemWr   <= '0';
					oRegWr    <= '1';
					oRegDst   <= '1';
                                        oBr       <= '0';
					oJ        <= '0';
                                        oSE       <= '0';
                                        oJR       <= '0';
				when "100100" => 	-- and
					oALUSrc   <= '0';
					oALUCtl   <= x"0"; -- and
					oMemtoReg <= '0';
					oDMemWr   <= '0';
					oRegWr    <= '1';
					oRegDst   <= '1';
                                        oBr       <= '0';
					oJ        <= '0';
                                        oSE       <= '0';
                                        oJR       <= '0';
				when "100111" => 	-- nor
					oALUSrc   <= '0';
					oALUCtl   <= x"3"; -- nor
					oMemtoReg <= '0';
					oDMemWr   <= '0';
					oRegWr    <= '1';
					oRegDst   <= '1';
                                        oBr       <= '0';
					oJ        <= '0';
                                        oSE       <= '0';
                                        oJR       <= '0';
				when "100110" => 	-- xor
					oALUSrc   <= '0';
					oALUCtl   <= x"2"; -- xor
					oMemtoReg <= '0';
					oDMemWr   <= '0';
					oRegWr    <= '1';
					oRegDst   <= '1';
                                        oBr       <= '0';
					oJ        <= '0';
                                        oSE       <= '0';
                                        oJR       <= '0';
				when "100101" => 	-- or
					oALUSrc   <= '0';
					oALUCtl   <= x"1"; -- or
					oMemtoReg <= '0';
					oDMemWr   <= '0';
					oRegWr    <= '1';
					oRegDst   <= '1';
                                        oBr       <= '0';
					oJ        <= '0';
                                        oSE       <= '0';
                                        oJR       <= '0';
				when "101010" => 	-- slt
					oALUSrc   <= '0';
					oALUCtl   <= x"F"; -- set less than
					oMemtoReg <= '0';
					oDMemWr   <= '0';
					oRegWr    <= '1';
					oRegDst   <= '1';
                                        oBr       <= '0';
					oJ        <= '0';
                                        oSE       <= '0';
                                        oJR       <= '0';
				when "000000" => 	-- sll
					oALUSrc   <= '0';
					oALUCtl   <= x"7"; -- sll
					oMemtoReg <= '0';
					oDMemWr   <= '0';
					oRegWr    <= '1';
					oRegDst   <= '1';
                                        oBr       <= '0';
					oJ        <= '0';
                                        oSE       <= '0';
                                        oJR       <= '0';
				when "000010" => 	-- srl
					oALUSrc   <= '0';
					oALUCtl   <= x"8"; -- srl
					oMemtoReg <= '0';
					oDMemWr   <= '0';
					oRegWr    <= '1';
					oRegDst   <= '1';
                                        oBr       <= '0';
					oJ        <= '0';
                                        oSE       <= '0';
                                        oJR       <= '0';
				when "000011" => 	-- sra
					oALUSrc   <= '0';
					oALUCtl   <= x"9"; -- sra
					oMemtoReg <= '0';
					oDMemWr   <= '0';
					oRegWr    <= '1';
					oRegDst   <= '1';
                                        oBr       <= '0';
					oJ        <= '0';
                                        oSE       <= '0';
                                        oJR       <= '0';
				when "100010" => 	-- sub
					oALUSrc   <= '0';
					oALUCtl   <= x"E"; -- sub
					oMemtoReg <= '0';
					oDMemWr   <= '0';
					oRegWr    <= '1';
					oRegDst   <= '1';
                                        oBr       <= '0';
					oJ        <= '0';
                                        oSE       <= '0';
                                        oJR       <= '0';
				when "100011" => 	-- subu
					oALUSrc   <= '0';
					oALUCtl   <= x"E"; -- sub
					oMemtoReg <= '0';
					oDMemWr   <= '0';
					oRegWr    <= '1';
					oRegDst   <= '1';
                                        oBr       <= '0';
					oJ        <= '0';
                                        oSE       <= '0';
                                        oJR       <= '0';
				when "001000" => 	-- jr
					oALUSrc   <= '0';
					oALUCtl   <= x"0";
					oMemtoReg <= '0';
					oDMemWr   <= '0';
					oRegWr    <= '0';
					oRegDst   <= '0';
                                        oBr       <= '0';
					oJ        <= '1';
                                        oSE       <= '0';
                                        oJR       <= '1';
				when others =>
					oALUSrc   <= '0';
					oALUCtl   <= x"0";
					oMemtoReg <= '0';
					oDMemWr   <= '0';
					oRegWr    <= '0';
					oRegDst   <= '0';
                                        oBr       <= '0';
					oJ        <= '0';
                                        oSE       <= '0';
                                        oJR       <= '0';
			end case;

	when "001000" => -- addi	
		oALUSrc   <= '1';  -- Immediate
		oALUCtl   <= x"6"; -- Add
		oMemtoReg <= '0';  -- Read from ALU out
                oDMemWr   <= '0';  -- Does not write to mem
                oRegWr    <= '1';  -- Writes to register
                oRegDst   <= '0';  -- rt is destination register, not rd
                oBr       <= '0';  -- no branch
		oJ        <= '0';  -- no jump
                oSE       <= '1';  -- Sign extension
                oJR       <= '0';
	when "001001" =>	-- addiu
		oALUSrc   <= '1';
		oALUCtl   <= x"6"; -- add
		oMemtoReg <= '0';
                oDMemWr   <= '0';
                oRegWr    <= '1';
                oRegDst   <= '0';
                oBr       <= '0';
		oJ        <= '0';
                oSE       <= '0';
                oJR       <= '0';
	when "001100" => 	-- andi
		oALUSrc   <= '1';
		oALUCtl   <= x"0"; -- and
		oMemtoReg <= '0';
                oDMemWr   <= '0';
                oRegWr    <= '1';
                oRegDst   <= '0';
                oBr       <= '0';
		oJ        <= '0';
                oSE       <= '0';
                oJR       <= '0';
	when "001111" => 	-- lui
		oALUSrc   <= '1';
		oALUCtl   <= x"C"; -- lui
		oMemtoReg <= '0';
                oDMemWr   <= '0';
                oRegWr    <= '1';
                oRegDst   <= '0';
                oBr       <= '0';
		oJ        <= '0';
                oSE       <= '0';
                oJR       <= '0';
	when "100011" => 	-- lw
		oALUSrc   <= '1';
		oALUCtl   <= x"6"; -- add
		oMemtoReg <= '1';
                oDMemWr   <= '0';
                oRegWr    <= '1';
                oRegDst   <= '0';
                oBr       <= '0';
		oJ        <= '0';
                oSE       <= '0';
                oJR       <= '0';
	when "001110" => 	-- xori
		oALUSrc   <= '1';
		oALUCtl   <= x"2"; -- xor
		oMemtoReg <= '0';
                oDMemWr   <= '0';
                oRegWr    <= '1';
                oRegDst   <= '0';
                oBr       <= '0';
		oJ        <= '0';
                oSE       <= '0';
                oJR       <= '0';
	when "001101" => 	-- ori
		oALUSrc   <= '1';
		oALUCtl   <= x"1"; -- or
		oMemtoReg <= '0';
                oDMemWr   <= '0';
                oRegWr    <= '1';
                oRegDst   <= '0';
                oBr       <= '0';
		oJ        <= '0';
                oSE       <= '0';
                oJR       <= '0';
	when "001010" => 	-- slti
		oALUSrc   <= '1';
		oALUCtl   <= x"F"; -- set less than
		oMemtoReg <= '0';
                oDMemWr   <= '0';
                oRegWr    <= '1';
                oRegDst   <= '0';
                oBr       <= '0';
		oJ        <= '0';
                oSE       <= '1';
                oJR       <= '0';
	when "101011" => 	-- sw
		oALUSrc   <= '1';
		oALUCtl   <= x"6"; -- add
		oMemtoReg <= '0';
                oDMemWr   <= '1';
                oRegWr    <= '0';
                oRegDst   <= '0';
                oBr       <= '0';
		oJ        <= '0';
                oSE       <= '0';
                oJR       <= '0';
	when "000100" => 	-- beq
		oALUSrc   <= '1';
		oALUCtl   <= x"E"; -- sub
		oMemtoReg <= '0';
                oDMemWr   <= '0';
                oRegWr    <= '0';
                oRegDst   <= '0';
                oBr       <= '1';
		oJ        <= '0';
                oSE       <= '0';
                oJR       <= '0';
	when "000101" => 	-- bne
		oALUSrc   <= '1';
		oALUCtl   <= x"C"; -- sub
		oMemtoReg <= '0';
                oDMemWr   <= '0';
                oRegWr    <= '0';
                oRegDst   <= '0';
                oBr       <= '1';
		oJ        <= '0';
                oSE       <= '0';
                oJR       <= '0';
	when "000010" => 	-- j
		oALUSrc   <= '0';
		oALUCtl   <= x"0";
		oMemtoReg <= '0';
                oDMemWr   <= '0';
                oRegWr    <= '0';
                oRegDst   <= '0';
                oBr       <= '0';
		oJ        <= '1';
                oSE       <= '0';
                oJR       <= '0';
	when "000011" => 	-- jal
		oALUSrc   <= '0';
		oALUCtl   <= x"0";
		oMemtoReg <= '0';
                oDMemWr   <= '0';
                oRegWr    <= '1';
                oRegDst   <= '0';
                oBr       <= '0';
		oJ        <= '1';
                oSE       <= '0';
                oJR       <= '0';
	when "010100" =>	-- halt
		oALUSrc   <= '0';
		oALUCtl   <= x"0";
		oMemtoReg <= '0';
                oDMemWr   <= '0';
                oRegWr    <= '1';
                oRegDst   <= '0';
                oBr       <= '0';
		oJ        <= '1';
                oSE       <= '0';
                oJR       <= '0';
		s_halt	  <= '1';
	when others => 	-- OTHER no writing
		oALUSrc   <= '0';
		oALUCtl   <= x"0";
		oMemtoReg <= '0';
                oDMemWr   <= '0';
                oRegWr    <= '0';
                oRegDst   <= '0';
                oBr       <= '0';
		oJ        <= '0';
                oSE       <= '0';
                oJR       <= '0';
    end case;
end process;
halt <= s_halt;

end behavior;
