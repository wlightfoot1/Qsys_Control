library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.all;

LIBRARY altera;
USE altera.altera_primitives_components.all;

entity Qsys_control is
	port(	clk					: in std_logic;
			reset_n				: in std_logic; --reset asserted low
			sw						: in std_logic_vector(3 downto 0);
			avs_s1_write		: in std_logic;
			avs_s1_read			: in std_logic;
			avs_s1_address		: in std_logic_vector(2 downto 0);
			avs_s1_readdata	: out std_logic_vector(31 downto 0);
			avs_s1_writedata	: in std_logic_vector(31 downto 0);
			LED					: out std_logic_vector(7 downto 0)
			);
end entity;

architecture Qsys_control_arch of Qsys_control is
component Final_Project_Hardware_Top is 
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
			LED_control : in std_logic
			);
end component;
--component ALU is
--	port (
--			switches : in std_logic_vector(3 downto 0);
--			A, B 		: in std_logic_vector(31 downto 0);
--			opcode	: in std_logic_vector(2 downto 0);
--			status	: out std_logic_vector(2 downto 0);--Result Flags: (F)overflow, (N)egative, (Z)ero 
--			resultLo	: out std_logic_vector(31 downto 0);
--			resultHi	: out std_logic_vector(31 downto 0)
--			);
--end component;
signal A_reg				: std_logic_vector(31 downto 0); --:= "00000000000000000000000000000000";
signal B_reg				: std_logic_vector(31 downto 0); --:= "00000000000000000000000000000000";
signal opcode_reg			: std_logic_vector(31 downto 0); --:= "00000000000000000000000000000000";
signal Lresult_reg		: std_logic_vector(31 downto 0); --:= "00000000000000000000000000000000";
signal Hresult_reg 		: std_logic_vector(31 downto 0); --:= "00000000000000000000000000000000";
signal status_reg			: std_logic_vector(31 downto 0); --:= "00000000000000000000000000000000";	--status register; signed or unsigned???
signal LED_control_reg 	: std_logic_vector(31 downto 0); --:= "00000000000000000000000000000111";

	begin	
		process (clk, opcode_reg, avs_s1_read, avs_s1_write) is
			
			begin
--				if(rising_edge(clk) and opcode_reg = "110") then
--					if(avs_s1_read = '1') then
--						case (avs_s1_address) is
--							when "000" => avs_s1_readdata <= A_reg;
--							when "001" => avs_s1_readdata <= B_reg;
--							when others => avs_s1_readdata <= (others => '0');
--						end case;
--					elsif(avs_s1_write = '1') then
--						case (avs_s1_address) is
--							when "000" => B_reg <= avs_s1_writedata;
--							when "001" => A_reg <= avs_s1_writedata;
--							when others => null;
--						end case;
--					end if;
--				else
					if(rising_edge(clk) and avs_s1_read = '1') then
						case (avs_s1_address) is
							when "000" => avs_s1_readdata <= A_reg;
							when "001" => avs_s1_readdata <= B_reg;
							when "010" => avs_s1_readdata <= opcode_reg;
							when "011" => avs_s1_readdata <= Lresult_reg;
							when "100" => avs_s1_readdata <= Hresult_reg;
							when "101" => avs_s1_readdata <= status_reg;
							when "110" => avs_s1_readdata <= LED_control_reg;
							when others => avs_s1_readdata <= (others => '0');
						end case;
					elsif(rising_edge(clk) and avs_s1_write = '1') then
						case (avs_s1_address) is
							when "000" => A_reg <= avs_s1_writedata;
							when "001" => B_reg <= avs_s1_writedata;
							when "010" => opcode_reg <= avs_s1_writedata;
--							when "011" => Lresult_reg <= avs_s1_writedata;
--							when "100" => Hresult_reg <= avs_s1_writedata;
--							when "101" => status_reg <= avs_s1_writedata;
							when "110" => LED_control_reg <= avs_s1_writedata;
							when others => null;
						end case;
					end if;
--				end if;
	end process;
		
A0	:	Final_Project_Hardware_Top port map (
			clock 		=> clk,
			reset 		=> not reset_n,
			SW				=> sw,
			LED			=> LED,
			A				=> A_reg, 
			B 				=> B_reg,
			opcode		=> opcode_reg,
			status		=> status_reg,	 
			Lresult		=> Lresult_reg,
			Hresult		=> Hresult_reg,
			LED_control => LED_control_reg(0)
			);
--A1	: ALU port map (
--			switches => sw,
--			A 			=> A_reg,
--			B			=> B_reg,
--			opcode	=> opcode_reg(2 downto 0),
--			status 	=> status_reg(2 downto 0),
--			resultLo	=> Lresult_reg,
--			resultHi	=> Hresult_reg
--			);
	
--	A2	: MUX port map (
--			clk			=> clk,
--			reset			=> reset_n,
--			switches		=> sw,		
--			reg0a			=> A_reg,
--			reg1b			=> B_reg,
--			reg2op		=> opcode_reg,
--			reg3L			=> Lresult_reg,
--			reg4H			=> Hresult_reg,
----			reg5Stat		=> status_reg,
--			reg6LED		=> LED_control_reg(0),
--			LEDs			=> LED
--			);

end architecture;