`timescale 1ns/1ps
module tb_tetromino;
    logic [2:0] piece_type;
    logic [1:0] rotation;
    logic [15:0] shape;
    tetromino dut (.piece_type(piece_type), .rotation(rotation), .shape(shape));

    initial begin
        for (int p = 0; p < 7; p++) begin
            for (int r = 0; r < 4; r++) begin
                piece_type = 3'(p);
                rotation = 2'(r);
                #10;
                assert ($countones(shape) == 4)
                    else $fatal(1, "Peca %0d rotacao %0d tem != 4 blocos", p, r);
                $display("Peca=%0d Rotacao=%0d Shape=%b", p, r, shape);
            end
        end
        piece_type = 3'd2;
        rotation = 2'd0;
        #10;
        assert (shape === 16'b0100_1110_0000_0000)
            else $fatal(1, "Orientacao inicial T incorreta");
        piece_type = 3'd7;
        #10;
        assert (shape === 16'b0)
            else $fatal(1, "PIECE_NONE deve ser vazio");
        $display("PASS: tb_tetromino");
        $finish;
    end
endmodule
