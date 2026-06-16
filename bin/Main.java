/* ============================================================
   Main.java  -  Acopla o Scanner (JFlex) e o Parser (JCup)
   Disciplina: Compiladores  -  Trabalho: Parser (JFlex + JCup)

   Compilar/Executar (dentro da pasta bin):
     1) java -jar java-cup-11b.jar Parser.cup      (gera parser.java e sym.java)
     2) jflex Scanner.flex                          (gera Scanner.java)
     3) javac -cp ".;java-cup-11b-runtime.jar" *.java
     4) java  -cp ".;java-cup-11b-runtime.jar" Main entrada.txt
   ============================================================ */

import java.io.*;
import java_cup.runtime.Symbol;

public class Main {

    public static void main(String[] argv) {
        // Por padrao le "entrada.txt"; aceita outro arquivo por parametro.
        String arquivo = (argv.length > 0) ? argv[0] : "entrada.txt";

        System.out.println("=================================================");
        System.out.println(" COMPILADOR Java--  |  Analise Sintatica (Parser)");
        System.out.println(" Arquivo de entrada: " + arquivo);
        System.out.println("=================================================");

        try {
            // 1) Instancia o Scanner apontando para o arquivo de entrada.
            Scanner scanner = new Scanner(new FileReader(arquivo));

            // 2) Instancia o Parser passando o Scanner como argumento.
            parser p = new parser(scanner);

            // 3) Chama o metodo parse() dentro de try-catch.
            Object resultado = p.parse().value;

        } catch (FileNotFoundException e) {
            System.err.println("ERRO: arquivo de entrada '" + arquivo + "' nao encontrado.");
        } catch (Exception e) {
            System.err.println("ERRO durante a analise:");
            e.printStackTrace();
        }
    }
}
