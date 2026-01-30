`include "xgemac_wb_pkt.sv"

class xgemac_wb_driver;
 
  string REPORT_TAG;
  xgemac_tb_config        h_cfg;
  vif_wb_t                vif;
  mailbox#(xgemac_wb_pkt) wb_mbx;
  
  // WB Driver Constructor
  function new(xgemac_tb_config h_cfg);
    this.h_cfg = h_cfg;
    REPORT_TAG = "WB Driver";
  endfunction: new

  // WB Driver Build
  function void build();
    $display("%s: Build", REPORT_TAG);

  endfunction: build

  // WB Driver Connect
  function void connect();
    $display("%s: Connect", REPORT_TAG);
    this.vif = h_cfg.vif_wb;
  endfunction: connect

  // WB Driver Run
  task run();
    $display("%s: Run", REPORT_TAG);
    forever begin
      wait_for_reset_done();
      reset_input_signals();
      drive_transfer();
    end
  endtask: run

  // Wait for reset to assert
  task wait_for_reset();
    @(posedge vif.rst);
  endtask: wait_for_reset

  // Wait for completion of reset
  task wait_for_reset_done();
    wait(vif.rst === 0);
    @(negedge vif.rst);
  endtask: wait_for_reset_done

  // Reset all input signals
  function void reset_input_signals();
    vif.wb_dat_i = 'h0;
    vif.wb_adr_i = 'h0;
    vif.wb_cyc_i = 'h0;
    vif.wb_stb_i = 'h0;
    vif.wb_we_i  = 'h0;
  endfunction: reset_input_signals

  // Initiate 2 Threads(get_and_drive() & wait_for_reset())
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

  // Receive packet through mailbox and clones packet
  task get_and_drive();
    xgemac_wb_pkt h_pkt, h_pkt_cln;
    forever begin
      wb_mbx.get(h_pkt);
      $cast(h_pkt_cln, h_pkt.clone());
      drive_into_pins(.h_pkt(h_pkt));
      @(posedge vif.clk);
      reset_input_signals();
    end
  endtask: get_and_drive

  // Drives the data into the pins through Virtual Interface
  task drive_into_pins(xgemac_wb_pkt h_pkt);
    $display("From WB Generator to Driver");
    h_pkt.display();
    vif.dr_cb.wb_cyc_i <= 'b1;
    vif.dr_cb.wb_stb_i <= 'b1;
    vif.dr_cb.wb_dat_i <= h_pkt.wb_dat_i;
    vif.dr_cb.wb_adr_i <= h_pkt.wb_adr_i;
    vif.dr_cb.wb_we_i  <= h_pkt.wb_we_i;

    wait(vif.mr_cb.wb_ack_o);

  endtask: drive_into_pins

  // WB Driver Report
  function void report();
    $display("%s: Report", REPORT_TAG);

  endfunction: report

endclass: xgemac_wb_driver
