# Compiladores — Roteiros 1 a 10

Projeto gerado a partir das respostas das atividades (Prof.ª Alessandra Hauck — CEUB).

## Estrutura

```
compilador/
├── roteiro1/          # Local, Bloco e Precedência
│   ├── scanner.flex   # Analisador léxico (JFlex)
│   ├── parser.cup     # Analisador sintático (CUP) — com MOD (Ativ. 2)
│   ├── Main.java      # Ponto de entrada — leitura por arquivo (Ativ. 4)
│   └── teste.txt      # Casos de teste
├── roteiro2/          # IDENT e Designator
│   ├── scanner.flex
│   ├── parser.cup     # Regra designator com erro semântico (Ativ. 2 e 3)
│   ├── Main.java
│   └── teste.txt
├── roteiro3/          # Declaração de Variável
│   ├── scanner.flex   # Inclui keyword "program" e vírgula
│   ├── parser.cup     # Regras varDecl, varDecl_op, type, program
│   ├── Main.java
│   └── teste.txt      # Exemplo da Verificação 6
├── roteiro5/          # Exemplos de gramática (.cup)
│   ├── Atividade1_Exemplo.cup
│   └── Atividade2_Exemplo.cup
├── roteiro6/          # Regra if (Atividades 1 e 2: true/false)
│   ├── linguagem.lex
│   ├── linguagem.cup
│   ├── Main.java
│   └── teste.txt
├── roteiro7/          # Regra if-else
│   ├── ex02.flex
│   ├── ex02.cup
│   ├── Main.java
│   ├── teste.txt
│   └── teste2.txt
├── roteiro8/          # while + for + do-while
│   ├── scanner.flex
│   ├── parser.cup
│   ├── Main.java
│   ├── teste_while.txt
│   ├── teste_for.txt
│   └── teste_dowhile.txt
├── roteiro9/          # Registro de Erros com Localização (linha/coluna)
│   ├── erros/         # Erro.java, ListaErros.java
│   ├── scanner/       # scanner.flex (package scanner)
│   ├── parser/        # parser.cup  (package parser)
│   ├── Main.java
│   ├── teste1.txt
│   └── teste2.txt
├── roteiro10/         # Tratamento de Erros (símbolo especial `error`)
│   ├── erros/         # Erro.java, ListaErros.java
│   ├── scanner/       # scanner.flex (package scanner)
│   ├── parser/        # parser.cup  (package parser, com `error` e syntax_error)
│   ├── Main.java
│   ├── teste1.txt
│   ├── teste2.txt
│   └── teste3.txt
└── compiladores_roteiros_6_a_10.sh   # Script que gera/compila/executa os roteiros 6 a 10
```

## Roteiros 6 a 10 (script automatizado)

Os roteiros 6 a 10 também podem ser gerados, compilados e executados pelo script
`compiladores_roteiros_6_a_10.sh` (instala dependências, roda JFlex + CUP, compila e executa):

```bash
bash compiladores_roteiros_6_a_10.sh        # menu interativo
bash compiladores_roteiros_6_a_10.sh 6      # executa apenas o roteiro 6
bash compiladores_roteiros_6_a_10.sh todos  # executa todos (6 a 10)
```

| Roteiro | Tema |
|---------|------|
| 6  | Regra `if` (Atividades 1 e 2: condições e `true`/`false`) |
| 7  | Regra `if-else` |
| 8  | `while` + `for` + `do-while` |
| 9  | Registro de Erros com Localização (linha/coluna) |
| 10 | Tratamento de Erros (símbolo especial `error` do CUP) |

## Como compilar e executar

### Pré-requisitos

- Java JDK 8+
- [JFlex](https://jflex.de/) (`jflex`)
- [CUP](http://www2.cs.tum.edu/projects/cup/) (`java_cup`)

### Passos (exemplo para o Roteiro 3)

```bash
cd roteiro3

# 1. Gerar o scanner a partir do .flex
jflex scanner.flex

# 2. Gerar o parser a partir do .cup
java java_cup.Main parser.cup

# 3. Compilar todos os .java gerados + Main.java
javac *.java

# 4. Executar
java Main
```

### Saída esperada (Roteiro 3 — Verificação 6)

```
Programa: p
Declaracao variavel: a
Declaracao variavel: vet
Declaracao variavel: b, x
= 3.0
= 5.0
Arquivo sem erros de sintaxe!
```

## Pontos-chave

| # | Ponto |
|---|-------|
| 1 | `IDENT` deve vir **após** todas as keywords no `scanner.flex` |
| 2 | O **vazio** em `varDecl_op` é essencial para permitir declaração de variável única |
| 3 | Recursão à **esquerda** em `term` produz associatividade matematicamente correta para `/` e `-` |
| 4 | `.cup` e `.flex` devem estar sempre coerentes (cada terminal declarado precisa de regra) |
| 5 | Dentro dos blocos `{: :}` pode-se escrever qualquer código Java |
| 6 | Índice negativo em vetor é erro **semântico** (sintaxe está correta) |

## Recursividade: direita vs. esquerda

### À direita (original — Roteiro 1)

```
12 / 4 / 2  →  12 / (4 / 2)  →  12 / 2  =  6.0  ⚠ matematicamente incorreto
```

### À esquerda (Atividade 3b)

Altere `parser.cup`:

```cup
term ::= term:t MULT factor:f  {: RESULT = t * f; :}
       | term:t DIV  factor:f  {: RESULT = t / f; :}
       | term:t MOD  factor:f  {: RESULT = t % f; :}
       | factor:f              {: RESULT = f.doubleValue(); :}
       ;
```

```
12 / 4 / 2  →  (12 / 4) / 2  →  3 / 2  =  1.5  ✓ matematicamente correto
```
