library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;
library LIB_RTL;
library LIB_AES;
use LIB_AES.state_definition_package.all;

entity FSM_InvAES_tb is
end FSM_InvAES_tb;

architecture FSM_InvAES_tb_arch of FSM_InvAES_tb is
	component FSM_InvAES
		port (
		clock_i : in std_logic;
		reset_i : in std_logic;
		round_i : in bit4;
		start_i : in std_logic;
		aes_done_o : out std_logic;
		round_enable_o	 : out std_logic;
		enable_output_o : out std_logic;
		enable_invMixColumns_o : out std_logic;
		enable_cpt_o : out std_logic;
		init_cpt_o : out std_logic
	);
	end component;

	signal clock_s : std_logic := '0'; 
	signal reset_s : std_logic;
	signal round_s : bit4;
	signal start_s : std_logic;
	signal done_s : std_logic;
	signal round_enable_s : std_logic;
	signal init_cpt_s : std_logic;
	signal enable_cpt_s : std_logic;
	signal enable_output_s : std_logic;
	signal enable_invMixColumns_s : std_logic;
	signal counter_s : natural range 0 to 15;
begin

	DUT : FSM_InvAES  
	port map (
		reset_i => reset_s,
		clock_i => clock_s,
		round_i => round_s,
		start_i => start_s,
		aes_done_o => done_s,
		round_enable_o =>round_enable_s,
		enable_output_o =>enable_output_s,
		enable_invMixColumns_o => enable_invMixColumns_s,
		enable_cpt_o => enable_cpt_s,
		init_cpt_o => init_cpt_s
	);
		
  --processus qui modelise la decrementation du numero de la ronde et remplace le bloc	Counter
  P0 : process(clock_s, reset_s, init_cpt_s, enable_cpt_s) --liste de sensibilite avec reset asynchrone 
  begin
    if (reset_s = '1') then --actif à l'état haut 
      counter_s <= 0; --reinitialisation du cpt
    elsif (clock_s'event and clock_s = '1') then --front montant
      if (enable_cpt_s = '1') then --cpt actif
	      if (init_cpt_s = '1') then --initialisation du cpt 
        		counter_s <= 10; --valeur maximale initial du cpt
      	else
	      	counter_s <= counter_s - 1; --cpt mis a jour
			end if;
   	else
        counter_s <= counter_s; --memorisation
      end if;
    end if;
  end process P0;
  
	clock_s <= not clock_s after 4 ns; --clock_i a 0, periode de 8 ns, 11 coups si reset a 0,  duree = 120 ns
	reset_s <= '1', '0' after 15 ns; --reinitialisation a 0 du counter tant que t < 15 ns
	--conversion de le numero de la ronde avec les fonctions suivantes
	--https://www.doulos.com/knowhow/vhdl/vhdl-2008-easier-to-use/#arithmeticslv/
   round_s <= std_logic_vector(to_unsigned(counter_s, 4)); 
	start_s <= '0', '1' after 15 ns; --demarrage de la FSM que si t > 15 ns
	
end FSM_InvAES_tb_arch; 

configuration FSM_InvAES_tb_conf of FSM_InvAES_tb is
	for FSM_InvAES_tb_arch
		for DUT : FSM_InvAES
		   use entity LIB_RTL.FSM_InvAES(FSM_InvAES_arch);
		end for;
	end for;
end FSM_InvAES_tb_conf;
