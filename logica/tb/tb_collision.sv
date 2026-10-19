`timescale 1ns/1ps
module tb_collision;
    logic [15:0] shape = 16'b0110_0110_0000_0000; // O
    logic signed [5:0] candidate_x, candidate_y;
    logic [199:0] board_data = '0;
    logic valid_position, hits_wall, hits_block;
    collision dut (.*);

    initial begin
        candidate_x = 3; candidate_y = 0; #1;
        if (!valid_position) $fatal(1,"Posicao inicial deveria ser valida");
        candidate_x = -2; #1;
        if (valid_position || !hits_wall) $fatal(1,"Falha parede esquerda");
        candidate_x = 8; #1;
        if (valid_position || !hits_wall) $fatal(1,"Falha parede direita");
        candidate_x = 3; candidate_y = 19; #1;
        if (valid_position || !hits_wall) $fatal(1,"Falha limite inferior");
        candidate_y = 0;
        board_data[1*10+4] = 1'b1; #1;
        if (valid_position || !hits_block) $fatal(1,"Falha bloco ocupado");
        board_data = '0; #1;
        if (!valid_position) $fatal(1,"Falha ao liberar bloco");
        $display("PASS: tb_collision");
        $finish;
    end
endmodule
