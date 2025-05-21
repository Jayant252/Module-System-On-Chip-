library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity registerFile_e is
     generic (
        registers   : integer := 32                          -- Number of 32-bit registers
    );
    Port (
        clk          : in  std_logic;                        -- Top level clock
        rst          : in  std_logic;                        -- Reset signal
        reg_wr       : in  std_logic;                        -- Register write enable signal
        reg_rd_adr1  : in  std_logic_vector(4 downto 0);     -- Operand 1 address
        reg_rd_adr2  : in  std_logic_vector(4 downto 0);     -- Operand 2 address
        reg_wr_adr   : in  std_logic_vector(4 downto 0);     -- Result address 
        reg_wr_data  : in  std_logic_vector(31 downto 0);    -- Result data      
        reg1_rd_data : out std_logic_vector(31 downto 0);    -- Operand 1 data      
        reg2_rd_data : out std_logic_vector(31 downto 0);    -- Operand 2 data         
        scan_enable  : in  std_logic;                        -- Scan chain enable signal
        tck          : in  std_logic;                        -- TAP controller clock
        tms          : in  std_logic;                        -- TAP control signal
        tdi          : in  std_logic;                        -- TAP data in port
        tdo          : out std_logic;                        -- TAP data out port
        trst         : in  std_logic                         -- TAP controller reset
        );
end registerFile_e;