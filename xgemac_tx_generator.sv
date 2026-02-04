class xgemac_tx_generator;

  // TX Generator Handles
  xgemac_tb_config        h_cfg;
  mailbox#(xgemac_tx_pkt) tx_mbx;
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
  endfunction: build

  // TX Generator Connect Method
  function void connect();
    $display("%s: Connect", REPORT_TAG);
    
  endfunction: connect

  // TX Generator Known Stimulus Generation Method
  task gen_and_send_directed_stimulus();
    int unsigned count;
    h_tx_pkt = new();
    repeat(h_cfg.trans_count) begin
      h_tx_pkt.pkt_tx_data = count+1;
      h_tx_pkt.pkt_tx_sop = (count == 0);
      h_tx_pkt.pkt_tx_eop = (count+1 == h_cfg.trans_count);
      if(h_tx_pkt.pkt_tx_eop) begin
        h_tx_pkt.pkt_tx_mod = 7;
      end
      $cast(h_tx_cln_pkt, h_tx_pkt.clone());
      $display("From TX Generator to TX Driver at %0t", $time);
      h_tx_cln_pkt.display();
      tx_mbx.put(h_tx_cln_pkt);
      count++;
    end

  endtask: gen_and_send_directed_stimulus  

  // TX Generator Incremental Stimulus Generation Method
  task gen_and_send_incremental_stimulus();
    int data = `INCR_START_VALUE;
    bit [`XGEMAC_TXRX_MOD_WIDTH-1:0]mod = 1;
    int unsigned count;
    h_tx_pkt = new(); 
    repeat(h_cfg.trans_count) begin
      h_tx_pkt.pkt_tx_data = data++;
      h_tx_pkt.pkt_tx_sop = (count == 0 || h_tx_pkt.pkt_tx_eop == 1);
      h_tx_pkt.pkt_tx_eop = (++count == h_cfg.trans_count || count == 10 || count == 20);
      if(h_tx_pkt.pkt_tx_eop) begin
        h_tx_pkt.pkt_tx_mod = mod++;
      end
      else h_tx_pkt.pkt_tx_mod = 0;
      $cast(h_tx_cln_pkt, h_tx_pkt.clone());
      $display("From TX Generator to TX Driver at %0t", $time);
      h_tx_cln_pkt.display();
      tx_mbx.put(h_tx_cln_pkt);
    end

  endtask: gen_and_send_incremental_stimulus

  // TX Generator Random Stimulus Generation Method
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

  // TX Generator Reset Stimulus Generation Method
  task gen_and_send_reset_stimulus();
    static int unsigned count = 1;
    int unsigned prev;
    count -= 1;
    h_tx_pkt = new();
    while(count < h_cfg.trans_count) begin
      h_tx_pkt.pkt_tx_data = count;
      h_tx_pkt.pkt_tx_sop = (prev++ == 0);
      h_tx_pkt.pkt_tx_eop = (count+1 == h_cfg.trans_count);
      if(h_tx_pkt.pkt_tx_eop) begin
        h_tx_pkt.pkt_tx_mod = 0;
      end
      $cast(h_tx_cln_pkt, h_tx_pkt.clone());
      $display("From TX Generator to TX Driver at %0t", $time);
      h_tx_cln_pkt.display();
      tx_mbx.put(h_tx_cln_pkt);
      count++;
    end

  endtask: gen_and_send_reset_stimulus

  // TX Generator Padding Stimulus Generation Method
  task gen_and_send_padding_stimulus();
    int unsigned count;
    h_tx_pkt = new(); 
    repeat(h_cfg.trans_count) begin
      h_tx_pkt.pkt_tx_data = 'hFFFF_FFFF_FFFF_FFFF;
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

  // TX Generator Continuous SOP Generation Method
  task gen_and_send_continuous_SOP();
    int unsigned count;
    h_tx_pkt = new();
    repeat(h_cfg.trans_count) begin
      h_tx_pkt.pkt_tx_data = count+1;
      h_tx_pkt.pkt_tx_sop = (count inside {[0:2]} || count == 4);
      count++;
      if(h_tx_pkt.pkt_tx_eop) begin
        h_tx_pkt.pkt_tx_mod = 0;
      end
      $cast(h_tx_cln_pkt, h_tx_pkt.clone());
      $display("From TX Generator to TX Driver at %0t", $time);
      h_tx_cln_pkt.display();
      tx_mbx.put(h_tx_cln_pkt);
    end
  endtask: gen_and_send_continuous_SOP

  // TX Generator Continuous EOP Generation Method
  task gen_and_send_direct_EOP();
    int unsigned count;
    h_tx_pkt = new();
    repeat(h_cfg.trans_count) begin
      h_tx_pkt.pkt_tx_data = `XGEMAC_TXRX_DATA_WIDTH'hFFFF_FFFF_FFFF_FFFF;
      h_tx_pkt.pkt_tx_eop = (count inside {[0:2]} || count+1 == h_cfg.trans_count);
      count++;
      if(h_tx_pkt.pkt_tx_eop) begin
        h_tx_pkt.pkt_tx_mod = 0;
      end
      $cast(h_tx_cln_pkt, h_tx_pkt.clone());
      $display("From TX Generator to TX Driver at %0t", $time);
      h_tx_cln_pkt.display();
      tx_mbx.put(h_tx_cln_pkt);
    end
  endtask: gen_and_send_direct_EOP
  
  //TX Generator Continuous SOP EOP Generation Method
/*task gen_and_send_SOP_EOP_at_same_time();
    int unsigned count;
    h_tx_pkt = new();
    repeat(h_cfg.trans_count) begin
      h_tx_pkt.pkt_tx_data = count+1;
      h_tx_pkt.pkt_tx_sop = (count inside {[0:6]});
      h_tx_pkt.pkt_tx_eop = h_tx_pkt.pkt_tx_sop;
      count++;
      if(h_tx_pkt.pkt_tx_eop) begin
        h_tx_pkt.pkt_tx_mod = 0;
      end
      $cast(h_tx_cln_pkt, h_tx_pkt.clone());
      $display("From TX Generator to TX Driver at %0t", $time);
      h_tx_cln_pkt.display();
      tx_mbx.put(h_tx_cln_pkt);
    end
  endtask: gen_and_send_SOP_EOP_at_same_time*/

  // TX Generator Stimulus Generation without SOP EOP
  task gen_and_send_without_sop_eop_stimulus();
    int unsigned count;
    h_tx_pkt = new();
    repeat(h_cfg.trans_count) begin
      h_tx_pkt.pkt_tx_data = count+1;
      count++;
      $cast(h_tx_cln_pkt, h_tx_pkt.clone());
      $display("From TX Generator to TX Driver at %0t", $time);
      h_tx_cln_pkt.display();
      tx_mbx.put(h_tx_cln_pkt);
    end
  endtask: gen_and_send_without_sop_eop_stimulus

endclass: xgemac_tx_generator

