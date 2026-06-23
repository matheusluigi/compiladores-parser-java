/* Main.java — Roteiro 2: IDENT e Designator */

import java.io.*;

class Main {
    public static void main(String[] args) throws Exception {

        // Leitura pelo TECLADO:
        // Scanner scanner = new Scanner(System.in);

        // Leitura pelo ARQUIVO:
        FileReader in = new FileReader("teste.txt");
        Scanner scanner = new Scanner(in);

        parser p = new parser(scanner);
        try {
            p.parse();
            System.out.println("Arquivo sem erros de sintaxe!");
        } catch (Exception e) {
            System.out.println("Erro de sintaxe: " + e);
        }
    }
}
