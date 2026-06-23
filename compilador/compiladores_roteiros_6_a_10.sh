#!/bin/bash
# ╔══════════════════════════════════════════════════════════════╗
# ║        COMPILADORES — TODOS OS ROTEIROS                     ║
# ║        Prof. Alessandra Hauck — CEUB                        ║
# ╠══════════════════════════════════════════════════════════════╣
# ║  Roteiro 6  — if (Atividades 1 e 2)                         ║
# ║  Roteiro 7  — if-else                                       ║
# ║  Roteiro 8  — while + for + do-while                        ║
# ║  Roteiro 9  — Registro de Erros com Localização             ║
# ║  Roteiro 10 — Tratamento de Erros (Especial error)          ║
# ╠══════════════════════════════════════════════════════════════╣
# ║  USO:                                                        ║
# ║    bash compiladores_todos_roteiros.sh        → menu         ║
# ║    bash compiladores_todos_roteiros.sh 6      → roteiro 6    ║
# ║    bash compiladores_todos_roteiros.sh todos  → todos        ║
# ╚══════════════════════════════════════════════════════════════╝

set -e

# ── Cores ─────────────────────────────────────────────────────
VERDE='\033[0;32m'
AZUL='\033[0;34m'
AMARELO='\033[1;33m'
CIANO='\033[0;36m'
RESET='\033[0m'

separador() {
  echo ""
  echo -e "${AMARELO}══════════════════════════════════════════════════════════════${RESET}"
  echo -e "${AMARELO}  $1${RESET}"
  echo -e "${AMARELO}══════════════════════════════════════════════════════════════${RESET}"
  echo ""
}

# ── Instalar dependências (uma vez) ───────────────────────────
instalar_deps() {
  echo -e "${CIANO}▶ Verificando dependências...${RESET}"
  for dep in "javac default-jdk" "jflex jflex" "cup cup"; do
    cmd=$(echo $dep | cut -d' ' -f1)
    pkg=$(echo $dep | cut -d' ' -f2)
    if ! command -v "$cmd" &>/dev/null; then
      echo "   Instalando $pkg..."
      sudo apt-get install -y "$pkg" 2>&1 | grep -E "(Instalando|already)" || true
    else
      echo -e "   ${VERDE}$cmd já instalado ✔${RESET}"
    fi
  done
}

CP="/usr/share/java/cup_runtime.jar:."

