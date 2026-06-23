import java_cup.runtime.Symbol;
%%
%class Scanner
%cupsym sym
%cup
%unicode
%line
%column
%public

digito       = [0-9]
letra        = [a-zA-Z]
digitos      = [0-9]+
opRelacional = ">"|"<"|">="|"<="|"=="|"!="
ident        = {letra}({letra}|{digito})*
fimdeLinha   = \r|\n|\r\n
espaco       = {fimdeLinha} | [ \t\f]

%%
{digitos} { double aux=Double.parseDouble(yytext()); return new Symbol(sym.NUMBER,Double.valueOf(aux)); }
"if"    { return new Symbol(sym.KW_IF); }
"else"  { return new Symbol(sym.KW_ELSE); }
{opRelacional} { return new Symbol(sym.OP_RELACIONAL, yytext()); }
"+"  { return new Symbol(sym.MAIS); }
"-"  { return new Symbol(sym.MENOS); }
"/"  { return new Symbol(sym.DIV); }
"*"  { return new Symbol(sym.MULT); }
"%"  { return new Symbol(sym.MOD); }
";"  { return new Symbol(sym.PTVIRG); }
"("  { return new Symbol(sym.ABRE_PARENT); }
")"  { return new Symbol(sym.FECHA_PARENT); }
"{"  { return new Symbol(sym.ABRE_CHAVE); }
"}"  { return new Symbol(sym.FECHA_CHAVE); }
"["  { return new Symbol(sym.ABRE_COLCH); }
"]"  { return new Symbol(sym.FECHA_COLCH); }
"."  { return new Symbol(sym.PTO); }
{espaco} { /* Nao faz nada */ }
{ident} { return new Symbol(sym.IDENT, yytext()); }
[^] { return new Symbol(sym.EOF, yyline, yycolumn, yytext()); }
