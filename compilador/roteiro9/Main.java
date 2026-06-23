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