# ══════════════════════════════════════════════════════════════
# ROTEIRO 6 — if (Atividades 1 e 2: true/false)
# ══════════════════════════════════════════════════════════════
roteiro6() {
  separador "ROTEIRO 6 — Regra if + Atividades 1 e 2"

  mkdir -p rot6 && cd rot6

  cat > linguagem.lex << 'LEX'
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
LEX

  cat > linguagem.cup << 'CUP'
import java_cup.runtime.*;

terminal            IF, TRUE, FALSE;
terminal            EQ, NEQ, GEQ, LEQ, GT, LT;
terminal            MAIS, MENOS, VEZES, DIV;
terminal            ABRE, FECHA, ABRE_CHAVE, FECHA_CHAVE, PONTO_VIRGULA;
terminal Integer    NUMERO;

non terminal          programa;
non terminal          bloco;
non terminal          lista_cmd;
non terminal          comando;
non terminal          lista_stmt;
non terminal          stmt;
non terminal Boolean  condicao;
non terminal Integer  expr;

precedence left MAIS, MENOS;
precedence left VEZES, DIV;

start with programa;

programa   ::= lista_cmd ;
lista_cmd  ::= lista_cmd comando | comando ;

comando ::= IF ABRE condicao:c FECHA bloco
            {: if (!c) System.out.println("  [if falso — bloco nao executado]\n"); :}
          ;

bloco ::= ABRE_CHAVE lista_stmt FECHA_CHAVE
        | ABRE_CHAVE FECHA_CHAVE
        ;

lista_stmt ::= lista_stmt stmt | stmt ;

stmt ::= expr:e PONTO_VIRGULA
         {: System.out.println("  Resultado: " + e); :}
       ;

condicao ::= expr:e1 EQ  expr:e2  {: RESULT = (e1.equals(e2)); :}
           | expr:e1 NEQ expr:e2  {: RESULT = (!e1.equals(e2)); :}
           | expr:e1 GEQ expr:e2  {: RESULT = (e1 >= e2); :}
           | expr:e1 LEQ expr:e2  {: RESULT = (e1 <= e2); :}
           | expr:e1 GT  expr:e2  {: RESULT = (e1 > e2); :}
           | expr:e1 LT  expr:e2  {: RESULT = (e1 < e2); :}
           | TRUE                 {: RESULT = true; :}
           | FALSE                {: RESULT = false; :}
           ;

expr ::= expr:e1 MAIS  expr:e2  {: RESULT = e1 + e2; :}
       | expr:e1 MENOS expr:e2  {: RESULT = e1 - e2; :}
       | expr:e1 VEZES expr:e2  {: RESULT = e1 * e2; :}
       | expr:e1 DIV   expr:e2  {: RESULT = e1 / e2; :}
       | MENOS expr:e            {: RESULT = -e; :}
       | ABRE expr:e FECHA       {: RESULT = e; :}
       | NUMERO:n                {: RESULT = n; :}
       ;
CUP

  cat > Main.java << 'JAVA'
import java_cup.runtime.*;
import java.io.*;
class Main {
  public static void main(String[] args) throws Exception {
    String f = args.length > 0 ? args[0] : "teste.txt";
    Lexer lexer = new Lexer(new FileReader(f));
    parser p = new parser(lexer);
    try { p.parse(); System.out.println("\n=== Concluído sem erros. ===");
    } catch(Exception e) { System.err.println("Erro: " + e.getMessage()); }
  }
}
JAVA

  cat > teste.txt << 'TESTE'
/* ATIVIDADE 1 */
if(30 == 30){ 1 + 2; 3 - 2 * 4; (3 -2) * 4; -1 - 2 - 3; 12 / 4 / 2; }
if(30 != 30){ 1 + 2; 3 - 2 * 4; (3 -2) * 4; -1 - 2 - 3; 12 / 4 / 2; }
if(30 >= 90){ 1 + 2; 3 - 2 * 4; (3 -2) * 4; -1 - 2 - 3; 12 / 4 / 2; }
/* ATIVIDADE 2 */
if(true){  1 + 2; (3 -2) * 4; -1 + 4 / 2; }
if(false){ 1 + 2; (3 -2) * 4; -1 + 4 / 2; }
TESTE

  echo -e "${CIANO}   Gerando Scanner e Parser...${RESET}"
  jflex linguagem.lex 2>/dev/null
  cup linguagem.cup 2>/dev/null
  echo -e "${CIANO}   Compilando...${RESET}"
  javac -cp "$CP" Lexer.java parser.java sym.java Main.java

  echo -e "${VERDE}--- Saída ---${RESET}"
  java -cp "$CP" Main teste.txt
  cd ..
}

