class xgemac_tx_driver;

  string REPORT_TAG;
  xgemac_tb_config        h_cfg;
  vif_tx_t                vif;
  mailbox#(xgemac_tx_pkt) tx_mbx;

  // TX Driver Constructor
  function new(xgemac_tb_config h_cfg);
    this.h_cfg = h_cfg;
    REPORT_TAG = "TX PKT Driver";
  endfunction: new
  
  // TX Interface Driver Build Method
  function void build();
    $display("%s: Build", REPORT_TAG);
  endfunction: build

  // TX Interface Driver Connect Method
  function void connect();
    $display("%s: Connect", REPORT_TAG);
    this.vif = h_cfg.vif_tx;
  endfunction: connect

  // TX Driver Run Method
  task run();
    $display("%s: Run", REPORT_TAG);
    forever begin
      wait_for_reset_done();
      reset_input_signals();
      drive_transfer();
    end
  endtask: run

  // Wait for Reset signal to assert
  task wait_for_reset();
    @(negedge vif.rst);
  endtask: wait_for_reset

  // Wait for Reset signal to deassert
  task wait_for_reset_done();
    wait(vif.rst == 0);
    @(posedge vif.rst);
   // @(posedge vif.clk);
  endtask: wait_for_reset_done

  // Reset all input signals
  function void reset_input_signals();
    vif.pkt_tx_data = 'h0;
    vif.pkt_tx_val  = 'b0;
    vif.pkt_tx_sop  = 'b0;
    vif.pkt_tx_eop  = 'b0;
    vif.pkt_tx_mod  = 'h0;
  endfunction: reset_input_signals

  // Runs get_and_drive() & wait_for_reset() parallelly
  task drive_transfer();
    process p[2];
    fork
      begin
        p[0] = process::self();
        get_and_drive();
      end
      begin
        p[1] = process::self();
        wait_for_reset();
      end
    join_any
    foreach (p[i]) p[i].kill();
  endtask: drive_transfer

  // Receives Packet and drives the input into vif pins 
  task get_and_drive();
    xgemac_tx_pkt h_pkt, h_pkt_cln;
    forever begin
      tx_mbx.get(h_pkt);
      $cast(h_pkt_cln, h_pkt.clone());
      $display("From TX Driver to VIF at %0t", $time);
      h_pkt_cln.display();
      drive_into_pins(h_pkt_cln);
      @(posedge vif.clk);
      reset_input_signals();
    end
  endtask: get_and_drive

  // Drives the input signals into DUT's pins
  task drive_into_pins(xgemac_tx_pkt h_pkt);

    wait(vif.mr_cb.pkt_tx_full === 'b0);

    vif.dr_cb.pkt_tx_val  <= 'b1;
    vif.dr_cb.pkt_tx_data <= h_pkt.pkt_tx_data;
    vif.dr_cb.pkt_tx_sop  <= h_pkt.pkt_tx_sop;
    vif.dr_cb.pkt_tx_eop  <= h_pkt.pkt_tx_eop;
    vif.dr_cb.pkt_tx_mod  <= h_pkt.pkt_tx_mod;
  
  endtask: drive_into_pins

  // TX Driver Report
  function void report();
    $display("%s: Report", REPORT_TAG);

  endfunction: report

endclass: xgemac_tx_driver
