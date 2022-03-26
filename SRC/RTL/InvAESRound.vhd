library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;
library LIB_RTL;
library LIB_AES;
use LIB_AES.state_definition_package.all;

entity InvAESRound is 
	port(
		data_i : in  type_state;
		key_Round_i : in type_state;
		round_enable_i : in std_logic;
		clock_i : in std_logic;
		reset_i : in std_logic;
		enable_InvMixColumns_i : in std_logic;
		data_o : out type_state
	);
end InvAESRound;

architecture InvAESRound_arch of InvAESRound is 
--la declaration est ordronnee de la meme facon que la ronde dans la figure de la structure : SR->SB->ARK->Reg->MC
	component InvShiftRows 
		port(
			data_i : in type_state;
			data_o : out type_state
		);
	end component;

	component  InvSubBytes
		port(
			data_i : in type_state;
			data_o : out type_state
		);
	end component;

	component InvAddRoundKey
		port(
			data_i : in type_state;
			key_i : in type_state;
			data_o : out type_state
		);
	end component;
	
	component  Reg_i 
		port(
			data_i : in type_state;
			clock_i : in std_logic;
			reset_i : in std_logic;
			data_o : out type_state
		);
	end component;

	component InvMixColumns
		port(
			data_i : in type_state;
			enable_i : in std_logic;
			data_o : out type_state
		);
	end component;

	signal key_s : type_state; --2eme entree du bloc ARK inverse
	signal ARK_in_s : type_state; --1ere entree du bloc ARK inverse
	signal MC_in_s : type_state; --1ere entree du bloc MC inverse
	signal SR_in_s : type_state; --entree du bloc SR inverse
	signal SB_in_s : type_state; --entree du bloc SB inverse
	signal state_1_s : type_state; --sortie du registre Reg_1
	signal round_output_1_s : type_state; --entree du registre Reg_1
	signal state_2_s : type_state; --sortie du registre Reg_2
	signal round_output_2_s : type_state; --entree du registre Reg_2
begin
	
	key_s <= key_Round_i; --copie de la cle en entree du bloc de ronde afin de la passer au bloc InvARK
	MC_in_s <= round_output_1_s; --copie de la sortie du Reg_1 avant bloc MC afin de le passer a InvMC
	--when et else permettent de modéliser le comportement du multiplexeur non instancié 
	ARK_in_s <= state_2_s when round_enable_i='1' else data_i;

	--instanctiation dans le sens du passage de la donnee avec Reg_i : ARK->Reg_1->MC->SR->Reg_2->SB--->ARK
	ARK : InvAddRoundKey
	port map
	(
		data_i => ARK_in_s,
		key_i => key_s,
		data_o => round_output_1_s
	);

	Reg_1 : Reg_i
	port map
	(
		data_i => round_output_1_s,
		clock_i => clock_i,
		reset_i => reset_i,
		data_o => state_1_s
	);
	
	MC : InvMixColumns
	port map
	(
		data_i => MC_in_s,
		enable_i => enable_InvMixColumns_i,
		data_o => SR_in_s
	);
	
	SR : InvShiftRows
	port map
	(
		data_i => SR_in_s,
		data_o => SB_in_s
	);
	
	Reg_2 : Reg_i	
	port map
	(
		data_i => round_output_2_s,
		clock_i => clock_i,
		reset_i => reset_i,
		data_o => state_2_s
	);

	SB : InvSubBytes
	port map
	(
		data_i => SB_in_s,
		data_o => round_output_2_s
	);

	data_o <= state_1_s;
	
end InvAESRound_arch;

configuration InvAESRound_conf of InvAESRound is
--la configuration est dans le meme ordre que la declaration
	for InvAESRound_arch
		for SR : InvShiftRows
		  	use entity LIB_RTL.InvShiftRows(InvShiftRows_arch);
		end for;
		for SB : InvSubBytes
			use entity LIB_RTL.InvSubBytes(InvSubBytes_arch);
		end for;
		for Reg_2 : Reg_i
			use entity LIB_RTL.Reg_i(Reg_i_arch);
		end for;	
		for ARK : InvAddRoundKey
			use entity LIB_RTL.InvAddRoundKey(InvAddRoundKey_arch);
		end for;
		for Reg_1 : Reg_i
			use entity LIB_RTL.Reg_i(Reg_i_arch);
		end for;	
		for MC : InvMixColumns
			use entity LIB_RTL.InvMixColumns(InvMixColumns_arch);
		end for;
	end for;
end InvAESRound_conf;
