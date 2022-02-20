import java.io.FileReader;
import java.io.FileNotFoundException;
import java.io.IOException;

class Yytoken {
  public String type;
  public Object value;
  public Yytoken(String type) {
    this.type = type;
  }
  public Yytoken(String type, Object value) {
    this.type = type;
    this.value = value;
  }
}

%%

%unicode

%{
StringBuffer stringBuffer = new StringBuffer();

public static void main(String[] args) throws FileNotFoundException, IOException{
            FileReader yyin = new FileReader(args[0]);
            Yylex yy = new Yylex(yyin);
            Yytoken t;
            while ((t = yy.yylex()) != null)
                System.out.println(t.type);
}
%}

LineTerminator = \r|\n|\r\n
InputCharacter = [^\r\n]
WhiteSpace     = {LineTerminator} | [ \t\f]

Identifier = [:jletter:] [:jletterdigit:]*


%state STRING

%%
<YYINITIAL> {
/* identifiers */
{Identifier}                   { return new Yytoken("IDENTIFIER"); }

/* literals */
\"                             { stringBuffer.setLength(0); yybegin(STRING); }

/* operators */
"="                            { return new Yytoken("EQ"); }

/* whitespace */
{WhiteSpace}                   { return new Yytoken("space"); }
}

<STRING> {
\"                             { yybegin(YYINITIAL);
                               return new Yytoken("STRING_LITERAL",
                               stringBuffer.toString()); }
[^\n\r\"\\]+                   { stringBuffer.append( yytext() ); }
\\t                            { stringBuffer.append('\t'); }
\\n                            { stringBuffer.append('\n'); }

\\r                            { stringBuffer.append('\r'); }
\\\"                           { stringBuffer.append('\"'); }
\\                             { stringBuffer.append('\\'); }
}

/* error fallback */
[^]                              { throw new Error("ERROR: Invalid Token "+
                                                yytext()+">"); }
