default:
	clear
	bison -d -v parser.y
	flex -d lexer.l
	gcc -o test parser.tab.c lex.yy.c
	./test input.txt
