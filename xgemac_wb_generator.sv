class xgemac_wb_generator;

  // WB Generator Constructor
  xgemac_tb_config        h_cfg;
  mailbox#(xgemac_wb_pkt) wb_mbx;
  string REPORT_TAG = "WB Generator";

  // WB Generator Constructor
  function new(xgemac_tb_config h_cfg);
    this.h_cfg = h_cfg;
  endfunction: new

  // WB Generator Build Method
  function void build();
    $display("%s: Build", REPORT_TAG);
    wb_mbx = new(1);
  endfunction: build

  // WB Generator Connect Method
  function void connect();
    $display("%s: Connect", REPORT_TAG);

  endfunction: connect

  // WB Generator Stimulus Generation Method
  task read_tx_enable_configuration();
    xgemac_wb_pkt h_wb_pkt, h_wb_cln_pkt;
    h_wb_pkt = new();
    h_wb_pkt.wb_adr_i = 'h0;
    h_wb_pkt.wb_dat_i = 'h0;
    h_wb_pkt.wb_we_i  = 'b0;
    $cast(h_wb_cln_pkt, h_wb_pkt.clone());
    h_wb_cln_pkt.display();
    wb_mbx.put(h_wb_cln_pkt);
  endtask: read_tx_enable_configuration

  task disable_tx_enable_configuration();
    xgemac_wb_pkt h_wb_pkt, h_wb_cln_pkt;
    h_wb_pkt = new();
    h_wb_pkt.wb_adr_i = 'h0;
    h_wb_pkt.wb_dat_i = 'h0;
    h_wb_pkt.wb_we_i  = 'h1;
    $cast(h_wb_cln_pkt, h_wb_pkt.clone());
    h_wb_cln_pkt.display();
    wb_mbx.put(h_wb_cln_pkt);
  endtask: disable_tx_enable_configuration

  task check_transaction_count();
    xgemac_wb_pkt h_wb_pkt, h_wb_cln_pkt;
    h_wb_pkt =new();
    h_wb_pkt.wb_adr_i = 'h80;
    h_wb_pkt.wb_dat_i = 'h0;
    h_wb_pkt.wb_we_i  = 'b0;
    $cast(h_wb_cln_pkt, h_wb_pkt.clone());
    h_wb_cln_pkt.display();
    wb_mbx.put(h_wb_cln_pkt);
  endtask: check_transaction_count

endclass: xgemac_wb_generator
