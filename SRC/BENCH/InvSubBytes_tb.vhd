library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;
library LIB_RTL;
library LIB_AES;
use LIB_AES.state_definition_package.all;

entity InvSubBytes_tb is
end InvSubBytes_tb;

architecture InvSubBytes_tb_arch of InvSubBytes_tb is 
	component InvSubBytes
		port(
			data_i : in type_state;
			data_o : out type_state
		);
	end component;
	signal data_i_s : type_state;
	signal data_o_s : type_state;
begin 
	DUT : InvSubBytes
	port map
	(
		data_i => data_i_s,
		data_o => data_o_s
	);
	data_i_s <= ((X"6b", X"19", X"77", X"f6"), (X"88", X"14", X"a2", X"8d"), (X"a6", X"2d", X"25", X"63"), (X"db", X"87", X"06", X"4f")); --donnee en entree du bloc InvSubBytes a la ronde numero 9
end InvSubBytes_tb_arch;

configuration InvSubBytes_tb_conf of InvSubBytes_tb is
	for InvSubBytes_tb_arch
		for DUT :InvSubBytes
		   use entity LIB_RTL.InvSubBytes(InvSubBytes_arch);
		end for;
	end for;
end InvSubBytes_tb_conf;
