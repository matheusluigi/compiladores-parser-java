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
