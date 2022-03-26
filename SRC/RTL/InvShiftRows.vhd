library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

library LIB_AES;
use LIB_AES.state_definition_package.all;

entity InvShiftRows is 
	port(
		data_i : in type_state;
		data_o : out type_state
	);
end InvShiftRows;

--arch type flot de donnees
architecture InvShiftRows_arch of InvShiftRows is 
	--signaux temporaires pour l'inversion de data_i data_o afin de rectifier le sens 
	signal temp_i_s : type_state;	
	signal temp_o_s : type_state;	
begin
	--possible de décaler chaque octet or redondance pour 16 elements
	L11 : for I in 0 to 3 generate
		L12 : for J in 0 to 3 generate
			temp_i_s(I)(J)<=data_i(J)(I); --1ere inversion des lignes et colonnes de data_i
		end generate;
	end generate;

	--pour la 1er ligne 	
	temp_o_s(0)<=temp_i_s(0); --aucune decalage pour la ligne d'indice 0
	--pour la 2eme ligne 
	temp_o_s(1)(0)<=temp_i_s(1)(3); --decalage a droite du 1er element de trois cases 
	L1 : for L in 1 to 3 generate 
		temp_o_s(1)(L)<=temp_i_s(1)(L-1); --decalage a gauche du reste de 1 case
	end generate;	
	--pour la 3eme ligne
	L3 : for I in 0 to 1 generate 
		temp_o_s(2)(I)<=temp_i_s(2)(I+2); --decalage a droite des 2 premiers elements de 2 cases 
	end generate;
	L2 : for M in 2 to 3 generate 
		temp_o_s(2)(M)<=temp_i_s(2)(M-2); --decalage a gauche des 2 elements extremes de 2 cases  
	end generate;
	--pour la 4eme ligne 
	L4 : for J in 0 to 2 generate 
		temp_o_s(3)(J)<=temp_i_s(3)(J+1); --decalage a droite des elements restants de 1 case
	end generate;
	temp_o_s(3)(3)<=temp_i_s(3)(0);  --decalage a gauche du dernier element de 3 cases  

	L21 : for I in 0 to 3 generate
		L22 : for J in 0 to 3 generate
			data_o(I)(J)<=temp_o_s(J)(I);	--remise du sens initial en inversant lignes et colonnes de data_o
		end generate;
	end generate;
		 
end InvShiftRows_arch;
