import java.util.*;
import java.io.FileReader;
import java.io.FileNotFoundException;
import java.io.IOException;


%%
%class Lexer
%standalone
%line
%column


LineTerminator = \r|\n|\r\n
Numbers = \d+\.?\d*
Alpha = [a-zA-Z]
Digit = [0-9]
WhiteSp  = [\040\ n]
InputCharacter = [^\r\n]
Comment = "//" {InputCharacter}* {LineTerminator}?

OpenBracket = "("
CloseBracket = ")"
COpenBracket = "{"
CCloseBracket = "}"
SemiC = ";"
Less = "<"
Greater = ">"
EQUIV = "=="
LessEQU = {Less} {EQU}
GreaterEQU = {Greater} {EQU}
Not = "!"
NotEQU = "!" {EQU}
EQU = "="
Plus = "+"
Minus= "-"
Dot = "\."


Type = {Int}|{Bool}|{String}

Bool = "bool"
Int = "int"
True = "true"
False = "false"
Void = "void"
Printf = "printf"
String = "string"
Struct = "struct" {Word} {COpenBracket} {Declaration}+ {CCloseBracket}
If = "if"
Then = "then"
Else = "else"
For = "for"
Return = "return"


IntVar = {Digit}+
BoolVar = {True}|{False}

Quotes = [\042]
StringVar = {Quotes} {InputCharacter}* {Quotes}

Declaration = {Type} {Word}

Compare = {Less} | {Greater} | {LessEQU} | {GreaterEQU} | {EQUIV} | {NotEQU}
Comparison = ({Word} | {Numbers}) {Compare} ({Word} | {Numbers})

Operator = {Plus} | {Minus}

ReturnType = {Type}|{Void}



IdentifierCharacter = {Alpha} | {Digit}
Word = {Alpha}{IdentifierCharacter}*

%{
 List<String> tokens = new ArrayList();
%}

%eof{
    boolean error = false;

    System.out.print("Tokens: ");
    for(int i=0; i<tokens.size();i++){
     System.out.print(tokens.get(i) + ", ");
    }
    
    String state = "Null";

    for(int i=0; i<tokens.size();i++){
        if(tokens.get(i).contentEquals("COMMENT")){
                if(!state.contentEquals("Null")){
                error = true;
            }
        }
        else if(tokens.get(i).contentEquals("TYPE")) {
            if(state.contentEquals("Null")||state.contentEquals("For")){
                state = "Type";
            }
            else {
                error = true;
            }

        }
        else if(tokens.get(i).contentEquals("WORD")) {
            if(state.contentEquals("Null")||state.contentEquals("Type")||state.contentEquals("Struct")){
                state = "Word";
            }
            else {
                error = true;
            }
        }
        else if(tokens.get(i).contentEquals("PRINTF")) {
            if(state.contentEquals("Null")){
                state = "Printf";
            }
            else {
                error = true;
            }
        }
        else if(tokens.get(i).contentEquals("STRINGVAR")) {
            if(state.contentEquals("Equal")||state.contentEquals("Printf")){
                state = "Content";
            }
            else {
                error = true;
            }
        }
        else if(tokens.get(i).contentEquals("INTVAR")) {
            if(state.contentEquals("Equal")||state.contentEquals("Operator")){
                state = "Content";
            }
            else {
                error = true;
            }
        }
        else if(tokens.get(i).contentEquals("BOOLVAR")) {
            if(state.contentEquals("Equal")){
                state = "Content";
            }
            else {
                error = true;
            }
        }
        else if(tokens.get(i).contentEquals("STRUCT")) {

        }
        else if(tokens.get(i).contentEquals("THEN")) {

        }
        else if(tokens.get(i).contentEquals("IF")) {

        }
        else if(tokens.get(i).contentEquals("FOR")) {

        }
        else if(tokens.get(i).contentEquals("EQU")) {
            if(state.contentEquals("Word")){
                state = "Equal";
            }
            else {
                error = true;
            }
        }
        else if(tokens.get(i).contentEquals("SEMIC")) {
            state = "Null";
        }
        else {
            error = true;
            }
    }
    if(error){
            System.out.print("\nError\n");
        }
    else {
            System.out.print("\nValid\n");
        }
%eof}

%%
{Type} {tokens.add("TYPE");}
{SemiC} {tokens.add("SEMIC");}
{EQU} {tokens.add("EQU");}
{StringVar} {tokens.add("STRINGVAR");}
{BoolVar} {tokens.add("BOOLVAR");}
{IntVar} {tokens.add("INTVAR");}
{Declaration} {tokens.add("DECLARATION");}
{Comment} {tokens.add("COMMENT");}
{Struct} {tokens.add("STRUCT");}
{Printf} {tokens.add("PRINTF");}
{If} {tokens.add("IF");}
{Then} {tokens.add("THEN");}
{Else} {tokens.add("ELSE");}
{For} {tokens.add("FOR");}
{Comparison} {tokens.add("COMPARISON");}
{Operator} {tokens.add("OPERATOR");}
{Word} {tokens.add("WORD");}
{WhiteSp} {}
\n {}
. {}