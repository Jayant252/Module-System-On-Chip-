architecture registerFile_a of registerFile_e is
  
-------------------------------------------------------------------------------------------------------------   
 -- Instantiation of scan flipflop 
------------------------------------------------------------------------------------------------------------- 
  component SFF_File is
  Port(     
        clk     : in STD_LOGIC;
        rst     : in STD_LOGIC;
        wr_en   : in std_logic_vector(4 downto 0); 
        adr     : in std_logic_vector(4 downto 0);        
        scan_en : in STD_LOGIC;
        d_i     : in STD_LOGIC;
        tdi_i   : in std_logic;
        q_o     : out STD_LOGIC;
        tdo_o   : out STD_LOGIC
        );
  end component;
 
-------------------------------------------------------------------------------------------------------------  
  -- Instantiation of TAP controller
------------------------------------------------------------------------------------------------------------- 
  component TapController is
  Port (
       tck             : in STD_LOGIC;
       tms             : in std_logic;
       tdi             : in STD_LOGIC;
       tdo             : out STD_LOGIC;
       trst            : in std_logic;
       scan_in_data     : in STD_LOGIC;
       scan_out_data    : out STD_LOGIC;
       parallel_data_in : in std_logic_vector(1023 downto 0)
       );
  end component;
         
  signal scan_in_signal : std_logic := '0';                      
  signal scan_out_signal : std_logic := '0';                     
  signal tap_state_signal : std_logic_vector(3 downto 0); 

------------------------------------------------------------------------------------------------------------- 
  -- Register file type declaration 
------------------------------------------------------------------------------------------------------------- 
  type regFile is array (31 downto 0) of std_logic_vector(31 downto 0);
  
-------------------------------------------------------------------------------------------------------------     
  -- Register file instantiation
------------------------------------------------------------------------------------------------------------- 
  signal qo_s : regFile;

------------------------------------------------------------------------------------------------------------- 
  -- Buffer to interconnect scan flipflops
------------------------------------------------------------------------------------------------------------- 
  signal tdi_s : std_logic_vector(1024 downto 0);
     
begin
   
-------------------------------------------------------------------------------------------------------------
 -- Generate the flip-flop scan chain
-------------------------------------------------------------------------------------------------------------
    tdi_s(0) <= scan_in_signal; -- Write scan in data into scan chain interconnect buffer         
    scanRegister: for i in 0 to 31 generate
    signal sample_vec : std_logic_vector(4 downto 0);
    begin
        sample_vec <= std_logic_vector(to_unsigned(i, sample_vec'length));
       scanFlipFlop: for j in 0 to 31 generate
       begin
            SFF_inst : SFF_File
                port map(
                    clk      =>  clk,
                    rst      =>  rst,
                    wr_en    =>  sample_vec,
                    adr      =>  reg_wr_adr,              
                    scan_en  =>  scan_enable,
                    d_i      =>  reg_wr_data(j),            -- Combinational logic data into SFF
                    tdi_i    =>  tdi_s((i*registers)+j),    -- Scan chain data into SFF
                    q_o      =>  qo_s(i)(j),                -- Combinational logic data out from SFF
                    tdo_o    =>  tdi_s((i*registers)+j+1)   -- Scan chain data out from SFF
                    ); 
        end generate;
    end generate;
    scan_out_signal <= tdi_s(1024); -- Read scan out data from scan chain interconnect buffer 

------------------------------------------------------------------------------------------------------------- 
 -- Register file read process
-------------------------------------------------------------------------------------------------------------
reg1_rd_data <= qo_s(to_integer(unsigned(reg_rd_adr1)));  -- write data into read data register1
reg2_rd_data <= qo_s(to_integer(unsigned(reg_rd_adr2)));  -- write data into read data register2

-------------------------------------------------------------------------------------------------------------     
 -- Port map of Tap Controller
-------------------------------------------------------------------------------------------------------------
    tapControllerIns : TapController port map( tck               =>  clk,   -- Clock to TAP controller      
                                               tms               =>  tms,   -- Control signal to TAP controller
                                               tdi               =>  tdi,   -- Data in to TAP controller
                                               tdo               =>  tdo,   -- Data out from TAP controller
                                               trst              =>  trst,  -- Reset signal from TAP controller         
                                               scan_out_data     =>  scan_in_signal,    -- Scan data out from TAP controller
                                               scan_in_data      =>  scan_out_signal,   -- Scan data in to TAP controller
                                               parallel_data_in  =>  tdi_s(1024 downto 1)   -- Parallel data in to TAP controller internal registers
                                               );   
 
end architecture registerFile_a;