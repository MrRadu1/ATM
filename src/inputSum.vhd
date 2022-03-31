library ieee ;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;  

library components;
use components.all;


entity inputSum is
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
end inputSUM;

architecture inputSum_arh of inputSum is 

component counter_stay is
	generic(nr_biti: natural :=6;
		max_value: natural :=32);
port(clk:	in std_logic;
	R:	in std_logic;
	EN:	in std_logic;
	Q:	out std_logic_vector(nr_biti-1 downto 0);
	Carry: out std_logic);
end component;

component and2_bneg is
	port(A: in std_logic;
	B: in std_logic;
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

component adder is
   port(A     : in  std_logic_vector(15 downto 0);
        B     : in  std_logic_vector(15 downto 0);
        Y    : out std_logic_vector (15 downto 0);
        carry  : out std_logic
   );  
end component;


component multiplier is
	port(A: in std_logic_vector(15 downto 0);
	B: in std_logic_vector(15 downto 0);
	Y: out std_logic_vector(15 downto 0)
	);
end component;


component and2 is
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

component controlled_buffer5 is
	port(A : in std_logic_vector(0 downto 0); 
	EN: in std_logic;
	Y:out std_logic_vector(0 downto 0));
end component;


signal out_inv, carry_counter, out_and,carry111,newclk,nconfirm,clock: std_logic;
signal y,y1,y2,y3: std_logic;
signal abc,c,p: std_logic_vector(0 downto 0);
signal x: std_logic_vector(31 downto 0);
signal z:std_logic_vector(3 downto 0);
signal out_unitati, out_zeci, out_sute, multi_unitati, multi_zeci, multi_sute, multi_sz, multi_szu, out_mux,reg1: std_logic_vector(15 downto 0); 
signal select_mux: std_logic_vector(2 downto 0);

begin
	C1: inverter
	port map(enable, out_inv);
	
	lll:controlled_buffer5
	port map(c,'1',p);
	
	C2: counter_wrap
	generic map(4, 32)
	port map(clock,out_inv,'1',z, carry_counter);
	
	C3: and2
	port map(enable, carry_counter, out_and);
	
	counter_unitati: counter_wrap
	generic map(16, 1)
	port map(out_and, out_inv ,Unitati, out_unitati, y);
	
	counter_zeci: counter_wrap
	generic map(16, 9)
	port map(out_and, out_inv ,Zeci, out_zeci, y);
	
	counter_sute: counter_wrap
	generic map(16, 1)
	port map(out_and, out_inv ,Sute, out_sute, y);
	
	multiplier_unitati: multiplier
	port map(out_unitati, X"0005", multi_unitati);
	
	multiplier_zeci: multiplier
	port map(out_zeci, X"000a", multi_zeci);
	
	multiplier_sute: multiplier
	port map(out_sute, X"0064", multi_sute); 
	
	adder_zeci_sute: adder
	port map(multi_sute, multi_zeci, multi_sz);
	 
	sumator: adder
	port map(multi_sz, multi_unitati, multi_szu); 
	
	C11:counter_stay
	generic map(1,1)
	port map(clk,nconfirm,buton_next,abc,carry111);
	C100:and2_bneg
	port map(buton_next,carry111,newclk);
	C54:inverter
	port map(buton_next,nconfirm);
	
	counter_select: counter_wrap
	generic map(3, 5)  
	port map(newclk, out_inv, buton_next, select_mux, y);
	
	mux: mux_n
	generic map(3, 16)
	port map(A(127 downto 96)=>X"00000000", 
	A(95 downto 80)=> multi_szu,
	A(79 downto 0)=>X"01f400c800640032000a",
	sel=>select_mux,
	Y=>out_mux);
	
	en_output: controlled_buffer
	port map(out_mux, enable, Sum_afis);
	
	Incarcare: registru
	generic map(16)
	port map(clk, '0',confirm, out_mux, reg1);
	en1_output: controlled_buffer
	port map(reg1, '1', Sum);
	
	c(0)<=clk;
	clock<=p(0);
end inputSum_arh;
	
	
	
	
	