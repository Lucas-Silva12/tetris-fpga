module vga_sync (
    input  wire       clk,        
    input  wire       rst,
    output wire       pix_en,     
    output wire       hs,
    output wire       vs,
    output wire       video_on,
    output wire [9:0] x,          
    output wire [9:0] y,          
    output wire       frame_tick  
);

    localparam H_VIS = 640, H_FP = 16, H_SYNC = 96, H_TOT = 800;
    localparam V_VIS = 480, V_FP = 10, V_SYNC = 2,  V_TOT = 525;

    reg tog;
    always @(posedge clk)
        if (rst) tog <= 1'b0; else tog <= ~tog;
    assign pix_en = tog;

    reg [9:0] h, v;
    always @(posedge clk) begin
        if (rst) begin
            h <= 10'd0; v <= 10'd0;
        end else if (pix_en) begin
            if (h == H_TOT-1) begin
                h <= 10'd0;
                v <= (v == V_TOT-1) ? 10'd0 : v + 10'd1;
            end else
                h <= h + 10'd1;
        end
    end

    assign hs = ~((h >= H_VIS+H_FP) && (h < H_VIS+H_FP+H_SYNC));
    assign vs = ~((v >= V_VIS+V_FP) && (v < V_VIS+V_FP+V_SYNC));
    assign video_on   = (h < H_VIS) && (v < V_VIS);
    assign x = h;
    assign y = v;
    assign frame_tick = pix_en && (h == H_VIS) && (v == V_VIS);
endmodule