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
