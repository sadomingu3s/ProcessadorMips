module PC (
input [31:0] address,
input clk,
input reset,
input load, //flag
input inc, //flag
output reg [31:0] current_address
);

always@(negedge clk) begin
if(reset) begin
current_address <= 0;
end
else if(load) begin
current_address <= address; //jump
end
 else begin
current_address <= current_address; // fica na msm instrução
end
end



endmodule