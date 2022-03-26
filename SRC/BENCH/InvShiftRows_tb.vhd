library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;
library LIB_RTL;
library LIB_AES;
use LIB_AES.state_definition_package.all;

entity InvShiftRows_tb is
end InvShiftRows_tb;

architecture InvShiftRows_tb_arch of InvShiftRows_tb is 
	component InvShiftRows
		port(
			data_i : in type_state;
			data_o : out type_state
		);
	end component;
	signal data_i_s : type_state;
	signal data_o_s : type_state;

begin 
	DUT : InvShiftRows
	port map
	(
		data_i => data_i_s,
		data_o => data_o_s
	);
	  
	data_i_s <= ((X"6b", X"14", X"25", X"4f"), (X"88", X"2d", X"06", X"f6"), (X"a6", X"87", X"77", X"8d"), (X"db", X"19", X"a2", X"63")); --donnee en entree du InvShiftRows a la ronde numero 9
end InvShiftRows_tb_arch;

configuration InvShiftRows_tb_conf of InvShiftRows_tb is
	for InvShiftRows_tb_arch
		for DUT : InvShiftRows
		   use entity LIB_RTL.InvShiftRows(InvShiftRows_arch);
		end for;
	end for;
end InvShiftRows_tb_conf;
