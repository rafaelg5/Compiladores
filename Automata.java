import java.io.*;

public class Automata{

  private FileReader file;
  private BufferedReader br;
  private String lastToken;

  public Automata(String pathname){
    try{
      file = new FileReader(pathname);
    }catch (Exception e) {
      e.printStackTrace();
    }
    br = new BufferedReader(file);
    lastToken = null;
  }

  public String nextToken() throws IOException{

    char c;
    int q = 0;
    String buffer = "";
    c = (char)br.read();

    while(c != -1){
      System.out.println(c);

      switch(q){

        case 0:

          if(isLetter(c))
            q = 1;
          else if(isDigit(c))
            q = 2;
          else if(c == '.')
            q = 3;
          else if(isBlankSpace(c))
            q = 5;
          else
            error();
          if(q != 5)
            buffer += c;
          break;

        case 1:
          if(c == '.')
            q = 2;
          else if(isBlankSpace(c)){
            lastToken = buffer;
            return lastToken;
          }
          else if(!isDigit(c) && !isLetter(c))
            error();
          buffer += c;
          break;

        case 2:

          if (isDigit (c))
            q = 2;
          else if (c == '.')
            q = 3;
          else if (isBlankSpace(c)) {
            lastToken = buffer;
            return lastToken;
          } else
            error ();
          buffer += c;
          break;

        case 3:
          if (isDigit(c))
            q = 4;
          else
            error ();
          buffer += c;
          break;

        case 4:
          if (isDigit(c))
            q = 4;
          else if (isBlankSpace(c)) {
            lastToken = buffer;
            return lastToken;
          } else
            error ();
          buffer += c;
          break;

        case 5:
          while (isBlankSpace(c))
            c = (char)br.read();
          q = 0;
      }

      if (q != 0)
        c = (char)br.read();
    }
    return null;
  }

  private boolean isDigit(char c){

    if(c >= 48 && c <= 57)
      return true;

    return false;
  }

  private boolean isLetter(char c){

    if((c >= 65 && c <= 90) || (c >= 97 && c <= 122))
      return true;

    return false;
  }

  private boolean isBlankSpace(char c){

    if(c == ' ' || c == '\n' || c == '\t')
      return true;

    return false;
  }

  private void error(){
    System.out.println("Fatal error. Terminating execution!!!");
    System.exit(0);
  }

  public static void main(String[] args) {
    // Aquí va la ruta del archivo a leer, en este caso lee el mismo programa
    String path = "Automata.java";
    Automata aut = new Automata(path);
    try{
      while(true){
        String token = aut.nextToken();
        System.out.printf("Token = %s\n",token);
      }
    }catch (Exception e) {
      e.printStackTrace();
    }
  }

}
