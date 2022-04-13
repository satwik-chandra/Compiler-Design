%option noyywrap
 
%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	#include "symtab.h"
	#include "parser.tab.h"
	extern FILE *yyin;
	extern FILE *yyout;
 
	int lineno = 1; // initialize to 1
	void ret_print(char *token_type);
	void yyerror();
%}
 
%x ML_COMMENT
 
alpha 		[a-zA-Z]
digit 		[0-9]
alnum 		{alpha}|{digit}
print		[ -~]
 
ID 			{alpha}+{alnum}*
ICONST		"0"|[0-9]{digit}*

STRING		\"{print}*\"
 
%%
 
"//".*					{ printf("Eat up comment at line %d\n", lineno); } 
 

"int"|"INT"				{ return INT; }
"if"|"IF"				{ return IF; }
"else"|"ELSE"			{ return ELSE; }
"for"|"FOR"				{ return FOR; }
"void"|"VOID"			{ return VOID; }
"return"|"RETURN"		{ return RETURN; }
"bool" | "BOOL"			{ return BOOL; }
"true" | "TRUE"         {return TRUE ; }
"false" | "FALSE"       {return FALSE ;} 
 
"+"|"-"					{ return ADDOP; }
"*"						{ return MULOP; }
"/"						{ return DIVOP; }
"||"					{ return OROP; }
"!"						{ return NOTOP; }
"=="|"!="				{ return EQUOP; }
">"|"<"|">="|"<="		{ return RELOP; }
 
 
"("				{ return LPAREN; }
")"				{ return RPAREN; }
"{"				{ return LBRACE; }
"}"				{ return RBRACE; }
";"				{ return SEMI; }
"."				{ return DOT; }
"="				{ return EQUAL; }

 
 
{ID} 			{
					// insert identifier into symbol table
					insert(yytext, strlen(yytext), UNDEF, lineno);
					return ID;
				}
{ICONST} 				{
					return ICONST; 
				}
		/*
		/ {ICONST} 		{ double temp = strtod(yytext());
		// 					if(temp > 32767 || temp < -32768)
		// 						{
		// 							return ERRORINT ;
		// 						}
		// 					else
		// 						{
		// 							return ICONST; 
		// 						}
		*/			
{STRING} 		{ return STRING; }
 
 
"\n"			{ lineno += 1; }
[ \t\r\f]+			/* eat up whitespace */
 
.				{ yyerror("Unrecognized character"); }
 
%%