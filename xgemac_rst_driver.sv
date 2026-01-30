class xgemac_rst_driver#(RESET_PERIOD, rst_t rst, type vif_t, bit monitor_reset=0);
    vif_t         vif;
    mailbox#(bit) rst_mbx;
    string REPORT_TAG;
    // Reset Driver Constructor
    function new(vif_t vif);
        this.vif = vif;
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
        bit get_reset;
        $display("%s: Run", REPORT_TAG);
        vif.rst = rst;
        @(posedge vif.clk);
        vif.rst = ~rst;
        repeat(RESET_PERIOD) @(posedge vif.clk);
        vif.rst = rst;
        if(monitor_reset) begin
          forever begin
            rst_mbx.get(get_reset);
            drive_into_pins(get_reset);
          end
        end
    endtask: run
    
    // Drives the value into VIF
    task drive_into_pins(bit value);
      vif.rst = !value;
    endtask: drive_into_pins

    // Reset Driver Report Method
    function void report();
      $display("%s: Report", REPORT_TAG);

    endfunction: report

endclass
