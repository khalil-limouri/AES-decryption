library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library LIB_AES;
library LIB_RTL;
use LIB_AES.state_definition_package.all;

entity KeyExpansion_table_tb is
end KeyExpansion_table_tb;

architecture KeyExpansion_table_tb_arch of KeyExpansion_table_tb is
  component KeyExpansion_table
    port (round_i         : in  bit4;
          expansion_key_o : out bit128);
  end component;
  signal round_s         : bit4;
  signal expansion_key_s : bit128;
begin
  DUT : KeyExpansion_table
  port map (
      round_i         => round_s,
      expansion_key_o => expansion_key_s);

    round_s <= X"0", X"A" after 10 ns; --test avec les deux numeros extremes de ronde : derniere : 0, et premiere : 10
end KeyExpansion_table_tb_arch;

configuration KeyExpansion_table_tb_conf of KeyExpansion_table_tb is
	for KeyExpansion_table_tb_arch
		for DUT : KeyExpansion_table
		   use entity LIB_RTL.KeyExpansion_table(KeyExpansion_table_arch);
		end for;
	end for;
end KeyExpansion_table_tb_conf;
