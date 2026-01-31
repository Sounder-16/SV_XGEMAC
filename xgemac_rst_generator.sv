class xgemac_rst_generator;
  
  mailbox#(xgemac_rst_pkt) rst_mbx;
  xgemac_tb_config         h_cfg;
  xgemac_rst_pkt           h_rst_pkt;
  xgemac_rst_pkt           h_rst_cln_pkt;
  string REPORT_TAG = "RESET GENERATOR";
  
  function new(xgemac_tb_config h_cfg);
    this.h_cfg = h_cfg;
  endfunction: new

  function void build();
    $display("%s: Build", REPORT_TAG);
    rst_mbx = new(1);
    h_rst_pkt = new();
  endfunction: build

  function void connect();
    $display("%s: Connect", REPORT_TAG);

  endfunction: connect

  task apply_reset();
    h_rst_pkt.reset_period = 3;
    $cast(h_rst_cln_pkt, h_rst_pkt);
    h_rst_cln_pkt.display();
    rst_mbx.put(h_rst_cln_pkt);
  endtask: apply_reset

endclass: xgemac_rst_generator
