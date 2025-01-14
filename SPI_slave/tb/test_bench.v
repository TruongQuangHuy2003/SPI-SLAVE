`timescale 1ns/1ps
module test_bench;
	reg clk;
	reg rst_n;
	reg mosi;
	reg sck;
	reg cs;
	wire miso;
	wire [7:0] data_out;

	slave dut(
		.clk(clk),
		.rst_n(rst_n),
		.mosi(mosi),
		.sck(sck),
		.cs(cs),
		.miso(miso),
		.data_out(data_out)
	);

	task verify;
		input [7:0] byte;
		integer i;
		begin
			for (i = 7; i >= 0; i = i - 1) begin
				mosi = byte[i];
				@(posedge clk); 
				sck = 1;
				@(posedge clk);
				sck = 0;
			end
			@(posedge clk);
			if (data_out == byte) begin
				$display("----------------------------------------------------------------------------------------------------------------");
				$display("PASSED: Expected data_out 8'h%h, Got data_out 8'h%h", byte, data_out);
				$display("----------------------------------------------------------------------------------------------------------------");
			end else begin
				$display("----------------------------------------------------------------------------------------------------------------");
				$display("FAILED: Expected data_out 8'h%h, Got data_out 8'h%h", byte, data_out);
				$display("----------------------------------------------------------------------------------------------------------------");
			end
		end
	endtask

	initial begin
		clk = 0;
		forever #5 clk = ~clk;
	end

	initial begin
		$dumpfile("test_bench.vcd");
		$dumpvars(0, test_bench);

		$display("---------------------------------------------------------------------------------------------------------------------");
		$display("---------------------------------------TESTBENCH FOR SPI SLAVE-------------------------------------------------------");
		$display("---------------------------------------------------------------------------------------------------------------------");

		rst_n = 0;
		mosi = 0;
		sck = 0;
		cs = 1;
		repeat (10) @(posedge clk);
		if (data_out == 8'h00) begin
			$display("----------------------------------------------------------------------------------------------------------------");
			$display("PASSED: Expected data_out 8'h%h, Got data_out 8'h%h", 8'h00, data_out);
			$display("----------------------------------------------------------------------------------------------------------------");
		end else begin
			$display("----------------------------------------------------------------------------------------------------------------");
			$display("FAILED: Expected data_out 8'h%h, Got data_out 8'h%h", 8'h00, data_out);
			$display("----------------------------------------------------------------------------------------------------------------");
		end

		rst_n = 1;
		cs = 0;
		@(posedge clk);
		verify(8'haa);

		@(posedge clk);
		verify(8'h33);

		@(posedge clk);
		verify(8'h0f);

		@(posedge clk);
		verify(8'hff);

		@(posedge clk);
		verify(8'h55);

		@(posedge clk);
		verify(8'h77);

		@(posedge clk);
		verify(8'hcc);

		@(posedge clk);
		verify(8'h11);

		@(posedge clk);
		verify(8'h99);

		@(posedge clk);
		verify(8'h66);

		@(posedge clk);
		verify(8'hff);

		#100;
		$finish;
	end
endmodule

