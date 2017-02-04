all:
	bison -d quackParser.y
	flex quackParser.l
	g++ quackParser.tab.c lex.yy.c -lfl -o quackParser

clean:
	rm -f lex.yy* quackParser quackParser.tab.*
