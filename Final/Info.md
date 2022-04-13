bison -d parser.y
flex lexer.l
gcc -o a parser.tab.c lex.yy.c 
./a input.txt