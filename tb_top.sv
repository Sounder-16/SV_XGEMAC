`timescale 1ps/1ps
`include "xgemac_defines.sv"
`include "xgemac_package.sv"
import xgemac_package::*;
`include "xgemac_clk_interface.sv"
`include "xgemac_rst_interface.sv"
`include "xgemac_tx_rx_xgmii_interface.sv"
`include "xgemac_tx_interface.sv"
`include "xgemac_rx_interface.sv"
`include "xgemac_wb_interface.sv"
`include "xgemac_test_top.sv"
`include "../rtl/verilog/xgemac_rtl_list.sv"

module tb_top();

//Clock Interfaces Instantiation
xgemac_clk_interface tx_rx_clk();
xgemac_clk_interface wb_clk();
xgemac_clk_interface xgmii_clk();

// Reset Interfaces Instantiation
xgemac_rst_interface tx_rx_rst_n(.clk(tx_rx_clk.clk));
xgemac_rst_interface wb_rst(.clk(wb_clk.clk));
xgemac_rst_interface xgmii_rst_n(.clk(xgmii_clk.clk));

// TX PKT Interface Instantiation
xgemac_tx_interface tx_intf(.clk(tx_rx_clk.clk), .rst(tx_rx_rst_n.rst));

// RX PKT Interface Instantiation
xgemac_rx_interface rx_intf(.clk(tx_rx_clk.clk), .rst(tx_rx_rst_n.rst));

// XGMII Interface Instantiation
xgemac_tx_rx_xgmii_interface xgmii_intf(.clk(xgmii_clk.clk), .rst(xgmii_rst_n.rst));


// Wishbone Interface Instantiation
xgemac_wb_interface wb_intf(.clk(wb_clk.clk), .rst(wb_rst.rst));

// DUT Instantiation
xge_mac DUT(.clk_156m25(tx_rx_clk.clk),
            .reset_156m25_n(tx_rx_rst_n.rst),
            .pkt_tx_data(tx_intf.pkt_tx_data),
            .pkt_tx_val(tx_intf.pkt_tx_val),
            .pkt_tx_sop(tx_intf.pkt_tx_sop),
            .pkt_tx_eop(tx_intf.pkt_tx_eop),
            .pkt_tx_mod(tx_intf.pkt_tx_mod),
            .pkt_tx_full(tx_intf.pkt_tx_full),
            .pkt_rx_ren(rx_intf.pkt_rx_ren),
            .pkt_rx_avail(rx_intf.pkt_rx_avail),
            .pkt_rx_data(rx_intf.pkt_rx_data),
            .pkt_rx_sop(rx_intf.pkt_rx_sop),
            .pkt_rx_eop(rx_intf.pkt_rx_eop),
            .pkt_rx_val(rx_intf.pkt_rx_val),
            .pkt_rx_mod(rx_intf.pkt_rx_mod),
            .pkt_rx_err(rx_intf.pkt_rx_err),
            .wb_clk_i(wb_clk.clk),
            .wb_rst_i(wb_rst.rst),
            .wb_adr_i(wb_intf.wb_adr_i),
            .wb_cyc_i(wb_intf.wb_cyc_i),
            .wb_dat_i(wb_intf.wb_dat_i),
            .wb_stb_i(wb_intf.wb_stb_i),
            .wb_we_i(wb_intf.wb_we_i),
            .wb_ack_o(wb_intf.wb_ack_o),
            .wb_dat_o(wb_intf.wb_dat_o),
            .wb_int_o(wb_intf.wb_int_o),
            .clk_xgmii_tx(xgmii_clk.clk),
            .clk_xgmii_rx(xgmii_clk.clk),
            .reset_xgmii_tx_n(xgmii_rst_n.rst),
            .reset_xgmii_rx_n(xgmii_rst_n.rst),
            .xgmii_txd(xgmii_intf.xgmii_txrxd),
            .xgmii_txc(xgmii_intf.xgmii_txrxc),
            .xgmii_rxd(xgmii_intf.xgmii_txrxd),
            .xgmii_rxc(xgmii_intf.xgmii_txrxc)
);

// Testbench Code Instantiation
xgemac_test_top TB(.tx_rx_clk(tx_rx_clk),
                   .wb_clk(wb_clk),
                   .xgmii_clk(xgmii_clk),
                   .tx_rx_rst_n(tx_rx_rst_n),
                   .wb_rst(wb_rst),
                   .xgmii_rst_n(xgmii_rst_n),
                   .tx_intf(tx_intf),
                   .rx_intf(rx_intf),
                   .wb_intf(wb_intf),
                   .xgmii_intf(xgmii_intf)
                    );


endmodule: tb_top
