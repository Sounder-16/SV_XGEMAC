class xgemac_wb_pkt;
  rand bit [`XGEMAC_WB_ADDR_WIDTH-1:0] wb_adr_i;
  rand bit [`XGEMAC_WB_DATA_WIDTH-1:0] wb_dat_i;
  rand bit                             wb_we_i;
  bit [`XGEMAC_WB_DATA_WIDTH-1:0]      wb_dat_o;
  bit                                  wb_int_o; 

  // Wishbone PKT Value Display method
  function void display();

    $display("WB Packet Addr             : %h", wb_adr_i);
    $display("WB Packet Data In          : %h", wb_dat_i);
    $display("WB Packet Write Enable     : %h", wb_we_i);
    $display("WB Packet Data Out         : %h", wb_dat_o);
    $display("WB Packet Interrupt        : %h", wb_int_o);

  endfunction: display

  // Wishbone PKT Clone Method
  function xgemac_wb_pkt clone();
    xgemac_wb_pkt h_pkt = new();
    h_pkt.copy(this);
    return h_pkt;
  endfunction: clone

  // Wishbone PKT Copy Method
  function void copy(xgemac_wb_pkt h_pkt);
    this.wb_dat_i = h_pkt.wb_dat_i;
    this.wb_adr_i = h_pkt.wb_adr_i;
    this.wb_we_i  = h_pkt.wb_we_i;
    this.wb_dat_o = h_pkt.wb_dat_o;
    this.wb_int_o = h_pkt.wb_int_o;
  endfunction: copy

endclass: xgemac_wb_pkt
