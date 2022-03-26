library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

library LIB_AES;
use LIB_AES.state_definition_package.all;

entity InvMixColumn is 
	port(
		col_i : in row_state;
		col_o : out row_state
	);
end InvMixColumn;

--arch de type dataflow
architecture InvMixColumn_arch of InvMixColumn is 
	-- signaux de sauvegarde des multiplications avec les puissances croissantes de 2
	signal inter_sx2, inter_sx4, inter_sx8: column_state;
begin
		--K(0) équivaut à 
		--col_i(0)(6 downto 0) & '0											<=> 0b'd0_6d0_5d0_4d0_3d0_2d0_1 
		--					xor 														<=> ⊗ 
		--"000"&col_i(0)(7)&col_i(0)(7)&0&col_i(0)(7)&col_i(0)(7);	<=> 0b‘000d0_7d0_70d0_7d0_7
		--																					 tel que d0_k = col_i(0)(k)
	L1 : for K in 0 to 3 generate
		inter_sx2(K) <= col_i(K)(6 downto 0) & "0" xor "000"&col_i(K)(7)&col_i(K)(7)&"0"&col_i(K)(7)&col_i(K)(7);
		inter_sx4(K) <= inter_sx2(K)(6 downto 0) & "0" xor "000"&inter_sx2(K)(7)&inter_sx2(K)(7)&"0"&inter_sx2(K)(7)&inter_sx2(K)(7);
	inter_sx8(K) <= inter_sx4(K)(6 downto 0) & "0" xor "000"&inter_sx4(K)(7)&inter_sx4(K)(7)&"0"&inter_sx4(K)(7)&inter_sx4(K)(7); 
	end generate;	
	--combinaison par xor en fonction de la ligne de la matrice donnee qui doit correspondre au numero de col_i
	col_o(0) <= (inter_sx8(0) xor inter_sx4(0) xor inter_sx2(0)) xor (inter_sx8(1) xor inter_sx2(1) xor col_i(1)) xor (inter_sx8(2) xor inter_sx4(2) xor col_i(2)) xor (inter_sx8(3) xor col_i(3));

	col_o(1) <= (inter_sx8(1) xor inter_sx4(1) xor inter_sx2(1)) xor (inter_sx8(2) xor inter_sx2(2) xor col_i(2)) xor (inter_sx8(3) xor inter_sx4(3)xor col_i(3)) xor (inter_sx8(0) xor col_i(0));

	col_o(2) <= (inter_sx8(2) xor inter_sx4(2) xor inter_sx2(2)) xor (inter_sx8(3) xor inter_sx2(3) xor col_i(3)) xor (inter_sx8(0) xor inter_sx4(0)xor col_i(0)) xor (inter_sx8(1) xor col_i(1));

	col_o(3) <= (inter_sx8(3) xor inter_sx4(3) xor inter_sx2(3)) xor (inter_sx8(0) xor inter_sx2(0) xor col_i(0)) xor (inter_sx8(1) xor inter_sx4(1)xor col_i(1)) xor (inter_sx8(2) xor col_i(2));
	--affectation des octets de la colonne en sortie en décalant l'ordre des octets des signaux avec modulo 4 selon indice L :
	--L2 : for L in 0 to 3 generate
		--col_o(L) <= (inter_sx8(L) xor inter_sx4(L) xor inter_sx2(L)) xor (inter_sx8(L+1 mod 4) xor inter_sx2(L+1 mod 4) xor col_i(L+1 mod 4)) xor (inter_sx8(L+2 mod 4) xor inter_sx4(L+2 mod 4) xor col_i(L+2 mod 4)) xor (inter_sx8(L+3 mod 4) xor col_i(L+3 mod 4));
	--end generate
end InvMixColumn_arch;
