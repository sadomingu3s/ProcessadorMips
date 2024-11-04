module registerOUT (
    input  [31:0] data_in,
    output [31:0] data_out,

    input  clk,
    input  load,
    input  reset
);
  reg [31:0] current_value;

  always @(posedge clk) begin
    if (reset) begin
      current_value <= 32'b0;
    end else if (load) begin
      current_value <= data_in;
    end else begin
      current_value <= current_value;
    end
  end

  assign data_out = current_value;

endmodule