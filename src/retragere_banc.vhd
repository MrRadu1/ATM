 library ieee ;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;  

library components;
use components.all;	 

entity retragere_banc is
	port 
	(enable,succes: in std_logic;
	clk: in std_logic; 
	Sum,data_in: in std_logic_vector(15 downto 0);
	data_out,nr_bancn: out std_logic_vector(15 downto 0);
	adress,val_bancn: out std_logic_vector(3 downto 0);
	finish,failed: out std_logic
	);
end retragere_banc;

architecture retragere_banc_arh of retragere_banc is

component controlled_buffer is
	port(A : in std_logic_vector(15 downto 0); 
	EN: in std_logic;
	Y:out std_logic_vector(15 downto 0));
end component;

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

component or2 is
	port(A: in std_logic;
	B: in std_logic;
	Y: out std_logic);
end component;

component multiplier is
	port(A: in std_logic_vector(15 downto 0);
	B: in std_logic_vector(15 downto 0);
	Y: out std_logic_vector(15 downto 0)
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
	
component Div is
    Port ( A   : in  STD_LOGIC_VECTOR (15 downto 0);
       B   : in  STD_LOGIC_VECTOR (15 downto 0);
       Y   : out  STD_LOGIC_VECTOR (15 downto 0);
       R   : out  STD_LOGIC_VECTOR (15 downto 0));
end component;
	
component SRAM is
port(	Clock:		in std_logic;	
	Write:		in std_logic;
	Addr:	in std_logic_vector(3 downto 0);
	Data_in: 	in std_logic_vector(15 downto 0);
	Data_out: 	out std_logic_vector(15 downto 0)
);
end component;

component controlled_buffer5 is
	port(A : in std_logic_vector(0 downto 0); 
	EN: in std_logic;
	Y:out std_logic_vector(0 downto 0));
end component;

component ROM is
port(
	Address	: in std_logic_vector(3 downto 0);
	Data_out: out std_logic_vector(15 downto 0)
);
end component;

signal out_and1,out_inv1,carry_counter1,out_and2,out_inv2,out_and3,carry_counter2,y,carry_counter3,out_and4: std_logic; 
signal carry_counter4,out_comp1,out_comp2,out_or1,out_comp3,out_inv3,out_and5,out_comp4_1,out_and6,out_and7: std_logic; 
signal	out_and8,out_comp4_2,out_orx: std_logic; 
signal	out_carry1,out_carry3,out_carry6,out_mux3,out_mux6 :std_logic_vector(3 downto 0);
signal	out_carry2,out_carry4,sel1,out_carry5,sel2,sel3,sel4,sel5,c,p,g,h:std_logic_vector(0 downto 0);
signal  out_rom,out_mux1,out_reg1,out_mux2,out_div,rem1,out_ram,out_mult1,out_sub,out_sub1,out_mux4,out_mux5,x ,out_rammm:std_logic_vector(15 downto 0);

begin
	C1:and2
	port map(h(0),enable,out_and1);
	C2:inverter
	port map(enable,out_inv1);
	C3:counter_stay
	generic map(4,6)
	port map(out_and1,out_inv1,out_and1,out_carry1,carry_counter1);
	C4:and2
	port map(out_and1,carry_counter1,out_and2);
	C5:inverter
	port map(out_carry2(0),out_inv2);
	C6:and2
	port map(out_and2,out_inv2,out_and3);
	C7:counter_stay
	generic map(1,1)
	port map(h(0),out_inv1,carry_counter3,out_carry2,y);
	c555:controlled_buffer5
    port map(c,'1',p);
    c556:controlled_buffer5
    port map(g,'1',h);
	C8:counter_wrap
	generic map(4,6)
	port map(p(0),carry_counter3,out_and4,out_carry3,carry_counter3); 
	C9:counter_stay
	generic map(1,1)
	port map(p(0),carry_counter3,'1',out_carry4,carry_counter4);
	C10:ROM
	port map(out_carry3,out_rom);
	C11:registru
	generic map(16)
	port map (p(0),'0','1',out_mux1,out_reg1);	
	C12:comparator
	port map(out_reg1,out_rom,out_comp1,y,y);
	C13:or2
	port map(out_comp1,out_comp2,out_or1);
	C14:and2								
	port map(out_or1,carry_counter4,out_and4);
	C15: comparator
	port map(out_reg1,"0000000000000000",y,out_comp3,y);
	C40: mux_n
	generic map(1,16)
	port map(A(31 downto 16)=>out_mux2,
	A(15 downto 0)=>Sum,
	sel=>out_carry4,
	Y=>out_mux1);
	C16:inverter
	port map(out_comp3,out_inv3);
	C17:and2
	port map(out_carry2(0),out_comp3,out_and5);
	C18:and2
	port map(out_carry2(0),out_inv3,failed);
	C19:Div
	port map(out_reg1,out_rom,out_div,rem1);
	C20: mux_n
	generic map(1,16)
	port map(A(31 downto 16)=>out_ram,
	A(15 downto 0)=>out_div,
	sel=>sel1,
	Y=>nr_bancn);
	C21:comparator
	port map(out_ram,"0000000000000000",y,out_comp2,y);
	C22:multiplier
	port map(out_ram,out_rom,out_mult1);
	C23:subtractor
	port map(out_reg1,out_mult1,out_sub,y);
	C24: mux_n
	generic map(1,16)
	port map(A(31 downto 16)=>out_sub,
	A(15 downto 0)=>rem1,
	sel=>sel1,
	Y=>out_mux2);
	C25:and2
	port map(out_carry2(0),out_and5,out_and6);
	C26:and2
	port map(out_and6,out_and1,out_and7);
	C27:counter_stay
	generic map(1,1)
	port map(out_and7,out_inv1,out_and7,out_carry5,y);
	C28:counter_stay													   
	generic map(4,6)
	port map(out_and7,out_inv1,out_carry5(0),out_carry6,finish);
	C29:and2
	port map(out_and6,succes,out_and8);
	C30: mux_n
	generic map(1,4)
	port map(A(7 downto 4)=>out_carry6,
	A(3 downto 0)=>out_carry1,
	sel=>sel2,
	Y=>adress);
	C31:mux_n
	generic map(1,16)
	port map(A(31 downto 16)=>out_ram,
	A(15 downto 0)=>data_in,
	sel=>sel2,
	Y=>data_out);
	C32: mux_n
	generic map(1,4)
	port map(A(7 downto 4)=>out_carry3,
	A(3 downto 0)=>out_carry1,
	sel=>sel3,
	Y=>out_mux3);
	C33:mux_n
	generic map(1,16)
	port map(A(31 downto 16)=>out_sub1,
	A(15 downto 0)=>data_in,
	sel=>sel3,
	Y=>out_mux4);
	C34:comparator
	port map(out_ram,out_div,out_comp4_1,out_comp4_2,y); 
	C35:or2
	port map(out_comp4_2,out_comp4_1,out_orx);
	C36:mux_n
	generic map(1,16)
	port map(A(31 downto 16)=>out_ram,
	A(15 downto 0)=>out_div,
	sel=>sel4,
	Y=>out_mux5);
	C37:subtractor
	port map(out_ram,out_mux5,out_sub1,y);
	C38: mux_n
	generic map(1,4)
	port map(A(7 downto 4)=>out_carry6,
	A(3 downto 0)=>out_mux3,
	sel=>sel5,
	Y=>out_mux6);
	C39:SRAM
	port map(out_and1,'1',out_mux6,out_mux4,out_rammm);
	componen: controlled_buffer
	port map(out_rammm,'1',out_ram);
	c(0)<=out_and3;
	val_bancn<=out_carry3;
	sel1(0)<=out_comp4_1;
	sel2(0)<=out_and8;
	sel3(0)<=carry_counter1;
	sel4(0)<=out_orx; 
	sel5(0)<=out_and6;	
	g(0)<=clk;
end	retragere_banc_arh;