# ══════════════════════════════════════════════════════════════
# ROTEIRO 7 — if-else
# ══════════════════════════════════════════════════════════════
roteiro7() {
  separador "ROTEIRO 7 — Regra if-else"

  mkdir -p rot7 && cd rot7

  cat > ex02.flex << 'FLEX'
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
FLEX

  cat > ex02.cup << 'CUP'
import java_cup.runtime.*;
parser code {: boolean deveExecutarBloco = false; :}
terminal PTVIRG, PTO, MAIS, MENOS, DIV, MULT, MOD;
terminal ABRE_PARENT, FECHA_PARENT, ABRE_CHAVE, FECHA_CHAVE, ABRE_COLCH, FECHA_COLCH;
terminal KW_IF, KW_ELSE;
terminal String OP_RELACIONAL;
terminal Double NUMBER;
terminal String IDENT;

non terminal if, else, condicao;
non terminal expr_list, expr_ptv;
non terminal Double expr, term, factor, designator;

if ::= {: System.out.print("if("); :}
       KW_IF ABRE_PARENT condicao FECHA_PARENT
       ABRE_CHAVE {: System.out.println("){"); :}
       expr_list FECHA_CHAVE {: System.out.println("}"); :} else ;

else ::= {: parser.deveExecutarBloco = !parser.deveExecutarBloco; System.out.print("else{"); :}
         KW_ELSE ABRE_CHAVE expr_list FECHA_CHAVE {: System.out.println("}"); :}
       | /* vazio */ ;

condicao ::= expr:e1 OP_RELACIONAL:op expr:e2
             {: boolean r = switch(op){ case "<" -> e1<e2; case "<=" -> e1<=e2;
                case ">" -> e1>e2; case ">=" -> e1>=e2; case "==" -> e1==e2;
                case "!=" -> e1!=e2; default -> false; };
                parser.deveExecutarBloco=r; System.out.print(r); :} ;

expr_list ::= expr_list expr_ptv | expr_ptv ;
expr_ptv  ::= expr:e {: if(parser.deveExecutarBloco) System.out.println("= "+e); :} PTVIRG ;

expr ::= expr:e MAIS term:t {: RESULT=e+t; :} | expr:e MENOS term:t {: RESULT=e-t; :}
       | MENOS term:t {: RESULT=-t; :} | term:t {: RESULT=t.doubleValue(); :} ;
term ::= factor:f MULT term:t {: RESULT=f*t; :} | factor:f DIV term:t {: RESULT=f/t; :}
       | factor:f {: RESULT=f.doubleValue(); :} ;
factor ::= NUMBER:n {: RESULT=n.doubleValue(); :}
         | ABRE_PARENT expr:e FECHA_PARENT {: RESULT=e.doubleValue(); :}
         | designator:d {: RESULT=d.doubleValue(); :} ;
designator ::= designator:d ABRE_COLCH expr FECHA_COLCH {: RESULT=Double.valueOf(1.0); :}
             | designator:d PTO IDENT {: RESULT=Double.valueOf(1.0); :}
             | IDENT {: RESULT=Double.valueOf(1.0); :} ;
CUP

  cat > Main.java << 'JAVA'
import java.io.*;
class Main {
  public static void main(String[] args) throws Exception {
    String f = args.length > 0 ? args[0] : "teste.txt";
    Scanner sc = new Scanner(new FileReader(f));
    parser p = new parser(sc);
    try { p.parse(); System.out.println("Arquivo sem erros de sintaxe!");
    } catch(Exception e) { System.out.println("Erro de sintaxe: "+e); }
  }
}
JAVA

  cat > teste.txt << 'TESTE'
if(3 < 30){ 1 + 2; 3 - 2 * 4; (3-2) * 4; -1 - 2 - 3; 12 / 4 / 2; }else{ 1+4; }
TESTE

  cat > teste2.txt << 'TESTE2'
if(10 < 10){ 1 + 2; 3 - 2 * 4; }else{ 1+4; }
TESTE2

  echo -e "${CIANO}   Gerando Scanner e Parser...${RESET}"
  jflex ex02.flex 2>/dev/null
  cup ex02.cup 2>/dev/null
  echo -e "${CIANO}   Compilando...${RESET}"
  javac -cp "$CP" Scanner.java parser.java sym.java Main.java

  echo -e "${VERDE}--- Teste 1: if(3 < 30) TRUE ---${RESET}"
  java -cp "$CP" Main teste.txt
  echo -e "${VERDE}--- Teste 2: if(10 < 10) FALSE ---${RESET}"
  cp teste2.txt teste.txt && java -cp "$CP" Main
  cd ..
}

