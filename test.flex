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
Numbers = [0-9]+(".")?[0-9]*
Mathoperators = ("++" | "--" | "+" | "-" | "*" | "/" | "=")*
Brackets = [(){}]*
Functionsarray = ("main" | "printf" | "scanf")*
Keywordsarray = ("int" | "float" | "double" | "if" | "else" | "for" | "return" | "include")*

Identifier = [:jletter:] [:jletterdigit:]*


%state STRING

%%
<YYINITIAL> {
/* function */
{Functionsarray}               { return new Yytoken("function"); } 

/* Keyword */
{Keywordsarray}                { return new Yytoken("keyword"); }

/* identifiers */
{Identifier}                   { return new Yytoken("identifier"); }

/* literals */
\"                             { stringBuffer.setLength(0); yybegin(STRING); }

/* brackets */
{Brackets}                     { return new Yytoken("brackets"); } 

/* Math operators */
{Mathoperators}                { return new Yytoken("operator"); }

/* numbers */
{Numbers}                      { return new Yytoken("number"); }

/* whitespace */
{WhiteSpace}                   { return new Yytoken("space"); }
}

<STRING> {
\"                             { yybegin(YYINITIAL);
                               return new Yytoken("String",
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
