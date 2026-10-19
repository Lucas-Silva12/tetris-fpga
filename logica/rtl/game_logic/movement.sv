// controle da peca ativa.
// Recebe comandos em pulsos de um clock, ja sincronizados e debounced.
// Prioridade provisoria: esquerda > direita > baixo > rotacao.
// Rotacao simplificada, sem wall kicks.
// Nao fixa pecas nem remove linhas.
module movement (
    input  logic clk,
    input  logic reset,
    input  logic move_left,
    input  logic move_right,
    input  logic move_down,
    input  logic rotate,
    input  logic [2:0] piece_type,
    input  logic [199:0] board_data,
    output logic signed [5:0] piece_x,
    output logic signed [5:0] piece_y,
    output logic [1:0] piece_rotation,
    output logic [15:0] piece_shape,
    output logic command_accepted,
    output logic blocked_down
);
    logic signed [5:0] candidate_x, candidate_y;
    logic [1:0] candidate_rotation;
    logic [15:0] candidate_shape;
    logic valid_position;
    logic hits_wall, hits_block;
    logic command_present;

    tetromino current_piece (
        .piece_type(piece_type),
        .rotation(piece_rotation),
        .shape(piece_shape)
    );

    tetromino proposed_piece (
        .piece_type(piece_type),
        .rotation(candidate_rotation),
        .shape(candidate_shape)
    );

    always_comb begin
        candidate_x = piece_x;
        candidate_y = piece_y;
        candidate_rotation = piece_rotation;
        command_present = move_left || move_right || move_down || rotate;
        if (move_left)
            candidate_x = piece_x - 6'sd1;
        else if (move_right)
            candidate_x = piece_x + 6'sd1;
        else if (move_down)
            candidate_y = piece_y + 6'sd1;
        else if (rotate)
            candidate_rotation = piece_rotation + 2'd1;
    end

    collision validate_candidate (
        .shape(candidate_shape),
        .candidate_x(candidate_x),
        .candidate_y(candidate_y),
        .board_data(board_data),
        .valid_position(valid_position),
        .hits_wall(hits_wall),
        .hits_block(hits_block)
    );

    assign command_accepted = !reset && command_present && valid_position;
    // Indica falha na descida apenas quando a descida foi o comando escolhido.
    assign blocked_down = !reset && !move_left && !move_right && move_down && !valid_position;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            piece_x <= 6'sd3;
            piece_y <= 6'sd0;
            piece_rotation <= 2'd0;
        end else if (command_accepted) begin
            piece_x <= candidate_x;
            piece_y <= candidate_y;
            piece_rotation <= candidate_rotation;
        end
    end
endmodule
