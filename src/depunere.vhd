library ieee ;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;  

library components;
use components.all;	 

entity depunere is
	port (b1,b2,b3,b4,b5,b6 : in std_logic;
	reset : in std_logic;
	enable: in std_logic;
	clk: in std_logic;
	confirm: in std_logic;
	cont_in,banc_in : in std_logic_vector(15 downto 0); 
	store_cont,store_banc,finish: out std_logic;
	adress: out std_logic_vector(3 downto 0);
	sum,cont_out,banc_out: out std_logic_vector(15 downto 0)
	);
end depunere;

architecture depunere_arh of depunere is   

component depBanc is
	port (b1,b2,b3,b4,b5,b6 : in std_logic;
	reset : in std_logic;
	enable: in std_logic;
	clk: in std_logic; 
	Sum,n1,n2,n3,n4,n5,n6: out std_logic_vector(15 downto 0)
	);
end component;

component d_latch is
	port(D, clk, R, EN: in std_logic;
	Q: out std_logic);
end component;

component and2 is
	port(A: in std_logic;
	B: in std_logic;
	Y: out std_logic);
end component;

component inverter is
port(A: in std_logic;
	Y: out std_logic);	
end component;	 

component mux_n is
 generic(nr_sel : natural :=3;
         nr_biti : natural := 16);
port ( A : in  std_logic_vector((2**nr_sel*nr_biti-1) downto 0);
      sel: in std_logic_vector(nr_sel-1 downto 0);
       Y : out std_logic_vector(nr_biti-1 downto 0));
end component;

component adder is
   port(A     : in  std_logic_vector(15 downto 0);
        B     : in  std_logic_vector(15 downto 0);
        Y    : out std_logic_vector (15 downto 0);
        carry  : out std_logic
   );  
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

signal out_inv,out_inv1, carry_counter1,carry_counter2,carry_counter3, out_t,out_and, out_d,out_mux: std_logic;
signal y: std_logic_vector(7 downto 0); 
signal z: std_logic_vector(1 downto 0);
signal sel,mux1: std_logic_vector(0 downto 0);
signal out_counter2:std_logic_vector(3 downto 0);
signal sum1,x1,x2,x3,x4,x5,x6,out_mux1 :std_logic_vector(15 downto 0); 

begin
C1: inverter
	port map(enable, out_inv);

C2: counter_stay
	generic map(8,40)
	port map(clk,out_inv,'1',y,carry_counter1);
	
C3: mux_n
	generic map(1, 1)
	port map(A(0)=>'0', 
	A(1)=> confirm,
	sel=>sel,
	Y=>mux1);
C4: and2
	port map(out_mux,enable,out_and);
C5: d_latch
	port map('1',clk,carry_counter2,out_and,out_d);
C6: counter_stay
	generic map(4,7)
	port map(clk,out_inv,out_d,out_counter2,carry_counter2);
C7:	counter_stay
	generic map(2,2)
	port map(clk,out_inv,carry_counter2,z,carry_counter3); 
C8: d_latch
	port map(carry_counter2,clk,carry_counter3,'1',out_t);
C9:	depBanc
	port map(b1,b2,b3,b4,b5,b6,reset,enable,clk,sum1,x1,x2,x3,x4,x5,x6);
C10:mux_n
generic map(4,16)
	port map(A(255 downto 112)=>X"000000000000000000000000000000000000",
	A(111 downto 96)=>X"1111",
	A(95 downto 80)=>x6,
	A(79 downto 64)=>x5,
	A(63 downto 48)=>x4,
	A(47 downto 32)=>x3,
	A(31 downto 16)=>x2,
	A(15 downto 0)=>x1,
	sel=>out_counter2,
	Y=>out_mux1);
C11:adder
	port map(cont_in,sum1,cont_out);
C12:adder
	port map(banc_in,out_mux1,banc_out);
sum<=sum1;
store_banc<=out_d;
finish<=carry_counter3;
adress<=out_counter2;
sel(0)<=carry_counter1;
out_mux<=mux1(0);
store_cont<=out_t;

end depunere_arh;

	



