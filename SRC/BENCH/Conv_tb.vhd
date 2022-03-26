library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;
library LIB_RTL;
library LIB_AES;
use LIB_AES.state_definition_package.all;

entity Conv_tb is 
end Conv_tb;

architecture Conv_tb_arch of Conv_tb is 
	component Conv
	  port(
			data_i : in bit128;
			data_o : out type_state);
	  end component;
  signal data_i_s : bit128;
  signal data_o_s : type_state;
begin
  DUT : Conv
   port map (
	data_i => data_i_s, 
	data_o => data_o_s
	);
	data_i_s <= X"8c11354406ad4488decaec83aa034306"; --donnee chiffree codee sur 128 bits en entree du bloc InvAES 
end Conv_tb_arch;

configuration Conv_tb_conf of Conv_tb is
	for Conv_tb_arch
		for DUT : Conv
		   use entity LIB_RTL.Conv(Conv_arch);
		end for;
	end for;
end Conv_tb_conf;
