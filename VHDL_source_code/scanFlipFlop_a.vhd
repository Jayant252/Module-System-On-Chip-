architecture scanFlipFlop_a of scanFlipFlop_e is

begin
    DFF_Porc : process(clk, rst)
    begin
    if(rst = '0') then
        q_o <= '0';
        tdo_o <= '0';
    elsif( falling_edge(clk) ) then
        
          if (scan_en = '1') then
              q_o <= tdi_i;
              tdo_o <= tdi_i;
          elsif (adr = wr_en) then
              q_o <= d_i;
              tdo_o <= d_i;
          end if;
        
    end if;
    end process;
    
end scanFlipFlop_a;