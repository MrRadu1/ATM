library ieee ;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;  

library components;
use components.all;


entity transfer is
	port(PIN: in std_logic_vector(3 downto 0);
	data_in: in std_logic_vector(15 downto 0); --soldul utilizatorului inaintea transferului
	suma: in std_logic_vector(15 downto 0);
	clk: in std_logic;
	enable: in std_logic;
	confirm: in std_logic;
	data_out: out std_logic_vector(15 downto 0); --soldul utilizatorului dupa transfer
	address: out std_logic_vector(3 downto 0); --adresa la care se memoreaza noua valoare a soldului
	store: out std_logic;
	finished: out std_logic;
	failed: out std_logic
	);
end transfer;

architecture transfer_arh of transfer is


component controlled_buffer is
	port(A : in std_logic_vector(15 downto 0); 
	EN: in std_logic;
	Y:out std_logic_vector(15 downto 0));
end component; 

component inverter is
port(A: in std_logic;
	Y: out std_logic);	
end component;

component adder is
   port(A     : in  std_logic_vector(15 downto 0);
        B     : in  std_logic_vector(15 downto 0);
        Y    : out std_logic_vector (15 downto 0);
        carry  : out std_logic
   );  
end component;

component subtractor is
   port(A     : in  std_logic_vector(15 downto 0);
        B     : in  std_logic_vector(15 downto 0);
        Y    : out std_logic_vector (15 downto 0);
        borrow  : out std_logic
   );        
end component;

component multiplier is
	port(A: in std_logic_vector(15 downto 0);
	B: in std_logic_vector(15 downto 0);
	Y: out std_logic_vector(15 downto 0)
	);
end component;

component comparator is
	 port(A     : in  std_logic_vector(15 downto 0);
        B     : in  std_logic_vector(15 downto 0);
        smaller    : out std_logic;
		equal    : out std_logic;
		bigger    : out std_logic
   );
end component;


component and2 is
	port(A: in std_logic;
	B:in std_logic;
	Y: out std_logic);
end component;

component and2_bneg is
	port(A: in std_logic;
	B: in std_logic;
	Y: out std_logic);
end component;

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

component counter_stay is
	generic(nr_biti: natural :=6;
		max_value: natural :=32);
port(clk:	in std_logic;
	R:	in std_logic;
	EN:	in std_logic;
	Q:	out std_logic_vector(nr_biti-1 downto 0);
	Carry: out std_logic);
end component; 

component registru is
generic(nr_biti: natural :=4);
port(clk:	in std_logic;
	R:	in std_logic;
	EN:	in std_logic;
	D:  in std_logic_vector(nr_biti-1 downto 0);
	Q:	out std_logic_vector(nr_biti-1 downto 0));
end component;

component d_latch is
	port(D, clk, R, EN: in std_logic;
	Q: out std_logic);
end component;

component controlled_buffer5 is
	port(A : in std_logic_vector(0 downto 0); 
	EN: in std_logic;
	Y:out std_logic_vector(0 downto 0));
end component;	  

signal not_enable, enable_circ, carry_counter1, not_carry_counter1, carry_counter2, not_carry_counter2, carry_counter3, sel_pin, carry_counter_store: std_logic;
signal out_intarziere_circ, not_out_intarziere_circ, borrow_sub, out_ultim_d, rez_comp, input1_or, input2_or, out_or, a,sstore,seln,carry111,nconfirm,newclk: std_logic;
signal out_mux_sub, rez_sub, rez_add, in1_comp: std_logic_vector(15 downto 0);
signal x, sel_mux_sub, in_ultim_d, sel0_mux_mare,abc,c,p: std_logic_vector(0 downto 0);	
signal y,z,b: std_logic_vector(1 downto 0);
signal out_pin1, out_pin2: std_logic_vector(3 downto 0);

