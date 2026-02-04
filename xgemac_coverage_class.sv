class xgemac_coverage_class;

  bit [`XGEMAC_TXRX_DATA_WIDTH-1:0]pkt_tx_data;
  bit                              pkt_tx_sop;
  bit                              pkt_tx_eop;
  bit [`XGEMAC_TXRX_MOD_WIDTH-1:0] pkt_tx_mod;
  bit                              pkt_tx_full;
  bit                              rst_156m25_n = 1;
  bit                              padding;
  bit                              pkt_rx_ren;
  bit [`XGEMAC_TXRX_DATA_WIDTH-1:0]pkt_rx_data;
  bit                              pkt_rx_sop;
  bit                              pkt_rx_eop;
  bit [`XGEMAC_TXRX_MOD_WIDTH-1:0] pkt_rx_mod;
  bit                              pkt_rx_err;
  string REPORT_TAG = "COVERAGE CLASS";

  // Cover Group to sample data from TX PKT features
  covergroup tx_cg(); 
    option.auto_bin_max = 128;
    tx_data: coverpoint pkt_tx_data;
    tx_sop : coverpoint pkt_tx_sop;
    tx_eop : coverpoint pkt_tx_eop;
    tx_mod : coverpoint pkt_tx_mod;
    pad    : coverpoint padding;
  endgroup: tx_cg

  // Cover Group to sample data from RX PKT features
  covergroup rx_cg(); 
    option.auto_bin_max = 128;
    rx_data: coverpoint pkt_rx_data;
    rx_sop : coverpoint pkt_rx_sop;
    rx_eop : coverpoint pkt_rx_eop;
    rx_mod : coverpoint pkt_rx_mod;
  endgroup: rx_cg

  // Coverage Class Constructor
  function new();
      tx_cg = new();
      rx_cg = new();
  endfunction: new

  // Get data from TX PKT Class Object
  function void get_values_from_tx_pkt(xgemac_tx_pkt h_tx_pkt);
    this.pkt_tx_data = h_tx_pkt.pkt_tx_data;
    this.pkt_tx_sop  = h_tx_pkt.pkt_tx_sop;
    this.pkt_tx_eop  = h_tx_pkt.pkt_tx_eop;
    this.pkt_tx_mod  = h_tx_pkt.pkt_tx_mod;
    this.pkt_tx_full = h_tx_pkt.pkt_tx_full;
  endfunction: get_values_from_tx_pkt

  // Get data from RX PKT Class Object
  function void get_values_from_rx_pkt(xgemac_rx_pkt h_rx_pkt);
    this.pkt_rx_ren  = h_rx_pkt.pkt_rx_ren;
    this.pkt_rx_data = h_rx_pkt.pkt_rx_data;
    this.pkt_rx_sop  = h_rx_pkt.pkt_rx_sop;
    this.pkt_rx_eop  = h_rx_pkt.pkt_rx_eop;
    this.pkt_rx_mod  = h_rx_pkt.pkt_rx_mod;
    this.pkt_rx_err  = h_rx_pkt.pkt_rx_err;
  endfunction: get_values_from_rx_pkt
  
  //call sample() method for TX PKT Coverage group
  function void do_tx_sampling();
    tx_cg.sample();
  endfunction: do_tx_sampling

  //call sample() method for RX PKT Coverage group
  function void do_rx_sampling();
    rx_cg.sample();
  endfunction: do_rx_sampling

  //Prints the Coverage details 
  function void print_coverage();
    $display("XGEMAC TX PKT Coverage");
    $display("Data  Coverage : %.2f%%", tx_cg.tx_data.get_coverage());
    $display("SOP   Coverage : %.2f%%", tx_cg.tx_sop.get_coverage());
    $display("EOP   Coverage : %.2f%%", tx_cg.tx_eop.get_coverage());
    $display("MOD   Coverage : %.2f%%", tx_cg.tx_mod.get_coverage());
    $display("Padding Coverage: %0.2f%%", tx_cg.pad.get_coverage());
    $display("Total TX Coverage : %.2f%%", tx_cg.get_coverage());
    $display("\nXGEMAC RX PKT Coverage");
    $display("Data  Coverage : %.2f%%", rx_cg.rx_data.get_coverage());
    $display("SOP   Coverage : %.2f%%", rx_cg.rx_sop.get_coverage());
    $display("EOP   Coverage : %.2f%%", rx_cg.rx_eop.get_coverage());
    $display("MOD   Coverage : %.2f%%", rx_cg.rx_mod.get_coverage());
    $display("Total RX Coverage : %.2f%%", rx_cg.get_coverage());
    $display();
  endfunction: print_coverage
  
endclass: xgemac_coverage_class