# ══════════════════════════════════════════════════════════════
# ROTEIRO 8 — while + for + do-while
# ══════════════════════════════════════════════════════════════
roteiro8() {
  separador "ROTEIRO 8 — while + for + do-while"

  mkdir -p rot8 && cd rot8

  cat > scanner.flex << 'FLEX'
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
Ident        = {letra}({letra}|{digito})*
fimdeLinha   = \r|\n|\r\n
espaco       = {fimdeLinha} | [ \t\f]

%%
{digitos} { double aux=Double.parseDouble(yytext()); return new Symbol(sym.NUMBER,Double.valueOf(aux)); }
"if"      { return new Symbol(sym.KW_IF); }
"else"    { return new Symbol(sym.KW_ELSE); }
"while"   { return new Symbol(sym.KW_WHILE); }
"for"     { return new Symbol(sym.KW_FOR); }
"do"      { return new Symbol(sym.KW_DO); }
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
","  { return new Symbol(sym.VIRG); }
"="  { return new Symbol(sym.IGUAL); }
{espaco} { /* despreza */ }
{Ident} { return new Symbol(sym.IDENT, yytext()); }
[^] { return new Symbol(sym.EOF, yyline, yycolumn, yytext()); }
FLEX

  cat > parser.cup << 'CUP'
import java_cup.runtime.*;
parser code {: boolean deveExecutarBloco = false; :}
terminal PTVIRG, PTO, MAIS, MENOS, DIV, MULT, MOD, IGUAL, VIRG;
terminal ABRE_PARENT, FECHA_PARENT, ABRE_CHAVE, FECHA_CHAVE, ABRE_COLCH, FECHA_COLCH;
terminal KW_IF, KW_ELSE, KW_WHILE, KW_FOR, KW_DO;
terminal String OP_RELACIONAL;
terminal Double NUMBER;
terminal String IDENT;

non terminal expr_list, expr_ptv, statement, statement_aux;
non terminal if, else, condicao, while, for, dowhile;
non terminal Double expr, term, factor, designator;

statement_aux ::= statement_aux statement | statement ;
statement ::= expr_ptv
  | designator:d IGUAL expr:e PTVIRG {: System.out.println("Atribuicao: "+e); :}
  | if | while | for | dowhile ;

if ::= {: System.out.print("if("); :}
       KW_IF ABRE_PARENT condicao FECHA_PARENT
       ABRE_CHAVE {: System.out.println("){"); :}
       expr_list FECHA_CHAVE {: System.out.println("}"); :} else ;

else ::= {: parser.deveExecutarBloco=!parser.deveExecutarBloco; System.out.print("else{"); :}
         KW_ELSE ABRE_CHAVE expr_list FECHA_CHAVE {: System.out.println("}"); :}
       | /* vazio */ ;

while ::= {: System.out.print("while("); :}
          KW_WHILE ABRE_PARENT condicao FECHA_PARENT
          ABRE_CHAVE {: System.out.println("){"); :}
          expr_list FECHA_CHAVE {: System.out.println("}"); :} ;

for ::= {: System.out.print("for("); :}
        KW_FOR ABRE_PARENT expr:i PTVIRG {: System.out.print(i+"; "); :}
        condicao PTVIRG expr:inc FECHA_PARENT
        ABRE_CHAVE {: System.out.println("){"); :}
        expr_list FECHA_CHAVE {: System.out.println("}"); :} ;

dowhile ::= {: System.out.println("do{"); parser.deveExecutarBloco=true; :}
            KW_DO ABRE_CHAVE expr_list FECHA_CHAVE
            {: System.out.print("}while("); :}
            KW_WHILE ABRE_PARENT condicao FECHA_PARENT PTVIRG
            {: System.out.println(");"); :} ;

condicao ::= expr:e1 OP_RELACIONAL:op expr:e2
  {: boolean r=switch(op){case "<"->e1<e2;case "<="->e1<=e2;case ">"->e1>e2;
     case ">="->e1>=e2;case "=="->e1==e2;case "!="->e1!=e2;default->false;};
     parser.deveExecutarBloco=r; System.out.print(r); :} ;

expr_list ::= expr_list expr_ptv | expr_ptv ;
expr_ptv  ::= expr:e {: if(parser.deveExecutarBloco) System.out.println("= "+e); :} PTVIRG ;

expr ::= expr:e MAIS term:t {: RESULT=e+t; :} | expr:e MENOS term:t {: RESULT=e-t; :}
       | MENOS term:t {: RESULT=-t; :} | term:t {: RESULT=t.doubleValue(); :} ;
term ::= factor:f MULT term:t {: RESULT=f*t; :} | factor:f DIV term:t {: RESULT=f/t; :}
       | factor:f {: RESULT=f.doubleValue(); :} ;
factor ::= NUMBER:n {: RESULT=n.doubleValue(); :}
         | ABRE_PARENT expr:e FECHA_PARENT {: RESULT=e.doubleValue(); :}
         | designator:d {: RESULT=d.doubleValue(); :} ;
designator ::= designator:d ABRE_COLCH expr FECHA_COLCH {: RESULT=Double.valueOf(1.0); :}
             | designator:d PTO IDENT {: RESULT=Double.valueOf(1.0); :}
             | IDENT {: RESULT=Double.valueOf(1.0); :} ;
CUP

  cat > Main.java << 'JAVA'
import java.io.*;
class Main {
  public static void main(String[] args) throws Exception {
    String f = args.length > 0 ? args[0] : "teste.txt";
    Scanner sc = new Scanner(new FileReader(f));
    parser p = new parser(sc);
    try { p.parse(); System.out.println("Arquivo sem erros de sintaxe!");
    } catch(Exception e) { System.out.println("Erro: "+e); }
  }
}
JAVA

  cat > teste_while.txt  << 'T1'
while(3 < 10){ 1 + 2; 3 / 2; }
T1
  cat > teste_for.txt    << 'T2'
for(1; 3 < 10; 1){ 2 + 3; }
T2
  cat > teste_dowhile.txt << 'T3'
do{ 1 + 2; 3 + 4; }while(10 < 3);
T3

  echo -e "${CIANO}   Gerando Scanner e Parser...${RESET}"
  jflex scanner.flex 2>/dev/null
  cup parser.cup 2>/dev/null
  echo -e "${CIANO}   Compilando...${RESET}"
  javac -cp "$CP" Scanner.java parser.java sym.java Main.java

  echo -e "${VERDE}--- while(3 < 10) TRUE ---${RESET}"
  cp teste_while.txt teste.txt && java -cp "$CP" Main
  echo -e "${VERDE}--- for(1; 3 < 10; 1) TRUE ---${RESET}"
  cp teste_for.txt teste.txt && java -cp "$CP" Main
  echo -e "${VERDE}--- do-while(10 < 3) executa 1x ---${RESET}"
  cp teste_dowhile.txt teste.txt && java -cp "$CP" Main
  cd ..
}

