library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity inverter is
	port(A: in std_logic;
	Y: out std_logic);
end inverter;

architecture inverter_arh of inverter is
begin
	process(A)
	begin
		Y <= not A;
	end process;
end inverter_arh;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity inverter2 is
	port(A: in std_logic_vector(6 downto 0);
	Y: out std_logic_vector(6 downto 0));
end inverter2;

architecture inverter2_arh of inverter2 is
begin
	process(A)
	begin
		Y <= not A;
	end process;
end inverter2_arh;

 library IEEE; 
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity controlled_buffer5 is
	port(A : in std_logic_vector(0 downto 0); 
	EN: in std_logic;
	Y:out std_logic_vector(0 downto 0));
end controlled_buffer5;

	
	
architecture buffer5_arh of controlled_buffer5 is
begin
Y <= A when (EN = '1') else (others => 'Z');
end buffer5_arh;	


 library IEEE; 
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity controlled_buffer is
	port(A : in std_logic_vector(15 downto 0); 
	EN: in std_logic;
	Y:out std_logic_vector(15 downto 0));
end controlled_buffer;

	
	
architecture buffer_arh of controlled_buffer is
begin
Y <= A when (EN = '1') else (others => 'Z');
end buffer_arh;	


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;	

entity and2 is
	port(A: in std_logic;
	B: in std_logic;
	Y: out std_logic);
end and2;

architecture and_arh of and2 is
begin
		Y<=  A and B;
end and_arh;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;	

entity and2_bneg is
	port(A: in std_logic;
	B: in std_logic;
	Y: out std_logic);
end and2_bneg;

architecture and2bneg_arh of and2_bneg is
begin
		Y<=  A and not B;
end and2bneg_arh;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

entity or2 is
	port(A: in std_logic;
	B: in std_logic;
	Y: out std_logic);
end or2;

architecture or_arh of or2 is
begin
		Y <=  A or B;
end or_arh;

library IEEE; 
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity d_latch is
	port(D, clk, R, EN: in std_logic;
	Q: out std_logic);
end d_latch;

architecture dlatch_arh of d_latch is
begin
	process(EN, R, Clk)
	variable iesire: std_logic :='0';
	begin
		if R='0' then
			if(EN = '1') then
				if(rising_edge(clk)) then
					iesire:=D;
				end if;
			end if;
		else
			iesire:='0';
		end if;
Q<=iesire;
end process;
end dlatch_arh;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity mux_n is
 generic(nr_sel : natural :=2;
         nr_biti : natural := 16);
port ( A : in  std_logic_vector((2**nr_sel*nr_biti-1) downto 0);
      sel: in std_logic_vector(nr_sel-1 downto 0);
       Y : out std_logic_vector(nr_biti-1 downto 0));
end mux_n;

architecture muxn_arh of mux_n is
begin
Y <= A(nr_biti*(to_integer(unsigned(sel))+1) - 1 downto nr_biti*(to_integer(unsigned(sel)))); 
end muxn_arh;


library ieee ;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;


entity counter_stay is
generic(nr_biti: natural :=4;
		max_value: natural :=8);
port(clk:	in std_logic;
	R:	in std_logic;
	EN:	in std_logic;
	Q:	out std_logic_vector(nr_biti-1 downto 0);
	Carry: out std_logic
);
end counter_stay;

