%{



%}

RESERVED = bool|int|true|false|void|printf|string|and|struct|if|then|else|for|return|mod|or
ID = [a-zA-Z][a-zA-Z0-9]*
INTEGER = [+-]?[0-9]+
STRING = \"(\\.|[^"\\])*\"
WHITESPACENL = [ \t\n\r]*
SYMBOLS  {|}|;|<|>|==|<=|>=|*|!=|!|(|)|+|-|.|=|/

/*The above definitons dont work for some weird reason*/
/*The below grammer will be changed to return the token to parser later*/
/*At the moment, String doesnt work, can't really figure out how to make the regular expression*/

%%


bool|int|true|false|void|printf|string|and|struct|if|then|else|for|return|mod|or {printf("Valid RESERVED: %s\n", yytext);} //Keywords
[a-zA-Z][a-zA-Z0-9]* {printf("Valid ID: %s\n", yytext);} //Identifier
([^\\\"]|\\.)* {printf("Valid STRING: %s\n", yytext);} //String{Not working perfectly, needs to be edited PENDING TASK}
[+-]?[0-9]+ {printf("Valid INTEGER: %s\n", yytext);} //Integers, + && -
\{|\}|;|<|>|==|<=|>=|\*|!=|!|\(|\)|\+|-|.|=|\\ {printf("Valid SYMBOL: %s\n", yytext);} //All the symbols
[ \t\n\r]* 
. {printf("Invalid\n");}


%%

int yywrap(){}
int main(){
    FILE *fp;
    fp = fopen("input.txt","r");
    yyin = fp;
    yylex();
} 
//Additional C code

