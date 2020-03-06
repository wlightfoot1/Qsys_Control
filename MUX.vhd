library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.all;

LIBRARY altera;
USE altera.altera_primitives_components.all;

entity MUX is
	port (
			switches		: 	in std_logic_vector(3 downto 0);		--SW(3:2) -- register select; SW(1:0)--byte selection
			reg0a			:	in std_logic_vector(31 downto 0);	--Register 0(A input)
			reg1b			:	in std_logic_vector(31 downto 0);	--Register 1(B input)
			reg2op		:	in std_logic_vector(31 downto 0);
			reg3L			:	in std_logic_vector(31 downto 0);	--Register 3(Low Word result)
			reg4H			:	in std_logic_vector(31 downto 0);	--Register 4(High word(Overflow) 
			reg5Stat		:  in std_logic_vector(31 downto 0);
			LEDs			:	out std_logic_vector(7 downto 0)
--			reg6LED		: in std_logic 								-- turns LEDs on/off for result
			);
end entity;

architecture MUX_arch of MUX is 

signal reg_sel		: std_logic_vector(1 downto 0);		--select which register
signal byte_sel	: std_logic_vector(1 downto 0);		--Low/High byte selecter

begin

reg_sel <= switches(3 downto 2);
byte_sel <= switches(1 downto 0);

MUX_LOGIC	:	process(byte_sel, reg_sel)
			begin
				if(reg_sel = "00") then						----------Register0--A input-----
					if(byte_sel = "00") then		---1/4 of 7 bytes in register
						LEDs <= reg0a(7 downto 0);
					elsif(byte_sel = "01") then	---2/4 of 7 bytes in register
						LEDs <= reg0a(15 downto 8);
					elsif(byte_sel = "10") then	---3/4 of 7 bytes in register
						LEDs <= reg0a(23 downto 16);
					elsif(byte_sel = "11") then	---4/4 of 7 bytes in register
						LEDs <= reg0a(31 downto 24);
					end if;
				elsif(reg_sel = "01") then					----------register1--B input-------
					if(byte_sel = "00") then		---1/4 of 7 bytes in register
						LEDs <= reg1b(7 downto 0);
					elsif(byte_sel = "01") then	---2/4 of 7 bytes in register
						LEDs <= reg1b(15 downto 8);
					elsif(byte_sel = "10") then	---3/4 of 7 bytes in register
						LEDs <= reg1b(23 downto 16);
					elsif(byte_sel = "11") then	---4/4 of 7 bytes in register
						LEDs <= reg1b(31 downto 24);
					end if;
				elsif(reg_sel = "10") then					-----------register3--Low word of results------
					if(byte_sel = "00") then		---1/4 of 7 bytes in register
						LEDs <= reg3L(7 downto 0);
					elsif(byte_sel = "01") then	---2/4 of 7 bytes in register
						LEDs <= reg3L(15 downto 8);
					elsif(byte_sel = "10") then	---3/4 of 7 bytes in register 
						LEDs <= reg3L(23 downto 16);
					elsif(byte_sel = "11") then	---4/4 of 7 bytes in register 
						LEDs <= reg3L(31 downto 24);
					end if;
				elsif(reg_sel = "11") then				---------register4-----High words of result register----
					if(byte_sel = "00") then		---1/4 of 7 bytes in register
						LEDs <= reg4H(7 downto 0);
					elsif(byte_sel = "01") then	---2/4 of 7 bytes in register
						LEDs <= reg4H(15 downto 8);
					elsif(byte_sel = "10") then	---3/4 of 7 bytes in register 
						LEDs <= reg4H(23 downto 16);
					elsif(byte_sel = "11") then	---4/4 of 7 bytes in register 
						LEDs <= reg4H(31 downto 24);
					end if;				
				end if;
	end process;

end architecture; 