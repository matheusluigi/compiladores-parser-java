/* scanner.flex — Roteiro 1: Local, Bloco e Precedência */

import java_cup.runtime.*;

%%

%class Scanner
%unicode
%cup
%line
%column

%%

/* Ignorar espaços e quebras de linha */
[ \t\r\n]+  { /* ignorar */ }

/* Números (inteiros e decimais) */
[0-9]+(\.[0-9]+)?  { return new Symbol(sym.NUMBER, Double.parseDouble(yytext())); }

/* Operadores aritméticos */
"+"  { return new Symbol(sym.PLUS); }
"-"  { return new Symbol(sym.MINUS); }
"*"  { return new Symbol(sym.MULT); }
"/"  { return new Symbol(sym.DIV); }
"%"  { return new Symbol(sym.MOD); }   // Atividade 2: operador MOD

/* Parênteses */
"("  { return new Symbol(sym.ABRE_PARENT); }
")"  { return new Symbol(sym.FECHA_PARENT); }

/* Ponto e vírgula */
";"  { return new Symbol(sym.PTVIRG); }

/* Fim de arquivo */
<<EOF>>  { return new Symbol(sym.EOF); }

/* Erro léxico */
.  { System.err.println("Erro léxico: caractere desconhecido '" + yytext() + "'"); }
