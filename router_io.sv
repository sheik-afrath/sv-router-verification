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

