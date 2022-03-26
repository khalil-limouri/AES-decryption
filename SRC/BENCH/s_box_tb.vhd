library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;
library LIB_AES;
library LIB_RTL;
use LIB_AES.state_definition_package.all;

entity s_box_tb is
end s_box_tb;

architecture s_box_tb_arch of s_box_tb is 
	component s_box
		port(
			d_i : in bit8;
			d_o : out bit8);
	end component;
	signal d_i_s : bit8;
	signal d_o_s : bit8;
begin 
	DUT : s_box 
	port map(
		d_i => d_i_s,
		d_o => d_o_s
		);
	d_i_s <= X"6b", X"19" after 10 ns, X"77" after 20 ns, X"f6" after 30 ns; --1ere ligne du 1ere tableau en entree du InvSubBytes a la ronde n°9 
end s_box_tb_arch;

configuration s_box_tb_conf of s_box_tb is
	for s_box_tb_arch
		for DUT : s_box
		   use entity LIB_RTL.s_box(s_box_arch);
		end for;
	end for;
end s_box_tb_conf;

