module fifo(
    input clk, rst, rd, wr,
    input [7:0] din,
    output reg [7:0] dout,
    output full, empty
);

reg [7:0] mem [31:0];
reg [5:0] rdptr, wrptr;

always @(posedge clk) begin
    if (rst) begin
        dout  <= 0;
        rdptr <= 0;
        wrptr <= 0;
    end
    else begin
        case ({wr, rd})
            2'b01: begin // read
                if (!empty) begin
                    dout  <= mem[rdptr[4:0]];
                    rdptr <= rdptr + 1;
                end
            end
            2'b10: begin // write
                if (!full) begin
                    mem[wrptr[4:0]] <= din;
                    wrptr <= wrptr + 1;
                end
            end
            2'b11: begin // simultaneous read/write
                if (empty) begin
                    dout <= din; 
                end
                else begin
                    mem[wrptr[4:0]] <= din;
                    wrptr <= wrptr + 1;
                    dout  <= mem[rdptr[4:0]];
                    rdptr <= rdptr + 1;
                end
            end
        endcase
    end
end

assign empty = (rdptr == wrptr);
assign full  = (rdptr == {~wrptr[5], wrptr[4:0]});

endmodule
