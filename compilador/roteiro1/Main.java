/* Main.java — Roteiro 1: Local, Bloco e Precedência */

import java.io.*;

class Main {
    public static void main(String[] args) throws Exception {

        // ── Atividade 4: alternar entre teclado e arquivo ──────────────────

        // Leitura pelo TECLADO (descomentar para usar):
        // Scanner scanner = new Scanner(System.in);

        // Leitura pelo ARQUIVO (descomentar para usar):
        FileReader in = new FileReader("teste.txt");
        Scanner scanner = new Scanner(in);

        // ───────────────────────────────────────────────────────────────────

        parser p = new parser(scanner);
        try {
            p.parse();
            System.out.println("Arquivo sem erros de sintaxe!");
        } catch (Exception e) {
            System.out.println("Erro de sintaxe: " + e);
        }
    }
}
