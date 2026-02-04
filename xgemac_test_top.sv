program xgemac_test_top(xgemac_clk_interface tx_rx_clk,
                        xgemac_clk_interface wb_clk,
                        xgemac_clk_interface xgmii_clk,
                        xgemac_rst_interface tx_rx_rst_n,
                        xgemac_rst_interface wb_rst,
                        xgemac_rst_interface xgmii_rst_n,
                        xgemac_tx_interface tx_intf,
                        xgemac_rx_interface rx_intf,
                        xgemac_wb_interface wb_intf,
                        xgemac_tx_rx_xgmii_interface xgmii_intf
                      );

    //TB Config instance
    xgemac_tb_config h_cfg;
    
    // Test Instance 
    xgemac_base_test h_base_test;
    
    initial begin
      create_and_assign_configuration();
      create_and_initiate_test();
    end

    // Create and assign configuration to tb_config class
    function void create_and_assign_configuration();
      h_cfg = new();
      h_cfg.vif_txrx_clk  = tx_rx_clk;
      h_cfg.vif_wb_clk    = wb_clk;
      h_cfg.vif_xgmii_clk = xgmii_clk;
      h_cfg.vif_txrx_rst  = tx_rx_rst_n;
      h_cfg.vif_wb_rst    = wb_rst;
      h_cfg.vif_xgmii_rst = xgmii_rst_n;
      h_cfg.vif_tx        = tx_intf;
      h_cfg.vif_rx        = rx_intf;
      h_cfg.vif_wb        = wb_intf;
      h_cfg.vif_xgmii     = xgmii_intf;
    endfunction: create_and_assign_configuration

    // Create and Initialize the Test
    task create_and_initiate_test();
        string test_name;
        if(!$value$plusargs("TEST_NAME=%s", test_name)) begin
          $fatal("Test Name not mentioned");
        end
        else begin
          $display("Received Test : %s", test_name);
        end
        case(test_name)
          "xgemac_base_test"       : h_base_test = new(.h_cfg(h_cfg));
          "xgemac_direct_test"     : begin
                                       xgemac_direct_test h_dir_test;
                                       h_dir_test = new(.h_cfg(h_cfg));
                                       $cast(h_base_test, h_dir_test);
                                     end
          "xgemac_incremental_test": begin
                                       xgemac_incremental_test h_inc_test;
                                       h_inc_test = new(.h_cfg(h_cfg));
                                       $cast(h_base_test, h_inc_test);
                                     end
          "xgemac_random_test"     : begin
                                       xgemac_random_test h_rand_test;
                                       h_rand_test = new(.h_cfg(h_cfg));
                                       $cast(h_base_test, h_rand_test);
                                     end
          "xgemac_reset_test"      : begin
                                       xgemac_reset_test h_reset_test;
                                       h_reset_test = new(.h_cfg(h_cfg));
                                       $cast(h_base_test, h_reset_test);
                                     end
          "xgemac_padding_test"    : begin
                                       xgemac_padding_test h_padding_test;
                                       h_padding_test = new(h_cfg);
                                       $cast(h_base_test, h_padding_test);
                                     end
          "xgemac_wb_test"         : begin
                                       xgemac_wb_test h_wb_test;
                                       h_wb_test = new(h_cfg);
                                       $cast(h_base_test, h_wb_test);
                                     end
          "xgemac_2sop_test"       : begin
                                       xgemac_error_case_two_SOP h_two_SOP;
                                       h_two_SOP = new(h_cfg);
                                       $cast(h_base_test, h_two_SOP);
                                     end
          "xgemac_direct_eop"      : begin
                                       xgemac_error_case_direct_EOP h_direct_eop;
                                       h_direct_eop = new(h_cfg);
                                       $cast(h_base_test, h_direct_eop);
                                     end
          "xgemac_sop_eop"         : begin
                                       xgemac_error_case_SOP_EOP h_sop_eop;
                                       h_sop_eop = new(h_cfg);
                                       $cast(h_base_test, h_sop_eop);
                                     end
          "xgemac_wb_tx_disable"   : begin
                                       xgemac_tx_disable_test h_tx_dis;
                                       h_tx_dis = new(h_cfg);
                                       $cast(h_base_test, h_tx_dis);
                                     end
          "xgemac_no_sop_eop_test" : begin
                                       xgemac_error_without_sop_eop h_no_sop_eop;
                                       h_no_sop_eop = new(h_cfg);
                                       $cast(h_base_test, h_no_sop_eop);
                                     end

        endcase    
        h_base_test.build();
        h_base_test.connect();
        h_base_test.run();
        h_base_test.report();
    endtask: create_and_initiate_test
    
endprogram: xgemac_test_top
