//Declare an interface "router_io"
//Declare a clocking block driven by posedge of signal clock
//Add all signals required to connect test program to the DUT
//All directions must be with respect to test program
//Add input and output skew in clocking block(optional)



//Create a modport to connect to test program
//Arguments should list clocking block and all other potential asynch signals



interface router_io(input bit clock);

	logic reset_n;
	logic [15:0] dout, valido_n, busy_n, frameo_n, din, frame_n, valid_n;

	clocking cb @(posedge clock);
		input dout, valido_n, busy_n, frameo_n;
		output reset_n;
		output din, frame_n, valid_n;
	endclocking: cb

	modport TB (clocking cb, output reset_n);

endinterface