architecture counter_stay_arh of counter_stay is
begin
    process(clk, EN, R)
	variable count: std_logic_vector(nr_biti-1 downto 0):=(others => '0');
	variable reached: std_logic :='0';
    begin
	if R = '1' then
 	    count := (others => '0');
		 reached:='0';
	elsif (clk='1' and clk'event) then 
		if EN = '1' then
			if (count < max_value) then
		count := count + 1;	
		if (count = max_value) then
		reached:='1';
		end if;
		end if;
	end if;
	end if;
	Q <= count;
	Carry <= reached;
    end process;
end counter_stay_arh; 



library ieee ;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;


entity counter_wrap is
generic(nr_biti: natural :=4;
		max_value: natural :=8);
port(clk:	in std_logic;
	R:	in std_logic;
	EN:	in std_logic;
	Q:	out std_logic_vector(nr_biti-1 downto 0);
	Carry: out std_logic
);
end counter_wrap;

architecture counter_wrap_arh of counter_wrap is
begin
    process(clk, EN, R)
	variable count: std_logic_vector(nr_biti-1 downto 0):=(others => '0');
	variable reached: std_logic :='0';
    begin
	if R = '1' then
 	    count := (others => '0');
		 reached:='0';
	elsif (clk='1' and clk'event) then 
		if EN = '1' then
			if (count < max_value) then
		count := count + 1;
		else
		count := (others=>'0');
		end if;
		if (count = max_value) then
		reached:='1';
		end if;
		if (count < max_value) then
		reached:='0';
		end if;
		end if;
	end if;
	Q <= count;
	Carry <= reached;
    end process;
end counter_wrap_arh;



library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder is
   port(A     : in  std_logic_vector(15 downto 0);
        B     : in  std_logic_vector(15 downto 0);
        Y    : out std_logic_vector (15 downto 0);
        carry  : out std_logic
   );        
end adder;

architecture adder_arh of adder is
    signal temp : std_logic_vector(15 downto 0);
begin
    temp <= std_logic_vector(unsigned(A) +unsigned(B));
    carry  <= '1' when (A(15)=B(15) and to_integer(unsigned(temp)) > 65535)
    else '0';
    Y <= temp;
end adder_arh;


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity subtractor is
   port(A     : in  std_logic_vector(15 downto 0);
        B     : in  std_logic_vector(15 downto 0);
        Y    : out std_logic_vector (15 downto 0);
        borrow  : out std_logic
   );        
end subtractor;

architecture subtractor_arh of subtractor is
    signal temp : std_logic_vector(15 downto 0);
begin
    temp <= std_logic_vector(unsigned(A) - unsigned(B));
    borrow <= '1' when (to_integer(unsigned(A)) < to_integer(unsigned(B)))
    else '0'; 
    Y <= temp;
end subtractor_arh;	


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity comparator is
   port(A     : in  std_logic_vector(15 downto 0);
        B     : in  std_logic_vector(15 downto 0);
        smaller    : out std_logic;
		equal    : out std_logic;
		bigger    : out std_logic
   );        
end comparator;

architecture comparator_arh of comparator is
begin
    smaller <= '1' when (to_integer(unsigned(A)) < to_integer(unsigned(B)))
    else '0'; 
    equal <= '1' when (to_integer(unsigned(A)) = to_integer(unsigned(B)))
    else '0'; 
	bigger <= '1' when (to_integer(unsigned(A)) > to_integer(unsigned(B)))
    else '0'; 
end comparator_arh;


library ieee ;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity registru is
generic(nr_biti: natural :=4);
port(clk:	in std_logic;
	R:	in std_logic;
	EN:	in std_logic;
	D:  in std_logic_vector(nr_biti-1 downto 0);
	Q:	out std_logic_vector(nr_biti-1 downto 0)
);
end registru;

architecture registru_arh of registru is
begin
    process(clk, EN, R)
	variable value: std_logic_vector(nr_biti-1 downto 0):=(others => '0');
    begin
	if R = '1' then
 	    value := (others => '0');
	elsif (clk='1' and clk'event) then 
	if EN = '1' then
		value := D;	
	end if;
	end if;
	Q <= value;
    end process;	
end registru_arh;


library ieee ;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity multiplier is
	port(A: in std_logic_vector(15 downto 0);
	B: in std_logic_vector(15 downto 0);
	Y: out std_logic_vector(15 downto 0)
	);
end multiplier;

architecture multiplier_arh of multiplier is
begin
	process(A, B)
	variable rez: std_logic_vector(31 downto 0):=(others =>'0');
	begin
		rez:=std_logic_vector(unsigned(A)*unsigned(B));
		Y<=rez(15 downto 0);
	end process;
end multiplier_arh;	  

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;		 
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity ROM is
port(
	Address	: in std_logic_vector(3 downto 0);
	Data_out: out std_logic_vector(15 downto 0)
);
end ROM;

architecture Behav of ROM is

    type ROM_Array is array (0 to 15) 
	of std_logic_vector(15 downto 0);

    constant Content: ROM_Array := (
        0 => "0000000111110100",		
        1 => "0000000011001000",		
        2 => "0000000001100100",		
        3 => "0000000000110010",       		
        4 => "0000000000001010",		
        5 => "0000000000000101",       				
	OTHERS => "0000000000000000"		
	);       

begin
	Data_out <= Content(conv_integer(Address));
end Behav;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity SRAM is
port(	Clock:		in std_logic;	
	Write:		in std_logic;
	Addr:	in std_logic_vector(3 downto 0);
	Data_in: 	in std_logic_vector(15 downto 0);
	Data_out: 	out std_logic_vector(15 downto 0)
);
end SRAM;

architecture behav of SRAM is

type ram_type is array (0 to 15) of 
std_logic_vector(15 downto 0);
signal tmp_ram: ram_type:=(
					"0000000000000000", 
					"0000000000000000", 
					"0000000000000000", 
					"0000000000000000",
				   "0000000000000000",
				   "0000000000000000",
				   "0000000000000000",
				   "0000000000000000",
				   "0000000000000000",
				   "0000000000000000",
				   "0000000000000000",
				   "0000000000000000",
				   "0000000000000000",
				   "0000000000000000",
				   "0000000000000000",
				   "0000000000000000");
begin
	Data_out <= tmp_ram(conv_integer(Addr));
    process(Clock, Write)
    begin
	if (Clock'event and Clock='1') then
		if Write='1' then
		    tmp_ram(conv_integer(Addr)) <= Data_in;
	    end if;
	end if;
    end process;

end behav;

library ieee ;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity Div is
    port(A: in std_logic_vector(15 downto 0);
	B: in std_logic_vector(15 downto 0);
	Y: out std_logic_vector(15 downto 0);
	R: out std_logic_vector(15 downto 0)
	);
end Div;

architecture Behavioral_div of Div is 

begin
	process(A, B)
	variable rez: std_logic_vector(15 downto 0):=(others =>'0');
	variable rez1: std_logic_vector(31 downto 0):=(others =>'0');
	variable rez2: std_logic_vector(31 downto 0):=(others =>'0');
	variable rez3: std_logic_vector(31 downto 0):=(others =>'0');
	begin 
		rez3(15 downto 0):=A;
		rez:=std_logic_vector(unsigned(A)/unsigned(B));
		rez1:=std_logic_vector(unsigned(rez)*unsigned(B));
		rez2:=std_logic_vector(unsigned(rez3)-unsigned(rez1));
		Y<=rez;
		R<=rez2(15 downto 0);	
	end process;
end Behavioral_div;	 

library ieee ;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all; 


library ieee ;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity Div2 is
    port(A: in std_logic_vector(31 downto 0);
	B: in std_logic_vector(31 downto 0);
	Y: out std_logic_vector(31 downto 0);
	R: out std_logic_vector(31 downto 0)
	);
end Div2;

architecture Behavioral_div2 of Div2 is 

begin
	process(A, B)
	variable rez: std_logic_vector(31 downto 0):=(others =>'0');
	variable rez1: std_logic_vector(63 downto 0):=(others =>'0');
	variable rez2: std_logic_vector(63 downto 0):=(others =>'0');
	variable rez3: std_logic_vector(63 downto 0):=(others =>'0');
	begin 
		rez3(31 downto 0):=A;
		rez:=std_logic_vector(unsigned(A)/unsigned(B));
		rez1:=std_logic_vector(unsigned(rez)*unsigned(B));
		rez2:=std_logic_vector(unsigned(rez3)-unsigned(rez1));
		Y<=rez;
		R<=rez2(31 downto 0);	
	end process;
end Behavioral_div2;	 

library ieee ;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity bitex is
    port(A: in std_logic_vector(15 downto 0);
	R: out std_logic_vector(31 downto 0)
	);
end bitex;

architecture Behavioral_bitex of bitex is 

begin
	process(A)
	variable rez1: std_logic_vector(31 downto 0):=(others =>'0');
	begin 
		rez1(15 downto 0):=A;
		R<=rez1;	
	end process;
end Behavioral_bitex; 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder2 is
   port(A     : in  std_logic_vector(31 downto 0);
        B     : in  std_logic_vector(31 downto 0);
        Y    : out std_logic_vector (31 downto 0);
        carry  : out std_logic
   );  
end adder2;

architecture adder2_arh of adder2 is
    signal temp : std_logic_vector(31 downto 0);
begin
    temp <= std_logic_vector(unsigned(A) +unsigned(B));
    carry  <= '1' when (A(31)=B(31) and A(31)='1')
    else '0';
    Y <= temp;
end adder2_arh;

library ieee ;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity multiplier2 is
	port(A: in std_logic_vector(31 downto 0);
	B: in std_logic_vector(31 downto 0);
	Y: out std_logic_vector(31 downto 0)
	);
end multiplier2 ;

architecture multiplier2_arh of multiplier2 is
begin
	process(A, B)
	variable rez: std_logic_vector(63 downto 0):=(others =>'0');
	begin
		rez:=std_logic_vector(unsigned(A)*unsigned(B));
		Y<=rez(31 downto 0);
	end process;
end multiplier2_arh;

library ieee ;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity controlled_buffer2 is
	port(A : in std_logic_vector(3 downto 0); 
	EN: in std_logic;
	Y:out std_logic_vector(3 downto 0));
end controlled_buffer2;

architecture buffer2_arh of controlled_buffer2 is
begin
Y <= A when (EN = '1') else (others => 'Z');
end buffer2_arh;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity dmux_n is
port ( A : in  std_logic;
      sel : in std_logic_vector(3 downto 0);
       y0,y1,y2,y3,y4,y5,y6,y7,y8,y9,y10,y11,y12,y13,y14,y15: out std_logic:='0');
end dmux_n;

architecture dmuxn_arh of dmux_n is
begin
	process(sel,A)
	begin
case sel is
	when "0000"=>
	y0<=A;
	y1<='0';
	y2<='0';
	y3<='0';
	y4<='0';
	y5<='0';
	y6<='0';
	y7<='0';
	y8<='0';
	y9<='0';
	y10<='0';
	y11<='0';
	y12<='0';
	y13<='0';
	y14<='0';
	y15<='0';
	when "0001"=> 
	y0<='0';
	y1<=A;
	y2<='0';
	y3<='0';
	y4<='0';
	y5<='0';
	y6<='0';
	y7<='0';
	y8<='0';
	y9<='0';
	y10<='0';
	y11<='0';
	y12<='0';
	y13<='0';
	y14<='0';
	y15<='0';
	when "0010"=> 
	y0<='0';
	y1<='0';
	y2<=A;
	y3<='0';
	y4<='0';
	y5<='0';
	y6<='0';
	y7<='0';
	y8<='0';
	y9<='0';
	y10<='0';
	y11<='0';
	y12<='0';
	y13<='0';
	y14<='0';
	y15<='0';
	when "0011"=> 
	y0<='0';
	y1<='0';
	y2<='0';
	y3<=A;
	y4<='0';
	y5<='0';
	y6<='0';
	y7<='0';
	y8<='0';
	y9<='0';
	y10<='0';
	y11<='0';
	y12<='0';
	y13<='0';
	y14<='0';
	y15<='0';
	when "0100"=>
	y0<='0';
	y1<='0';
	y2<='0';
	y3<='0';
	y4<=A;
	y5<='0';
	y6<='0';
	y7<='0';
	y8<='0';
	y9<='0';
	y10<='0';
	y11<='0';
	y12<='0';
	y13<='0';
	y14<='0';
	y15<='0';
	when "0101"=>
	y0<='0';
	y1<='0';
	y2<='0';
	y3<='0';
	y4<='0';
	y5<=A;
	y6<='0';
	y7<='0';
	y8<='0';
	y9<='0';
	y10<='0';
	y11<='0';
	y12<='0';
	y13<='0';
	y14<='0';
	y15<='0';
	when "0110"=> 
	y0<='0';
	y1<='0';
	y2<='0';
	y3<='0';
	y4<='0';
	y5<='0';
	y6<=A;
	y7<='0';
	y8<='0';
	y9<='0';
	y10<='0';
	y11<='0';
	y12<='0';
	y13<='0';
	y14<='0';
	y15<='0';
	when "0111"=> 
	y0<='0';
	y1<='0';
	y2<='0';
	y3<='0';
	y4<='0';
	y5<='0';
	y6<='0';
	y7<=A;
	y8<='0';
	y9<='0';
	y10<='0';
	y11<='0';
	y12<='0';
	y13<='0';
	y14<='0';
	y15<='0';
	when "1000"=>
	y0<='0';
	y1<='0';
	y2<='0';
	y3<='0';
	y4<='0';
	y5<='0';
	y6<='0';
	y7<='0';
	y8<=A;
	y9<='0';
	y10<='0';
	y11<='0';
	y12<='0';
	y13<='0';
	y14<='0';
	y15<='0';
	when "1001"=>
	y0<='0';
	y1<='0';
	y2<='0';
	y3<='0';
	y4<='0';
	y5<='0';
	y6<='0';
	y7<='0';
	y8<='0';
	y9<=A;
	y10<='0';
	y11<='0';
	y12<='0';
	y13<='0';
	y14<='0';
	y15<='0';
	when "1010"=> 
	y0<='0';
	y1<='0';
	y2<='0';
	y3<='0';
	y4<='0';
	y5<='0';
	y6<='0';
	y7<='0';
	y8<='0';
	y9<='0';
	y10<=A;
	y11<='0';
	y12<='0';
	y13<='0';
	y14<='0';
	y15<='0'; 
	when "1011"=>
	y0<='0';
	y1<='0';
	y2<='0';
	y3<='0';
	y4<='0';
	y5<='0';
	y6<='0';
	y7<='0';
	y8<='0';
	y9<='0';
	y10<='0';
	y11<=A;
	y12<='0';
	y13<='0';
	y14<='0';
	y15<='0';
	when "1100"=>
	y0<='0';
	y1<='0';
	y2<='0';
	y3<='0';
	y4<='0';
	y5<='0';
	y6<='0';
	y7<='0';
	y8<='0';
	y9<='0';
	y10<='0';
	y11<='0';
	y12<=A;
	y13<='0';
	y14<='0';
	y15<='0';
	when "1101"=>
	y0<='0';
	y1<='0';
	y2<='0';
	y3<='0';
	y4<='0';
	y5<='0';
	y6<='0';
	y7<='0';
	y8<='0';
	y9<='0';
	y10<='0';
	y11<='0';
	y12<='0';
	y13<=A;
	y14<='0';
	y15<='0';
	when "1110"=>
	y0<='0';
	y1<='0';
	y2<='0';
	y3<='0';
	y4<='0';
	y5<='0';
	y6<='0';
	y7<='0';
	y8<='0';
	y9<='0';
	y10<='0';
	y11<='0';
	y12<='0';
	y13<='0';
	y14<=A;
	y15<='0';
	when others=>
	y0<='0';
	y1<='0';
	y2<='0';
	y3<='0';
	y4<='0';
	y5<='0';
	y6<='0';
	y7<='0';
	y8<='0';
	y9<='0';
	y10<='0';
	y11<='0';
	y12<='0';
	y13<='0';
	y14<='0';
	y15<=A;
end case;
end process;
end dmuxn_arh;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity comparator2 is
   port(A     : in  std_logic_vector(3 downto 0);
        B     : in  std_logic_vector(3 downto 0);
        smaller    : out std_logic;
		equal    : out std_logic;
		bigger    : out std_logic
   );        
end comparator2;

architecture comparator2_arh of comparator2 is
begin
    smaller <= '1' when (to_integer(unsigned(A)) < to_integer(unsigned(B)))
    else '0'; 
    equal <= '1' when (to_integer(unsigned(A)) = to_integer(unsigned(B)))
    else '0'; 
	bigger <= '1' when (to_integer(unsigned(A)) > to_integer(unsigned(B)))
    else '0'; 
end comparator2_arh;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

entity or3 is
	port(A: in std_logic;
	B,C: in std_logic;
	Y: out std_logic);
end or3;

architecture or3_arh of or3 is
begin
		Y <=  A or B or C;
end or3_arh;

library ieee ;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity decodificator is
	port(sel: in std_logic_vector(2 downto 0);
	iesire: out std_logic_vector(7 downto 0)
	);
end decodificator ;

architecture decodificator_arh of decodificator is
begin
	process(sel)
	variable ies: std_logic_vector(7 downto 0):=(others =>'0');
	begin
		case sel is
            when "000" => ies := "00000001";
			when "001" => ies := "00000010";
			when "010" => ies := "00000100";
			when "011" => ies := "00001000";
			when "100" => ies := "00010000";
			when "101" => ies := "00100000";
			when "110" => ies := "01000000";
			when others => ies := "10000000";	
		end case;
		iesire<=ies;
	end process;
end decodificator_arh;




		
