class xgemac_tb_config;
   string REPORT_TAG = "TB Config";
  // Virtual Interfaces
   vif_txrx_clk_t  vif_txrx_clk;
   vif_wb_clk_t    vif_wb_clk;
   vif_xgmii_clk_t vif_xgmii_clk;
   vif_txrx_rst_t  vif_txrx_rst;
   vif_wb_rst_t    vif_wb_rst;
   vif_xgmii_rst_t vif_xgmii_rst;
   vif_tx_t        vif_tx;
   vif_rx_t        vif_rx;
   vif_wb_t        vif_wb;
   vif_xgmii_t     vif_xgmii;

   // Knobs
   bit has_env = 1;
   bit has_txrx_clk_drv  = 1;
   bit has_wb_clk_drv    = 1;
   bit has_xgmii_clk_drv = 1;
   bit has_txrx_rst_drv  = 1;
   bit has_wb_rst_drv    = 1;
   bit has_xgmii_rst_drv = 1;
   bit has_tx_gen        = 1;
   bit has_tx_drv        = 1;
   bit has_wb_gen        = 1;
   bit has_wb_drv        = 1;
   bit has_rx_drv        = 1;
   bit has_tx_mon        = 1;
   bit has_wb_mon        = 1;
   bit has_rx_mon        = 1;
   bit has_scbd          = 1;
   bit tx_enable         = 1;

   rand int unsigned ren_delay;
   rand int unsigned trans_count;
        int unsigned act_count;
        test_sts_t   test_status;
        string       print_test_status;
   constraint C { trans_count <= 500; trans_count >=10;}
   function void get_plusargs();
     if($value$plusargs("HAS_ENV=%b", has_env)) begin
       
     end
     if($value$plusargs("TRANS_COUNT=%0d", trans_count)) begin
       trans_count.rand_mode(0);
     end
     if($value$plusargs("REN_DELAY=%0d", ren_delay)) begin
       ren_delay.rand_mode(0);
     end
   endfunction: get_plusargs
   function new();
      $display("%s Obj created", REPORT_TAG);
   endfunction: new

endclass: xgemac_tb_config
