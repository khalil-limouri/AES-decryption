library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;
library LIB_RTL;
library LIB_AES;
use LIB_AES.state_definition_package.all;

entity InvAES is 
	port(
		data_i : in bit128;
		start_i : in std_logic;
		clock_i : in std_logic;
		reset_i : in std_logic;
		aes_done_o : out std_logic;
		data_o : out bit128
	);
end InvAES;
--tous les composants : FSM, InvAESRound, Counter, RegSel, Reg_i, utilisant le clock et le reset, recoivent respectivement les ports en entree clock_i et reser_i de InvAES
architecture InvAES_arch of InvAES is 
	component Counter
		port(
			reset_i  : in  std_logic;
		   enable_i : in  std_logic;
		   clock_i  : in  std_logic;
		   init_i : in  std_logic;
		   count_o  : out bit4);
	end component;

	component KeyExpansion_table
	  port (round_i         : in  bit4;
		     expansion_key_o : out bit128);
	end component;

	component FSM_InvAES
		port (
			clock_i : in std_logic;
			reset_i : in std_logic;
			round_i : in bit4;
			start_i : in std_logic;
			aes_done_o : out std_logic;
			round_enable_o	 : out std_logic;
			init_cpt_o : out std_logic;
			enable_cpt_o : out std_logic;
			enable_output_o : out std_logic;
			enable_InvMixColumns_o : out std_logic
		);
	end component;

	component InvAESRound 
	port(
			data_i : in  type_state;
			key_Round_i : in type_state;
			round_enable_i : in std_logic;
			clock_i : in std_logic;
			reset_i : in std_logic;
			enable_InvMixColumns_i : in std_logic;
			data_o : out type_state
		);
	end component;

	component RegSel
		port(
			data_i : in  bit128;
			clock_i : in std_logic;
			reset_i : in std_logic;
			enable_i : in std_logic;		
			data_o : out bit128
		);
	end component;

	component InvConv
		port(
			data_i : in type_state;
			data_o : out bit128);
	end component;

	component Conv
		port(
			data_i : in bit128;
			data_o : out type_state);
	end component;

	-- signaux pour KeyExpansion_table, Counter, FSM
	signal expansion_key_s : bit128; 
	signal round_s : bit4;
	-- signaux pour Counter, FSM
	signal init_cpt_s : std_logic;
	signal enable_cpt_s : std_logic;
	-- signal pour FSM, RegSel
	signal enable_output_s : std_logic;
	-- signaux pour FSM, InvAESRound
	signal round_enable_s : std_logic;
	signal enable_InvMixColumns_s : std_logic;
	-- signaux pour Conv, InvAESRound, KeyExpansion_table
	signal data_in_s: type_state;
	signal key_Round_s: type_state;
	-- signal pour InvAESRound, InvConv
	signal data_out_s: type_state;
	-- signal pour InvConv, RegSel
	signal data_reg_s: bit128;

begin
	
	Count : Counter 
	port map(
		reset_i => reset_i,
		enable_i => enable_cpt_s,
		clock_i => clock_i,
		init_i => init_cpt_s,
		count_o => round_s
	);
	
	Key_table : KeyExpansion_table	
	port map(
		round_i => round_s,
		expansion_key_o => expansion_key_s
	);
	
	FSM : FSM_InvAES
	port map (
		reset_i => reset_i,
		clock_i => clock_i,
		round_i => round_s,
		start_i => start_i,
		aes_done_o => aes_done_o,
		init_cpt_o => init_cpt_s,
		enable_cpt_o => enable_cpt_s,
		enable_output_o =>enable_output_s,
		round_enable_o =>round_enable_s,
		enable_InvMixColumns_o => enable_InvMixColumns_s
	);

	Reg_Sel : RegSel
	port map(
		data_i => data_reg_s,		
		clock_i => clock_i,
		reset_i => reset_i,		
		enable_i => enable_output_s,		
		data_o => data_o
	);

	InvRound : InvAESRound 
	port map
	(
		data_i => data_in_s,
		key_Round_i => key_Round_s,
		round_enable_i =>round_enable_s, 
		clock_i => clock_i,
		reset_i => reset_i,
		enable_InvMixColumns_i => enable_InvMixColumns_s,
		data_o => data_out_s 
	);
	
	Conv_key : Conv 
	port map(
	    data_i => expansion_key_s,
	    data_o => key_Round_s
	);
	
	Conv_data : Conv 
	port map(
		    data_i => data_i,
		    data_o => data_in_s
	);
	
	Inv_Conv : InvConv 
	port map(
	    data_i => data_out_s,
	    data_o => data_reg_s
	);

end InvAES_arch;

--en somme 8 instances et 7 composants dans les choix du modele de la configuration
configuration InvAES_conf of InvAES is
	for InvAES_arch
		for Key_table : KeyExpansion_table	
			use entity LIB_RTL.KeyExpansion_table(KeyExpansion_table_arch);
		end for;
		for InvRound : InvAESRound
		  	 use entity LIB_RTL.InvAESRound(InvAESRound_arch);
		end for;
		for FSM : FSM_InvAES
		   use entity LIB_RTL.FSM_InvAES(FSM_InvAES_arch_Moore);
		end for;
		for Count : Counter
			use entity LIB_RTL.Counter(Counter_arch);
		end for;
		for Reg_Sel : RegSel
			use entity LIB_RTL.RegSel(RegSel_arch);
		end for;	
		for Conv_key : Conv
			use entity LIB_RTL.Conv(Conv_arch);
		end for;	
		for Conv_data : Conv
			use entity LIB_RTL.Conv(Conv_arch);
		end for;	
		for Inv_Conv : InvConv
			use entity LIB_RTL.InvConv(InvConv_arch);
		end for;	
	end for;
end InvAES_conf;
