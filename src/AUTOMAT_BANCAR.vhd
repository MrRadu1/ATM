 library ieee ;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;  

library components;
use components.all;	

entity automat_bancar is
	port(clock,START,nextb,confirm,res_alta_op,op1,op0,p3,p2,p1,p0,b5,b10,b50,b100,b200,b500,s,z,u  :in std_logic;
	finished,failed: out std_logic;
	catod:out std_logic_vector(6 downto 0);
	anod: out std_logic_vector(7 downto 0));
end automat_bancar;

architecture automat_bancar_arh of automat_bancar is

component inverter is
	port(A: in std_logic;
	Y: out std_logic);
end component; 

component inverter2 is
port(A: in std_logic_vector(6 downto 0); 
	Y: out std_logic_vector(6 downto 0));	
end component;

component input_pin is
	port(enable,clock: in std_logic;
	confirm: in std_logic;
	PIN3: in std_logic;
	PIN2: in std_logic;
	PIN1: in std_logic;
	PIN0: in std_logic;
	PIN_4b: out std_logic_vector(3 downto 0);
	PIN_16b: out std_logic_vector(15 downto 0));
end component;

component inputSum is
	port(Sute: in std_logic;
	Zeci: in std_logic;
	Unitati: in std_logic;
	enable: in std_logic;
	clk: in std_logic;
	buton_next: in std_logic;
	confirm: in std_logic;
	Sum: out std_logic_vector(15 downto 0);
	Sum_afis: out std_logic_vector(15 downto 0)
	);
end component;
	
component depunere is
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
end component;

component retragere is
	port 
	(enable: in std_logic;
	clk: in std_logic; 
	Sum,data_in,banc_in: in std_logic_vector(15 downto 0);
	banc_out,cont_out: out std_logic_vector(15 downto 0);
	afis:out std_logic_vector(31 downto 0);
	adress: out std_logic_vector(3 downto 0);
	finish,fail: out std_logic
	);
end component;

component transfer is
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
end component;

component uc is
	port(start,clk,alta_opt,confirm,op2,op1,finish,failed: in std_logic;
	enable_pin,enable_sum,enable_depunere,enable_tr,enable_ret,enable_afis,enable_interogare,alta_opt1,alege:out std_logic
	);
end component; 

component afisor is
	port(intrare: in std_logic_vector(31 downto 0);
	mode: in std_logic;
	enable:	in std_logic;
	opt: in std_logic;
	clock: in std_logic;
	alta_op: in std_logic;
	catod: out std_logic_vector(6 downto 0);
	anod: out std_logic_vector(7 downto 0)
	);
end component;

component selectie_afisor is
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
end component;

component and2 is
	port(A: in std_logic;
	B: in std_logic;
	Y: out std_logic);
end component; 

component or3 is
	port(A: in std_logic;
	B,C: in std_logic;
	Y: out std_logic);
end component;

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
	Carry: out std_logic
);
end component;

component controlled_buffer is
	port(A : in std_logic_vector(15 downto 0); 
	EN: in std_logic;
	Y:out std_logic_vector(15 downto 0));
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

component SRAM is
port(	Clock:		in std_logic;	
	Write:		in std_logic;
	Addr:	in std_logic_vector(3 downto 0);
	Data_in: 	in std_logic_vector(15 downto 0);
	Data_out: 	out std_logic_vector(15 downto 0)
);
end component;

signal finishs,fails,ep,es,ed,et,er,ea,ei,ao,a,store_contd,store_bancd,finishd,finishr,out_mux6,carry_counter1 : std_logic;
signal failr,storet,finishedt,failedt,out_and1,carry_counter2,out_or1,out_mux5,out_and2,out_mux7,orx3,or100 : std_logic;
signal out_mux1,x,out_mux2  :std_logic_vector(0 downto 0);
signal PIN_4b,adressb,adressr,addresst,out_carry1,out_mux3,out_buff1,out_mux8,out_buff3    :std_logic_vector(3 downto 0);
signal PIN_16b,sumi,sum_a,banc_out,cont_out,cont_outb,banc_outb,sumb,banc_outr,cont_outr,data_outt,out_mux9,out_buff4,out_mux4,out_buff2,cont_outttt   :std_logic_vector(15 downto 0);
signal out_sel ,afisr  :std_logic_vector(31 downto 0);	   
signal catodh:std_logic_vector(6 downto 0);

