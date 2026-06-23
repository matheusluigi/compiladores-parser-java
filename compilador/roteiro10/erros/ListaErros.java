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
