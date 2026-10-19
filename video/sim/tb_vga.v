`timescale 1ns/1ps

module tb_vga;
    reg CLOCK_50 = 0;
    reg [0:0] KEY = 0;
    wire [3:0] R, G, B;
    wire HS, VS;

    vga_top dut (.CLOCK_50(CLOCK_50), .KEY(KEY),
                 .VGA_R(R), .VGA_G(G), .VGA_B(B),
                 .VGA_HS(HS), .VGA_VS(VS));

    always #10 CLOCK_50 = ~CLOCK_50;           

    integer f, count;
    initial begin
        f = $fopen("frame.ppm", "w");
        $fwrite(f, "P3\n640 480\n255\n");
        count = 0;
        #100 KEY = 1;                          
    end

    always @(posedge CLOCK_50) begin
        if (KEY[0] && dut.pix_en && dut.video_on) begin
            $fwrite(f, "%0d %0d %0d\n", R*17, G*17, B*17);
            count = count + 1;
            if (count == 640*480) begin
                $fclose(f);
                $display("Quadro gravado.");
                $finish;
            end
        end
    end

    time t_ult = 0;
    always @(negedge VS) begin
        if (t_ult != 0) $display("Periodo do quadro: %0d ns", $time - t_ult);
        t_ult = $time;
    end
endmodule