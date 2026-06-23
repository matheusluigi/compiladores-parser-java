package scanner;
import java_cup.runtime.Symbol;
import parser.sym;
import erros.ListaErros;
%%
%class Scanner
%cupsym sym
%cup
%unicode
%line
%column
%public
%eofval{ return criaSimbolo(sym.EOF); %eofval}
%{
  private ListaErros listaErros;
  public Scanner(java.io.FileReader in, ListaErros le) { this(in); this.listaErros=le; }
  public ListaErros getListaErros() { return listaErros; }
  public void defineErro(int l,int c,String t){ listaErros.defineErro(l,c,t); }
  public void defineErro(int l,int c){ listaErros.defineErro(l,c); }
  public void defineErro(String t){ listaErros.defineErro(t); }
  private Symbol criaSimbolo(int code,Object value){ return new Symbol(code,yyline,yycolumn,value); }
  private Symbol criaSimbolo(int code){ return new Symbol(code,yyline,yycolumn,null); }
%}
FimDeLinha=\r|\n|\r\n
Espaco={FimDeLinha}|[ \t]
Inteiro=0|[1-9][0-9]*
OpMaiorIgual=">=" OpMenorIgual="<=" OpIgualIgual="==" OpDiferente="!="
OpMaior=">" OpMenor="<"
OpMais="+" OpMenos="-" OpMult="*" OpDiv="/" PtoVirg=";"
KwIf="if" KwElse="else" abrePar="(" fechaPar=")" abreChave="{" fechaChave="}"
%%
{Espaco}       { /* despreza */ }
{Inteiro}      { return criaSimbolo(sym.NUMBER,Double.parseDouble(yytext())); }
{OpMais}       { return criaSimbolo(sym.MAIS); }
{OpMenos}      { return criaSimbolo(sym.MENOS); }
{OpMult}       { return criaSimbolo(sym.MULT); }
{OpDiv}        { return criaSimbolo(sym.DIV); }
{PtoVirg}      { return criaSimbolo(sym.PTVIRG); }
{OpMaior}      { return criaSimbolo(sym.MAIOR); }
{OpMenor}      { return criaSimbolo(sym.MENOR); }
{OpMaiorIgual} { return criaSimbolo(sym.MAIORIGUAL); }
{OpMenorIgual} { return criaSimbolo(sym.MENORIGUAL); }
{OpIgualIgual} { return criaSimbolo(sym.IGUALIGUAL); }
{OpDiferente}  { return criaSimbolo(sym.DIF); }
{KwIf}         { return criaSimbolo(sym.KW_IF); }
{KwElse}       { return criaSimbolo(sym.KW_ELSE); }
{abrePar}      { return criaSimbolo(sym.ABREPAR); }
{fechaPar}     { return criaSimbolo(sym.FECHAPAR); }
{abreChave}    { return criaSimbolo(sym.ABRECHAVE); }
{fechaChave}   { return criaSimbolo(sym.FECHACHAVE); }
[^] { this.defineErro(yyline,yycolumn,"Lexico - Simbolo desconhecido:"+yytext()); }
