library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

library LIB_AES;
use LIB_AES.state_definition_package.all;

entity InvConv is 
	port(
		data_i : in type_state; --sortie de la ronde inversee
		data_o : out bit128);--sortie du registre selection 
end InvConv;

architecture InvConv_arch of InvConv is 
	signal data_s : type_state;
begin
			-- data_o(127 downto 120)<=data_i(0)(0)
			-- data_o(119 downto 112)<=data_i(0)(1)
			-- ...
			-- data_o(7 downto 0)<=data_i(3)(3)		
	L1 : for I in 0 to 3 generate
		L2 : for J in 0 to 3 generate
			data_o(127-8*J-32*I downto 128-8*(J+1)-32*I)<=data_i(I)(J); 				
		end generate;
	end generate;
end InvConv_arch;
