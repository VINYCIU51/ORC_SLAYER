# Orc Slayer 

**Orc Slayer** é um jogo 2D de ação e aventura desenvolvido como parte da disciplina de **Engenharia de Software II**. O jogo foi criado utilizando a engine **Godot** e conta a história de um cavaleiro corajoso que foi encarregado de resgatar uma princesa sequestrada por criaturas malignas.  

O jogador deve enfrentar diversos desafios, derrotar monstros e superar obstáculos para avançar nos níveis e, finalmente, salvar a princesa.  


## Estrutura 

```plaintext

 Orc_slayer
 ├── assets/                # Sprites utilizados
 ├── constructors/          # Scenes utilitárias para definiçao de tipo dos inimigos (atirador, perseguidor etc)
 ├── fonts/                 # Fontes utilizadas nos diálogos e menus
 ├── scenes/
 │      ├── Enemies/        # Scenes de inimigos
 │      ├── Player/         # scene do player
 │      ├── Others/         # Scenes de utilitátios como camera, areas de queda etc
 │      ├── Interface/      # Scenes dos menus e interface do player
 │      ├── projectiles/    # Scenes dos projeteis como flechas e bolas de fogo
 │      ├── NPC/            # Scenes dos npcs do mapa de turotial
 │      └── worlds/         # Scenes dos mapas
 │
 ├── scripts/               # Scripts de todos os elementos do jogo
 ├── sounds/                # Pasta contendo todos os sons (inimigos, player, músicas)
 └── project.godot          # Arquivo principal para uso na godot

 ```

 ## Como Usar

1. Clone o repositório em sua máquina local:
   ```bash
   git clone https://github.com/VINYCIU51/ORC_SLAYER.git
2. Execute a godot e clique em **F5** ou no atalho no canto superior direito para executar o projeto.
3. clique em **Iniciar** e comece a jogar


## Tecnologias Utilizadas  

- **Engine**: Godot (versão 4.4.1)  
- **Linguagem**: GDScript  
- **Design**: Pixel Art

## Licença

Este projeto é de código aberto e está disponível para reutilização e modificação sob a licença [MIT](https://opensource.org/licenses/MIT).