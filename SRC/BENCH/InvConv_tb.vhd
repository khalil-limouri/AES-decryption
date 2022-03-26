library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;
library LIB_RTL;
library LIB_AES;
use LIB_AES.state_definition_package.all;

entity InvConv_tb is 
end InvConv_tb;

architecture InvConv_tb_arch of InvConv_tb is 
component InvConv
  port(
		data_i : in type_state;
		data_o : out bit128);
  end component;
  signal data_i_s : type_state;
  signal data_o_s : bit128;
begin
  DUT : InvConv
   port map (
	data_i => data_i_s, 
	data_o => data_o_s);
data_i_s <= ((X"8c", X"11", X"35", X"44"), (X"06", X"ad", X"44", X"88"), (X"de", X"ca", X"ec", X"83"), (X"b0", X"03", X"43", X"06")); --donnee chiffree en entree du InvAES sous forme de tableau de tableaux  
end InvConv_tb_arch;

configuration InvConv_tb_conf of InvConv_tb is
	for InvConv_tb_arch
		for DUT : InvConv
		   use entity LIB_RTL.InvConv(InvConv_arch);
		end for;
	end for;
end InvConv_tb_conf;
