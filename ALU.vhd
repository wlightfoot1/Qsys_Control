library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.math_real.all;

LIBRARY altera;
USE altera.altera_primitives_components.all;

entity ALU is
	port (
			switches : in std_logic_vector(3 downto 0);
			A, B 		: in std_logic_vector(31 downto 0);
			opcode	: in std_logic_vector(2 downto 0);
			status	: out std_logic_vector(2 downto 0);--Result Flags: (F)overflow, (N)egative, (Z)ero 
			resultLo	: out std_logic_vector(31 downto 0);
			resultHi	: out std_logic_vector(31 downto 0)
			);
end entity;

architecture ALU_arch of ALU is


begin

ALU 	: process(opcode, A, B)
	
	variable CUSTOM_TEMPa	: integer;
	variable CUSTOM_TEMPb	: integer;
	variable CUSTOM_R			: integer; 
	variable inputA_64		: signed(63 downto 0); 
	variable inputB_64		: signed(63 downto 0);
	variable inResult_64		: std_logic_vector(63 downto 0);
		
		begin
		
		inputA_64 := resize(signed(A), 64);
		inputB_64 := resize(signed(B), 64);
		
			
				if(opcode = "000") then
					inResult_64 := null;
				elsif(opcode = "001") then				--addition--
					
					inResult_64 := std_logic_vector(inputA_64 + inputB_64);
					
					---------------------FLAGS------------------
					--handle overflow;
						if(inresult_64(63 downto 32) = "11111111111111111111111111111111")  then 
							status(2) <= '1';
						else
							status(2) <= '0';
						end if; ---end overflow---
					
					--negative flag---
						if(inResult_64(63) = '1') then
							status(1) <= '1';
						else
							status(1) <= '0';
						end if; --end negative flag----
					
					--handles the Zero flag---
					if(inResult_64 = x"00") then		
						status(0) <= '1';
					else
						status(0) <= '0';
					end if;
				
				elsif(opcode = "010") then				--subtraction--
					
					inResult_64 := std_logic_vector(inputA_64 - inputB_64);
					
					---------------------FLAGS------------------
					--handle overflow;
						if(inresult_64(63 downto 32) = "11111111111111111111111111111111")  then 
							status(2) <= '1';
						else
							status(2) <= '0';
						end if; ---end overflow---
					
					--negative flag---
						if(inResult_64(63) = '1') then
							status(1) <= '1';
						else
							status(1) <= '0';
						end if; --end negative flag----
					
					--handles the Zero flag---
					if(inResult_64 = x"00") then		
						status(0) <= '1';
					else
						status(0) <= '0';
					end if;
				
				elsif(opcode = "011") then				--multiplication--
				
					CUSTOM_TEMPa := to_integer(signed(A));
					CUSTOM_TEMPb := to_integer(signed(B));
					CUSTOM_R := CUSTOM_TEMPa * CUSTOM_TEMPb;
					inResult_64 := std_logic_vector(to_signed(CUSTOM_R, inresult_64'length));

					---------------------FLAGS------------------
					--handle overflow;
					if(inresult_64(63 downto 32) = "11111111111111111111111111111111")  then 
							status(2) <= '1';
						else
							status(2) <= '0';
						end if; ---end overflow---
					
					--negative flag---
						if(inResult_64(63) = '1') then
							status(1) <= '1';
						else
							status(1) <= '0';
						end if; --end negative flag----
					
					--handles the Zero flag---
					if(inResult_64 = x"00") then		
						status(0) <= '1';
					else
						status(0) <= '0';
					end if;
				elsif(opcode = "100") then 				--decrement B--
					
					inResult_64 := std_logic_vector(inputB_64 - 1);
					
					---------------------FLAGS------------------
					--handle overflow;
						if(inresult_64(63 downto 32) = "11111111111111111111111111111111")  then 
							status(2) <= '1';
						else
							status(2) <= '0';
						end if; ---end overflow---
					
					--negative flag---
						if(inResult_64(63) = '1') then
							status(1) <= '1';
						else
							status(1) <= '0';
						end if; --end negative flag----
					
					--handles the Zero flag---
					if(inResult_64 = x"00") then		
						status(0) <= '1';
					else
						status(0) <= '0';
					end if;				
				elsif(opcode = "101") then 				--Move A--
					
					inResult_64 := std_logic_vector(inputA_64);
					
					---------------------FLAGS------------------
					--handle overflow;
					if(inresult_64(63 downto 32) = "11111111111111111111111111111111")  then 
							status(2) <= '1';
						else
							status(2) <= '0';
						end if; ---end overflow---
					
					--negative flag---
						if(inResult_64(63) = '1') then
							status(1) <= '1';
						else
							status(1) <= '0';
						end if; --end negative flag----
					
					--handles the Zero flag---
					if(inResult_64 = x"00") then		
						status(0) <= '1';
					else
						status(0) <= '0';
					end if;
				
				elsif(opcode = "110") then
					---SWAP HANDLED IN QSYS_CONTROL---
				elsif(opcode = "111") then 				--custom equation--
					
					inResult_64 := std_logic_vector(signed(A)*signed(A));
					
					---------------------FLAGS------------------
					--handle overflow;
					if(inresult_64(63 downto 32) = "11111111111111111111111111111111")  then 
						status(2) <= '1';
					else
						status(2) <= '0';
					end if; ---end overflow---
					--negative flag---
					if(inResult_64(63) = '1') then
						status(1) <= '1';
					else
						status(1) <= '0';
					end if; --end negative flag---	
					--handles the Zero flag---
					if(inResult_64 = x"00") then		
						status(0) <= '1';
					else
						status(0) <= '0';
					end if;
				end if;
				resultLo <= inResult_64(31 downto 0);
				resultHi <= inResult_64(63 downto 32);
	end process;	
end architecture;