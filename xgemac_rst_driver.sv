class xgemac_rst_driver#(RESET_PERIOD, rst_t rst, type vif_t);
    vif_t                    vif;
    mailbox#(xgemac_rst_pkt) rst_mbx;
    xgemac_rst_pkt           h_rst_pkt;
    string REPORT_TAG;
    // Reset Driver Constructor
    function new(vif_t vif);
        this.vif = vif;
        h_rst_pkt = new();
        REPORT_TAG = "Reset Driver";
    endfunction: new
    
    // Reset Driver Build Method
    function void build();
      $display("%s: Build", REPORT_TAG);

    endfunction: build

    // Reset Driver Connect Method
    function void connect();
      $display("%s: Connect", REPORT_TAG);

    endfunction: connect

    // Reset Driver Run Method
    task run();
        $display("%s: Run", REPORT_TAG);
        vif.rst = rst;
        @(posedge vif.clk);
        vif.rst = ~rst;
        repeat(h_rst_pkt.reset_period) @(posedge vif.clk);
        vif.rst = rst;
        rst_mbx.get(h_rst_pkt);
        run();
    endtask: run
  
    // Reset Driver Report Method
    function void report();
      $display("%s: Report", REPORT_TAG);

    endfunction: report

endclass
