library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.all;

LIBRARY altera;
USE altera.altera_primitives_components.all;

entity Final_Project_Hardware_Top is
	port (
			clock 	: in std_logic;
			reset 	: in std_logic;
			SW			: in std_logic_vector(3 downto 0);
			LED		: out std_logic_vector(7 downto 0);
			A, B 		: in std_logic_vector(31 downto 0);
			opcode	: in std_logic_vector(31 downto 0);
			status	: out std_logic_vector(31 downto 0);	--Result Flags: (Z)ero, (N)egative, (F):result uses both result registers 
			Lresult	: out std_logic_vector(31 downto 0);
			Hresult	: out std_logic_vector(31 downto 0);
			LED_control : in std_logic	-- turn on/off LEDs for results
			);
end entity;

architecture Final_Project_Hardware_Top_arch of  Final_Project_Hardware_Top is
----------------COMPONENTS-------------------------------------------------------------------
component MUX is
	port (
			switches		: 	in std_logic_vector(3 downto 0);		--SW(3:2) -- register select; SW(1:0)--byte selection
			reg0a			:	in std_logic_vector(31 downto 0);	--Register 0(A input)
			reg1b			:	in std_logic_vector(31 downto 0);	--Register 1(B input)
			reg2op		:	in std_logic_vector(31 downto 0);	--opcode
			reg3L			:	in std_logic_vector(31 downto 0);	--Register 3(Low Word result)
			reg4H			:	in std_logic_vector(31 downto 0);	--Register 4(High word(Overflow)
			reg5Stat		:  in std_logic_vector(31 downto 0);	
			LEDs			:	out std_logic_vector(7 downto 0)		--LED Output
--			reg6LED		: in std_logic 	
			);
end component;

component ALU is
	port (
			A, B 		: in std_logic_vector(31 downto 0);
			opcode	: in std_logic_vector(2 downto 0);
			status	: out std_logic_vector(2 downto 0);--Result Flags: (F)overflow, (N)egative, (Z)ero 
			resultLo	: out std_logic_vector(31 downto 0);
			resultHi	: out std_logic_vector(31 downto 0)
			);
end component;
-----------------END COMPONENTS---------------------------------------------------------------

signal status_s		: std_logic_vector(31 downto 0);
signal Lresult_s : std_logic_vector(31 downto 0);
signal Hresult_s : std_logic_vector(31 downto 0);

begin

Lresult <= Lresult_s;
Hresult <= Hresult_s; 
status <= status_s;

--CONTROLLER	:	process(LED_control, Lresult, Hresult)
--				begin
--					if (LED_control = '1') then
--						ALU_Lresult_s <= Lresult;
--						ALU_Hresult_s <= Hresult;
--					else
--						MUX_Lresult_s <= Lresult;
--						MUX_Hresult_s <= Hresult;
--					end if;
--				end process;



A1	:	ALU port map(
		A 			=> A,
		B			=> B,
		opcode	=> opcode(2 downto 0),
		status 	=> status_s(2 downto 0),
		resultLo	=> Lresult_s,
		resultHi	=> Hresult_s
		);

	A2	: MUX port map (
			switches		=> SW,		
			reg0a			=> A,
			reg1b			=> B,
			reg2op		=> opcode,
			reg3L			=> Lresult_s,
			reg4H			=> Hresult_s,
			reg5Stat		=> status_s,
			LEDs			=> LED
			);





end architecture; 