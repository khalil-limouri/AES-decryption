library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;
library LIB_RTL;
library LIB_AES;
use LIB_AES.state_definition_package.all;

entity FSM_Counter_InvAES_tb is
end FSM_Counter_InvAES_tb;

architecture FSM_Counter_InvAES_tb_arch of FSM_Counter_InvAES_tb is
	component FSM_InvAES
		port (
		clock_i : in std_logic;
		reset_i : in std_logic;
		round_i : in bit4;
		start_i : in std_logic;
		aes_done_o : out std_logic;
		round_enable_o	 : out std_logic;
		enable_output_o : out std_logic;
		enable_InvMixColumns_o : out std_logic;
		enable_cpt_o : out std_logic;
		init_cpt_o : out std_logic
	);
	end component;
	component Counter
		port (reset_i  : in  std_logic;
		    enable_i : in  std_logic;
		    clock_i  : in  std_logic;
		    init_i : in  std_logic;
		    count_o  : out bit4
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
	signal enable_InvMixColumns_s : std_logic;
		 
begin

	FSM_DUT : FSM_InvAES  
	port map (
		reset_i => reset_s,
		clock_i => clock_s,
		round_i => round_s,
		start_i => start_s,
		aes_done_o => done_s,
		round_enable_o =>round_enable_s,
		enable_output_o =>enable_output_s,
		enable_InvMixColumns_o => enable_InvMixColumns_s,
		enable_cpt_o => enable_cpt_s,
		init_cpt_o => init_cpt_s
	);
	Counter_DUT : Counter
	port map(
		reset_i => reset_s,
		enable_i => enable_cpt_s,
		clock_i => clock_s,
		init_i => init_cpt_s,
		count_o => round_s
		);
	clock_s <= not clock_s after 4 ns; --clock_i a 0, periode de 8 ns, 11 coups si reset a 0,  duree = 120 ns
	reset_s <= '1', '0' after 15 ns; --reinitialisation a 0 du counter tant que t < 15 ns
	start_s <= '0', '1' after 15 ns; --demarrage de la FSM que si t > 15 ns
	
end FSM_Counter_InvAES_tb_arch; 

configuration FSM_Counter_InvAES_tb_conf of FSM_Counter_InvAES_tb is
	for FSM_Counter_InvAES_tb_arch
		for FSM_DUT : FSM_InvAES
		   use entity LIB_RTL.FSM_InvAES(FSM_InvAES_arch);
		end for;
		for Counter_DUT : Counter
		   use entity LIB_RTL.Counter(Counter_arch);
		end for;
	end for;
end FSM_Counter_InvAES_tb_conf;

