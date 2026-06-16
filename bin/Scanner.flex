/* ============================================================
   Scanner.flex  -  Analisador Lexico da linguagem Java--
   Disciplina: Compiladores  -  Trabalho: Parser (JFlex + JCup)
   Gera: Scanner.java  (comando: jflex.bat Scanner.flex)
   ============================================================ */

import java_cup.runtime.Symbol;

%%

/* -------- Diretivas / Opcoes do JFlex -------- */
%class Scanner          /* nome da classe gerada -> Scanner.java          */
%unicode                /* suporte a Unicode                              */
%cup                    /* integracao com o JCup (retorna java_cup.Symbol)*/
%line                   /* habilita contagem de linhas  (yyline)          */
%column                 /* habilita contagem de colunas (yycolumn)        */
%public                 /* construtor publico (evita erros de acesso)     */

%{
    /* Metodos auxiliares: criam o Symbol ja com linha e coluna (base 1).
       O canal de comunicacao entre Scanner e Parser e a classe "sym",
       gerada pelo JCup. Os nomes dos terminais DEVEM ser identicos. */
    private Symbol symbol(int tipo) {
        return new Symbol(tipo, yyline + 1, yycolumn + 1);
    }
    private Symbol symbol(int tipo, Object valor) {
        return new Symbol(tipo, yyline + 1, yycolumn + 1, valor);
    }
%}

/* -------- Macros (Expressoes Regulares) -------- */
digito          = [0-9]
letra           = [a-zA-Z_]
ident           = {letra}({letra}|{digito})*
inteiro         = {digito}+
real            = {digito}+"."{digito}+
fimDeLinha      = \r|\n|\r\n
espaco          = {fimDeLinha} | [ \t\f]
comentarioBloco = "/*" ~"*/"
comentarioLinha = "//" [^\r\n]*

%%

/* ============================================================
   REGRAS (Expressoes Regulares  ->  Acoes)
   ============================================================ */

/* ---- Palavras reservadas ---- */
"program"   { return symbol(sym.PROGRAM); }
"if"        { return symbol(sym.IF); }
"else"      { return symbol(sym.ELSE); }
"while"     { return symbol(sym.WHILE); }
"int"       { return symbol(sym.INT); }
"float"     { return symbol(sym.FLOAT); }

/* ---- Operadores relacionais (os de 2 caracteres ANTES dos de 1) ---- */
"=="        { return symbol(sym.IGUAL); }
"!="        { return symbol(sym.DIFER); }
">="        { return symbol(sym.MAIORIG); }
"<="        { return symbol(sym.MENORIG); }
">"         { return symbol(sym.MAIOR); }
"<"         { return symbol(sym.MENOR); }

/* ---- Operador de atribuicao ---- */
"="         { return symbol(sym.ATRIB); }

/* ---- Operadores aritmeticos ---- */
"+"         { return symbol(sym.MAIS); }
"-"         { return symbol(sym.MENOS); }
"*"         { return symbol(sym.MULT); }
"/"         { return symbol(sym.DIV); }
"%"         { return symbol(sym.MOD); }

/* ---- Delimitadores ---- */
"("         { return symbol(sym.ABREPAR); }
")"         { return symbol(sym.FECHAPAR); }
"{"         { return symbol(sym.ABRECHAVE); }
"}"         { return symbol(sym.FECHACHAVE); }
"["         { return symbol(sym.ABRECOL); }
"]"         { return symbol(sym.FECHACOL); }
";"         { return symbol(sym.PTVIRG); }
","         { return symbol(sym.VIRG); }

/* ---- Numeros (REAL antes de INTEIRO por causa do ponto) ----
   Ambos sao devolvidos como Double, pois no Parser.cup os terminais
   INTEIRO e REAL sao do tipo Double (permite calcular as expressoes). */
{real}      { return symbol(sym.REAL,    Double.valueOf(yytext())); }
{inteiro}   { return symbol(sym.INTEIRO, Double.valueOf(yytext())); }

/* ---- Identificadores ---- */
{ident}     { return symbol(sym.ID, yytext()); }

/* ---- Itens ignorados: espacos em branco e comentarios ---- */
{espaco}            { /* despreza */ }
{comentarioBloco}   { /* despreza  (comentario de multiplas linhas) */ }
{comentarioLinha}   { /* despreza */ }

/* ---- Qualquer outro caractere e invalido ---- */
[^]         { System.err.println("ERRO LEXICO: caractere invalido '" + yytext()
                  + "' na linha " + (yyline + 1) + ", coluna " + (yycolumn + 1)); }