# ══════════════════════════════════════════════════════════════
# ROTEIRO 9 — Registro de Erros com Localização
# ══════════════════════════════════════════════════════════════
roteiro9() {
  separador "ROTEIRO 9 — Registro de Erros com Localização"

  mkdir -p rot9/erros rot9/scanner rot9/parser && cd rot9

  cat > erros/Erro.java << 'JAVA'
package erros;
public class Erro {
  private int linha, coluna;
  private String texto;
  public Erro() { this.linha=-1; this.coluna=-1; this.texto=""; }
  public Erro(int linha, int coluna, String texto) { this.linha=linha; this.coluna=coluna; this.texto=texto; }
  public Erro(int linha, int coluna) { this.linha=linha; this.coluna=coluna; this.texto=null; }
  public void imprime() {
    String aux="linha:"+this.linha+", coluna:"+this.coluna+", ";
    if(this.texto==null) aux+=" erro indefinido!"; else aux+=this.texto;
    System.out.println(aux);
  }
  public String getTexto() { return texto; }
  public void setTexto(String texto) { this.texto=texto; }
}
JAVA

  cat > erros/ListaErros.java << 'JAVA'
package erros;
import java.util.ArrayList;
import java.util.List;
public class ListaErros {
  private List<Erro> erros=null;
  public ListaErros() { this.erros=new ArrayList<Erro>(); }
  public void defineErro(int l, int c, String t) { erros.add(new Erro(l,c,t)); }
  public void defineErro(int l, int c) { erros.add(new Erro(l,c)); }
  public void defineErro(String t) {
    for(Erro e:erros){ if(e.getTexto()==null){ e.setTexto(t); return; } }
  }
  public void dump() { for(Erro e:erros) e.imprime(); }
  public boolean hasErros() { return erros.size()>0; }
}
JAVA

  cat > scanner/scanner.flex << 'FLEX'
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
FLEX

  cat > parser/parser.cup << 'CUP'
package parser;
import java_cup.runtime.*;
import erros.ListaErros;
parser code {:
  public void defineErro(int l,int c,String t){ scanner.Scanner sc=(scanner.Scanner)this.getScanner(); sc.defineErro(l,c,t); }
  public void defineErro(int l,int c){ scanner.Scanner sc=(scanner.Scanner)this.getScanner(); sc.defineErro(l,c); }
  public void defineErro(String t){ scanner.Scanner sc=(scanner.Scanner)this.getScanner(); sc.defineErro(t); }
:};
terminal MAIOR,MENOR,MAIORIGUAL,MENORIGUAL,IGUALIGUAL,DIF;
terminal PTVIRG,MAIS,MENOS,MULT,DIV,KW_IF,KW_ELSE,ABREPAR,FECHAPAR,ABRECHAVE,FECHACHAVE;
terminal Double NUMBER;
non terminal Double expr_list,expr_ptv,expr,factor,term,condicao,if;
non terminal else;
non terminal op_Relacional;

if ::= KW_IF ABREPAR condicao FECHAPAR ABRECHAVE expr_list FECHACHAVE else
     | KW_IF condicao:c {: parser.defineErro(cleft,cright,"IF sem parenteses "); :} ABRECHAVE expr_list FECHACHAVE else ;

else ::= KW_ELSE ABRECHAVE expr_list FECHACHAVE | /* vazio */ ;

condicao ::= expr op_Relacional expr ;
op_Relacional ::= MAIOR|MENOR|MAIORIGUAL|MENORIGUAL|IGUALIGUAL|DIF ;

expr_list ::= expr_list expr_ptv | expr_ptv ;
expr_ptv  ::= expr PTVIRG ;

expr ::= expr:e MAIS term:t {: RESULT=e+t; :} | expr:e MENOS term:t {: RESULT=e-t; :}
       | expr:e {: parser.defineErro(eleft,eright,"Expressao sem operador."); :} term:t {: RESULT=t; :}
       | MENOS term:t {: RESULT=-t; :} | term:t {: RESULT=t; :} ;
term ::= factor:f MULT term:t {: RESULT=f*t; :}
       | factor:f DIV term:t {: if(t==0){parser.defineErro(tleft,tright,"Divisao por zero.");} RESULT=f/t; :}
       | factor:f {: RESULT=f; :} ;
factor ::= NUMBER:n {: RESULT=n; :} | ABREPAR expr:e FECHAPAR {: RESULT=e; :} ;
CUP

  cat > Main.java << 'JAVA'
import java.io.*;
import erros.ListaErros;
public class Main {
  public static void main(String[] args) throws Exception {
    String f = args.length>0 ? args[0] : "teste.txt";
    FileReader in = new FileReader(f);
    ListaErros le = new ListaErros();
    scanner.Scanner sc = new scanner.Scanner(in,le);
    parser.parser p = new parser.parser(sc);
    p.parse();
    if(!le.hasErros()) System.out.println("Sintaxe Correta");
    else { System.out.println("Erros encontrados:"); le.dump(); }
  }
}
JAVA

  cat > teste1.txt << 'T1'
if (10 < 3) { 7+5-(5-2); 7-5+8/0; }else{ 1+2; }
T1
  cat > teste2.txt << 'T2'
if 10 < 3 { 7+5-(5-2); 7-5+8/0; }else{ 1+2; }
T2

  echo -e "${CIANO}   Gerando Scanner e Parser...${RESET}"
  jflex scanner/scanner.flex 2>/dev/null && mv Scanner.java scanner/
  cup -package parser parser/parser.cup 2>/dev/null && mv parser.java sym.java parser/
  echo -e "${CIANO}   Compilando...${RESET}"
  javac -cp "$CP" erros/Erro.java erros/ListaErros.java
  javac -cp "$CP" scanner/Scanner.java
  javac -cp "$CP" parser/sym.java parser/parser.java
  javac -cp "$CP" Main.java

  echo -e "${VERDE}--- Teste 1: if correto + divisão por zero ---${RESET}"
  cp teste1.txt teste.txt && java -cp "$CP" Main
  echo -e "${VERDE}--- Teste 2: IF sem parênteses ---${RESET}"
  cp teste2.txt teste.txt && java -cp "$CP" Main
  cd ..
}

