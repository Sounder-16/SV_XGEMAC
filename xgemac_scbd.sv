class xgemac_scbd;
  // XGEMAC Scoreboard Handles
  xgemac_tb_config         h_cfg;
  mailbox#(xgemac_tx_pkt)  tx_mon_mbx;
  mailbox#(xgemac_rx_pkt)  rx_mon_mbx;
  mailbox#(xgemac_rst_pkt) rst_mon_mbx;
  xgemac_tx_pkt            tx_exp_pkt[$];
  mailbox#(bit)            rst_ack_mbx;
  string REPORT_TAG = "Scoreboard";
  
  // XGEMAC Scoreboard Constructor
  function new(xgemac_tb_config h_cfg);
    this.h_cfg = h_cfg;
  endfunction: new

  // XGEMAC Scoreboard Build
  function void build();
    $display("%s: Build", REPORT_TAG);
    rst_ack_mbx = new();
  endfunction: build

  // XGEMAC Scoreboard Connect
  function void connect();
    $display("%s: Connect", REPORT_TAG);

  endfunction: connect

  // XGEMAC Scoreboard Run
  task run();
    $display("%s: Run", REPORT_TAG);
    fork
      wait_for_tx_pkt_and_calc_exp_data();
      wait_for_rx_pkt();
    join_none
  endtask: run

  // Wait for TX PKT to arrive
  task wait_for_tx_pkt_and_calc_exp_data();
    xgemac_tx_pkt h_tx_exp_pkt, h_tx_exp_cln_pkt;
    xgemac_rst_pkt h_rst_pkt, h_rst_cln_pkt;
    int cur_count;
    bit rst_ack;
    forever begin
      tx_mon_mbx.get(h_tx_exp_pkt);
      $cast(h_tx_exp_cln_pkt, h_tx_exp_pkt.clone());
      //rst_mon_mbx.get(h_rst_pkt);
      //$cast(h_rst_cln_pkt, h_rst_pkt.clone());
      //if(!rst_ack_mbx.try_get(rst_ack)) begin
      //if(!h_rst_pkt.reset) begin
      //  while(tx_exp_pkt.size()) begin
      //    if(tx_exp_pkt.size() == 1) h_cfg.act_count++;
      //    $display("Popped %p at %0t",tx_exp_pkt.pop_front(), $time);
      //    h_cfg.act_count += 1; 
      //  end
      //end
      //else begin
        if(h_tx_exp_pkt.pkt_tx_sop) cur_count = 0;
        cur_count += 1;
        $display("From TX Monitor to SCBD");
        h_tx_exp_cln_pkt.display();

        //Padding Handling
        if(h_tx_exp_cln_pkt.pkt_tx_eop && cur_count < 8) begin
          h_cfg.act_count -= (8-cur_count);
          h_tx_exp_cln_pkt.pkt_tx_eop = 0;
          h_tx_exp_cln_pkt.pkt_tx_mod = 0;
          tx_exp_pkt.push_back(h_tx_exp_cln_pkt);
          while(cur_count++ < 8) begin
            h_tx_exp_cln_pkt = new();
            if(cur_count == 8) begin
              h_tx_exp_cln_pkt.pkt_tx_eop = 1;
              h_tx_exp_cln_pkt.pkt_tx_mod = 4;
            end
            tx_exp_pkt.push_back(h_tx_exp_cln_pkt);
          end
        end
        else begin
          tx_exp_pkt.push_back(h_tx_exp_cln_pkt);
        end
      //end
    end
    
  endtask: wait_for_tx_pkt_and_calc_exp_data

  // Wait for RX PKT to arrive
  task wait_for_rx_pkt();
    xgemac_rx_pkt h_rx_act_pkt, h_rx_act_cln_pkt;
    forever begin
      rx_mon_mbx.get(h_rx_act_pkt);
      $cast(h_rx_act_cln_pkt, h_rx_act_pkt.clone());
      $display("From RX Monitor to Scoreboard");
      h_rx_act_cln_pkt.display();
      h_cfg.act_count += 1;
      $display("TC: %0d AC: %0d", h_cfg.trans_count, h_cfg.act_count);
     check_exp_and_act_data(h_rx_act_cln_pkt);
    end
  endtask: wait_for_rx_pkt

  // Checker that checks the Expected and Actual Data is similar
  function void check_exp_and_act_data(xgemac_rx_pkt h_rx_act_pkt);
    xgemac_tx_pkt h_tx_exp_pkt = tx_exp_pkt.pop_front();
    
    // Checkers
    if(!check_received_data(h_tx_exp_pkt, h_rx_act_pkt)) begin
      $error("DATA MISMATCH: Expected Data %h and Actual Data %h does not match", h_tx_exp_pkt.pkt_tx_data, h_rx_act_pkt.pkt_rx_data);
     h_cfg.test_status = FAIL;
     h_cfg.print_test_status = {h_cfg.print_test_status, $sformatf("ACTUAL_COUNT: %0d Expected DATA: %h Actual DATA: %h\n", h_cfg.act_count, h_tx_exp_pkt.pkt_tx_data, h_rx_act_pkt.pkt_rx_data)};
    end

    if(h_tx_exp_pkt.pkt_tx_sop != h_rx_act_pkt.pkt_rx_sop) begin
      $error("SOP MISMATCH: Expected SOP %h and Actual SOP %h does not match", h_tx_exp_pkt.pkt_tx_sop, h_rx_act_pkt.pkt_rx_sop);
      h_cfg.test_status = FAIL;
     h_cfg.print_test_status = {h_cfg.print_test_status, $sformatf("ACTUAL_COUNT: %0d Expected DATA: %h Actual DATA: %h\n", h_cfg.act_count, h_tx_exp_pkt.pkt_tx_data, h_rx_act_pkt.pkt_rx_data)};
    end

     if(h_tx_exp_pkt.pkt_tx_eop != h_rx_act_pkt.pkt_rx_eop) begin
      $error("EOP MISMATCH: Expected EOP %h and Actual EOP %h does not match", h_tx_exp_pkt.pkt_tx_eop, h_rx_act_pkt.pkt_rx_eop);
      h_cfg.test_status = FAIL;
      h_cfg.print_test_status = {h_cfg.print_test_status, $sformatf("ACTUAL_COUNT: %0d Expected DATA: %h Actual DATA: %h\n", h_cfg.act_count, h_tx_exp_pkt.pkt_tx_data, h_rx_act_pkt.pkt_rx_data)};
    end

    if(h_tx_exp_pkt.pkt_tx_mod != h_rx_act_pkt.pkt_rx_mod) begin
      $error("MOD MISMATCH: Expected MOD %h and Actual MOD %h does not match", h_tx_exp_pkt.pkt_tx_mod, h_rx_act_pkt.pkt_rx_mod);
      h_cfg.test_status = FAIL;
      h_cfg.print_test_status = {h_cfg.print_test_status, $sformatf("ACTUAL_COUNT: %0d Expected DATA: %h Actual DATA: %h\n", h_cfg.act_count, h_tx_exp_pkt.pkt_tx_data, h_rx_act_pkt.pkt_rx_data)};
    end

  endfunction: check_exp_and_act_data

  // Checks the received data with modulus
  function bit check_received_data(xgemac_tx_pkt exp_pkt, xgemac_rx_pkt act_pkt);
    bit[`XGEMAC_TXRX_DATA_WIDTH-1:0] exp_res, act_res;
    if(exp_pkt.pkt_tx_eop && exp_pkt.pkt_tx_mod && h_cfg.act_count >= 8) begin
      exp_res =exp_pkt.pkt_tx_data & ('hFFFF_FFFF_FFFF_FFFF<<(`NO_OF_BITS_IN_BYTE*(`TOTAL_BYTES_IN_TXRX_DATA-exp_pkt.pkt_tx_mod)));
    end
    else exp_res = exp_pkt.pkt_tx_data;
    if(act_pkt.pkt_rx_eop && act_pkt.pkt_rx_mod) begin
      act_res =act_pkt.pkt_rx_data & ('hFFFF_FFFF_FFFF_FFFF<<(`NO_OF_BITS_IN_BYTE*(`TOTAL_BYTES_IN_TXRX_DATA-act_pkt.pkt_rx_mod)));
    end
    else act_res = act_pkt.pkt_rx_data;
    return (act_res == exp_res);
  endfunction: check_received_data
  
  // Report Phase
  function void report();
    $display("%s: Report", REPORT_TAG);
    repeat(3) $display();
    $display("************************************************");
    $write("*** ");
    if(tx_exp_pkt.size()) begin
      $error("%s: Trans Count(%0d) & Actual Count (%0d) does not match Queue Size: %0d. TEST FAILED", REPORT_TAG, h_cfg.trans_count, h_cfg.act_count, tx_exp_pkt.size());
    end
    else begin
      if(h_cfg.test_status == PASS) begin
        $write("%s: TEST PASSED SUCCESSFULLY", REPORT_TAG);
      end
      else begin
        $error("%s: TEST FAILED\n Reason:\n%s", REPORT_TAG, h_cfg.print_test_status);
      end
    end
    $write(" ***");
    $display("\n************************************************");
    
    $display("%s: Trans Count(%0d) & Actual Count (%0d)",REPORT_TAG, h_cfg.trans_count, h_cfg.act_count);
    repeat(3) $display();
  endfunction: report

endclass: xgemac_scbd
