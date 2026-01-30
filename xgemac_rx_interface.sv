interface xgemac_rx_interface(input clk, rst);
  logic                               pkt_rx_ren;
  logic                               pkt_rx_avail;
  logic [`XGEMAC_TXRX_DATA_WIDTH-1:0] pkt_rx_data;
  logic                               pkt_rx_val;
  logic                               pkt_rx_sop;
  logic                               pkt_rx_eop;
  logic [`XGEMAC_TXRX_MOD_WIDTH-1:0]  pkt_rx_mod;
  logic                               pkt_rx_err;

  clocking dr_cb @(posedge clk);
      output pkt_rx_ren;
  endclocking: dr_cb

  clocking mr_cb @(posedge clk);
      input pkt_rx_ren;
      input pkt_rx_avail;
      input pkt_rx_data;
      input pkt_rx_sop;
      input pkt_rx_eop;
      input pkt_rx_mod;
      input pkt_rx_err;
      input pkt_rx_val;
  endclocking: mr_cb
endinterface
