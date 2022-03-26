library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;
library LIB_RTL;
library LIB_AES;
use LIB_AES.state_definition_package.all;

entity InvSubBytes is 
	port(
		data_i : in type_state;
		data_o : out type_state
	);
end InvSubBytes;

--arch de type structurel
architecture InvSubBytes_arch of InvSubBytes is 
	component s_box  
		port(	
			d_i : in bit8;
			d_o : out bit8
		);
	end component;
begin
	--mapper d_i et d_o des 16 instances aux octets de data_i et data_o
	s_box_table_row : for k in 0 to 3 generate
		s_box_table_col : for l in 0 to 3 generate
		s_box_cell : s_box port map (
			d_i => data_i(k)(l),
			d_o => data_o(k)(l)
		);
		end generate s_box_table_col;	
	end generate s_box_table_row;

end InvSubBytes_arch;

configuration InvSubBytes_conf of InvSubBytes is
	for InvSubBytes_arch
		for s_box_table_row --pour chaque ligne 
			for s_box_table_col --pour chaque colonne
				for s_box_cell : s_box --nom du composant instancie
			  	 use entity LIB_RTL.s_box(s_box_arch);
				end for;
			end for;
		end for;
	end for;
end InvSubBytes_conf;