# ══════════════════════════════════════════════════════════════
# ROTEIRO 10 — Tratamento de Erros (Especial error)
# ══════════════════════════════════════════════════════════════
roteiro10() {
  separador "ROTEIRO 10 — Tratamento de Erros (Especial error)"

  mkdir -p rot10/erros rot10/scanner rot10/parser && cd rot10

  # Erro.java e ListaErros.java — iguais ao Roteiro 9
  cat > erros/Erro.java << 'JAVA'
package erros;
public class Erro {
  private int linha, coluna;
  private String texto;
  public Erro() { this.linha=-1; this.coluna=-1; this.texto=""; }
  public Erro(int linha, int coluna, String texto) { this.linha=linha; this.coluna=coluna; this.texto=texto; }
  public Erro(int linha, int coluna) { this.linha=linha; this.coluna=coluna; this.texto=null; }
  public void imprime() {
    String aux="linha:"+this.linha+", coluna:"+this.coluna+", ";
    if(this.texto==null) aux+=" erro indefinido!"; else aux+=this.texto;
    System.out.println(aux);
  }
  public String getTexto() { return texto; }
  public void setTexto(String texto) { this.texto=texto; }
}
JAVA

  cat > erros/ListaErros.java << 'JAVA'
package erros;
import java.util.ArrayList;
import java.util.List;
public class ListaErros {
  private List<Erro> erros=null;
  public ListaErros() { this.erros=new ArrayList<Erro>(); }
  public void defineErro(int l,int c,String t){ erros.add(new Erro(l,c,t)); }
  public void defineErro(int l,int c){ erros.add(new Erro(l,c)); }
  public void defineErro(String t){ for(Erro e:erros){ if(e.getTexto()==null){ e.setTexto(t); return; } } }
  public void dump() { for(Erro e:erros) e.imprime(); }
  public boolean hasErros() { return erros.size()>0; }
}
JAVA

  cat > scanner/scanner.flex << 'FLEX'
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
  public Scanner(java.io.FileReader in,ListaErros le){ this(in); this.listaErros=le; }
  public ListaErros getListaErros(){ return listaErros; }
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
KwIf="if" KwElse="else" KwWhile="while" KwDo="do"
abrePar="(" fechaPar=")" abreChave="{" fechaChave="}"
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
{KwWhile}      { return criaSimbolo(sym.KW_WHILE); }
{KwDo}         { return criaSimbolo(sym.KW_DO); }
{abrePar}      { return criaSimbolo(sym.ABREPAR); }
{fechaPar}     { return criaSimbolo(sym.FECHAPAR); }
{abreChave}    { return criaSimbolo(sym.ABRECHAVE); }
{fechaChave}   { return criaSimbolo(sym.FECHACHAVE); }
[^] { this.defineErro(yyline,yycolumn,"Lexico - Simbolo desconhecido:"+yytext()); }
FLEX

  cat > parser/parser.cup << 'CUP'
package parser;
import java_cup.runtime.*;
import erros.ListaErros;

parser code {:
  public void syntax_error(Symbol s){ this.defineErro(s.left, s.right); }
  public void defineErro(int l,int c,String t){ scanner.Scanner sc=(scanner.Scanner)this.getScanner(); sc.defineErro(l,c,t); }
  public void defineErro(int l,int c){ scanner.Scanner sc=(scanner.Scanner)this.getScanner(); sc.defineErro(l,c); }
  public void defineErro(String t){ scanner.Scanner sc=(scanner.Scanner)this.getScanner(); sc.defineErro(t); }
:};

terminal MAIOR,MENOR,MAIORIGUAL,MENORIGUAL,IGUALIGUAL,DIF;
terminal PTVIRG,MAIS,MENOS,MULT,DIV,KW_IF,KW_ELSE,KW_WHILE,KW_DO,ABREPAR,FECHAPAR,ABRECHAVE,FECHACHAVE;
terminal Double NUMBER;

non terminal          programa,lista_stmt,stmt;
non terminal          if_stmt,else_stmt,while_stmt,dowhile_stmt;
non terminal          condicao,op_Relacional,expr_list,expr_ptv;
non terminal Double   expr,term,factor;

programa   ::= lista_stmt ;
lista_stmt ::= lista_stmt stmt | stmt ;
stmt       ::= if_stmt | while_stmt | dowhile_stmt | expr_ptv ;

if_stmt ::= KW_IF ABREPAR condicao FECHAPAR ABRECHAVE expr_list FECHACHAVE else_stmt
          | error {: parser.defineErro("IF incompleto "); :} ;

else_stmt ::= KW_ELSE ABRECHAVE expr_list FECHACHAVE | /* vazio */ ;

while_stmt ::= KW_WHILE ABREPAR condicao FECHAPAR ABRECHAVE expr_list FECHACHAVE
             | KW_WHILE error {: parser.defineErro("WHILE incompleto "); :} ;

dowhile_stmt ::= KW_DO ABRECHAVE expr_list FECHACHAVE KW_WHILE ABREPAR condicao FECHAPAR PTVIRG
               | KW_DO error {: parser.defineErro("DO-WHILE incompleto "); :} ;

condicao ::= expr op_Relacional expr
           | error {: parser.defineErro("condicao com erro - operador relacional ausente"); :} ;

op_Relacional ::= MAIOR|MENOR|MAIORIGUAL|MENORIGUAL|IGUALIGUAL|DIF
                | error {: parser.defineErro("Operador relacional desconhecido"); :} ;

expr_list ::= expr_list expr_ptv | expr_ptv ;
expr_ptv  ::= expr PTVIRG | error PTVIRG {: parser.defineErro("Expressao incompleta"); :} ;

expr ::= expr:e MAIS term:t {: RESULT=e+t; :} | expr:e MENOS term:t {: RESULT=e-t; :}
       | MENOS term:t {: RESULT=-t; :} | term:t {: RESULT=t; :} ;
term ::= factor:f MULT term:t {: RESULT=f*t; :}
       | factor:f DIV term:t {: if(t==0){parser.defineErro(tleft,tright,"Divisao por zero.");} RESULT=f/t; :}
       | factor:f {: RESULT=f; :} ;
factor ::= NUMBER:n {: RESULT=n; :} | ABREPAR expr:e FECHAPAR {: RESULT=e; :} ;
CUP

  cat > Main.java << 'JAVA'
import java.io.*;
import erros.ListaErros;
public class Main {
  public static void main(String[] args) throws Exception {
    String f=args.length>0?args[0]:"teste.txt";
    FileReader in=new FileReader(f);
    ListaErros le=new ListaErros();
    scanner.Scanner sc=new scanner.Scanner(in,le);
    parser.parser p=new parser.parser(sc);
    p.parse();
    if(!le.hasErros()) System.out.println("Sintaxe Correta");
    else { System.out.println("Erros encontrados:"); le.dump(); }
  }
}
JAVA

  cat > teste1.txt << 'T1'
if (10 < 3) { 1+9; 7-5+8/0; }else{ 1+2; }
T1
  cat > teste2.txt << 'T2'
if 10 < 3 { 1+9; 7-5+8/0; }else{ 1+2; }
T2
  cat > teste3.txt << 'T3'
while(3 < 10){ 1+2; }
do{ 1+2; }while(5 < 3);
T3

  echo -e "${CIANO}   Gerando Scanner e Parser...${RESET}"
  jflex scanner/scanner.flex 2>/dev/null && mv Scanner.java scanner/
  cup -package parser parser/parser.cup 2>/dev/null && mv parser.java sym.java parser/
  echo -e "${CIANO}   Compilando...${RESET}"
  javac -cp "$CP" erros/Erro.java erros/ListaErros.java
  javac -cp "$CP" scanner/Scanner.java
  javac -cp "$CP" parser/sym.java parser/parser.java
  javac -cp "$CP" Main.java

  echo -e "${VERDE}--- Teste 1: if correto + divisão por zero ---${RESET}"
  cp teste1.txt teste.txt && java -cp "$CP" Main
  echo -e "${VERDE}--- Teste 2: IF sem parênteses (error) ---${RESET}"
  cp teste2.txt teste.txt && java -cp "$CP" Main
  echo -e "${VERDE}--- Teste 3: while + do-while ---${RESET}"
  cp teste3.txt teste.txt && java -cp "$CP" Main
  cd ..
}

