class xgemac_rst_monitor;

  xgemac_tb_config h_cfg;
  mailbox#(bit)    rst_mon_mbx;
  vif_txrx_rst_t   vif;
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
    $display("%s: Run", REPORT_TAG);
    forever begin
      if(vif.rst == 0) begin
        rst_mon_mbx.put(1);
      end
      @(posedge vif.clk);
    end
  endtask: run

  function void report();
    $display("%s: Report", REPORT_TAG);
  endfunction: report

endclass: xgemac_rst_monitor
