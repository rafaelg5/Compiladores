# Makefile: A standard Makefile

all:
	bison --warnings=none -vd --file-prefix=parser-output/parser src/parser.y
	flex -o scanner-output/lex.yy.c src/lexer.l
	gcc scanner-output/lex.yy.c src/symbol_table.c src/ast.c parser-output/parser.tab.c -lfl -o parser


clean:
	rm -f parser
	rm -f parser-output/*
	rm -f scanner-output/*
