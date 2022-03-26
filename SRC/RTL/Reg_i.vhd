library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

library LIB_AES;
use LIB_AES.state_definition_package.all;

entity Reg_i is 
	port(
 	    data_i : in type_state;
       clock_i : in std_logic;
       reset_i : in std_logic;
       data_o : out type_state
	);
end Reg_i;

architecture Reg_i_arch of Reg_i is 
	signal state_i_s : type_state;
	signal round_output_i_s : type_state;
begin
    round_output_i_s <= data_i;
    data_o <= state_i_s;
	 --processus qui etait nomme dans le document du projet : seq_0   
    P0 : process (clock_i, reset_i) is
    begin
    if reset_i = '1' then --actif à l'état haut 
    	state_i_s <= ((others => (others => (others => '0'))));  --meme resultat obtenu que : 
																				 	-- state_i_s <= ((X"00", X"00", X"00", X"00"), (X"00", X"00", X"00", X"00"), (X"00", X"00", X"00", X"00"), (X"00", X"00", X"00", X"00"));
																				 	--ou avec la generate 
																				 	--L1 : for I in 0 to 3 generate
																					--		L2 : for J in 0 to 3 generate
																					--			state_i_s(I)(J) <= '0';    
																					--		end generate;
																					--end generate;
    elsif clock_i'event and clock_i = '1' then --front montant 
    	state_i_s <= round_output_i_s; --mis a jour
    else
	    state_i_s <= state_i_s; --memorisation
    end if;
    end process P0;
	
end Reg_i_arch;
