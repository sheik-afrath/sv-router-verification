//Declare a program block with arguments to connect
//to modport TB declared in interface
program router_test(router_io.TB rtr_io);

bit[3:0] sa; // source address (input port)
bit[3:0] da; // destination address (output port)
logic[7:0] payload[$]; // packet data array

//Define a System Verilog reset task to reset the DUT and to drive the frame_n, valid_n inputs of the DUT to 1 during reset
//After 2 clock cycles drive the reset input of the DUT to 1

	task reset();
	    rtr_io.reset_n = 1'b0;
	    rtr_io.cb.frame_n <= '1;
	    rtr_io.cb.valid_n <= '1;
	    repeat(2) @(rtr_io.cb);
	    rtr_io.cb.reset_n <= 1'b1;
	    repeat(15) @(rtr_io.cb);
	endtask: reset


	task gen(int n);
		sa = 3;
		da = 7;
		payload.delete();
		for (int i = 0; i<n; i++) begin
			payload.push_back($urandom_range(255));
		end
	endtask: gen


	task send();
		send_addrs();
		send_pad();
		send_payload();
	endtask: send


	task send_addrs();
		rtr_io.cb.frame_n[sa] <= 1;
		rtr_io.cb.valid_n[sa] <= 1;
		@(rtr_io.cb);
		rtr_io.cb.frame_n[sa] <= 0;
		for (int i = 0; i<4; i++) begin
			rtr_io.cb.din[sa] <= da[i];
			@(rtr_io.cb);
		end
	endtask: send_addrs


	task send_pad();
		rtr_io.cb.din[sa] <= 1;
		repeat(5) @(rtr_io.cb);
	endtask: send_pad


	task send_payload();
		rtr_io.cb.valid_n[sa] <= 0;
		for (int i = 0; i<payload.size(); i++) begin
			$display("BYTE %0d is: %0b", i, payload[i]);
			for (int j = 0; j<8; j++) begin
				rtr_io.cb.din[sa] <= payload[i][j];
				rtr_io.cb.valid_n[sa] <= 0;
				if (i == payload.size()-1 && j == 7) begin
					rtr_io.cb.frame_n[sa] <= 1;
				end
				$display("Bit %0d of byte %0d: %0b",j,i,payload[i][j]);
				@(rtr_io.cb);
				
			end
		end
		rtr_io.cb.valid_n[sa] <= 1;
		@(rtr_io.cb);
	endtask: send_payload

//Declare an initial block and invoke the reset task. Use appropriate display statements
	initial
	 begin
		reset();
		$display("Reset applied");
		gen(4);
		$display("Address and Data generated");
		send();
		$display("Data sent!");
		$stop;
	 end

endprogram

