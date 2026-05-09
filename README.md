# BST em Assembly RISC-V / BST in RISC-V Assembly

> GEX1213 — Organização de Computadores  
> Implementação de Árvore Binária de Busca (BST) em Assembly RISC-V

---

## 🇧🇷 Português

### Descrição

Este projeto implementa uma **Árvore Binária de Busca (BST)** em linguagem Assembly RISC-V, com alocação dinâmica de memória no heap via `sbrk`. O programa oferece um menu interativo com as operações principais da estrutura.

### Operações disponíveis

| Opção | Operação | Descrição |
|-------|----------|-----------|
| 1 | Inserir | Insere um valor na árvore (ignora duplicatas) |
| 2 | Remover | Remove um valor da árvore |
| 3 | Buscar | Busca um valor e exibe seu endereço de memória |
| 4 | Preorder | Imprime a árvore em pré-ordem (raiz → esq → dir) |
| 5 | Inorder | Imprime a árvore em ordem (esq → raiz → dir) |
| 6 | Postorder | Imprime a árvore em pós-ordem (esq → dir → raiz) |
| 7 | Árvore completa | Exibe a árvore em formato visual |
| 8 | Máximo | Exibe o maior valor da árvore |
| 9 | Mínimo | Exibe o menor valor da árvore |
| 0 | Sair | Encerra o programa |

### Arquivos

```
bst.asm     → módulo com todas as funções da BST
menu.asm    → programa principal com menu interativo
```

### Pré-requisitos

- **Java 8 ou superior** instalado
- Simulador **RARS** (RISC-V Assembler and Runtime Simulator)
  - Download: https://github.com/TheThirdOne/rars/releases

### Como executar

#### Via terminal

Em [nomeJar.jar]: coloque o nome do arquivo .jar que irá utilizar. Por ex: "rars1_6.jar"
```bash
java -jar [nomeJar.jar] menu.riscv bst.riscv
```

> ⚠️ Os dois arquivos devem estar na mesma pasta que o `rars.jar`.

#### Via interface gráfica

1. Abra o RARS
2. Vá em **File → Open** e selecione `menu.asm`
3. Clique em **Assemble** (F3)
4. Clique em **Go** (F5) para executar

### Observações

- A árvore é **zerada automaticamente** ao sair (opção 0)
- Valores duplicados são **ignorados silenciosamente** com aviso
- O símbolo `├──` e `└──` exige terminal com suporte a UTF-8. Caso apareçam caracteres estranhos, edite o `bst.asm` e descomente as linhas alternativas:
  ```asm
  #.P1: .asciz "|-- "
  #.P2: .asciz "`-- "
  ```

---

## 🇺🇸 English

### Description

This project implements a **Binary Search Tree (BST)** in RISC-V Assembly language, with dynamic heap memory allocation via `sbrk`. The program provides an interactive menu with the main operations of the data structure.

### Available operations

| Option | Operation | Description |
|--------|-----------|-------------|
| 1 | Insert | Inserts a value into the tree (ignores duplicates) |
| 2 | Delete | Removes a value from the tree |
| 3 | Search | Searches for a value and displays its memory address |
| 4 | Preorder | Prints the tree in pre-order (root → left → right) |
| 5 | Inorder | Prints the tree in order (left → root → right) |
| 6 | Postorder | Prints the tree in post-order (left → right → root) |
| 7 | Full tree | Displays the tree in visual format |
| 8 | Maximum | Displays the largest value in the tree |
| 9 | Minimum | Displays the smallest value in the tree |
| 0 | Exit | Terminates the program |

### Files

```
bst.asm     → module with all BST functions
menu.asm    → main program with interactive menu
```

### Requirements

- **Java 8 or higher** installed
- **RARS** simulator (RISC-V Assembler and Runtime Simulator)
  - Download: https://github.com/TheThirdOne/rars/releases

### How to run

#### Via terminal
In [jarName.jar]: put the file name of the .jar file. eg: "rars1_6.jar"
```bash
java -jar [jarName.jar] menu.riscv bst.riscv
```

> ⚠️ Both files must be in the same folder as `rars.jar`.

#### Via graphical interface

1. Open RARS
2. Go to **File → Open** and select `menu.asm`
3. Click **Assemble** (F3)
4. Click **Go** (F5) to run

### Notes

- The tree is **automatically cleared** on exit (option 0)
- Duplicate values are **silently ignored** with a warning message
- The `├──` and `└──` symbols require a UTF-8 capable terminal. If strange characters appear, edit `bst.asm` and uncomment the fallback lines:
  ```asm
  #.P1: .asciz "|-- "
  #.P2: .asciz "`-- "
  ```

---

## Estrutura do nó / Node structure

```
┌─────────┬─────────┬─────────┐
│  value  │  left   │  right  │
│ 4 bytes │ 4 bytes │ 4 bytes │
└─────────┴─────────┴─────────┘
  0(ptr)    4(ptr)    8(ptr)
```

Cada nó ocupa **12 bytes** alocados dinamicamente no heap via `sbrk` (syscall 9).  
Each node occupies **12 bytes** dynamically allocated on the heap via `sbrk` (syscall 9).

---

## Convenção de registradores / Register convention

| Registrador | Uso |
|-------------|-----|
| `s0` | Ponteiro para o root da árvore / Root pointer |
| `a0` | Endereço do nó atual / Current node address |
| `a1` | Valor a inserir/buscar/deletar / Value to insert/search/delete |