begin
	C1:uc
	port map(START,clock,res_alta_op,confirm,op1,op0,finishs,fails,ep,es,ed,et,er,ea,ei,ao,a);
	C2:input_pin
	port map(ep,clock,confirm,p3,p2,p1,p0,PIN_4b,PIN_16b);
	C3:inputSum
	port map(s,z,u,es,clock,nextb,confirm,sumi,sum_a);
	C4:depunere
	port map(b500,b200,b100,b50,b10,b5,res_alta_op,ed,clock,confirm,cont_out,banc_out,store_contd,store_bancd,finishd,adressb,sumb,cont_outb,banc_outb);
	C5:retragere
	port map(er,clock,sumi,cont_out,banc_out,banc_outr,cont_outr,afisr,adressr,finishr,failr);
	C6:transfer
	port map(PIN_4b,cont_out,sumi,clock,et,confirm,data_outt,addresst,storet,finishedt,failedt);
	C7:selectie_afisor 
	port map(afisr,PIN_16b,ep,sum_a,es,sumb,ed,er,clock,et,cont_out,ei,confirm,out_sel);
	C8:afisor
	port map(out_sel,er,ea,a,clock,ao,catodh,anod);  
	iesirec:inverter2
	port map(catodh,catod);
	C9:or3
	port map(finishedt,finishr,finishd,finishs);
	C10:or2
	port map(failr,failedt,fails);
	C11:SRAM 
	port MAP(clock,out_mux1(0),out_mux3,out_mux4,banc_out); 
	C12:mux_n
	generic map(1,1)
	port map(A(1)=>out_and1,
	A(0)=>'1',
	sel(0)=>carry_counter1,
	Y=>out_mux1);
	C40:counter_stay
	generic map(4,6)
	port map(clock,'0',carry_counter2,out_carry1,carry_counter1);
	C13:counter_stay
	generic map(1,1)
	port map(clock,'0',START,x,carry_counter2);
	C100:or2
	port map(ed,er,or100);
	C14:and2
	port map(out_mux2(0),or100,out_and1);
	C15:mux_n
	generic map(1,1)
	port map(A(1)=>store_bancd,
	A(0)=>'1',
	sel(0)=>ed,
	Y=>out_mux2);
	C16:or3
	port map(ed,er,et,out_or1);
	C17:mux_n
	generic map(1,4)
	port map(A(7 downto 4)=>out_buff1,
	A(3 downto 0)=>out_carry1,
	sel(0)=>carry_counter1,
	Y=>out_mux3);
	C18:controlled_buffer2
	port map(adressb,ed,out_buff1);
	C19:controlled_buffer2
	port map(adressr,er,out_buff1);
	C20:mux_n
	generic map(1,16)
	port map(A(31 downto 16)=>out_buff2,
	A(15 downto 0)=>"0000000000001010",
	sel(0)=>carry_counter1,
	Y=>out_mux4);
	C21:controlled_buffer
	port map(banc_outr,er,out_buff2);
	C22:controlled_buffer
	port map(banc_outb,ed,out_buff2);
	C23:SRAM
	port map(clock,out_mux5,out_mux8,out_mux9,cont_outttt);
	C222:controlled_buffer
	port map(cont_outttt,'1',cont_out);
	C24:mux_n
	generic map(1,1)
	port map(A(1)=>out_mux6,
	A(0)=>'1',
	sel(0)=>carry_counter1,
	Y(0)=>out_mux5);
	C25:mux_n
	generic map(1,1)
	port map(A(1)=>storet,
	A(0)=>out_and2,
	sel(0)=>et,
	Y(0)=>out_mux6);
	C26:and2
	port map(out_mux7,out_or1,out_and2);
	C27:mux_n
	generic map(1,1)
	port map(A(1)=>store_contd,
	A(0)=>'1',
	sel(0)=>ed,
	Y(0)=>out_mux7);
	C28:mux_n
	generic map(1,4)
	port map(A(7 downto 4)=>out_buff3,
	A(3 downto 0)=>out_carry1,
	sel(0)=>carry_counter1,
	Y=>out_mux8);
	C29:controlled_buffer2
	port map(PIN_4b,orx3,out_buff3);
	C30:controlled_buffer2
	port map(addresst,et,out_buff3);
	C31:or3	
	port map (er,ed,ei,orx3);
	C32:mux_n
	generic map(1,16)
	port map(A(31 downto 16)=>out_buff4,
	A(15 downto 0)=>"0000101010101010",
	sel(0)=>carry_counter1,
	Y=>out_mux9);
	C33:controlled_buffer
	port map(cont_outr,er,out_buff4);
	C34:controlled_buffer
	port map(data_outt,et,out_buff4);
	C35:controlled_buffer
	port map(cont_outb,ed,out_buff4);
	finished<=finishs;
	failed<=fails;

end automat_bancar_arh;







	
	