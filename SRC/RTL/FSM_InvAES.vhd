library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

library LIB_AES;
use LIB_AES.state_definition_package.all;

entity FSM_InvAES is
	port(
	clock_i : in std_logic;
	reset_i : in std_logic;
	round_i : in bit4;
	start_i : in std_logic;
	aes_done_o : out std_logic;
	round_enable_o	 : out std_logic; --activer la ronde en la bouclant
	enable_output_o : out std_logic; --activer le registre de selection de la donnee dechiffree
	enable_InvMixColumns_o : out std_logic; --operer la transformation InvMixColumns
	enable_cpt_o : out std_logic;  --activer la decrementation du Counter
	init_cpt_o : out std_logic --initialiser le Counter a 0xA
);
end FSM_InvAES;

architecture FSM_InvAES_arch_Moore of FSM_InvAES is --contrainte de nomenclature du fichier de la FSM
	type state is (init, round10, round0, round9_1, fin); --5 etats possibles de la FSM dans l'ordre
	signal etat_present, etat_futur : state; --déclaration de deux etats du type prédéfini
begin 
	--actualisation à chaque nouveau front montants 
	seq_0 : process (clock_i, reset_i) 
	begin 
		if reset_i = '1'
		then 
			etat_present <= init; --etat par defaut au reset
		elsif clock_i'event and clock_i='1' then  --front montant 
			etat_present <= etat_futur;
		end if;
	end process seq_0;

	--calcul de etat_futur selon etat_present et entrees : start et numero (n°) de la round
	comb_0 : process(etat_present, round_i)
	begin 
		case etat_present is 
			--init-->round10 si start_i=1 
			when init =>
				if start_i = '1' then
					etat_futur <= round10;
			--sinon init-->init
				else 
					etat_futur <= init;
				end if;
			--round10-->round9_1
			when round10 =>
					etat_futur <= round9_1;
			--round9_1-->round0 si n°round=1
			when round9_1 =>
				if round_i = "0001" then
					etat_futur <= round0;
			--sinon round9_1-->round9_1
				else 
					etat_futur <= round9_1;
				end if;
			--round0-->fin	
			when round0 =>
					etat_futur <= fin;
			--fin-->init si start_i=0 
			when fin =>
				if start_i = '0' then
					etat_futur <= init;
			--sinon fin-->fin
				else 
					etat_futur <= fin;
				end if;
		end case; 
	end process comb_0;

	--affectation de la sortie à partir uniquement de etat_présent car FSM type Moore
	comb_1 : process(etat_present)
	begin 
		--toutes les sorties de la FSM sont initialisees à 0
	 	aes_done_o <= '0';
		round_enable_o <= '0';
		enable_InvMixColumns_o <= '0';
		enable_cpt_o <= '0';
		init_cpt_o <= '0';
		enable_output_o <= '0';
		case etat_present is 
			--activation et initialisation sans decrementation du Counter  
			when init =>
				init_cpt_o <= '1';
				enable_cpt_o <= '1';		
			--a la premiere ronde pas de bouclage : la donnee est le texte chiffre
			when round10 =>
				init_cpt_o <= '0';
				enable_cpt_o <= '1';		
				round_enable_o <= '0';
				enable_InvMixColumns_o <= '0';					
			--la ronde bouclee et le bloc InvMixColumns actif
			when round9_1 =>
				init_cpt_o <= '0';
				enable_cpt_o <= '1';
				round_enable_o <= '1';
				enable_InvMixColumns_o <= '1';	
			--InvMixColumns est desactive a la derniere ronde qui est bouclee
			when round0 =>
				round_enable_o <= '1';
				enable_InvMixColumns_o <= '0';
			--terminaison du calcul disponible en sortie de RegSel avec Counter inactif
			when fin =>
				enable_cpt_o <= '0';
				aes_done_o <= '1';
				enable_output_o <= '1';		
		end case;
	end process comb_1;
end FSM_InvAES_arch_Moore;