# ══════════════════════════════════════════════════════════════
# MENU PRINCIPAL
# ══════════════════════════════════════════════════════════════
menu() {
  echo ""
  echo -e "${AZUL}╔══════════════════════════════════════════════════════════════╗${RESET}"
  echo -e "${AZUL}║        COMPILADORES — CEUB | Prof. Alessandra Hauck         ║${RESET}"
  echo -e "${AZUL}╠══════════════════════════════════════════════════════════════╣${RESET}"
  echo -e "${AZUL}║  Escolha o roteiro a executar:                              ║${RESET}"
  echo -e "${AZUL}║    6  → Roteiro 6  — if (Atividades 1 e 2)                 ║${RESET}"
  echo -e "${AZUL}║    7  → Roteiro 7  — if-else                               ║${RESET}"
  echo -e "${AZUL}║    8  → Roteiro 8  — while + for + do-while                ║${RESET}"
  echo -e "${AZUL}║    9  → Roteiro 9  — Registro de Erros                     ║${RESET}"
  echo -e "${AZUL}║    10 → Roteiro 10 — Tratamento de Erros (error)           ║${RESET}"
  echo -e "${AZUL}║  todos → Executa todos em sequência                         ║${RESET}"
  echo -e "${AZUL}╚══════════════════════════════════════════════════════════════╝${RESET}"
  echo ""
  read -p "Digite sua opção: " opcao
  executar "$opcao"
}

executar() {
  instalar_deps
  case "$1" in
    6)    roteiro6 ;;
    7)    roteiro7 ;;
    8)    roteiro8 ;;
    9)    roteiro9 ;;
    10)   roteiro10 ;;
    todos)
      roteiro6
      roteiro7
      roteiro8
      roteiro9
      roteiro10
      echo ""
      echo -e "${VERDE}✔ Todos os roteiros executados com sucesso!${RESET}"
      ;;
    *)
      echo "Opção inválida. Use: 6, 7, 8, 9, 10 ou todos"
      ;;
  esac
}

# ── Ponto de entrada ──────────────────────────────────────────
if [ $# -eq 0 ]; then
  menu
else
  instalar_deps
  executar "$1"
fi
