library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;
library LIB_RTL;
library LIB_AES;
use LIB_AES.state_definition_package.all;

entity InvMixColumns is 
	port(
		data_i : in type_state;
		enable_i : in std_logic;
		data_o : out type_state
	);
end InvMixColumns;

--type de arch est structurel
architecture InvMixColumns_arch of InvMixColumns is 
	component InvMixColumn
		port(	
			col_i : in row_state;
			col_o : out row_state
			);
	end component;
	--signal temporaire pour data_i
		signal temp_s : type_state;	
	--signal temporaire utile au data_o
	signal data_s : type_state;	
begin 
	L1 : for I in 0 to 3 generate
		L2 : for J in 0 to 3 generate
			temp_s(I)(J)<=data_i(J)(I); --lie l'entrée des instances au colonnes de data_i
		end generate;
	end generate;
	
	--les ports des 4 instances aux signaux declares
	InvMixColumn_col : for L in 0 to 3 generate
			InvMixColumn_cell : InvMixColumn port map (
				col_i => temp_s(L),
				col_o => data_s(L)
		);
	end generate InvMixColumn_col;		
	--mux : data_o est soit le résultat des sorties 4 instances soit data_i selon enable_i
	data_o <= data_i when enable_i = '0' else	data_s;
end InvMixColumns_arch;

configuration InvMixColumns_conf of InvMixColumns is
	for InvMixColumns_arch
		for InvMixColumn_col
				for InvMixColumn_cell : InvMixColumn
			  	 use entity LIB_RTL.InvMixColumn(InvInvMixColumn_arch);
				end for;
		end for;
	end for;
end InvMixColumns_conf;
