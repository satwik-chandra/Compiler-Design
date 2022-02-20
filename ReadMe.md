clone repo

install java, flex and jflex on your machine

steps:
cd Compiler-Design

jflex test.flex

javac Yylex.java

java Yylex input.txt

It should then output what types are in input.txt ( only identifiers, = and strings so far(working on this))
