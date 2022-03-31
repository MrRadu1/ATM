library ieee ;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

library components;
use components.all;


entity uc is
	port(start,clk,alta_opt,confirm,op2,op1,finish,failed: in std_logic;
	enable_pin,enable_sum,enable_depunere,enable_tr,enable_ret,enable_afis,enable_interogare,alta_opt1,alege:out std_logic
	);
end uc;

architecture uc_arh of uc is

component inverter is
	port(A: in std_logic;
	Y: out std_logic);
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

component comparator2 is
   port(A     : in  std_logic_vector(3 downto 0);
        B     : in  std_logic_vector(3 downto 0);
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

component controlled_buffer2 is
	port(A : in std_logic_vector(3 downto 0); 
	EN: in std_logic;
	Y:out std_logic_vector(3 downto 0));
end component;

component d_latch is
	port(D, clk, R, EN: in std_logic;
	Q: out std_logic);
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

component dmux_n is
port ( A : in  std_logic;
      sel : in std_logic_vector(3 downto 0);
       y0,y1,y2,y3,y4,y5,y6,y7,y8,y9,y10,y11,y12,y13,y14,y15: out std_logic:='0');
end component;

signal out_or1,carry_counter1,out_and1,y,out_comp,out_inv1,carry_counter2,out_and3,out_inv2,out_and2,d0,d1,d2,d3,d4,d5,d6,d7,d8,d9,d10,d11,d12,d13,d14,d15:std_logic; 
signal sel1,z,z1,out_c:std_logic_vector(0 downto 0);
signal split1,split2:std_logic_vector(1 downto 0);
signal out_mux1,out_mux2,out_mux3,out_mux4,nextst,st,out_mux5:std_logic_vector(3 downto 0);

begin 
	C1:mux_n
	generic map(1,4)
	port map(A(7 downto 4)=>"0011",
	A(3 downto 0)=>"0101",
	sel=>sel1,
	Y=>out_mux1);
	C2:mux_n
	generic map(2,4)
	port map(A(15 downto 12)=>"0000",
	A(11 downto 8)=>"0011",
	A(7 downto 4)=>"0011",
	A(3 downto 0)=>"0111",
	sel=>split1,
	Y=>out_mux2);
	C3:mux_n
	generic map(2,4)
	port map(A(15 downto 12)=>"0000",
	A(11 downto 8)=>"0011",
	A(7 downto 4)=>"0011",
	A(3 downto 0)=>"1010",
	sel=>split1,
	Y=>out_mux3);
	C4:mux_n
	generic map(1,4)
	port map(A(7 downto 4)=>"0001",
	A(3 downto 0)=>"0000",
	sel=>out_c,
	Y=>out_mux4);
	C7:and2
	port map(confirm,carry_counter1,out_and1);
	C8:registru
	generic map(4)
	port map(out_and1,'0',out_and1,nextst,st);
	C9:comparator2
	port map("0011",st,y,out_comp,y);
	C10:inverter
	port map(out_comp,out_inv1);
	C11:counter_stay
	generic map(1,1)				  
	port map(out_and1,out_inv1,out_comp,z1,carry_counter2);
	C12:and2
	port map(out_and3,carry_counter2,out_and2);
	C13:dmux_n
	port map('1',st,d0,d1,d2,d3,d4,d5,d6,d7,d8,d9,d10,d11,d12,d13,d14,d15);
	C14:or2
	port map(d0,d8,enable_pin);
	C15:controlled_buffer2
	port map("0001",d0,nextst);
	C16:controlled_buffer2
	port map(out_mux5,d1,nextst);
	C17:mux_n
	generic map(2,4)
	port map(A(15 downto 12)=>"1000",
	A(11 downto 8)=>"0110",
	A(7 downto 4)=>"0100",
	A(3 downto 0)=>"0010",
	sel=>split2,
	Y=>out_mux5);
	C18:controlled_buffer2
	port map("0011",d2,nextst);
	C19:controlled_buffer2
	port map(out_mux4,d3,nextst);
	C20:or2
	port map(d4,d5,enable_depunere);
	C21:controlled_buffer2
	port map("0101",d4,nextst);
	C22:controlled_buffer2
	port map(out_mux1,d5,nextst);
	C23:or2
	port map(d6,d9,enable_sum);
	C24:controlled_buffer2
	port map("0111",d6,nextst);
	C25:controlled_buffer2
	port map(out_mux2,d7,nextst);
	C26:or3
	port map(d8,d9,d10,enable_tr);
	C27:controlled_buffer2
	port map("1001",d8,nextst);
	C28:controlled_buffer2
	port map("1010",d9,nextst);
	C29:controlled_buffer2
	port map(out_mux3,d10,nextst);
	C30:counter_stay
	generic map(1,1)				  
	port map(clk,out_and2,start,z,carry_counter1);
	C31:counter_stay
	generic map(1,1)				  
	port map(clk,out_inv1,alta_opt,out_c,y);
	C666:inverter
	port map(out_c(0),out_inv2);
	C999:and2
	port map(out_inv2,out_and1,out_and3);
	enable_afis<=carry_counter1;
	enable_ret<=d7;
	alta_opt1<=d3;
	enable_interogare<=d2;
	alege<=d1;
	sel1(0)<=finish;
	split1(0)<=finish;
	split1(1)<=failed;
	split2(0)<=op1;
	split2(1)<=op2;
end uc_arh;