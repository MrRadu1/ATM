library ieee ;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

library components;
use components.all;

entity selectie_afisor is
	port(Intrare: in std_logic_vector (31 downto 0);
	int1: in std_logic_vector(15 downto 0);
	en1: in std_logic;
	int2: in std_logic_vector(15 downto 0);
	en2: in std_logic;
	int3: in std_logic_vector(15 downto 0);
	en3: in std_logic;
	sel: in std_logic;
	clock: in std_logic;
	enable1: in std_logic;
	int4: in std_logic_vector(15 downto 0);
	en4: in std_logic;
	enable2: in std_logic;
	Iesire: out std_logic_vector(31 downto 0));
end selectie_afisor;

architecture selectie_afisor_arh of selectie_afisor is

component controlled_buffer is
	port(A : in std_logic_vector(15 downto 0); 
	EN: in std_logic;
	Y:out std_logic_vector(15 downto 0));
end component;

component inverter is
	port(A: in std_logic;
	Y: out std_logic);
end component;

component mux_n is
 generic(nr_sel : natural :=2;
         nr_biti : natural := 16);
port ( A : in  std_logic_vector((2**nr_sel*nr_biti-1) downto 0);
      sel: in std_logic_vector(nr_sel-1 downto 0);
	  Y : out std_logic_vector(nr_biti-1 downto 0));
end component;

component counter_stay is
generic(nr_biti: natural :=4;
		max_value: natural :=8);
port(clk:	in std_logic;
	R:	in std_logic;
	EN:	in std_logic;
	Q:	out std_logic_vector(nr_biti-1 downto 0);
	Carry: out std_logic
);
end component;

component registru is
generic(nr_biti: natural :=4);
port(clk:	in std_logic;
	R:	in std_logic;
	EN:	in std_logic;
	D:  in std_logic_vector(nr_biti-1 downto 0);
	Q:	out std_logic_vector(nr_biti-1 downto 0)
);
end component;

component and2_bneg is
	port(A: in std_logic;
	B: in std_logic;
	Y: out std_logic);
end component;

component bitex is
    port(A: in std_logic_vector(15 downto 0);
	R: out std_logic_vector(31 downto 0)
	);
end component;

signal and1, and2, carry, not_enable1: std_logic;
signal out_buffere, out_reg, out_mux :std_logic_vector(15 downto 0);
signal out_extend: std_logic_vector(31 downto 0);
signal a:std_logic_vector(0 downto 0);

begin
	primul_and: and2_bneg
	port map(en1, enable1, and1);
	
	primul_buff: controlled_buffer
	port map(int1, and1, out_buffere);
	
	doi_and: and2_bneg
	port map(en2, enable1, and2);
	
	doi_buff: controlled_buffer
	port map(int2, and2, out_buffere);
	
	trei_buff: controlled_buffer
	port map(int3,en3, out_buffere);
	
	extrender: bitex
	port map(out_buffere, out_extend);
	
	mux_iesire: mux_n
	generic map(1, 32)
	port map(A(63 downto 32)=>Intrare, A(31 downto 0)=>out_extend, sel(0)=>sel, Y=>Iesire);
	
	inv_enable: inverter
	port map(enable1, not_enable1);
	
	prim_reg: registru
	generic map(16)
	port map(clock, not_enable1, en2, int2, out_reg);
	
	prim_count: counter_stay
	generic map(1, 1)
	port map(clock, not_enable1, enable2, a, carry);
	
	prim_mux: mux_n
	generic map(1, 16)
	port map(A(31 downto 16)=>out_reg, A(15 downto 0)=>int1, sel(0)=>carry, Y=>out_mux); 
	
	patru_buff: controlled_buffer
	port map(out_mux, enable1, out_buffere);
	
	cinci_buff: controlled_buffer
	port map(int4, en4, out_buffere);
	
end selectie_afisor_arh;