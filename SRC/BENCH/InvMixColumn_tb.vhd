library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;
library LIB_RTL;
library LIB_AES;
use LIB_AES.state_definition_package.all;

entity InvMixColumn_tb is
end InvMixColumn_tb;

architecture InvMixColumn_tb_arch of InvMixColumn_tb is 
	component InvMixColumn
		port(
			col_i : in row_state;
			col_o : out row_state
		);
	end component;
	signal col_i_s : row_state;
	signal col_o_s : row_state;
begin 
	DUT : InvMixColumn
	port map
	(
		col_i => col_i_s,
		col_o => col_o_s
	);
	 --premiere ligne de la matrice en entree du InvMixColumns a la ronde numero 9 
	col_i_s <= (X"74", X"6c", X"e0", X"09");
end InvMixColumn_tb_arch;

configuration InvMixColumn_tb_conf of InvMixColumn_tb is
	for InvMixColumn_tb_arch
		for DUT : InvMixColumn
		   use entity LIB_RTL.InvMixColumn(InvMixColumn_arch);
		end for;
	end for;
end InvMixColumn_tb_conf;
