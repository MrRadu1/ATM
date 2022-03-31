 library ieee ;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;  

library components;
use components.all;	 

entity retragere_cont is
	port 
	(enable: in std_logic;
	clk: in std_logic; 
	Sum,data_in: in std_logic_vector(15 downto 0);
	data_out: out std_logic_vector(15 downto 0);
	finish,failed: out std_logic
	);
end retragere_cont;

architecture retragere_cont_arh of retragere_cont is

component inverter is
	port(A: in std_logic;
	Y: out std_logic);
end component;

component and2 is
	port(A: in std_logic;
	B: in std_logic;
	Y: out std_logic);
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

component comparator is
   port(A     : in  std_logic_vector(15 downto 0);
        B     : in  std_logic_vector(15 downto 0);
        smaller    : out std_logic;
		equal    : out std_logic;
		bigger    : out std_logic
   );        
end component;

component mux_n is
 generic(nr_sel : natural :=2;
         nr_biti : natural := 16);
port ( A : in  std_logic_vector((2**nr_sel*nr_biti-1) downto 0);
      sel: in std_logic_vector(nr_sel-1 downto 0);
       Y : out std_logic_vector(nr_biti-1 downto 0));
end component; 

component subtractor is
   port(A     : in  std_logic_vector(15 downto 0);
        B     : in  std_logic_vector(15 downto 0);
        Y    : out std_logic_vector (15 downto 0);
        borrow  : out std_logic
   );        
end component; 

component controlled_buffer5 is
	port(A : in std_logic_vector(0 downto 0); 
	EN: in std_logic;
	Y:out std_logic_vector(0 downto 0));
end component;

signal out_inv,y,carry_counter,out_comp,out_inv1: std_logic; 
signal out_reg,out_sub:std_logic_vector(15 downto 0);	 
signal sel,z,c,p: std_logic_vector(0 downto 0);

begin		  
	C1:inverter
	port map(enable,out_inv);
	lll:controlled_buffer5
	port map(c,'1',p);
	C2:counter_stay
	generic map(1,1)
	port map(p(0),out_inv,'1',z,carry_counter);
	C3:comparator
	port map(out_reg,sum,out_comp,y,y);
	C4:and2
	port map(carry_counter,out_comp,failed);
	C5:inverter
	port map (out_comp,out_inv1);
	C9:and2
	port map(carry_counter,out_inv1,finish);
	C6:registru
	generic map(16)
	port map(carry_counter,out_inv,carry_counter,data_in,out_reg);
	C7:subtractor 
	port map(out_reg,sum,out_sub,y);
	C8:mux_n
	generic map(1,16)
	port map(A(31 downto 16)=>out_reg,
	A(15 downto 0)=>out_sub,
	sel=>sel,
	Y=>data_out);
	c(0)<=clk;
	sel(0)<=out_comp;
end retragere_cont_arh;