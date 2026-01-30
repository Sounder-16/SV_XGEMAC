
class xgemac_tx_generator;

  // TX Generator Handles
  xgemac_tb_config        h_cfg;
  mailbox#(xgemac_tx_pkt) tx_mbx;
  mailbox#(bit)           rst_mbx;
  xgemac_tx_pkt           h_tx_pkt;
  xgemac_tx_pkt           h_tx_cln_pkt;
  string REPORT_TAG;

  // TX Generator Constructor
  function new(xgemac_tb_config h_cfg);
    this.h_cfg = h_cfg;
    REPORT_TAG = "TX PKT Generator";
  endfunction: new

  // TX Generator Build Method
  function void build();
    $display("%s: Build", REPORT_TAG);
    tx_mbx = new(1);
    rst_mbx = new(1);
  endfunction: build

  // TX Generator Connect Method
  function void connect();
    $display("%s: Connect", REPORT_TAG);
    
  endfunction: connect

  // TX Generator Stimulus Generation Method
  task gen_and_send_directed_stimulus();
    int unsigned count;
    h_tx_pkt = new();
    repeat(h_cfg.trans_count) begin
      h_tx_pkt.pkt_tx_data = `XGEMAC_TXRX_DATA_WIDTH'hFFFF_FFFF_FFFF_FFFF;
      h_tx_pkt.pkt_tx_sop = (count == 0);
      h_tx_pkt.pkt_tx_eop = (++count == h_cfg.trans_count);
      if(h_tx_pkt.pkt_tx_eop) begin
        h_tx_pkt.pkt_tx_mod = 0;
      end
      $cast(h_tx_cln_pkt, h_tx_pkt.clone());
      $display("From TX Generator to TX Driver at %0t", $time);
      h_tx_cln_pkt.display();
      tx_mbx.put(h_tx_cln_pkt);
    end

  endtask: gen_and_send_directed_stimulus  

  task gen_and_send_plus_rand_stimulus();
    int count;
    bit[`XGEMAC_TXRX_DATA_WIDTH-1:0] tx_data;
    if($value$plusargs($sformatf("TX_DATA=%0d", count), tx_data)) begin

    end
  endtask: gen_and_send_plus_rand_stimulus

  task gen_and_send_incremental_stimulus();
    int data = `INCR_START_VALUE;
    int unsigned count;
    h_tx_pkt = new();
    repeat(h_cfg.trans_count) begin
      h_tx_pkt.pkt_tx_data = data++;
      h_tx_pkt.pkt_tx_sop = (count == 0 || h_tx_pkt.pkt_tx_eop == 1);
      h_tx_pkt.pkt_tx_eop = (++count == h_cfg.trans_count || count == 9 || count == 17);
      if(h_tx_pkt.pkt_tx_eop) begin
        h_tx_pkt.pkt_tx_mod = 'b0;
      end
      $cast(h_tx_cln_pkt, h_tx_pkt.clone());
      $display("From TX Generator to TX Driver at %0t", $time);
      h_tx_cln_pkt.display();
      tx_mbx.put(h_tx_cln_pkt);
    end

  endtask: gen_and_send_incremental_stimulus

  task gen_and_send_random_stimulus();
    int unsigned count;
    h_tx_pkt = new(h_cfg.trans_count);
    repeat(h_cfg.trans_count) begin
      if(!h_tx_pkt.randomize()) begin
        $display("TX PKT Not randomized");
      end
      count++;
      $cast(h_tx_cln_pkt, h_tx_pkt.clone());
      $display("From TX Generator to TX Driver at %0t", $time);
      h_tx_cln_pkt.display();
      tx_mbx.put(h_tx_cln_pkt);
    end

  endtask: gen_and_send_random_stimulus

  task gen_and_send_reset_stimulus();
    int unsigned count;
    h_tx_pkt = new();
    fork
      apply_reset();
    join_none
    repeat(h_cfg.trans_count) begin
      h_tx_pkt.pkt_tx_data = `XGEMAC_TXRX_DATA_WIDTH'hFFFF_FFFF_FFFF_FFFF;
      h_tx_pkt.pkt_tx_sop = (count == 0);
      h_tx_pkt.pkt_tx_eop = (++count == h_cfg.trans_count);
      if(h_tx_pkt.pkt_tx_eop) begin
        h_tx_pkt.pkt_tx_mod = 0;
      end
      $cast(h_tx_cln_pkt, h_tx_pkt.clone());
      $display("From TX Generator to TX Driver at %0t", $time);
      h_tx_cln_pkt.display();
      tx_mbx.put(h_tx_cln_pkt);
    end

    wait(h_cfg.vif_txrx_rst.rst == 0);
    @(posedge h_cfg.vif_txrx_rst.rst);
  endtask: gen_and_send_reset_stimulus

  task apply_reset();
    int count;
    forever begin

    @(posedge h_cfg.vif_txrx_clk.clk);
     count+=1;
      if(count inside {[7:9]}) begin
        rst_mbx.put(1);
      end
      else rst_mbx.put(0);
      if(count > 100) return;

    end
  endtask: apply_reset
task gen_and_send_padding_stimulus();
    int unsigned count;
    h_tx_pkt = new();
    repeat(h_cfg.trans_count) begin
      void'(std::randomize(h_tx_pkt.pkt_tx_data));
      h_tx_pkt.pkt_tx_sop = (count == 0);
      h_tx_pkt.pkt_tx_eop = (++count == h_cfg.trans_count);
      if(h_tx_pkt.pkt_tx_eop) begin
        h_tx_pkt.pkt_tx_mod = 5;
      end
      $cast(h_tx_cln_pkt, h_tx_pkt.clone());
      $display("From TX Generator to TX Driver at %0t", $time);
      h_tx_cln_pkt.display();
      tx_mbx.put(h_tx_cln_pkt);
    end

  endtask: gen_and_send_padding_stimulus
endclass: xgemac_tx_generator





