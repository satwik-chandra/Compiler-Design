%{
	#include "symtab.c"
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	extern FILE *yyin;
	extern FILE *yyout;
	extern int lineno;
	extern int yylex();
	void yyerror();
%}
 
/* token definition */
%token INT IF THEN ELSE FOR  VOID RETURN BOOL
%token ADDOP MULOP DIVOP  OROP NOTOP EQUOP RELOP
%token LPAREN RPAREN LBRACE RBRACE SEMI DOT COMMA ASSIGN EQUAL
%token ID ICONST  STRING
 
%start program
 
/* expression priorities and rules */
 
%%
 
program: declarations statements ;
 
declarations: declarations declaration | declaration;
 
declaration: type names SEMI ;
 
type: INT | VOID;
 
names: ID | names COMMA ID;
 
statements: statements statement | statement;
 
statement:
	if_statement | for_statement | assigment |
	| RETURN SEMI
;
 
if_statement: IF LPAREN expression RPAREN tail else_if_part else_part ;
 
else_if_part: 
	else_if_part ELSE IF LPAREN expression RPAREN tail |
	ELSE IF LPAREN expression RPAREN tail  |
	/* empty */
; 
else_part: ELSE tail | /* empty */ ; 
 
for_statement: FOR LPAREN expression SEMI expression SEMI expression RPAREN tail ;
 
tail: statement SEMI | LBRACE statements RBRACE ;
 
expression:
    expression ADDOP expression |
    expression MULOP expression |
    expression DIVOP expression |
 
    expression OROP expression |
    NOTOP expression |
    expression EQUOP expression |
    expression RELOP expression |
    LPAREN expression RPAREN |
    names |
    sign constant
;
 
sign: ADDOP | /* empty */ ; 
constant: ICONST  ;
assigment: names EQUAL expression SEMI ; 
 
%%
 
void yyerror ()
{
  fprintf(stderr, "Syntax error at line %d\n", lineno);
  exit(1);
}
 
int main (int argc, char *argv[]){
 
	// initialize symbol table
	init_hash_table();
 
	// parsing
	int flag;
	yyin = fopen(argv[1], "r");
	flag = yyparse();
	fclose(yyin);
 
	// symbol table dump
	yyout = fopen("symtab_dump.out", "w");
	symtab_dump(yyout);
	fclose(yyout);	
 
	return flag;
}