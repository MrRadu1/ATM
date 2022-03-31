library ieee ;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

library components;
use components.all;

entity afisor is
	port(intrare: in std_logic_vector(31 downto 0);
	mode: in std_logic;
	enable:	in std_logic;
	opt: in std_logic;
	clock: in std_logic;
	alta_op: in std_logic;
	catod: out std_logic_vector(6 downto 0);
	anod: out std_logic_vector(7 downto 0)
	);
end afisor;

architecture afisor_arh of afisor is

component or2 is
	port(A: in std_logic;
	B:in std_logic;
	Y: out std_logic);
end component;

component mux_n is
 generic(nr_sel : natural :=3;
         nr_biti : natural := 16);
port ( A : in  std_logic_vector((2**nr_sel*nr_biti-1) downto 0);
      sel: in std_logic_vector(nr_sel-1 downto 0);
       Y : out std_logic_vector(nr_biti-1 downto 0));
end component;

component and2 is
	port(A: in std_logic;
	B:in std_logic;
	Y: out std_logic);
end component;

component counter_wrap is
	generic(nr_biti: natural :=6;
		max_value: natural :=32);
port(clk:	in std_logic;
	R:	in std_logic;
	EN:	in std_logic;
	Q:	out std_logic_vector(nr_biti-1 downto 0);
	Carry: out std_logic);
end component; 

component decodificator is
	port(sel: in std_logic_vector(2 downto 0);
	iesire: out std_logic_vector(7 downto 0));
end component; 

component hex is
	port(Intrare: in std_logic_vector(31 downto 0);
	Iesire1: out std_logic_vector(3 downto 0);
	Iesire2: out std_logic_vector(3 downto 0);
	Iesire3: out std_logic_vector(3 downto 0);
	Iesire4: out std_logic_vector(3 downto 0);
	Iesire5: out std_logic_vector(3 downto 0);
	Iesire6: out std_logic_vector(3 downto 0);
	Iesire7: out std_logic_vector(3 downto 0);
	Iesire8: out std_logic_vector(3 downto 0));
end component;

component decodAfis is
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
	g: out std_logic);
end component;

signal enable_circ, out_or, a, b: std_logic;
signal numarator1, numarator2, mux_inc: std_logic_vector(2 downto 0);
signal mux_mare1, mux_mare2, mux_sel, in_decod: std_logic_vector(3 downto 0);
signal iesire0, iesire1, iesire2, iesire3, iesire4, iesire5, iesire6, iesire7, mux_hex: std_logic_vector(3 downto 0);
signal out_decod: std_logic_vector(7 downto 0);
begin
	enable_circuit: and2
	port map(enable, clock, enable_circ);
	
	counterul1: counter_wrap
	generic map(3, 7)
	port map(clk=>enable_circ, R=>a, EN=>enable_circ, Q=>numarator1, Carry=>b);
	
	counterul2: counter_wrap
	generic map(3, 3)
	port map(clk=>enable_circ, R=>a, EN=>enable_circ, Q=>numarator2, Carry=>b);
	
	mux_inceput: mux_n
	generic map(1, 3)
	port map(A(5 downto 3)=>numarator1, A(2 downto 0)=>numarator2, sel(0)=>mode, Y=>mux_inc);
	
	muxu_mare1: mux_n
	generic map(3, 4)
	port map(A=>X"0000caa0", sel=>mux_inc, Y=>mux_mare1);
	
	muxu_mare2: mux_n
	generic map(3, 4)
	port map(A=>X"0000cca0", sel=>mux_inc, Y=>mux_mare2);
	
	mux_sel_mari: mux_n
	generic map(1, 4)
	port map(A(7 downto 4)=>mux_mare1, A(3 downto 0)=>mux_mare2, sel(0)=>alta_op, Y=>mux_sel);
	
	hexare: hex
	port map(intrare, iesire0, iesire1, iesire2, iesire3, iesire4, iesire5, iesire6, iesire7);
	
	muxu_hex: mux_n
	generic map(3, 4)
	port map(A(31 downto 28)=>iesire7,
	A(27 downto 24)=>iesire6,
	A(23 downto 20)=>iesire5,
	A(19 downto 16)=>iesire4,
	A(15 downto 12)=>iesire3,
	A(11 downto 8)=>iesire2,
	A(7 downto 4)=>iesire1,
	A(3 downto 0)=>iesire0,
	sel=>mux_inc,
	Y=>mux_hex);
	
	poarta_or: or2
	port map(alta_op, opt, out_or);
	
	penultim_mux: mux_n
	generic map(1, 4)
	port map(A(7 downto 4)=>mux_sel, A(3 downto 0)=>mux_hex, sel(0)=>out_or, Y=>in_decod);
	
	decodificare_catod: decodAfis
	port map(bit4=>in_decod(3), bit3=>in_decod(2), bit2=>in_decod(1), bit1=>in_decod(0),
	a=>catod(0), b=>catod(1), c=>catod(2), d=>catod(3), e=>catod(4), f=>catod(5), g=>catod(6));
	
	decodificare_anod: decodificator
	port map(sel=>mux_inc,
	iesire(7)=>out_decod(7), iesire(6)=>out_decod(6), iesire(5)=>out_decod(5), iesire(4)=>out_decod(4),
	iesire(3)=>out_decod(3), iesire(2)=>out_decod(2), iesire(1)=>out_decod(1), iesire(0)=>out_decod(0));
	
	ultim_mux: mux_n
	generic map(1, 8)
	port map(A(15 downto 8)=>out_decod, A(7 downto 0)=>X"00", sel(0)=>enable, Y=>anod);
	
	end afisor_arh;
	