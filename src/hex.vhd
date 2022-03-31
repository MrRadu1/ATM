library ieee ;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

library components;
use components.all;


entity hex is
	port(Intrare: in std_logic_vector(31 downto 0);
	Iesire1: out std_logic_vector(3 downto 0);
	Iesire2: out std_logic_vector(3 downto 0);
	Iesire3: out std_logic_vector(3 downto 0);
	Iesire4: out std_logic_vector(3 downto 0);
	Iesire5: out std_logic_vector(3 downto 0);
	Iesire6: out std_logic_vector(3 downto 0);
	Iesire7: out std_logic_vector(3 downto 0);
	Iesire8: out std_logic_vector(3 downto 0)
	);
end hex;

architecture hex_arh of hex is

component Div2 is
    port(A: in std_logic_vector(31 downto 0);
	B: in std_logic_vector(31 downto 0);
	Y: out std_logic_vector(31 downto 0);
	R: out std_logic_vector(31 downto 0)
	);
end component;

signal ies1, ies2, ies3, ies4, ies5, ies6, ies7, ies8: std_logic_vector(3 downto 0);
signal rez1, rez2, rez3, rez4, rez5, rez6, rez7, rez8: std_logic_vector(31 downto 0);
signal zero: std_logic_vector(27 downto 0):=(others=>'0');

begin 
	
	divi1: Div2
	port map(A=>Intrare, B=>X"0000000a", Y=>rez1, R(31 downto 4)=>zero, R(3 downto 0)=>ies1(3 downto 0));
	
	divi2: Div2
	port map(A=>rez1, B=>X"0000000a", Y=>rez2, R(31 downto 4)=>zero, R(3 downto 0)=>ies2(3 downto 0));
	
	divi3: Div2
	port map(A=>rez2, B=>X"0000000a", Y=>rez3, R(31 downto 4)=>zero, R(3 downto 0)=>ies3(3 downto 0));
	
	divi4: Div2
	port map(A=>rez3, B=>X"0000000a", Y=>rez4, R(31 downto 4)=>zero, R(3 downto 0)=>ies4(3 downto 0));
	
	divi5: Div2
	port map(A=>rez4, B=>X"0000000a", Y=>rez5, R(31 downto 4)=>zero, R(3 downto 0)=>ies5(3 downto 0));
	
	divi6: Div2
	port map(A=>rez5, B=>X"0000000a", Y=>rez6, R(31 downto 4)=>zero, R(3 downto 0)=>ies6(3 downto 0));
	
	divi7: Div2
	port map(A=>rez6, B=>X"0000000a", Y=>rez7, R(31 downto 4)=>zero, R(3 downto 0)=>ies7(3 downto 0));
	
	divi8: Div2
	port map(A=>rez7, B=>X"0000000a", Y=>rez8, R(31 downto 4)=>zero, R(3 downto 0)=>ies8(3 downto 0));
	
	Iesire1<=ies1;
	Iesire2<=ies2;
	Iesire3<=ies3;
	Iesire4<=ies4;
	Iesire5<=ies5;
	Iesire6<=ies6;
	Iesire7<=ies7;
	Iesire8<=ies8;
	
	end hex_arh;
	
	
	
	
	