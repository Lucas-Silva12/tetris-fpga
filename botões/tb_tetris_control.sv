
`timescale 1ns/1ps

module tb_tetris_control;

    logic clk = 1'b0;
    logic reset = 1'b1;
    logic [3:0] KEY = 4'b1111;

    logic move_left;
    logic move_right;
    logic move_down;
    logic rotate;

    integer left_count = 0;
    integer right_count = 0;
    integer down_count = 0;
    integer rotate_count = 0;

    // Clock de 50 MHz: periodo de 20 ns
    always #10 clk = ~clk;

    tetris_control_bridge #(
        .DEBOUNCE_CYCLES(4)
    ) dut (
        .clk(clk),
        .reset(reset),
        .KEY(KEY),
        .move_left(move_left),
        .move_right(move_right),
        .move_down(move_down),
        .rotate(rotate)
    );

    // Conta os pulsos de cada comando
    always @(posedge clk) begin
        if (move_left)  left_count  = left_count + 1;
        if (move_right) right_count = right_count + 1;
        if (move_down)  down_count  = down_count + 1;
        if (rotate)     rotate_count = rotate_count + 1;
    end

    task automatic wait_cycles(input integer n);
        repeat (n) @(negedge clk);
    endtask

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_tetris_control);

        // Inicializacao
        wait_cycles(3);
        reset = 1'b0;
        wait_cycles(3);

        // Teste 1: ruido curto em KEY[0]
        KEY[0] = 1'b0;
        wait_cycles(2);
        KEY[0] = 1'b1;
        wait_cycles(6);

        if (left_count != 0)
            $fatal(1, "Falha: ruido gerou movimento");

        // Teste 2: pressionamento real de KEY[0]
        KEY[0] = 1'b0;
        wait_cycles(8);

        if (left_count != 1)
            $fatal(1, "Falha: esquerda nao gerou um pulso");

        // Segurar nao deve repetir o comando
        wait_cycles(10);

        if (left_count != 1)
            $fatal(1, "Falha: comando repetido ao segurar");

        // Soltar e pressionar novamente
        KEY[0] = 1'b1;
        wait_cycles(8);
        KEY[0] = 1'b0;
        wait_cycles(8);

        if (left_count != 2)
            $fatal(1, "Falha: segundo clique nao reconhecido");

        // Teste dos demais botoes
        KEY[0] = 1'b1;
        wait_cycles(8);

        KEY[1] = 1'b0;
        wait_cycles(8);
        KEY[1] = 1'b1;
        wait_cycles(8);

        KEY[2] = 1'b0;
        wait_cycles(8);
        KEY[2] = 1'b1;
        wait_cycles(8);

        KEY[3] = 1'b0;
        wait_cycles(8);
        KEY[3] = 1'b1;
        wait_cycles(8);

        if (right_count != 1 ||
            rotate_count != 1 ||
            down_count != 1)
            $fatal(1, "Falha: comandos incorretos");

        $display("PASSOU: todos os testes do controlador.");
        $finish;
    end

endmodule
