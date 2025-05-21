architecture tapController_a of tapController_e is

TYPE state_type is   ( Test_Logic_Reset,Run_Test_Idle,
                       Select_DR_Scan,Capture_DR,Shift_DR,Exit1_DR,Pause_DR,Exit2_DR,Update_DR,
                       Select_IR_Scan,Capture_IR,Shift_IR,Exit1_IR,Pause_IR,Exit2_IR,Update_IR);

SIGNAL  current_state, next_state: state_type;
SIGNAL  dr1_s :  STD_LOGIC_VECTOR(1023 downto 0);   -- data register 1
SIGNAL  dr2_s :  STD_LOGIC_VECTOR(1023 downto 0);   -- data register 2
SIGNAL  ir1_s :  STD_LOGIC_VECTOR(2 downto 0);      -- instruction register 1
SIGNAL  ir2_s :  STD_LOGIC_VECTOR(2 downto 0);      -- instruction register 2

begin

---------------------------------------------------------------------------------------------------------------
  --Process to update the state 
---------------------------------------------------------------------------------------------------------------
    process(tck, tms, trst)
    begin
        if trst = '1' then
            current_state <= Test_Logic_Reset;
            
        elsif rising_edge(tck) then
            current_State <= Next_State;
            
        end if;
    end process;
     
---------------------------------------------------------------------------------------------------------------
-- FSM process
---------------------------------------------------------------------------------------------------------------
process (current_state, tms)
begin
     case current_state is             
               -- state 1
            when Test_Logic_Reset =>
                if tms = '1' then
                    next_state <= Test_Logic_Reset;
                    
                else
                    next_state <= Run_Test_Idle;
                    
                end if;
           
              -- State 2
            when Run_Test_Idle =>
                if tms = '1' then
                    next_state <= Select_DR_Scan;
                     
                else
                    next_state <= Run_Test_Idle;
                    
                end if;
                 
                 -- State 3
            when Select_DR_Scan =>
                if tms = '1' then
                    next_state <= Select_IR_Scan;
                     
                else
                    next_state <= Capture_DR;
                     
                end if;
                
                -- State 4

              when Capture_DR =>
                  if tms = '1' then
                     next_state <= Exit1_DR;
                      
                  else
                      next_state <= Shift_DR;
                       
                      end if;
                 -- State 5                        
                                         
              when Shift_DR =>
                    if tms = '1' then
                        next_state <= Exit1_DR;
                         
                    else
                        next_state <= Shift_DR;
                         
                    end if;
               
                -- State 6
                
                when Exit1_DR =>
                    if tms = '1' then
                        next_state <= Update_DR;
                         
                    else
                        next_state <= Pause_DR;
                         
                    end if;
            -- State 7
            
                when Pause_DR =>
                    if tms = '1' then
                        next_state <= Exit2_DR;
                         
                    else
                        next_state <= Pause_DR;
                         
                    end if;
               -- State 8
    
                when Exit2_DR =>
                    if tms = '1' then
                        next_state <= Update_DR;
                         
                    else
                        next_state <= Shift_DR;
                         
                    end if;
    
               -- State 9  
                when Update_DR =>
                    if tms = '1' then
                        next_state <= Select_DR_Scan;
                         
                    else
                        next_state <= Run_Test_Idle;
                         
                    end if;
    
                -- State 10
                when Select_IR_Scan =>
                    if tms = '1' then
                        next_state <= Test_Logic_Reset; 
                         
                    else
                        next_state <= Capture_IR;
                         
                    end if;
     
             -- State 11
                when Capture_IR =>
                if tms = '1' then
                        next_state <= Exit1_IR; 
                         
                    else
                        next_state <= Shift_IR;
                        
                    end if;
     
                    -- State 12
                when Shift_IR =>
                    if tms = '1' then
                        next_state <= Exit1_IR;
                         
                    else
                        next_state <= Shift_IR;
                        
                    end if;
    
                -- State 13
                when Exit1_IR =>
                    if tms = '1' then
                        next_state <= Update_IR;
                         
                    else
                        next_state <= Pause_IR;
                         
                    end if;
                    
                -- State 14
                when Pause_IR =>
                    if tms = '1' then
                        next_state <= Exit2_IR;
                         
                    else
                        next_state <= Pause_IR;
                         
                    end if;
     
                -- state 15
                when Exit2_IR =>
                    if tms = '1' then
                        next_state <= Update_IR;
                        
                    else
                        next_state <= Shift_IR;
                          
                    end if;
                    
                  -- state 16 not clear 1 AND 0
                when Update_IR =>
                    if tms = '1' then
                        next_state <= Select_DR_Scan;
                          
                    else
                        next_state <= Run_Test_Idle;
                        
                    end if;

            when others =>
                next_state <= Test_Logic_Reset;
                 
        end case;
    end process;
 
