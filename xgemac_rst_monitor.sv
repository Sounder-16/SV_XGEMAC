class xgemac_rst_monitor;

  xgemac_tb_config            h_cfg;
  mailbox#(xgemac_rst_pkt)    rst_mon_mbx;
  vif_txrx_rst_t              vif;
  string REPORT_TAG = "RESET MONITOR";

  function new(xgemac_tb_config h_cfg);
      this.h_cfg = h_cfg;
  endfunction: new

  function void build();
    $display("%s: Build", REPORT_TAG);
    rst_mon_mbx = new();
  endfunction: build

  function void connect();
    $display("%s: Connect", REPORT_TAG);
    vif = h_cfg.vif_txrx_rst;
  endfunction: connect

  task run();
    xgemac_rst_pkt h_rst_pkt;
    $display("%s: Run", REPORT_TAG);
    wait(vif.rst == 0);
    @(posedge vif.rst);
    h_rst_pkt = new();
    forever begin
      if(vif.rst == 0) begin
      //h_rst_pkt.reset = 0;
      //end
      //else begin
      //  h_rst_pkt.reset = 1;
       rst_mon_mbx.put(h_rst_pkt);
      end
      //rst_mon_mbx.put(h_rst_pkt);
      @(posedge vif.clk);
    end
  endtask: run

  function void report();
    $display("%s: Report", REPORT_TAG);
  endfunction: report

endclass: xgemac_rst_monitor
