library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity scanFlipFlop_e is
  Port
  (     clk        : in std_logic;
        rst        : in std_logic;
        wr_en      : in std_logic_vector(4 downto 0); 
        adr        : in std_logic_vector(4 downto 0); 
        scan_en    : in std_logic;
        d_i        : in std_logic;
        tdi_i      : in std_logic;
        q_o        : out std_logic;
        tdo_o      : out std_logic);
		
  
end scanFlipFlop_e;