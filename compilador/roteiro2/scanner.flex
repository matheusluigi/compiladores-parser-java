/* scanner.flex — Roteiro 2: IDENT e Designator */

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

/* Números */
[0-9]+(\.[0-9]+)?  { return new Symbol(sym.NUMBER, Double.parseDouble(yytext())); }

/* Identificadores (IDENT deve vir DEPOIS das keywords) */
[a-zA-Z_][a-zA-Z0-9_]*  { return new Symbol(sym.IDENT, yytext()); }

/* Operadores aritméticos */
"+"  { return new Symbol(sym.PLUS); }
"-"  { return new Symbol(sym.MINUS); }
"*"  { return new Symbol(sym.MULT); }
"/"  { return new Symbol(sym.DIV); }
"%"  { return new Symbol(sym.MOD); }

/* Delimitadores */
"("  { return new Symbol(sym.ABRE_PARENT); }
")"  { return new Symbol(sym.FECHA_PARENT); }
"["  { return new Symbol(sym.ABRE_COLCH); }
"]"  { return new Symbol(sym.FECHA_COLCH); }
"."  { return new Symbol(sym.PTO); }
";"  { return new Symbol(sym.PTVIRG); }

<<EOF>>  { return new Symbol(sym.EOF); }

.  { System.err.println("Erro léxico: '" + yytext() + "'"); }
