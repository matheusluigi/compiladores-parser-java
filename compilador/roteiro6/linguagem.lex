import java_cup.runtime.*;

%%
%class Lexer
%unicode
%cup
%line
%column

%{
  private Symbol symbol(int type) { return new Symbol(type, yyline, yycolumn); }
  private Symbol symbol(int type, Object value) { return new Symbol(type, yyline, yycolumn, value); }
%}

Inteiro  = [0-9]+
Espaco   = [ \t\r\n]+
Comentario = "/*" [^*]* "*"+ ([^/*] [^*]* "*"+)* "/"

%%
"if"    { return symbol(sym.IF); }
"true"  { return symbol(sym.TRUE); }
"false" { return symbol(sym.FALSE); }
"=="    { return symbol(sym.EQ); }
"!="    { return symbol(sym.NEQ); }
">="    { return symbol(sym.GEQ); }
"<="    { return symbol(sym.LEQ); }
">"     { return symbol(sym.GT); }
"<"     { return symbol(sym.LT); }
"+"     { return symbol(sym.MAIS); }
"-"     { return symbol(sym.MENOS); }
"*"     { return symbol(sym.VEZES); }
"/"     { return symbol(sym.DIV); }
"("     { return symbol(sym.ABRE); }
")"     { return symbol(sym.FECHA); }
"{"     { return symbol(sym.ABRE_CHAVE); }
"}"     { return symbol(sym.FECHA_CHAVE); }
";"     { return symbol(sym.PONTO_VIRGULA); }
{Inteiro}      { return symbol(sym.NUMERO, Integer.parseInt(yytext())); }
{Espaco}       { /* ignora */ }
{Comentario}   { /* ignora */ }
[^] { System.err.println("Erro léxico: '" + yytext() + "' na linha " + (yyline+1)); }
