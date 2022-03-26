library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library LIB_RTL;
library LIB_AES;
use LIB_AES.state_definition_package.all;

entity Counter_tb is
end Counter_tb;

architecture Counter_tb_arch of Counter_tb is
  component Counter
    port(
		reset_i  : in  std_logic;
      enable_i : in  std_logic;
      clock_i  : in  std_logic;
      init_i : in  std_logic;
      count_o  : out bit4);
  end component;
  signal reset_s  : std_logic;
  signal enable_s : std_logic;
  signal clock_s : std_logic := '0'; 
  signal init_s  : std_logic;
  signal count_s  : bit4;
begin
	DUT : Counter
	port map (
		reset_i  => reset_s,
		enable_i => enable_s,
		clock_i  => clock_s,
		init_i => init_s,
		count_o  => count_s
		); 
	 clock_s <= not clock_s after 5 ns;	--front montant tous les 10 ns
	 reset_s <= '1', '0' after 10 ns; --reinitialisation a 0 du counter tant que t < 10ns
	 init_s <= '1', '0' after 80 ns; --initialisation a 0xA du counter tant que t < 80ns
	 enable_s <= '1'; --counter toujours actif mais ne se decrementre que si t > 80ns

end Counter_tb_arch;

configuration Counter_tb_conf of Counter_tb is
	for Counter_tb_arch
		for DUT : Counter
		   use entity LIB_RTL.Counter(Counter_arch);
		end for;
	end for;
end Counter_tb_conf;

