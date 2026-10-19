// Etapa 5: verifica se TODOS os quatro blocos de uma matriz 4x4
// cabem no tabuleiro e nao coincidem com blocos ja fixados.
// board_data[y*10+x] = 1 indica celula ocupada.
module collision (
    input  logic [15:0] shape,
    input  logic signed [5:0] candidate_x,
    input  logic signed [5:0] candidate_y,
    input  logic [199:0] board_data,
    output logic valid_position,
    output logic hits_wall,
    output logic hits_block
);
    always_comb begin : detect_collision
        integer abs_x, abs_y;
        hits_wall  = 1'b0;
        hits_block = 1'b0;
        for (int y = 0; y < 4; y++) begin
            for (int x = 0; x < 4; x++) begin
                if (shape[15-(4*y+x)]) begin
                    abs_x = $signed(candidate_x) + x;
                    abs_y = $signed(candidate_y) + y;
                    if (abs_x < 0 || abs_x >= 10 ||
                        abs_y < 0 || abs_y >= 20) begin
                        hits_wall = 1'b1;
                    end else if (board_data[abs_y*10+abs_x]) begin
                        hits_block = 1'b1;
                    end
                end
            end
        end
        valid_position = !hits_wall && !hits_block;
    end
endmodule

