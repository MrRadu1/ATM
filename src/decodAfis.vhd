library ieee ;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

library components;
use components.all;

entity decodAfis is
	port(bit4: in std_logic;
	bit3: in std_logic;
	bit2: in std_logic;
	bit1: in std_logic;
	a: out std_logic;
	b: out std_logic;
	c: out std_logic;
	d: out std_logic;
	e: out std_logic;
	f: out std_logic;
	g: out std_logic
	);
end decodAfis; 

architecture decodAfis_arh of decodAfis is
begin
process(bit4, bit3, bit2, bit1)
variable biti: std_logic_vector(3 downto 0);
variable abcdefg: std_logic_vector(6 downto 0);
begin
	biti(3):=bit4;
	biti(2):=bit3;
	biti(1):=bit2;
	biti(0):=bit1;
	
    case biti is
    when "0000" => abcdefg := "1111110"; -- 0    
    when "0001" => abcdefg := "0110000"; -- 1
    when "0010" => abcdefg := "1101101"; -- 2
    when "0011" => abcdefg := "1111001"; -- 3
    when "0100" => abcdefg := "0110011"; -- 4
    when "0101" => abcdefg := "1011011"; -- 5 
    when "0110" => abcdefg := "1011111"; -- 6 
    when "0111" => abcdefg := "1110000"; -- 7 
    when "1000" => abcdefg := "1111111"; -- 8 
    when "1001" => abcdefg := "1111011"; -- 9
    when "1010" => abcdefg := "1110111"; -- a
	when "1100" => abcdefg := "0000000"; --all off
	when others => abcdefg := "1100011"; --all on
    end case;
	
	a<=abcdefg(6);
	b<=abcdefg(5);
	c<=abcdefg(4);
	d<=abcdefg(3);
	e<=abcdefg(2);
	f<=abcdefg(1);
	g<=abcdefg(0); 
	
end process;
end decodAfis_arh;