class xgemac_environment;
    // TB Config Handle
    xgemac_tb_config h_cfg;

    // Clock Driver Handles
    xgemac_clk_driver#(int, `XGEMAC_TXRX_CLOCK_PERIOD, vif_txrx_clk_t)  h_txrx_clk_drv;
    xgemac_clk_driver#(int, `XGEMAC_WB_CLOCK_PERIOD, vif_wb_clk_t)      h_wb_clk_drv;
    xgemac_clk_driver#(int, `XGEMAC_TXRX_CLOCK_PERIOD, vif_xgmii_clk_t) h_xgmii_clk_drv;

    // Reset Driver Handles
    xgemac_rst_driver#(`XGEMAC_TXRX_RESET_PERIOD, NEG_RESET, vif_txrx_rst_t, 1) h_txrx_rst_drv;
    xgemac_rst_driver#(`XGEMAC_WB_RESET_PERIOD, POS_RESET, vif_wb_rst_t)        h_wb_rst_drv;
    xgemac_rst_driver#(`XGEMAC_TXRX_RESET_PERIOD, NEG_RESET, vif_xgmii_rst_t)   h_xgmii_rst_drv;

    // TX PKT Generator, Driver & Monitor handles
    xgemac_tx_generator h_tx_gen;
    xgemac_tx_driver    h_tx_drv;
    xgemac_tx_monitor   h_tx_mon;

    // WishBone Generator, Driver & Monitor handles
    xgemac_wb_generator h_wb_gen;
    xgemac_wb_driver    h_wb_drv;
    xgemac_wb_monitor   h_wb_mon;

    // RX PKT Generator, Driver & Monitor handles
    xgemac_rx_driver    h_rx_drv;
    xgemac_rx_monitor   h_rx_mon;

    // Scoreboard handle
    xgemac_scbd         h_scbd;

    // Reset Monitor Handle
    xgemac_rst_monitor  h_rst_mon;
    
    string REPORT_TAG = "XGEMAC Environment";

    // Environment Constructor
    function new(xgemac_tb_config h_cfg);
        this.h_cfg = h_cfg;
    endfunction: new

    // Environment Build
    function void build();
      $display("%s: Build", REPORT_TAG);
      if(h_cfg.has_txrx_clk_drv) begin
        h_txrx_clk_drv = new(.vif(h_cfg.vif_txrx_clk));
        h_txrx_clk_drv.build();
        $display("TX RX Clock Build");
      end
      if(h_cfg.has_wb_clk_drv) begin
        h_wb_clk_drv   = new(.vif(h_cfg.vif_wb_clk));
        h_wb_clk_drv.build();
        $display("WB Clock Build");
      end
      if(h_cfg.has_xgmii_clk_drv) begin
        h_xgmii_clk_drv = new(.vif(h_cfg.vif_xgmii_clk));
        h_xgmii_clk_drv.build();
        $display("XGMII Clock Build");
      end
      if(h_cfg.has_txrx_rst_drv) begin
        h_txrx_rst_drv = new(.vif(h_cfg.vif_txrx_rst));
        h_txrx_rst_drv.build();
        $display("TX RX Reset Build");
      end
      if(h_cfg.has_wb_rst_drv) begin
        h_wb_rst_drv   = new(.vif(h_cfg.vif_wb_rst));
        h_wb_rst_drv.build();
        $display("WB Reset Build");
      end
      if(h_cfg.has_xgmii_clk_drv) begin
        h_xgmii_rst_drv = new(.vif(h_cfg.vif_xgmii_rst));
        h_xgmii_rst_drv.build();
        $display("XGMII Reset Build");
      end
      if(h_cfg.has_tx_gen) begin
        h_tx_gen = new(.h_cfg(h_cfg));
        h_tx_gen.build();
        $display("TX Generator Build");
      end
      if(h_cfg.has_tx_drv) begin
        h_tx_drv = new(.h_cfg(h_cfg));
        h_tx_drv.build();
        $display("TX Driver Build");
      end
      if(h_cfg.has_tx_mon) begin
        h_tx_mon = new(.h_cfg(h_cfg));
        h_tx_mon.build();
        $display("TX Monitor Build");
      end
      if(h_cfg.has_wb_gen) begin
        h_wb_gen = new(.h_cfg(h_cfg));
        h_wb_gen.build();
        $display("WB Generator Build");
      end
      if(h_cfg.has_wb_drv) begin
        h_wb_drv = new(.h_cfg(h_cfg));
        h_wb_drv.build();
        $display("WB Driver Build");
      end
      if(h_cfg.has_wb_mon) begin
        h_wb_mon = new(.h_cfg(h_cfg));
        h_wb_mon.build();
      $display("WB Monitor Build");
      end
      if(h_cfg.has_rx_drv) begin
        h_rx_drv = new(.h_cfg(h_cfg));
        h_rx_drv.build();
        $display("RX Driver Build");
      end
      if(h_cfg.has_rx_mon) begin
        h_rx_mon = new(.h_cfg(h_cfg));
        h_rx_mon.build();
        $display("RX Monitor Build");
      end
      if(h_cfg.has_scbd) begin
        h_scbd = new(.h_cfg(h_cfg));
        h_scbd.build();
        $display("Scoreboard Build");
      end
      h_rst_mon = new(.h_cfg(h_cfg));
      h_rst_mon.build();
      $display("Reset Monitor Build");
    endfunction: build

    //Environment Connect
    function void connect();
      $display("%s: Connect", REPORT_TAG);
      if(h_cfg.has_txrx_clk_drv)  h_txrx_clk_drv.connect();
      if(h_cfg.has_wb_clk_drv)    h_wb_clk_drv.connect();
      if(h_cfg.has_xgmii_clk_drv) h_xgmii_clk_drv.connect();
      if(h_cfg.has_txrx_rst_drv)  h_txrx_rst_drv.connect();
      if(h_cfg.has_wb_rst_drv)    h_wb_rst_drv.connect();
      if(h_cfg.has_xgmii_rst_drv) h_xgmii_rst_drv.connect();
      if(h_cfg.has_tx_drv && h_cfg.has_tx_gen) h_tx_drv.tx_mbx = h_tx_gen.tx_mbx; 
      if(h_cfg.has_wb_drv && h_cfg.has_wb_gen) h_wb_drv.wb_mbx = h_wb_gen.wb_mbx;
      if(h_cfg.has_scbd) begin
        if(h_cfg.has_tx_mon) h_scbd.tx_mon_mbx = h_tx_mon.tx_mon_mbx;
        if(h_cfg.has_rx_mon) h_scbd.rx_mon_mbx = h_rx_mon.rx_mon_mbx;
      end
      h_scbd.rst_mon_mbx = h_rst_mon.rst_mon_mbx;
      h_txrx_rst_drv.rst_mbx = h_tx_gen.rst_mbx;
      if(h_cfg.has_tx_gen) h_tx_gen.connect();
      if(h_cfg.has_tx_drv) h_tx_drv.connect();
      if(h_cfg.has_tx_mon) h_tx_mon.connect();
      if(h_cfg.has_rx_drv) h_rx_drv.connect();
      if(h_cfg.has_rx_mon) h_rx_mon.connect();
      if(h_cfg.has_wb_gen) h_wb_gen.connect();
      if(h_cfg.has_wb_drv) h_wb_drv.connect();
      if(h_cfg.has_scbd)   h_scbd.connect();
      if(h_cfg.has_wb_mon) h_wb_mon.connect();
    endfunction: connect

    //Environment Run
    task run();
      $display("%s: Run", REPORT_TAG);
        fork
            if(h_cfg.has_txrx_clk_drv)  h_txrx_clk_drv.run();
            if(h_cfg.has_wb_clk_drv)    h_wb_clk_drv.run();
            if(h_cfg.has_xgmii_clk_drv) h_xgmii_clk_drv.run();
            if(h_cfg.has_txrx_rst_drv)  h_txrx_rst_drv.run();
            if(h_cfg.has_wb_rst_drv)    h_wb_rst_drv.run();
            if(h_cfg.has_xgmii_clk_drv) h_xgmii_rst_drv.run();
            if(h_cfg.has_tx_drv)        h_tx_drv.run();
            if(h_cfg.has_tx_mon)        h_tx_mon.run();
            if(h_cfg.has_rx_drv)        h_rx_drv.run();
            if(h_cfg.has_rx_mon)        h_rx_mon.run();
            if(h_cfg.has_wb_drv)        h_wb_drv.run();
            if(h_cfg.has_scbd)          h_scbd.run();
            if(h_cfg.has_wb_mon)        h_wb_mon.run();
        join_none
    endtask: run
    
    // Environment Report
    function void report();
      $display("%s: Report", REPORT_TAG);
      if(h_cfg.has_txrx_clk_drv) h_txrx_clk_drv.report();
      if(h_cfg.has_wb_clk_drv)   h_wb_clk_drv.report();
      if(h_cfg.has_txrx_rst_drv) h_txrx_rst_drv.report();
      if(h_cfg.has_wb_rst_drv)   h_wb_rst_drv.report();
      if(h_cfg.has_tx_drv)       h_tx_drv.report();
      if(h_cfg.has_tx_mon)       h_tx_mon.report();
      if(h_cfg.has_rx_drv)       h_rx_drv.report();
      if(h_cfg.has_rx_mon)       h_rx_mon.report();
      if(h_cfg.has_wb_drv)       h_wb_drv.report();
      if(h_cfg.has_wb_mon)       h_wb_mon.report();
      if(h_cfg.has_scbd)         h_scbd.report();
    endfunction: report

endclass: xgemac_environment
