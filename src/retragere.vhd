library ieee ;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;  

library components;
use components.all;	 

entity retragere is
	port 
	(enable: in std_logic;
	clk: in std_logic; 
	Sum,data_in,banc_in: in std_logic_vector(15 downto 0);
	banc_out,cont_out: out std_logic_vector(15 downto 0);
	afis:out std_logic_vector(31 downto 0);
	adress: out std_logic_vector(3 downto 0);
	finish,fail: out std_logic
	);
end retragere;

architecture retragere_arh of retragere is

component inverter is
	port(A: in std_logic;
	Y: out std_logic);
end component;

component and2 is
	port(A: in std_logic;
	B: in std_logic;
	Y: out std_logic);
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

component or2 is
	port(A: in std_logic;
	B: in std_logic;
	Y: out std_logic);
end component;

component multiplier2 is
	port(A: in std_logic_vector(31 downto 0);
	B: in std_logic_vector(31 downto 0);
	Y: out std_logic_vector(31 downto 0)
	);
end component;

component counter_wrap is
generic(nr_biti: natural :=4;
		max_value: natural :=8);
port(clk:	in std_logic;
	R:	in std_logic;
	EN:	in std_logic;
	Q:	out std_logic_vector(nr_biti-1 downto 0);
	Carry: out std_logic
);
end component;

component SRAM is
port(	Clock:		in std_logic;	
	Write:		in std_logic;
	Addr:	in std_logic_vector(3 downto 0);
	Data_in: 	in std_logic_vector(15 downto 0);
	Data_out: 	out std_logic_vector(15 downto 0)
);
end component;

component ROM is
port(
	Address	: in std_logic_vector(3 downto 0);
	Data_out: out std_logic_vector(15 downto 0)
);
end component;

component adder2 is
   port(A     : in  std_logic_vector(31 downto 0);
        B     : in  std_logic_vector(31 downto 0);
        Y    : out std_logic_vector (31 downto 0);
        carry  : out std_logic
   );  
end component;	

component bitex is
    port(A: in std_logic_vector(15 downto 0);
	R: out std_logic_vector(31 downto 0)
	);
end component;

component retragere_cont is
	port 
	(enable: in std_logic;
	clk: in std_logic; 
	Sum,data_in: in std_logic_vector(15 downto 0);
	data_out: out std_logic_vector(15 downto 0);
	finish,failed: out std_logic
	);
end component;

component retragere_banc is
	port 
	(enable,succes: in std_logic;
	clk: in std_logic; 
	Sum,data_in: in std_logic_vector(15 downto 0);
	data_out,nr_bancn: out std_logic_vector(15 downto 0);
	adress,val_bancn: out std_logic_vector(3 downto 0);
	finish,failed: out std_logic
	);
end component;



signal  out_inv1,y,out_and1,t,finishc,failc,finishb,failedb,out_and2,out_or1,carry_counter2,out_comp1: std_logic;
signal	out_carry1,sel1,sel2:std_logic_vector(0 downto 0);
signal	adressb,val_bancnb,out_mux1,out_counter3:std_logic_vector(3 downto 0);
signal 	datac_out,nr_bancnt,out_rom	,out_ram:std_logic_vector(15 downto 0);
signal	out_b1,out_b2,out_m2,out_a:std_logic_vector(31 downto 0);					 
signal x:std_logic_vector(6 downto 0);

begin
	C1:inverter
	port map(enable,out_inv1);
	C2:counter_stay
	generic map(1,1)
	port map(clk,out_inv1,'1',out_carry1,y);
	C3:and2
	port map(clk,t,out_and1);
	C4:retragere_cont
	port map(enable,out_and1,Sum,data_in,datac_out,finishc,failc);
	C5:retragere_banc
	port map(enable,finishc,clk,sum,banc_in,banc_out,nr_bancnt,adress,val_bancnb,finishb,failedb);
	C6:and2
	port map(finishc,finishb,out_and2);
	C7:or2
	port map(failc,failedb,fail);
	C8:counter_wrap
	generic map(7,127)
	port map(out_and1,out_inv1,out_and2,x,carry_counter2);
	C9:counter_stay
	generic map(4,5)
	port map(carry_counter2,out_inv1,out_and2,out_counter3,finish);
	C10:mux_n
	generic map(1,16)
	port map(A(31 downto 16)=>datac_out,
	A(15 downto 0)=>data_in,
	sel=>sel1,
	Y=>cont_out);
	C11:mux_n
	generic map(1,4)
	port map(A(7 downto 4)=>out_counter3,
	A(3 downto 0)=>val_bancnb,
	sel=>sel2,
	Y=>out_mux1);
	C12:comparator
	port map(nr_bancnt,"0000000000000000",y,y,out_comp1);
	C13:ROM
	port map(out_counter3,out_rom);
	C14:SRAM
	port map(out_and1,out_comp1,out_mux1,nr_bancnt,out_ram);
	C15:bitex
	port map(out_rom,out_b1);
	C16:bitex
	port map(out_ram,out_b2);
	C17:multiplier2
	port map(out_b2,"00000000000000000010011100010000",out_m2);
	C18:adder2
	port map(out_b1,out_m2,out_a);
	C19:mux_n
	generic map(1,32)
	port map(A(63 downto 32)=>out_a,
	A(31 downto 0)=>"00000000000000000000000000000000",
	sel=>sel2,
	Y=>afis);
	sel1(0)<=finishb;
	sel2(0)<=out_and2;
   	t<=out_carry1(0);
 end retragere_arh;

