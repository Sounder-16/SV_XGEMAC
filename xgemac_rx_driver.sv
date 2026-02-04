class xgemac_rx_driver;
  // RX Driver Handles 
  xgemac_tb_config h_cfg;
  vif_rx_t         vif;
  string REPORT_TAG;
  // RX Driver COnstructor
  function new(xgemac_tb_config h_cfg);
    this.h_cfg = h_cfg;
    REPORT_TAG = "RX PKT Driver";
  endfunction: new

  // RX Driver Build
  function void build();
    $display("%s: Build", REPORT_TAG);

  endfunction: build

  // RX Driver Connect
  function void connect();
    $display("%s: Connect", REPORT_TAG);
    this.vif = h_cfg.vif_rx;
  endfunction: connect

  // RX Driver Run
  task run();
    $display("%s: Run", REPORT_TAG);
    forever begin
      reset_input_signals();
      wait_for_reset_done();
      drive_transfer();
    end
  endtask: run

  // RX Driver Wait for Reset
  task wait_for_reset();
    @(negedge vif.rst);
  endtask: wait_for_reset

  // RX Driver Wait for Reset Done
  task wait_for_reset_done();
    wait(vif.rst == 0);
    @(posedge vif.rst);
  endtask: wait_for_reset_done

  // RX Driver Reset Input Signals
  function void reset_input_signals();
    vif.pkt_rx_ren = 'b0;
  endfunction: reset_input_signals

  // Drive Transfer
  task drive_transfer();
    process p[2];
    fork
      begin
        p[0] = process::self();
        wait_and_drive();
      end
      begin
        p[1] = process::self();
        wait_for_reset();
      end
    join_any

    foreach (p[i]) p[i].kill();

  endtask: drive_transfer

  // Wait and Drive
  task wait_and_drive();
    forever begin
      if(vif.mr_cb.pkt_rx_avail)begin
        repeat(h_cfg.ren_delay) begin
          @(posedge vif.clk);
        end
        while(vif.mr_cb.pkt_rx_eop == 'b0) begin
          drive_into_pins(); 
          @(posedge vif.clk);
        end
      end
      reset_input_signals();
      @(posedge vif.clk);
    end
  endtask: wait_and_drive

  // Drive into pins
  task drive_into_pins();
    vif.dr_cb.pkt_rx_ren <= 'b1;
  endtask: drive_into_pins

  // RX Driver Report
  function void report();
    $display("%s: Report", REPORT_TAG);
    
  endfunction: report

endclass: xgemac_rx_driver
