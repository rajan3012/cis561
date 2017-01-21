all:
	flex scanner.l
	g++ lex.yy.c -lfl -o scanner

clean:
	rm -f lex.yy* scanner
