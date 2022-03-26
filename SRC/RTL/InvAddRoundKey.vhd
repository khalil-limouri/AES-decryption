library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

library LIB_AES;
use LIB_AES.state_definition_package.all;

entity InvAddRoundKey is 
	port(
		data_i : in type_state;
		key_i : in type_state;
		data_o : out type_state
	);
end InvAddRoundKey;

--arch de type dataflow
architecture InvAddRoundKey_arch of InvAddRoundKey is 
begin 
	--pour les 16 octets, elements des tableaux, xorer un a un
	L1 : for I in 0 to 3 generate
		L2 : for J in 0 to 3 generate
			data_o(I)(J)<=data_i(I)(J) xor key_i(I)(J);			
		end generate;
	end generate;
end InvAddRoundKey_arch;

