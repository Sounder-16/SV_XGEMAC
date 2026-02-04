class xgemac_rst_pkt;

  int reset_period = `XGEMAC_TXRX_RESET_PERIOD;
  
  function void display();
    $display("Reset Packet Value");
    $display("RESET PERIOD: %0d", reset_period);
  endfunction: display

  function xgemac_rst_pkt clone();
    xgemac_rst_pkt h_rst = new();
    h_rst.copy(this);
    return h_rst;
  endfunction: clone

  function void copy(xgemac_rst_pkt h_rst);
    this.reset_period = h_rst.reset_period;
  endfunction: copy

endclass: xgemac_rst_pkt

