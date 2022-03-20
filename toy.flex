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
%cup

%{
StringBuffer stringBuffer = new StringBuffer();

public static void main(String[] args) throws FileNotFoundException, IOException{
    FileReader yyin = new FileReader(args[0]);
    Yylex yy = new Yylex(yyin);
    Yytoken t;
    while ((t = yy.yylex()) != null){
      //System.out.println(t.type);
      if(t.type == "error"){
         System.out.println("Error");
         //valid = true; 
       }
       else{
         System.out.println("Valid " + t.type);
         //valid = false;
       }
    }

}
%}

LineTerminator = \r|\n|\r\n
WhiteSpace     = {LineTerminator} | [ \t\f]
Numbers = [0-9]+(".")?[0-9]*
Mathoperators = ("++" | "--" | "+" | "-" | "*" | "/" | "=")*
Brackets = [(){}]*
Functionsarray = ("main" | "printf" | "scanf")*
Keywordsarray = ("bool" | "int" | "true" | "false" | "void" | "printf" | "string" | "and" | "struct" | "if" | "then"| "else" | "for" | "return" | "mod" | "or")*
Identifier = [:jletter:] [:jletterdigit:]*


%state STRING

%%
<YYINITIAL> {
/* function */
{Functionsarray}               { return new Yytoken("Function"); } 

/* Keyword */
{Keywordsarray}                { return new Yytoken("Keyword"); }

/* identifiers */
{Identifier}                   { return new Yytoken("Identifier"); }

/* literals */
\"                             { stringBuffer.setLength(0); yybegin(STRING); }

/* brackets */
{Brackets}                     { return new Yytoken("Bracket"); } 

/* Math operators */
{Mathoperators}                { return new Yytoken("Operator"); }

/* numbers */
{Numbers}                      { return new Yytoken("Number"); }

/* whitespace */
{WhiteSpace}                   {/*ignore */ }
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

/* error token */
[^]                              { return new Yytoken("ERROR: "+ yytext()); } //return new Yytoken("ERROR: Invalid Token here -> "+ yytext()); }
