library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tapController_e is
    Port (
               tck  : in STD_LOGIC;
               tms  : in STD_LOGIC; 
               tdi  : in STD_LOGIC;
               tdo  : out STD_LOGIC := '0';
               trst : in STD_LOGIC;
               scan_out_data : out STD_LOGIC;
               scan_in_data  : in std_logic := '0';
               parallel_data_in : in std_logic_vector(1023 downto 0)
               );
end tapController_e;