library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library LIB_AES;
library LIB_RTL;
use LIB_AES.state_definition_package.all;

entity RegSel_tb is
end RegSel_tb;

architecture RegSel_tb_arch of RegSel_tb is
  component RegSel
	port(
		data_i : in  bit128;
		clock_i : in std_logic;
		reset_i : in std_logic;
		enable_i : in std_logic;		
		data_o : out bit128
	);
	  end component;
  signal reset_s  : std_logic;
  signal enable_s : std_logic := '1'; --valeur initiale du enable_i est 1
  signal clock_s : std_logic := '0'; --valeur initiale du clock_i est 0
  signal data_i_s  : bit128;
  signal data_o_s  : bit128;
begin
  DUT : RegSel
    port map (
      reset_i  => reset_s,
      enable_i => enable_s,
      clock_i  => clock_s,
      data_i => data_i_s,
      data_o  => data_o_s
      );
	 reset_s <= '1', '0' after 10 ns; --reinitialisation a 0 du counter tant que t < 10ns
	 --a decommenter afin de tester une nouvelle donnee en entree du registre 
    data_i_s <= X"2b7e151628aed2a6abf7158809cf4f3c", X"8c11354406ad4488decaec83aa034306" after 35 ns ; --X"d4f125f097f7cee747669b783056caa7" after 65 ns; --le test bench utilise la cle et la donnee a dechiffree 
    enable_s <= not enable_s after 30 ns; --activite de facon periodique de duree 60 ns
    clock_s <= not clock_s after 5 ns;	--front montant tous les 10 ns
end RegSel_tb_arch;

configuration RegSel_tb_conf of RegSel_tb is
	for RegSel_tb_arch
		for DUT : RegSel
		   use entity LIB_RTL.RegSel(RegSel_arch);
		end for;
	end for;
end RegSel_tb_conf;

