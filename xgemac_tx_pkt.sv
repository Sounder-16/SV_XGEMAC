class xgemac_tx_pkt;

  rand bit [`XGEMAC_TXRX_DATA_WIDTH-1:0] pkt_tx_data;
  rand bit                               pkt_tx_sop;
  rand bit                               pkt_tx_eop;
  rand bit [`XGEMAC_TXRX_MOD_WIDTH-1:0]  pkt_tx_mod;
  int unsigned cur_frame_count;
  int unsigned total_count;
  int unsigned act_cnt;
  rand int unsigned trans_count_in_each_frame[];
  byte unsigned index;
  bit first_rand;
  bit eop_prev;
  constraint Frames {
    trans_count_in_each_frame.size() inside {[3:10]};
    foreach(trans_count_in_each_frame[i]) {
      trans_count_in_each_frame[i] >7; trans_count_in_each_frame[i] <=total_count;
    }
    trans_count_in_each_frame.sum() == total_count;
  }
  constraint SOP_EOP { (!first_rand) -> {pkt_tx_sop == 1; pkt_tx_eop == 0;}
                       (first_rand && act_cnt == cur_frame_count-1) -> {pkt_tx_eop == 1;}
                       (act_cnt != cur_frame_count-1) -> {pkt_tx_eop == 0;}
                       (pkt_tx_eop == 0) -> pkt_tx_mod == 0; 
                       (eop_prev == 1) -> {pkt_tx_eop == 0; pkt_tx_sop == 1; }
                       (first_rand && eop_prev == 0) -> {pkt_tx_sop == 0;}
                      }
  constraint MOD { !(pkt_tx_mod inside {[1:4]}); } // FIXIT

  function new(int total_count=0);
    this.total_count = total_count;
  endfunction: new
  
  function void pre_randomize();
    cur_frame_count = trans_count_in_each_frame[index];
  endfunction: pre_randomize

  function void post_randomize();
    if(!first_rand) trans_count_in_each_frame.rand_mode(0);
    act_cnt += 1;
    if(pkt_tx_eop) begin
      act_cnt = 0;
      index++;
    end
    first_rand = 1;
    eop_prev = pkt_tx_eop;
  endfunction: post_randomize

  // TX PKT Class Display Method
  function void display();
    $display("TX Packet Data : %h", pkt_tx_data);
    $display("TX Packet SOP  : %b", pkt_tx_sop);
    $display("TX Packet EOP  : %b", pkt_tx_eop);
    $display("TX Packet Mod  : %h", pkt_tx_mod);
  endfunction: display

  // TX PKT Clone Method
  function xgemac_tx_pkt clone();
    xgemac_tx_pkt h_pkt = new();
    h_pkt.copy(this);
    return h_pkt;
  endfunction: clone

  // TX PKT Copy Method
  function void copy(xgemac_tx_pkt h_pkt);
    this.pkt_tx_data = h_pkt.pkt_tx_data;
    this.pkt_tx_sop  = h_pkt.pkt_tx_sop;
    this.pkt_tx_eop  = h_pkt.pkt_tx_eop;
    this.pkt_tx_mod  = h_pkt.pkt_tx_mod;
  endfunction: copy

endclass: xgemac_tx_pkt
