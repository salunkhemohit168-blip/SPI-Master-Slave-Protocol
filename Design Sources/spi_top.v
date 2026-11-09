`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.07.2026 16:41:00
// Design Name: 
// Module Name: spi_top
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

module spi_top(

    input clk,
    input rst,
    input start,

    input [1:0] slave_select,
    input [7:0] data_in,

    output [7:0] data_out,
    output done

);

// SPI Signals
wire mosi;
wire miso;
wire sclk;

wire cs0;
wire cs1;
wire cs2;

// Slave outputs
wire miso1;
wire miso2;
wire miso3;

wire [7:0] rx_data1;
wire [7:0] rx_data2;
wire [7:0] rx_data3;

//--------------------------------------------
// MISO Multiplexer
//--------------------------------------------
assign miso =
       (!cs0) ? miso1 :
       (!cs1) ? miso2 :
       (!cs2) ? miso3 :
       1'b0;

//--------------------------------------------
// SPI Master
//--------------------------------------------
spi_master master(

    .clk(clk),
    .rst(rst),
    .start(start),

    .slave_select(slave_select),
    .data_in(data_in),

    .miso(miso),

    .mosi(mosi),
    .sclk(sclk),

    .cs0(cs0),
    .cs1(cs1),
    .cs2(cs2),

    .done(done),
    .data_out(data_out)

);

//--------------------------------------------
// Slave 1
//--------------------------------------------
spi_slave #(
    .TX_DATA(8'h3C)
)
slave1(

    .rst(rst),
    .sclk(sclk),
    .cs(cs0),
    .mosi(mosi),

    .miso(miso1),
    .rx_data(rx_data1)

);

//--------------------------------------------
// Slave 2
//--------------------------------------------
spi_slave #(
    .TX_DATA(8'hA7)
)
slave2(

    .rst(rst),
    .sclk(sclk),
    .cs(cs1),
    .mosi(mosi),

    .miso(miso2),
    .rx_data(rx_data2)

);

//--------------------------------------------
// Slave 3
//--------------------------------------------
spi_slave #(
    .TX_DATA(8'hF5)
)
slave3(

    .rst(rst),
    .sclk(sclk),
    .cs(cs2),
    .mosi(mosi),

    .miso(miso3),
    .rx_data(rx_data3)

);

endmodule