---------------------------------------------------------------------------------------------------------------
-- Tap controller process
---------------------------------------------------------------------------------------------------------------    
process(current_state,tck, tdi, scan_in_data)
      variable bypass_reg : std_logic := '0';
      variable capture_ir_sig : std_logic_vector(2 downto 0):= b"000";
      variable update_ir_sig : std_logic_vector(2 downto 0) := b"000";
           
begin
        case current_state is
           
            when Capture_DR =>  --CaptureDR
                if(trst ='1')then  
                    dr1_s <= (others => '0');
                elsif (tck'event and tck ='1') then
                    dr1_s <= parallel_data_in;  -- capture parallel data in 
                end if;
                
            when  Shift_DR =>   --ShiftDR
                
                case ir2_s is 
                                            
                    when b"000" =>   -- bypass
                       if (trst ='1') then  
                           dr1_s <= (others => '0');
                           dr2_s <= (others => '0');
                       elsif (tck'event and tck ='1') then
                           bypass_reg := tdi;
                           tdo  <= bypass_reg;
                       end if;    
                     
                    when b"001" =>   -- ScanChain
                      if (trst ='1') then  
                         dr1_s <= (others => '0');
                         dr2_s <= (others => '0');
                      elsif (tck'event and tck ='1') then
                         scan_out_data <= tdi;
                         tdo <= scan_in_data;
                      end if; 
                    
                    when b"010" =>  -- Sample 
                      if (trst ='1') then  
                        dr1_s <=  (others => '0');
                      elsif (tck'event and tck ='1') then
                        dr1_s <= parallel_data_in;
                      end if;
                   
                   when b"011" => -- Preload 
                      if (trst ='1') then  
                        dr1_s <= (others => '0');
                      elsif (tck'event and tck ='1') then
                        tdo <= dr1_s(1023); -- serial data to TDO
                        dr1_s <= dr1_s(1022 downto 0) & '0';
                        dr1_s(0) <= tdi;                          
                    end if;
                                 
                   when others =>
                   bypass_reg := '0';
                   scan_out_data <= '0';
                   tdo <= '0';
                end case;        
            
            when Shift_IR =>   --ShiftIR (shift the TDI data to our internal IR register)
             
                 if(trst ='1')then  --ShiftIR
                    ir1_s <= (others => '0');
                 elsif (tck'event and tck ='1') then
                    tdo <= ir1_s(2);
                    ir1_s <= '0' & ir1_s(2 downto 1); 
                    ir1_s(2)  <= tdi;
                    
                 end if;    
             
            when  Update_IR=>  -- UpdateIR
               if (trst ='1') then  
                    dr2_s <= (others => '0');
               elsif (tck'event and tck ='1') then
                    ir2_s <= ir1_s;     
               end if;
               
            when  Update_DR=>   -- UpdateDR
                 if(trst ='1')then  
                     dr2_s <= (others => '0');
                 elsif (tck'event and tck ='1') then
                     dr2_s <= dr1_s;
                 end if;
       
            when others =>
                TDO <= 'Z';
        end case;
        
    end process;
    
end tapController_a;