library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;
library LIB_RTL;
library LIB_AES;
use LIB_AES.state_definition_package.all;

entity InvAES_tb is 
end InvAES_tb;

architecture InvAES_tb_arch of InvAES_tb is 
	component InvAES
		port(
		data_i : in bit128;
		start_i : in std_logic;
		clock_i : in std_logic;
		reset_i : in std_logic;
		aes_done_o : out std_logic;
		data_o : out bit128
		);
	end component; 
	
	signal data_i_s : bit128;
	signal start_s: std_logic;
	signal clock_s : std_logic := '0';
	signal reset_s : std_logic;
	signal aes_done_s : std_logic;
	signal data_o_s : bit128;
begin
	DUT : InvAES
	port map(
		data_i => data_i_s,
		start_i => start_s, 
		clock_i => clock_s,	
		reset_i => reset_s,
		aes_done_o => aes_done_s,
		data_o => data_o_s
	);		
	--pour enchainer 2 fois consecutivement le meme calcul decommenter la deuxieme moitie de la ligne :
	data_i_s <= X"8c11354406ad4488decaec83aa034306";--, X"8c11354406ad4488decaec83aa034306" after 155 ns;
	clock_s <= not clock_s after 5 ns;--clock_i:=0 et periode de 10 ns et 14 coups, donc duree totale 145 ns 
	--pour enchainer 2 fois consecutivement le meme calcul decommenter la deuxieme moitie des 2 lignes :
	start_s <= '0', '1' after 15 ns, '0' after 135 ns, '1' after 155 ns;--, '1' after 160 ns;
	reset_s <= '1', '0' after 15 ns, '1' after 155 ns;--, '0' after 160 ns, '1' after 305 ns; 
end InvAES_tb_arch;

configuration InvAES_tb_conf of InvAES_tb is
	for InvAES_tb_arch
		for DUT : InvAES
			  	 use entity LIB_RTL.InvAES(InvAES_arch);
		end for;
	end for;
end InvAES_tb_conf;

