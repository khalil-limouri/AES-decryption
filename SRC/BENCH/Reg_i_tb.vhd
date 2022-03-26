library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;
library LIB_RTL;
library LIB_AES;
use LIB_AES.state_definition_package.all;

entity Reg_i_tb is
end Reg_i_tb;

architecture Reg_i_tb_arch of Reg_i_tb is 
  component Reg_i
	port(
		data_i : in  type_state;
		clock_i : in std_logic;
		reset_i : in std_logic;
		data_o : out type_state
	);	
	end component;
    signal reset_s  : std_logic;
    signal clock_s : std_logic := '0'; 
    signal data_i_s  : type_state;
    signal data_o_s  : type_state;
begin
    DUT : Reg_i
    port map (
      reset_i  => reset_s,
      clock_i  => clock_s,
      data_i => data_i_s,
      data_o  => data_o_s
      );
    reset_s <= '1', '0' after 10 ns; --reinitialisation a 0 du counter tant que t < 10 ns
    data_i_s <= ((X"2b", X"7e", X"15", X"16"), (X"28", X"ae", X"d2", X"a6"), (X"ab", X"f7", X"15", X"88"), (X"09", X"cf", X"4f", X"3c")), ((X"75", X"ec", X"78", X"56"), (X"5d", X"42", X"aa", X"f0"), (X"f6", X"b5", X"bf", X"78"),(X"ff", X"7a", X"f0", X"44")) after 8 ns ; --le test bench utilise les deux dernieres valeur de la cle
    clock_s <= not clock_s after 5 ns;	--front montant tous les 10 ns
end Reg_i_tb_arch;


configuration Reg_i_tb_conf of Reg_i_tb is
	for Reg_i_tb_arch
		for DUT : Reg_i
			use entity LIB_RTL.Reg_i(Reg_i_arch);
		end for;	
    end for;		
end Reg_i_tb_conf;
