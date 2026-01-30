class xgemac_rx_pkt; 
  
  bit [`XGEMAC_TXRX_DATA_WIDTH-1:0] pkt_rx_data;
  bit                               pkt_rx_sop;
  bit                               pkt_rx_eop;
  bit [`XGEMAC_TXRX_MOD_WIDTH-1:0]  pkt_rx_mod;
  bit                               pkt_rx_err;
  
  // RX Packet Value Display Method
  function void display();
    $display("RX Packet Data      : %h", pkt_rx_data);
    $display("RX Packet SOP       : %h", pkt_rx_sop);
    $display("RX Packet EOP       : %h", pkt_rx_eop);
    $display("RX Packet Module    : %h", pkt_rx_mod);
    $display("RX Packet Error     : %h", pkt_rx_err);
  endfunction: display

  // RX Packet Clone Method
  function xgemac_rx_pkt clone();
    xgemac_rx_pkt h_pkt = new();
    h_pkt.copy(this);
    return h_pkt;
  endfunction: clone

  // RX Packet Copy Method
  function void copy(xgemac_rx_pkt h_pkt);

    this.pkt_rx_data  = h_pkt.pkt_rx_data;
    this.pkt_rx_sop   = h_pkt.pkt_rx_sop;
    this.pkt_rx_eop   = h_pkt.pkt_rx_eop;
    this.pkt_rx_mod   = h_pkt.pkt_rx_mod;
    this.pkt_rx_err   = h_pkt.pkt_rx_err;

  endfunction: copy
  
endclass: xgemac_rx_pkt
