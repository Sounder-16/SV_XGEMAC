class xgemac_clk_driver#(type t =int, t CLOCK_PERIOD, type vif_t = int);
    vif_t vif;
    string REPORT_TAG;
    // Clock Driver Constructor
    function new(vif_t vif);
        this.vif = vif;
        REPORT_TAG = "Clock Driver";
    endfunction: new
   
    // Clock Driver Build Method
    function void build();
      $display("%s: Build", REPORT_TAG);

    endfunction: build

    // Clock Driver Connect Method
    function void connect();
      $display("%s Connect", REPORT_TAG);

    endfunction: connect

    // Clock Driver Run Method
    task run();
        $display("%s: Run", REPORT_TAG);
        vif.clk = 0;
        forever begin
            #(CLOCK_PERIOD/2);
            vif.clk = ~vif.clk;
        end
    endtask: run

    // Clock Driver Report Method
    function void report();
      $display("%s: Report", REPORT_TAG);
    endfunction: report

endclass: xgemac_clk_driver

