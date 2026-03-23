module tt_um_cells(
        input wire [7:0] ui_in,
        output wire [7:0] uo_out,
        input wire [7:0] uio_in,
        output wire [7:0] uio_out,
        output wire [7:0] uio_oe,
        input wire ena,
        input wire clk,
        input wire rst
)
    assign uio_out[6:0] = 7'b0000000;
    assign uio_oe = 8'b10000000;

    cells cells(.clk(clk), .rst(rst), speaker(uio_out[0]))
