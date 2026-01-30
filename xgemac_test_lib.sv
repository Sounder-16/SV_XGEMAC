class xgemac_base_test;
   xgemac_tb_config   h_cfg;
   xgemac_environment h_env;
   bit timeout;
   string REPORT_TAG;
   // Base Test Constructor
   function new(xgemac_tb_config h_cfg);
      this.h_cfg = h_cfg;
      REPORT_TAG = "BASE_TEST";
   endfunction: new
   
   // Base Test Build Method
   function void build();
      $display("%s Build", REPORT_TAG);

      set_test_specific_configuration();
      if(h_cfg.has_env) begin
        h_env = new(.h_cfg(h_cfg));
        h_env.build();
      end
    endfunction: build

   // Base Test Connect Method
   function void connect();
      $display("%s Connect", REPORT_TAG);
      if(h_cfg.has_env) begin
        h_env.connect();
      end
   endfunction: connect

   // Base Test Run Method
   virtual task run();
      $display("%s Run", REPORT_TAG);
      if(h_cfg.has_env) begin
        h_env.run();
        give_stimulus();
        $display("Stimulus completed at %0tns", $time/1000);
        wait_for_finish();
      end
   endtask: run

   // Set Test Specific Configuration Method
   virtual function void set_test_specific_configuration();
      $display("%s: Inside Set Test Specific Config", REPORT_TAG);
    endfunction: set_test_specific_configuration

   // Give stimulus Method
   virtual task give_stimulus();
      $display("%s: Inside Give Stimulus", REPORT_TAG);
    
   endtask
    
   // Wait for Finish
   task wait_for_finish();
     process p[2];
     fork
        begin
          p[0] = process::self();
          wait(h_cfg.act_count > 7 && h_cfg.trans_count <= h_cfg.act_count);
        end
        begin
          p[1] = process::self();
          #(`TIMEOUT *1ns);
          $error("Trans_count(%0d) & Actual Count(%0d) doesn't match. TIMEOUT!!!", h_cfg.trans_count, h_cfg.act_count);
        end
     join_any
     timeout = 'b1;
     foreach (p[i]) begin
       if(p[i] != null) p[i].kill();
     end
     timeout = 1;
   endtask

   // Base Test Report Method
   function void report();
      $display("%s Report", REPORT_TAG);
      if(h_cfg.has_env) begin
        h_env.report();
      end
   endfunction: report
    
endclass: xgemac_base_test

class xgemac_direct_test extends xgemac_base_test;
  
  // Direct Test Constructor
  function new(xgemac_tb_config h_cfg);
    super.new(.h_cfg(h_cfg));
    REPORT_TAG = "DIRECTED_TEST";
  endfunction: new

  // Set Test Specific Configuration
  function void set_test_specific_configuration();
    $display("%s: set_test_specific_configuration", REPORT_TAG);
    h_cfg.trans_count = 10;
  endfunction: set_test_specific_configuration

  // Give Stimulus Method
  task give_stimulus();
    $display("%s: give_stimulus", REPORT_TAG);
      h_env.h_tx_gen.gen_and_send_directed_stimulus();
    
  endtask

endclass: xgemac_direct_test

class xgemac_incremental_test extends xgemac_base_test;

  function new(xgemac_tb_config h_cfg);
    super.new(h_cfg);
    REPORT_TAG = "INCREMENTAL TEST";
  endfunction: new

  function void set_test_specific_configuration();
    $display("%s: Set test Specific Configuration", REPORT_TAG);
    h_cfg.trans_count = 25;
  endfunction: set_test_specific_configuration

  task give_stimulus();
    $display("%s: Give Stimulus", REPORT_TAG);
    h_env.h_tx_gen.gen_and_send_incremental_stimulus();
  endtask: give_stimulus

endclass: xgemac_incremental_test

class xgemac_random_test extends xgemac_base_test;
  
  function new(xgemac_tb_config h_cfg);
    super.new(h_cfg);
    REPORT_TAG = "RANDOM TEST";
  endfunction: new

  function void set_test_specific_configuration();
    $display("%s: Set test specific Configuration", REPORT_TAG);
    h_cfg.ren_delay.rand_mode(0);
    if(!h_cfg.randomize()) begin
      $display("TB Config Not Randomized");
    end
  endfunction: set_test_specific_configuration

  task give_stimulus();
    $display("%s: Give Stimulus", REPORT_TAG);
    h_env.h_tx_gen.gen_and_send_random_stimulus();
  endtask: give_stimulus

endclass: xgemac_random_test

class xgemac_wb_test extends xgemac_base_test;
  function new(xgemac_tb_config h_cfg);
    super.new(h_cfg);
    REPORT_TAG = "WISHBONE TEST";
  endfunction: new
  function void set_test_specific_configuration();
    $display("%s: set test specific configuration", REPORT_TAG);
    h_cfg.trans_count = 25;
  endfunction: set_test_specific_configuration
  
  task give_stimulus();
    $display("%s: give stimulus", REPORT_TAG);
    h_env.h_tx_gen.gen_and_send_incremental_stimulus();
  endtask: give_stimulus

  task run();
    super.run();
    if(timeout) begin
      h_env.h_wb_gen.check_transaction_count();
      #40ns;
    end
  endtask: run
endclass: xgemac_wb_test

class xgemac_reset_test extends xgemac_base_test;
  function new(xgemac_tb_config h_cfg);
    super.new(h_cfg);
    REPORT_TAG = "RESET TEST";
  endfunction: new

  function void set_test_specific_configuration();
      $display("%s: Inside set test specific configuration", REPORT_TAG);
      h_cfg.trans_count = 10;
  endfunction: set_test_specific_configuration

  task give_stimulus();
    $display("%s: Inside Give Stimulus", REPORT_TAG);
    h_env.h_tx_gen.gen_and_send_reset_stimulus();
  endtask: give_stimulus

endclass: xgemac_reset_test

class xgemac_padding_test extends xgemac_base_test;

  function new(xgemac_tb_config h_cfg);
    super.new(h_cfg);
    REPORT_TAG = "PADDING TEST";
  endfunction: new
  function void set_test_specific_configuration();
      $display("%s: Inside set test specific configuration", REPORT_TAG);
      h_cfg.trans_count = 2;
  endfunction: set_test_specific_configuration

  task give_stimulus();
    $display("%s: Inside Give Stimulus", REPORT_TAG);
    h_env.h_tx_gen.gen_and_send_padding_stimulus();
  endtask: give_stimulus

  
endclass: xgemac_padding_test
