# 🎮 [Nome do Jogo]

Agarre-se

## 🛠️ Tecnologias

* **Lua**
* **LÖVE 2D**

## ▶️ Como executar

### 1. Instale o LÖVE

Baixe e instale a versão do LÖVE compatível com o seu sistema operacional:

[Download do LÖVE 2D](https://love2d.org/)

### 2. Clone ou baixe o projeto

```bash
git clone <URL_DO_REPOSITORIO>
cd <PASTA_DO_PROJETO>
```

Ou simplesmente baixe o projeto como `.zip` e extraia os arquivos.

### 3. Execute o jogo

Existem algumas formas de executar um projeto LÖVE.

#### Windows

Arraste a pasta do projeto para o executável do LÖVE (`love.exe`).

Ou, pelo terminal:

```bash
love .
```

#### Linux / macOS

No terminal, dentro da pasta do projeto:

```bash
love .
```

O LÖVE irá procurar o arquivo `main.lua` e iniciar o jogo.

## 📁 Estrutura básica

A estrutura do projeto segue a organização padrão de um jogo desenvolvido com LÖVE
O arquivo `main.lua` funciona como ponto de entrada da aplicação

## 🎮 Controles

| Tecla          | Ação            |
| -------------- | --------------- |
| `WASD` / Setas | Movimento       |
| `P`            | Pause           |
| `Esc`          | Voltar / Pausar |
| ...            | ...             |

> Os controles podem variar de acordo com a versão do jogo.

## 📦 Criando uma versão executável

O LÖVE também permite distribuir o jogo como um arquivo `.love` ou criar uma versão executável para diferentes plataformas.

Para criar um arquivo `.love`, compacte os arquivos do projeto em um `.zip` e altere sua extensão para:

```text
jogo.love
```

Depois, o arquivo pode ser executado com:

```bash
love jogo.love
```

## 📝 Desenvolvimento

Um jogo desenvolvido em **Lua** utilizando o framework **LÖVE (Love2D)**, para a semana criativa **Criathlon Méliès 2026**.

Muito foi desenvolvido levando em base os repositórios abaixo:

https://github.com/Przemekkkth/love-pacman/tree/main
https://github.com/challacade/legend-of-lua

Libs utilizadas = {
    - astar
    - anim8
    - binocles
    - bump
    - classic
    - tesound
    - timer
}

---

**Desenvolvido com Lua + LÖVE 2D.**
