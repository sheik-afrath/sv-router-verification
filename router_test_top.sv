//Declare the top level harness module
module top();


//Initialize the required signals
 bit clock = 0;


//Include the Clock generation
 always #5 clock = ~clock;


//Add an interface instance
  router_io i_rtr_io(clock);


//Instantiate the test program and make the I/O connection via interface modport
  router_test test(i_rtr_io);


//Instantiate the DUT and make the I/O connection via interface
 router dut (.reset_n(i_rtr_io.reset_n), .clock(i_rtr_io.clock), .frame_n(i_rtr_io.frame_n), .valid_n(i_rtr_io.valid_n), .din(i_rtr_io.din), .dout(i_rtr_io.dout), .busy_n(i_rtr_io.busy_n), .valido_n(i_rtr_io.valido_n), .frameo_n(i_rtr_io.frameo_n));


endmodule
