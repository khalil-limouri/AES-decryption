library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;
library LIB_RTL;
library LIB_AES;
use LIB_AES.state_definition_package.all;

entity InvAddRoundKey_tb is
end InvAddRoundKey_tb;

architecture InvAddRoundKey_tb_arch of InvAddRoundKey_tb is 
	component InvAddRoundKey
		port(
			data_i : in type_state;
			key_i : in type_state;
			data_o : out type_state
		);
	end component;
	signal data_i_s : type_state;
	signal key_s : type_state;
	signal data_o_s : type_state;

	begin 
	DUT : InvAddRoundKey
	port map	(
		data_i => data_i_s,
		key_i => key_s,
		data_o => data_o_s
	);
	
	data_i_s <= ((X"8c", X"11", X"35", X"44"), (X"06", X"ad", X"44", X"88"), (X"de", X"ca", X"ec", X"83"), (X"b0", X"03", X"43", X"06"));--donnee en entree du InvAddRoundKey a la ronde numero 10
	key_s <= ((X"e7", X"05", X"10", X"0b"), (X"8e", X"80", X"42", X"7e"), (X"78", X"4d", X"9b", X"0e"),(X"71", X"1a", X"e1", X"65"));--cle en sortie du KeyExpansion_table a la ronde numero 10
end InvAddRoundKey_tb_arch;
	
configuration InvAddRoundKey_tb_conf of InvAddRoundKey_tb is
	for InvAddRoundKey_tb_arch
		for DUT : InvAddRoundKey
		   use entity LIB_RTL.InvAddRoundKey(InvAddRoundKey_arch);
		end for;
	end for;
end InvAddRoundKey_tb_conf;


