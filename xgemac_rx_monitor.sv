class xgemac_rx_monitor;
  
  // RX Monitor Handles
  xgemac_tb_config        h_cfg;
  mailbox#(xgemac_rx_pkt) rx_mon_mbx;
  vif_rx_t                vif;
  string REPORT_TAG = "RX Monitor";

  // RX Monitor Constructor
  function new(xgemac_tb_config h_cfg);
    this.h_cfg = h_cfg;
  endfunction: new

  // RX Monitor Build
  function void build();
    $display("%s: Build", REPORT_TAG);
    rx_mon_mbx = new();
  endfunction: build

  // RX Monitor Connect
  function void connect();
    $display("%s: Connect", REPORT_TAG);
    this.vif = h_cfg.vif_rx;
  endfunction: connect
  
  // RX Monitor Run
  task run();
    $display("%s: Run", REPORT_TAG);
    forever begin
      wait_for_reset_done();
      collect_transfer();
    end
  endtask: run

  // Wait for Reset Method
  task wait_for_reset();
    @(negedge vif.rst);
  endtask: wait_for_reset

  // Wait for Reset Method
  task wait_for_reset_done();
    wait(vif.rst == 0);
    @(posedge vif.rst);
  endtask: wait_for_reset_done

  // Collect Transfer Method
  task collect_transfer();
    process p[2];
    fork
      begin
        p[0] = process::self();
        collect_from_vif();
      end
      begin
        p[1] = process::self();
        wait_for_reset();
      end
    join_any

    foreach (p[i]) begin
      if(p[i] != null) begin
        p[i].kill();
      end
    end

  endtask: collect_transfer

  // Collect from VIF Method
  task collect_from_vif();
    xgemac_rx_pkt h_rx_pkt, h_rx_cln_pkt;
    h_rx_pkt = new();
    forever begin
      if(vif.mr_cb.pkt_rx_val) begin
        h_rx_pkt.pkt_rx_data  = vif.mr_cb.pkt_rx_data;
        h_rx_pkt.pkt_rx_sop   = vif.mr_cb.pkt_rx_sop;
        h_rx_pkt.pkt_rx_eop   = vif.mr_cb.pkt_rx_eop;
        h_rx_pkt.pkt_rx_mod   = vif.mr_cb.pkt_rx_mod; 
        h_rx_pkt.pkt_rx_err   = vif.mr_cb.pkt_rx_err;

        $display("From Vif to RX Monitor at %0tps", $time);
        $cast(h_rx_cln_pkt, h_rx_pkt.clone());
        h_rx_cln_pkt.display();
        rx_mon_mbx.put(h_rx_cln_pkt);
      end
      @(vif.mr_cb);
    end
      
  endtask: collect_from_vif

  // RX Monitor Report
  function void report();
    $display("%s: Report", REPORT_TAG);

  endfunction: report
endclass: xgemac_rx_monitor
