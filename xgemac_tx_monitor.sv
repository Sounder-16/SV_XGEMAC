class xgemac_tx_monitor;
 
  // TX Monitor Handles
  xgemac_tb_config        h_cfg;
  mailbox#(xgemac_tx_pkt) tx_mon_mbx;
  vif_tx_t                vif;
  string REPORT_TAG = "TX Monitor";
  // TX Monitor Constructor
  function new(xgemac_tb_config h_cfg);
    this.h_cfg = h_cfg;
  endfunction: new

  // TX Monitor Build
  function void build();
    $display("%s: Build", REPORT_TAG);
    tx_mon_mbx = new();
  endfunction: build

  // TX Monitor Connect
  function void connect();
    $display("%s: Connect", REPORT_TAG);
    this.vif = h_cfg.vif_tx;
  endfunction: connect

  // TX Monitor Run
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

  // Wait for Reset Done Method
  task wait_for_reset_done();
    @(posedge vif.rst);
  endtask: wait_for_reset_done

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

  task collect_from_vif();
    xgemac_tx_pkt h_tx_pkt, h_tx_cln_pkt;
    h_tx_pkt = new();
    forever begin
      if(vif.mr_cb.pkt_tx_val) begin    
        h_tx_pkt.pkt_tx_data = vif.mr_cb.pkt_tx_data;
        h_tx_pkt.pkt_tx_sop  = vif.mr_cb.pkt_tx_sop;
        h_tx_pkt.pkt_tx_eop  = vif.mr_cb.pkt_tx_eop;
        h_tx_pkt.pkt_tx_mod  = vif.mr_cb.pkt_tx_mod;
        
        $cast(h_tx_cln_pkt, h_tx_pkt.clone());
        $display("From VIF to TX Monitor");
        h_tx_cln_pkt.display();
        tx_mon_mbx.put(h_tx_pkt);
      end
      @(vif.mr_cb); 
    end

  endtask: collect_from_vif


  function void report();
    $display("%s: Report", REPORT_TAG);

  endfunction: report

endclass: xgemac_tx_monitor
