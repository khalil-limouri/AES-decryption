library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

library LIB_AES;
use LIB_AES.state_definition_package.all;

entity Counter is
  port(reset_i  : in  std_logic;
       enable_i : in  std_logic;
       clock_i  : in  std_logic;
       init_i : in  std_logic;
       count_o  : out bit4);
end entity Counter;

architecture Counter_arch of Counter is
  signal counter_s : natural range 0 to 15; --plus petite puissance de 2 (1,2...,16...) et superieur au nombre total des etats de la FSM (11)
begin
  P0 : process(clock_i, reset_i, init_i, enable_i) --liste de sensibilite avec reset asynchrone
  begin
    if (reset_i = '1') then --actif à l'état haut 
      counter_s <= 0; --reinitialisation du cpt
    elsif (clock_i'event and clock_i = '1') then --front montant
      if (enable_i = '1') then --cpt actif
	      if (init_i = '1') then --initialisation du cpt 
        		counter_s <= 10; --valeur maximale initiale du cpt
      	else
	      	counter_s <= counter_s - 1; --cpt mis a jour
			end if;
   	else
        counter_s <= counter_s; --memorisation
      end if;
    end if;
  end process P0;
	--conversion de la sortie de comptage sur 4 bits non signee avec les fonctions 
	--https://www.doulos.com/knowhow/vhdl/vhdl-2008-easier-to-use/#arithmeticslv/
  count_o <= std_logic_vector(to_unsigned(counter_s, 4));
end architecture Counter_arch;

