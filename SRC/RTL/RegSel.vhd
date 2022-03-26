library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

library LIB_AES;
use LIB_AES.state_definition_package.all;

entity RegSel is 
	port(
		data_i : in  bit128;
		clock_i : in std_logic;
		reset_i : in std_logic;
		enable_i : in std_logic;		
		data_o : out bit128
		);
end RegSel;

architecture RegSel_arch of RegSel is 
  signal data_s : bit128;
begin

	P0 : process (clock_i, reset_i, enable_i)
	begin 
	if reset_i = '1' then --reset asynchrone actif à l'état haut 
			data_s <= (others => '0'); --tous les octets a 0 meme resultat que :
												--data_s <= X"00000000000000000000000000000000";
	elsif clock_i'event and clock_i = '1' then --front montant 
		if enable_i = '1' then
			data_s <= data_i;--mis a jour
		else
			data_s <= data_s;--memorisation
		end if;
	end if;		
	end process P0;
data_o <= data_s;
end RegSel_arch;
