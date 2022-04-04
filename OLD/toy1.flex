import java_cup.runtime.*;




/**
* This class is a simple example lexer.
*/
%%
%class Lexer
%unicode
%cup
%line
%column



%{
StringBuffer string = new StringBuffer();
private Symbol symbol(int type) {
return new Symbol(type, yyline, yycolumn);
}
private Symbol symbol(int type, Object value) {
return new Symbol(type, yyline, yycolumn, value);
}
%}


/**
* Terminals down here: Reserved words(Set), ID(REGEX), and Integer(REGEX), String literals(REGEX), Symbolds(to be defined seperately, one by one), Comments(REGEX), Whitespaces(REGEX).
*/
LineTerminator = \r|\n|\r\n
InputCharacter = [^\r\n]

TraditionalComment = "/*" [^*] ~"*/" | "/*" "*"+ "/"

RESERVED = ["bool"|"int"|"true"|"false"|"void"|"printf"|"string"|"and"|"struct"|"if"|"then"|"else"|"for"|"return"|"mod"|"or"]
ID = [a-zA-Z_][a-zA-Z0-9_]*
INTEGER = 0 | [1-9][0-9]*

COMMENT = {TraditionalComment}
WHITESPACE = {LineTerminator} | [ \t\f]


%state STRING
%%

<YYINITIAL> {

        {ID}                { return symbol(sym.IDENTIFIER); }



        /* literals */
        {INTEGER}           { return symbol(sym.INTEGER_LITERAL); }
        \"                  { string.setLength(0); yybegin(STRING); }

        /* operators */
        "{"              { return symbol(sym.LBRACE); }
        "}"             { return symbol(sym.RBRACE); }
        ";"              { return symbol(sym.SEMICOLON); }
        "<"              { return symbol(sym.LT); }
        ">"              { return symbol(sym.GT); }
        "=="              { return symbol(sym.EQEQ); }
        "<="              { return symbol(sym.LTEQ); }
        ">="              { return symbol(sym.GTEQ); }
        "*"              { return symbol(sym.STAR); }
        "!="              { return symbol(sym.NOTEQ); }
        "!"              { return symbol(sym.NOT); }
        "("              { return symbol(sym.LBRACK); }
        ")"              { return symbol(sym.RBRACK); }
        "+"              { return symbol(sym.PLUS); }
        "-"              { return symbol(sym.MINUS); }
        "."              { return symbol(sym.DOT); }
        "="              { return symbol(sym.EQ); }
        "/"              { return symbol(sym.DIV); }


        /* comments */
        {COMMENT}       { /* ignore */ }


        /* whitespace */
        {WHITESPACE}    { /* ignore */ }
}

        <STRING> {
        \"                  { yybegin(YYINITIAL);
                                return symbol(sym.STRING_LITERAL,
                                string.toString()); }
        [^\n\r\"\\]+        { string.append( yytext() ); }
        \\t                 { string.append('\t'); }
        \\n                 { string.append('\n'); }
        \\r                 { string.append('\r'); }
        }
        /* error fallback */
        [^]                 { throw new Error("Illegal character <"+
                                                                yytext()+">");}

 