begin
	nu_enable: inverter
	port map(enable, not_enable);
	
	enable_circuit: and2
	port map(clk, enable, enable_circ);	
	
	counter1: counter_stay
	generic map(1, 1)
	port map(enable_circ, '0', enable, x, carry_counter1); 
	
	inverter_c1: inverter
	port map(carry_counter1, not_carry_counter1);
	
	counter2: counter_stay
	generic map(2, 2)
	port map(enable_circ, '0', carry_counter1, z, carry_counter2);
	
	inverter_c2: inverter 
	port map(carry_counter2, not_carry_counter2);
	
	registru_pin1: registru
	generic map(4)
	port map(clk, '0', not_carry_counter1, PIN, out_pin1); 
	
	registru_pin2: registru
	generic map(4)
	port map(clk, not_enable, enable, PIN, out_pin2); 
	
	C11:counter_stay
	generic map(1,1)
	port map (clk,nconfirm,confirm,abc,carry111);
	C100:and2_bneg
	port map(confirm,carry111,newclk);
	C54:inverter
	port map(confirm,nconfirm);
	
	counter3: counter_stay
	generic map(2, 2)
	port map(newclk, not_enable, confirm, y, carry_counter3);
	
	selectie_flip_flop: d_latch
	port map(carry_counter3, clk, not_enable, enable, sel_pin);
	
	andf:and2
	port map(sel_pin,sstore,seln);
	
	mux_adresa: mux_n
	generic map(1, 4)
	port map(A(7 downto 4)=>out_pin2,
	A(3 downto 0)=>out_pin1,
	sel(0)=>seln,
	Y=>address);
	
	
	negare_intarziere: inverter
	port map(out_intarziere_circ, not_out_intarziere_circ);
	
	mux1: mux_n
	generic map(1, 1)
	port map(A(1)=>carry_counter3,
	A(0)=>'0',
	sel(0)=> not_out_intarziere_circ,
	Y=>sel_mux_sub);
	
	mux2: mux_n
	generic map(1, 1)
	port map(A(1)=>enable_circ,
	A(0)=>'0',
	sel(0)=> sel_mux_sub(0),
	Y=>in_ultim_d);
	
	
	mux_sub: mux_n
	generic map(1, 16)
	port map(A(31 downto 16)=>suma,
	A(15 downto 0)=>X"0000",
	sel(0)=>sel_mux_sub(0),
	Y=>out_mux_sub);
	
	scazator: subtractor
	port map(data_in, out_mux_sub, rez_sub, borrow_sub);
	
	sumator: adder
	port map(data_in, suma, rez_add, a); 
	lll:controlled_buffer5
	port map(c,'1',p);
	ultim_delay: d_latch
	port map(borrow_sub, p(0), not_enable, '1' , out_ultim_d);
	
	mux_pt_sel: mux_n
	generic map(1, 1)
	port map(A(1)=>out_ultim_d,
	A(0)=>borrow_sub,
	sel(0)=>sel_pin,
	Y=>sel0_mux_mare);
	
	
	mux_final: mux_n
	generic map(2, 16)
	port map(A(63 downto 48)=>data_in,
	A(47 downto 32)=>rez_add,
	A(31 downto 16)=>data_in,
	A(15 downto 0)=>rez_sub,
	sel(1)=>sel_pin,
	sel(0)=>sel0_mux_mare(0),
	Y=>data_out);
	
	
	registru_data: registru
	generic map(16)
	port map(clk, not_enable, not_carry_counter2, data_in, in1_comp);
	
	comparare: comparator
	port map(in1_comp, suma, rez_comp);
	
	pt_failed: and2
	port map(rez_comp, out_intarziere_circ, failed);
	
	pt_finished: and2_bneg
	port map(out_intarziere_circ, rez_comp, finished);
	
	in1_or: and2
	port map(sel0_mux_mare(0), sel_pin, input1_or); 
	
	in2_or: and2_bneg
	port map(sel_pin, sel0_mux_mare(0), input2_or);
	
	sau: or2
	port map(input1_or, input2_or, out_or);
	
	intarziere_circ: d_latch
	port map(out_or, clk, not_enable, enable, out_intarziere_circ);
	
	counter_store: counter_stay
	generic map(2, 2)
	port map(clk, not_enable, carry_counter3, b, carry_counter_store);
	
	enable_store: and2_bneg
	port map(carry_counter3, carry_counter_store, sstore);
	c(0)<=clk;
	store<=sstore;
	
end transfer_arh;
	
	
