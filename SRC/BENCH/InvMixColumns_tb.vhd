library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;
library LIB_RTL;
library LIB_AES;
use LIB_AES.state_definition_package.all;

entity InvMixColumns_tb is
end InvMixColumns_tb;

architecture InvMixColumns_tb_arch of InvMixColumns_tb is 
	component InvMixColumns
		port(
			data_i : in type_state;
			enable_i : in std_logic;
			data_o : out type_state
		);
	end component;
	
	signal data_i_s : type_state;
	signal enable_s : std_logic;
	signal data_o_s : type_state;
begin 
	DUT : InvMixColumns
	port map
	(
		data_i => data_i_s,
		enable_i => enable_s,
		data_o => data_o_s
	);

	data_i_s <= ((X"74", X"6c", X"e0", X"09"), (X"ad", X"7f", X"68", X"28"), (X"d2", X"15", X"e6", X"8b"), (X"b0", X"40", X"15", X"ef")); --donnee en entree du InvMixColumns a la ronde numero 9
	enable_s <= '1';
end InvMixColumns_tb_arch;

configuration InvMixColumns_tb_conf of InvMixColumns_tb is
	for InvMixColumns_tb_arch
		for DUT : InvMixColumns
		   use entity LIB_RTL.InvMixColumns(InvMixColumns_arch);
		end for;
	end for;
end InvMixColumns_tb_conf;
