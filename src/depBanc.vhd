library ieee ;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;  

library components;
use components.all;	 

entity depBanc is
	port (b1,b2,b3,b4,b5,b6 : in std_logic;
	reset : in std_logic;
	enable: in std_logic;
	clk: in std_logic; 
	Sum,n1,n2,n3,n4,n5,n6: out std_logic_vector(15 downto 0)
	);
end depBanc;

architecture depBanc_arh of depBanc is

component counter_wrap is
	generic(nr_biti: natural :=6;
		max_value: natural :=32);
port(clk:	in std_logic;
	R:	in std_logic;
	EN:	in std_logic;
	Q:	out std_logic_vector(nr_biti-1 downto 0);
	Carry: out std_logic);
end component;	

component or2 is
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
	Q:	out std_logic_vector(nr_biti-1 downto 0));
end component;	  

component inverter is
port(A: in std_logic;
	Y: out std_logic);	
end component;

component and2 is
	port(A: in std_logic;
	B:in std_logic;
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

component controlled_buffer5 is
	port(A : in std_logic_vector(0 downto 0); 
	EN: in std_logic;
	Y:out std_logic_vector(0 downto 0));
end component;	  

signal out_inv, carry_counter, out_and, out_or,clock: std_logic;
signal c,p  :std_logic_vector(0 downto 0);
signal y: std_logic; 
signal z:std_logic_vector(3 downto 0);
signal x1,x2,x3,x4,x5,x6 :std_logic_vector(15 downto 0);
signal s1,s2,s3,s4,m1,m2,m3,m4,m5,m6 :std_logic_vector(15 downto 0); 

begin
C1: inverter
	port map(enable, out_inv);

lll:controlled_buffer5
	port map(c,'1',p);
	
C2: counter_wrap
	generic map(4, 32)
	port map(clock,out_inv,'1',z, carry_counter);	  

C3: or2
	port map(out_inv,reset,out_or);
	
C4: and2
	port map(enable,carry_counter,out_and);
	
C5: counter_wrap
	generic map(16, 32)
	port map(out_and,out_or,b1,x1, y);
	
C6: counter_wrap                                                                                                                                                                                                    
	generic map(16, 32)
	port map(out_and,out_or,b2,x2, y);
	
C7: counter_wrap
	generic map(16, 32)
	port map(out_and,out_or,b3,x3, y);
	
C8: counter_wrap
	generic map(16, 32)
	port map(out_and,out_or,b4,x4, y);
	
C9: counter_wrap
	generic map(16, 32)
	port map(out_and,out_or,b5,x5, y);
	
C10: counter_wrap
	generic map(16, 32)
	port map(out_and,out_or,b6,x6, y);
	
C11: multiplier
	port map(x6, X"0005",m6);
	
C12: multiplier
	port map(x5, X"000a",m5);

C13: multiplier
	port map(x4, X"0032",m4);

C14: multiplier
	port map(x3, X"0064",m3);

C15: multiplier
	port map(x2, X"00c8",m2);

C16: multiplier
	port map(x1, X"01f4",m1);
   
C17: adder
	port map(m1, m2, s1);
	
C18: adder
	port map(m3, m4, s2);

C19: adder
	port map(m5, m6, s3);

C20: adder
	port map(s1, s2, s4);

C21: adder
	port map(s3, s4, sum);

n1<=x1;
n2<=x2;
n3<=x3;
n4<=x4;
n5<=x5;
n6<=x6;	

    c(0)<=clk;
	clock<=p(0);

end depBanc_arh;



	





