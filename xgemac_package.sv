package xgemac_package;
    // Clock Virtual Interface Typedef
    typedef virtual xgemac_clk_interface vif_txrx_clk_t;
    typedef virtual xgemac_clk_interface vif_wb_clk_t;
    typedef virtual xgemac_clk_interface vif_xgmii_clk_t;

    // Reset Virtual Interface Typedef
    typedef virtual xgemac_rst_interface vif_txrx_rst_t;
    typedef virtual xgemac_rst_interface vif_wb_rst_t;
    typedef virtual xgemac_rst_interface vif_xgmii_rst_t;

    // TX Virtual Interface Typedef
    typedef virtual xgemac_tx_interface vif_tx_t;

    // RX Virtual Interface Typedef
    typedef virtual xgemac_rx_interface vif_rx_t;

    // WB Virtual Interface Typedef
    typedef virtual xgemac_wb_interface vif_wb_t;

    // XGMII Virtual Interface Typedef
    typedef virtual xgemac_tx_rx_xgmii_interface vif_xgmii_t;

    // Enum Typedef
    typedef enum bit {POS_RESET, NEG_RESET}rst_t;
    typedef enum bit {PASS, FAIL}test_sts_t;

    // Include files
    `include "xgemac_tb_config.sv"
    `include "xgemac_clk_driver.sv"
    `include "xgemac_rst_driver.sv"
    `include "xgemac_tx_pkt.sv"
    `include "xgemac_rx_pkt.sv"
    `include "xgemac_tx_driver.sv"
    `include "xgemac_wb_driver.sv"
    `include "xgemac_rx_driver.sv"
    `include "xgemac_tx_generator.sv"
    `include "xgemac_wb_generator.sv"
    `include "xgemac_tx_monitor.sv"
    `include "xgemac_rx_monitor.sv"
    `include "xgemac_wb_monitor.sv"
    `include "xgemac_rst_monitor.sv"
    `include "xgemac_scbd.sv"
    `include "xgemac_environment.sv"
    `include "xgemac_test_lib.sv"
    
endpackage: xgemac_package
