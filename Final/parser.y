%{
	#include "ToY.c"
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	extern FILE *yyin;
	extern FILE *yyout;
	extern int lineno;
	extern int yylex();
	void yyerror();
%}
//a lot to do here


/* token definition */
%token NOTOPERATOR
%token ADDOPERATOR SUBOPERATOR 
%token RELOPERATOR
%token EQUAL EQUOPERATOR

%token MULOPERATOR DIVOPERATOR  OROPERATOR  ANDOPERATOR MODOPERATOR
%token INTEGER IF THEN ELSE FOR  VOID RETURN BOOL TRU FAL STRUCT
%token LPAREN RPAREN LBRACE RBRACE SEMI DOT COMMA PRINT
%token ID ICONST STRING SCONST

%left NOTOPERATOR SUBOPERATOR ADDOPERATOR  MULOPERATOR DIVOPERATOR 
%nonassoc EQUOPERATOR RELOPERATOR
%left DOT

%start program
 
/* expression priorities and rules */
 
%%
 
program: procedure_declarations ;
 
procedure_declarations: procedure_declaration procedure_declarations |  ;

procedure_declaration: 
	return_type ID LPAREN declarations_p LBRACE statements RBRACE | 
	return_type ID LPAREN RPAREN LBRACE statements RBRACE |
	STRUCT ID LBRACE declarations_s 
;

procedure_calls: 
	ID LPAREN expressions RPAREN SEMI | 
	ID EQUAL ID LPAREN expressions RPAREN SEMI 
;

type: INTEGER | STRING | BOOL;

declaration: type ID SEMI;

declarations_p: declaration_p COMMA declarations_p | declaration_p RPAREN;
declarations_s: declaration_p COMMA declarations_s | declaration_p RBRACE;

declaration_p: type ID;

statements: statement statements | ;
 
statement:
	if_statements | for_statement | assignment | prints | declaration | procedure_calls
	| RETURN returns SEMI 

prints: PRINT LPAREN SCONST RPAREN SEMI ;

returns:
	ID | ICONST | SCONST | VOID | ;

return_type:
	INTEGER | STRING | BOOL | VOID;

assignment:  ID EQUAL VOID SEMI | ID EQUAL expression SEMI ; 

lexp : ID | ID DOT ID | 

if_statements: if_statements if_statement | ;

if_statement: IF LPAREN bool_exp RPAREN THEN LBRACE statements RBRACE else_part;
 
else_part: ELSE LBRACE statements RBRACE | ; 
 
for_statement: FOR LPAREN assignment conditionals SEMI conditionals RPAREN LBRACE statements RBRACE;

bool_exp : conditionals | ID | TRU | FAL ;

conditionals:
	expression EQUOPERATOR expression |
    expression RELOPERATOR expression |
	NOTOPERATOR expression |
	expression OROPERATOR expression  |
	expression ANDOPERATOR expression |
	ID EQUAL expression 

expressions: expressions expression | ;
expression:
	ICONST |
	SCONST |
	TRU |
	FAL |
	expression OPERATOR expression |
    LPAREN expression RPAREN |
	sign ICONST |
    NOTOPERATOR expression |
	ID |
	ID DOT ID
	
;
 
sign: ADDOPERATOR | SUBOPERATOR;
OPERATOR : ADDOPERATOR | SUBOPERATOR | MULOPERATOR | DIVOPERATOR |MODOPERATOR | ANDOPERATOR | OROPERATOR | NOTOPERATOR | EQUOPERATOR | RELOPERATOR ;

 
%%
 
void yyerror ()
{
   fprintf(stderr, "Syntax Error at line \n");
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
	yyout = fopen("ToY_dump.out", "w");
	ToY_dump(yyout);
	fclose(yyout);

	printf("\n\nProgram: ",flag);

	if(flag == 0){
		printf("VALID\n\n\n");
	}
	else{
		printf("ERROR\n\n\n");
	}
	
	return flag;
}