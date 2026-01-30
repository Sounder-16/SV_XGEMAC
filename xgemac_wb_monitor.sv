class xgemac_wb_monitor;

  // WishBone Monitor Instances
  xgemac_tb_config        h_cfg;
  vif_wb_t                vif;
  mailbox#(xgemac_wb_pkt) wb_mbx;
  string REPORT_TAG = "Wishbone Monitor";

  // WishBone Monitor Constructor
  function new(xgemac_tb_config h_cfg);
    this.h_cfg = h_cfg;
  endfunction: new

  // WishBone Monitor Build
  function void build();
    $display("%s: Build", REPORT_TAG);
    wb_mbx = new(1);
  endfunction: build

  // WishBone Monitor Connect
  function void connect();
    $display("%s: Connect", REPORT_TAG);
    this.vif = h_cfg.vif_wb;
  endfunction: connect

  // WishBone Monitor Run
  task run();
    $display("%s: Run", REPORT_TAG);
    forever begin
      wait_for_reset_done();
      collect_transfer();
    end
  endtask: run

  // Wait for Reset Method
  task wait_for_reset();
    @(posedge vif.clk);
  endtask

  // Wait for Reset Completion Method
  task wait_for_reset_done();
    @(negedge vif.clk);
  endtask: wait_for_reset_done

  /* Forks two thread parallelly: One collects data from Vif and other waits
  for reset assert*/
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

    foreach (p[i]) p[i].kill();

  endtask: collect_transfer

  // Collects the data from Vif
  task collect_from_vif();
    xgemac_wb_pkt h_pkt;
    h_pkt = new();
    forever begin
      wait(vif.mr_cb.wb_ack_o);

      h_pkt.wb_dat_i = vif.mr_cb.wb_dat_i;
      h_pkt.wb_adr_i = vif.mr_cb.wb_adr_i;
      //h_pkt.wb_cyc_i = vif.mr_cb.wb_cyc_i;
      //h_pkt.wb_stb_i = vif.mr_cb.wb_stb_i;
      h_pkt.wb_we_i  = vif.mr_cb.wb_we_i;
      //h_pkt.wb_ack_o = vif.mr_cb.wb_ack_o;
      h_pkt.wb_dat_o = vif.mr_cb.wb_ack_o;
      h_pkt.wb_int_o = vif.mr_cb.wb_int_o;

      wb_mbx.put(h_pkt);
      $display("From Vif to WB Monitor");
      h_pkt.display();
      @(posedge vif.clk);
    end
  endtask: collect_from_vif

  // WishBone Monitor Report
  function void report();
    $display("%s: Report", REPORT_TAG);

  endfunction: report

endclass: xgemac_wb_monitor
