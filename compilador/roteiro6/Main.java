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
