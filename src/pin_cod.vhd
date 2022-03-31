library ieee ;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity pin_cod is
	port(PIN: in std_logic_vector(3 downto 0);
	PIN_codificat: out std_logic_vector(15 downto 0));
end pin_cod;


architecture pin_cod_arh of pin_cod is 	
begin
	process(PIN)
	variable temp : std_logic_vector(15 downto 0);
	variable unu: std_logic_vector(15 downto 0):=(others => '0');
	variable doi: std_logic_vector(15 downto 0):=(others => '0');
	variable trei: std_logic_vector(15 downto 0):=(others => '0');
	variable patru:std_logic_vector(15 downto 0):=(others => '0');
	begin
		for I in 9 downto 5 loop
			patru(I):=PIN(3);
		end loop;
		patru(3):=PIN(3);
		
		trei(6):=PIN(2);
		trei(5):=PIN(2);
		trei(2):=PIN(2);
		
		doi(3):=PIN(1);
		doi(1):=PIN(1);
		
		unu(0):=PIN(0);
		
		temp:=std_logic_vector(unsigned(patru) + unsigned(trei) + unsigned(doi) + unsigned(unu)); 
		
		PIN_codificat<= temp;
		end process;
end pin_cod_arh;
		
		
		
	

