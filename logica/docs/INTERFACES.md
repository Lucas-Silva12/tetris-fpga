# Interface e convenios

- Tabuleiro: 10 colunas x 20 linhas; `board_data[y*10+x]` = 1 para celula fixa.
- Peca: `shape[15-(4*y_local+x_local)]` dentro da matriz 4x4.
- `piece_type`: I=0, O=1, T=2, S=3, Z=4, J=5, L=6, NONE=7.
- `piece_rotation`: 0,1,2,3. Rotacao no sentido horario ao redor da matriz 4x4;
  peca O mantem o mesmo formato em qualquer orientacao.
- `piece_x`, `piece_y`: origem da matriz 4x4, signed 6 bits.
- `movement` reseta para x=3, y=0, rotation=0. `piece_type` vem da FSM futura.
- Comandos: pulsos de um ciclo de clock, sincronizados; prioridade esquerda > direita > baixo > rotacao.
- `command_accepted`: fica alto durante comando valido, ANTES da borda que atualiza estado.
- `blocked_down`: alto se um comando de descida prioritario colide; nao e armazenado.
- Nao ha protocolo de escrita de tabuleiro nesta versao.
- Politica atual: nao permitir blocos com y<0 na criacao ou rotacao.
- Nao existe wall kick: rotacao que colide simplesmente nao ocorre.

`collision` recebe a matriz do **candidato**, nao a matriz anterior.
Nao acesse `board_data` sem primeiro checar se `abs_x`/`abs_y` estao dentro dos limites.

- `board_in` e o tabuleiro de 200 bits apos a fixacao.
- `board_out` e o tabuleiro compactado, com zeros no topo.
- `lines_cleared[4:0]` conta todas as linhas completas de entrada.
- Bloco combinacional; o controlador decide quando gravar a saida.
- `lock_clear_demo` registra limpeza apenas se a fixacao for valida.
