interface xgemac_tx_rx_xgmii_interface(input clk, rst);
    logic [`XGEMAC_XGMII_CONTROL_WIDTH-1:0] xgmii_txrxc;
    logic [`XGEMAC_XGMII_DATA_WIDTH-1:0] xgmii_txrxd;
endinterface
