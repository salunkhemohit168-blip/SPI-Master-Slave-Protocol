`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.07.2026 16:34:16
// Design Name: 
// Module Name: spi_master
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


module spi_master(

    input clk,
    input rst,
    input start,

    input [1:0] slave_select,
    input [7:0] data_in,

    input miso,

    output reg mosi,
    output reg sclk,

    output reg cs0,
    output reg cs1,
    output reg cs2,

    output reg done,
    output reg [7:0] data_out

);

reg [7:0] tx_reg;
reg [7:0] rx_reg;
reg [2:0] bit_cnt;

parameter IDLE     = 2'b00;
parameter TRANSFER = 2'b01;
parameter FINISH   = 2'b10;

reg [1:0] state;

always @(posedge clk or posedge rst)
begin

    if(rst)
    begin

        state <= IDLE;

        cs0 <= 1;
        cs1 <= 1;
        cs2 <= 1;

        sclk <= 0;
        done <= 0;

        tx_reg <= 0;
        rx_reg <= 0;

        bit_cnt <= 0;

        mosi <= 0;
        data_out <= 0;

    end

    else
    begin

        case(state)

        //---------------------------------
        IDLE:
        //---------------------------------
        begin

            done <= 0;
            sclk <= 0;

            cs0 <= 1;
            cs1 <= 1;
            cs2 <= 1;

            if(start)
            begin

                tx_reg <= data_in;
                bit_cnt <= 7;

                case(slave_select)

                    2'b00: cs0 <= 0;
                    2'b01: cs1 <= 0;
                    2'b10: cs2 <= 0;

                endcase

                state <= TRANSFER;

            end

        end

        //---------------------------------
        TRANSFER:
        //---------------------------------

        begin

            sclk <= ~sclk;

            if(sclk==0)
            begin

                mosi <= tx_reg[7];
                tx_reg <= {tx_reg[6:0],1'b0};

            end

            else
            begin

                rx_reg <= {rx_reg[6:0],miso};

                if(bit_cnt==0)
                begin

                    data_out <= {rx_reg[6:0],miso};

                    state <= FINISH;

                end

                else

                    bit_cnt <= bit_cnt-1;

            end

        end

        //---------------------------------
        FINISH:
        //---------------------------------

        begin

            cs0 <= 1;
            cs1 <= 1;
            cs2 <= 1;

            sclk <= 0;

            done <= 1;

            state <= IDLE;

        end

        endcase

    end

end

endmodule   
