clone repo/ download file

install java, flex and jflex on your machine

steps:
cd Compiler-Design

jflex toy.flex

javac Lexer.java

java Yylex input.txt

It should then output valid types that are in input.txt

To start parsing:
Command:- java -jar java-cup-11b.jar parser.cup  input.txt

