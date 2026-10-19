// geometria dos sete tetrominos em matrizes 4x4.
// shape[15-(4*y+x)] representa a celula local (x,y).
// As rotacoes usam a matriz 4x4 inteira (MVP simplificado).
module tetromino (
    input  logic [2:0]  piece_type,
    input  logic [1:0]  rotation,
    output logic [15:0] shape
);
    logic [15:0] base_shape;

    function automatic logic [15:0] rotate_cw(input logic [15:0] original);
        logic [15:0] result;
        result = '0;
        for (int y = 0; y < 4; y++) begin
            for (int x = 0; x < 4; x++) begin
                result[15-(y*4+x)] = original[15-((3-x)*4+y)];
            end
        end
        return result;
    endfunction

    always_comb begin
        case (piece_type)
            3'd0: base_shape = 16'b0000_1111_0000_0000; // I
            3'd1: base_shape = 16'b0110_0110_0000_0000; // O
            3'd2: base_shape = 16'b0100_1110_0000_0000; // T
            3'd3: base_shape = 16'b0110_1100_0000_0000; // S
            3'd4: base_shape = 16'b1100_0110_0000_0000; // Z
            3'd5: base_shape = 16'b1000_1110_0000_0000; // J
            3'd6: base_shape = 16'b0010_1110_0000_0000; // L
            default: base_shape = 16'b0000_0000_0000_0000;
        endcase
    end

    always_comb begin
        case (rotation)
            2'd0: shape = base_shape;
            2'd1: shape = (piece_type == 3'd1) ? base_shape : rotate_cw(base_shape);
            2'd2: shape = (piece_type == 3'd1) ? base_shape : rotate_cw(rotate_cw(base_shape));
            2'd3: shape = (piece_type == 3'd1) ? base_shape : rotate_cw(rotate_cw(rotate_cw(base_shape)));
            default: shape = base_shape;
        endcase
    end
endmodule
