	library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;
library LIB_RTL;
library LIB_AES;
use LIB_AES.state_definition_package.all;

entity Conv is 
	port(
		data_i : in  bit128;	--cle a la sortie du Key_expander ou donnee en entree du circuit AES inverse
		data_o : out type_state); --la cle en entree de ARK inverse ou la donnee entrante de AES round inverse
end Conv;

architecture Conv_arch of Conv is 
begin
	-- data_i(0)(0)<=data_o(127 downto 120)
	-- data_i(0)(1)<=data_o(119 downto 112)
	-- ...
	-- data_i(3)(3)<=data_o(7 downto 0)
	L1 : for I in 0 to 3 generate
		L2 : for J in 0 to 3 generate
		data_o(I)(J) <= data_i(127-8*J-32*I downto 128-8*(J+1)-32*I);
		end generate;
	end generate;
end Conv_arch;
