library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;
library LIB_RTL;
library LIB_AES;
use LIB_AES.state_definition_package.all;

entity InvAESRound_tb is 
end InvAESRound_tb;

architecture InvAESRound_tb_arch of InvAESRound_tb is 
	component InvAESRound
		port(
			data_i : in type_state;
			key_Round_i : in type_state;
			round_enable_i : in std_logic;
			clock_i : in std_logic;
			reset_i : in std_logic;
			enable_InvMixColumns_i : in std_logic;
			data_o : out type_state
		);
	end component; 
	signal data_i_s : type_state;
	signal key_Round_s: type_state;
	signal round_enable_s : std_logic;
	signal clock_s : std_logic := '0';
	signal reset_s : std_logic;
	signal enable_InvMixColumns_s : std_logic;
	signal data_o_s : type_state;
begin
	DUT : InvAESRound
		port map(
			data_i => data_i_s,
			key_Round_i => key_Round_s,
			round_enable_i =>round_enable_s,
			clock_i => clock_s,
			reset_i => reset_s,
			enable_InvMixColumns_i => enable_InvMixColumns_s,
			data_o => data_o_s
		);
	--test des rondes 10 et 9
	data_i_s <= ((X"8c", X"11", X"35", X"44"), (X"06", X"ad", X"44", X"88"), (X"de", X"ca", X"ec", X"83"), (X"aa", X"03", X"43", X"06")); 
   key_Round_s <= ((X"e7", X"05", X"10", X"0b"), (X"8e", X"80", X"42", X"7e"), (X"78", X"4d", X"9b", X"0e"),(X"71", X"1a", X"e1", X"65")), ((X"0b", X"b8", X"15", X"4b"), (X"69", X"85", X"52", X"75"), (X"f6", X"cd", X"d9", X"70"), (X"09", X"57", X"7a", X"6b")) after 10 ns; 
	--test de la ronde 0
	--data_i_s <= ((X"6a", X"0d", X"38", X"62"), (X"5d", X"8e", X"be", X"c7"), (X"8b", X"b4", X"5a", X"de"), (X"40", X"8b", X"6f", X"03"));
	--key_Round_s <= ((X"2b", X"7e", X"15", X"16"), (X"28", X"ae", X"d2", X"a6"), (X"ab", X"f7", X"15", X"88"), (X"09", X"cf", X"4f", X"3c"))

	clock_s <=  not clock_s after 2 ns;	 --periode de 4 ns 
	reset_s <=  '1', '0' after 10 ns;
   round_enable_s <= '0', '1' after 10 ns; --test de la ronde 0	 		round_enable_s <='0';
	enable_InvMixColumns_s <= '0', '1' after 10 ns; --test de round 0 	enable_InvMixColumns_s <='0';

end InvAESRound_tb_arch;

configuration InvAESRound_tb_conf of InvAESRound_tb is
	for InvAESRound_tb_arch
		for DUT : InvAESRound
			  	 use entity LIB_RTL.InvAESRound(InvAESRound_arch);
		end for;
	end for;
end InvAESRound_tb_conf;



