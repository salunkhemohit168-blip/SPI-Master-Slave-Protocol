`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.07.2026 16:36:41
// Design Name: 
// Module Name: spi_slave
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module spi_slave #(
    parameter TX_DATA = 8'h3C
)
(
    input wire rst,
    input wire sclk,
    input wire cs,
    input wire mosi,

    output reg miso,
    output reg [7:0] rx_data
);

reg [7:0] tx_shift;
reg [7:0] rx_shift;
reg [2:0] bit_count;

always @(posedge sclk or posedge rst)
begin

    if(rst)
    begin
        tx_shift <= TX_DATA;
        rx_shift <= 8'h00;
        rx_data <= 8'h00;
        miso <= 1'b0;
        bit_count <= 3'd0;
    end

    else if(!cs)
    begin

        // Transmit MSB
        miso <= tx_shift[7];

        // Shift transmit register
        tx_shift <= {tx_shift[6:0],1'b0};

        // Shift received bit
        rx_shift <= {rx_shift[6:0],mosi};

        bit_count <= bit_count + 1'b1;

        // Store received byte after 8 bits
        if(bit_count == 3'd7)
        begin
            rx_data <= {rx_shift[6:0],mosi};

            // Reload transmit register for next transfer
            tx_shift <= TX_DATA;

            bit_count <= 3'd0;
        end

    end

end

endmodule
