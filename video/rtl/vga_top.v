module vga_top (
    input  wire       CLOCK_50,
    input  wire [0:0] KEY,          
    output wire [3:0] VGA_R, VGA_G, VGA_B,
    output wire       VGA_HS, VGA_VS
);

    wire rst = ~KEY[0];
    wire pix_en, video_on, frame_tick;
    wire [9:0] x, y;

    vga_sync sync (.clk(CLOCK_50), .rst(rst), .pix_en(pix_en),
                   .hs(VGA_HS), .vs(VGA_VS), .video_on(video_on),
                   .x(x), .y(y), .frame_tick(frame_tick));

    wire border = (x == 0) || (x == 639) || (y == 0) || (y == 479);
    reg [11:0] rgb;
    always @* begin
        if (border) rgb = 12'hFFF;
        else case (x[8:6])
            3'd0: rgb = 12'hF00;
            3'd1: rgb = 12'h0F0;
            3'd2: rgb = 12'h00F;
            3'd3: rgb = 12'hFF0;
            3'd4: rgb = 12'h0FF;
            3'd5: rgb = 12'hF0F;
            3'd6: rgb = 12'h888;
            default: rgb = 12'hFFF;
        endcase
    end

    assign VGA_R = video_on ? rgb[11:8] : 4'd0;
    assign VGA_G = video_on ? rgb[7:4]  : 4'd0;
    assign VGA_B = video_on ? rgb[3:0]  : 4'd0;
endmodule