library ieee ;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

library components;
use components.all;


entity input_pin is
	port(enable,clock: in std_logic;
	confirm: in std_logic;
	PIN3: in std_logic;
	PIN2: in std_logic;
	PIN1: in std_logic;
	PIN0: in std_logic;
	PIN_4b: out std_logic_vector(3 downto 0);
	PIN_16b: out std_logic_vector(15 downto 0));
end input_pin;


architecture input_pin_arh of input_pin is

component controlled_buffer2 is
	port(A : in std_logic_vector(3 downto 0); 
	EN: in std_logic;
	Y:out std_logic_vector(3 downto 0));
end component;

component counter_stay is
	generic(nr_biti: natural :=4;
		max_value: natural :=8);
port(clk:	in std_logic;
	R:	in std_logic;
	EN:	in std_logic;
	Q:	out std_logic_vector(nr_biti-1 downto 0);
	Carry: out std_logic);
end component;

component pin_cod is
	port(PIN: in std_logic_vector(3 downto 0);
	PIN_codificat: out std_logic_vector(15 downto 0));
end component;

component registru is
generic(nr_biti: natural :=4);
port(clk:	in std_logic;
	R:	in std_logic;
	EN:	in std_logic;
	D:  in std_logic_vector(nr_biti-1 downto 0);
	Q:	out std_logic_vector(nr_biti-1 downto 0));
end component;

component controlled_buffer is
	port(A : in std_logic_vector(15 downto 0); 
	EN: in std_logic;
	Y:out std_logic_vector(15 downto 0));
end component; 

component inverter is
port(A: in std_logic;
	Y: out std_logic);	
end component;

signal out_counter: std_logic_vector(0 downto 0);
signal out_inverter, x: std_logic;
signal out_pin_cod: std_logic_vector(15 downto 0);
signal carry_numarator: std_logic;
signal xd: std_logic_vector(3 downto 0);
begin
	
	C1: counter_stay
	generic map(1, 1)
	port map(clock, out_inverter, confirm, out_counter, carry_numarator);	
	
	C2:inverter
	port map(enable, out_inverter);
	
	
	C3: registru
	generic map(4)
	port map(
	clk=>clock, 
	R=>'0',
	EN=>enable,
	D(3)=>PIN3,
	D(2)=>PIN2,
	D(1)=>PIN1,
	D(0)=>PIN0,
	Q=>xd(3 downto 0));	
	Sheeesh: controlled_buffer2
	port map(xd,'1',PIN_4b);
	
	C4: pin_cod
	port map(
	PIN(3)=>PIN3,
	PIN(2)=>PIN2,
	PIN(1)=>PIN1,
	PIN(0)=>PIN0,
	PIN_codificat=>out_pin_cod);
	
	C5: controlled_buffer 
	port map(out_pin_cod, enable, PIN_16b(15 downto 0));
	
	end architecture;
	
	
	
	
	
	
