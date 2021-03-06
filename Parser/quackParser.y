%{
#include <cstdio>
#include <stdio.h>
#include <iostream>
#include "quackParser.tab.h"
using namespace std;

// stuff from flex that bison needs to know about:
extern "C" int yylex();
extern "C" FILE *yyin;
extern int line_num;
extern char* yytext;

 
void yyerror(const char *s);
%}

// Bison fundamentally works by asking flex to get the next token, which it
// returns as an object of type "yystype".  But tokens could be of any
// arbitrary data type!  So we deal with that in Bison by defining a C union
// holding each of the types of tokens that Flex could return, and have Bison
// use that union instead of "int" for the definition of "yystype":
%union {
	int ival;
	char *sval;
//	struct node_struct* nodeval;
}

// define the constant-string tokens:
%token PLUS
%token MINUS
%token TIMES
%token DIVIDE
%token EQUALS
%token ATMOST
%token ATLEAST
%token LESS
%token MORE
%token <sval> STRING_LIT INT_LIT 
%token ELLIPSIS
%token DEF
%token CLASS
%token EXTENDS
%token IF
%token ELIF 
%token ELSE
%token WHILE
%token RETURN
%token GETS
%token AND
%token OR
%token NOT
%token ')'
%token '('
%token '{'
%token '}'
%token SCOLON
%token COMMA
%token DOT
%token COLON
%token IDENT

%left AND OR NOT
%left ATMOST ATLEAST 
%left EQUALS LESS MORE
%left NEG
%right PLUS MINUS 
%left TIMES DIVIDE
%left DOT

/*%type <ival> NUM
%type <sval> WORD
*/

%start program
%%

program:
	classes statements
	;

classes:
	//empty
	| classes class
	;

class:
	class_signature class_body
	;

class_signature:
	CLASS IDENT '(' formal_args ')'
	| CLASS IDENT '(' formal_args ')' EXTENDS IDENT
	;
		
formal_args:
	//empty
	| IDENT COLON IDENT args 
	;

args:
	//empty
	| args COMMA IDENT COLON IDENT
	;

class_body:
	//empty
	| '{' statements methods '}'
	;

methods:
	//empty
	| methods method
	;

method:
	DEF IDENT '(' formal_args')' statement_block
	| DEF IDENT '(' formal_args')' COLON IDENT statement_block
	;

statement_block:
	'{' statements '}'
	;

statements:
	//empty
	| statements statement
	;

statement:
	IF r_expr statement_block
	| IF r_expr statement_block elseIf ELSE statement_block 
	| WHILE r_expr statement_block
	| r_expr SCOLON
	| l_expr GETS r_expr SCOLON 
	| l_expr COLON IDENT GETS r_expr SCOLON 
	| RETURN r_expr SCOLON
	| RETURN SCOLON
	;

elseIf:
	//empty
	| elseIf ELIF r_expr statement_block
	;

l_expr:
	IDENT
	| r_expr DOT IDENT
	;

r_expr: 
	l_expr
	| r_expr MINUS r_expr
	| r_expr PLUS r_expr 
	| r_expr TIMES r_expr 
	| r_expr DIVIDE r_expr
	| MINUS r_expr %prec NEG
	| '(' r_expr ')'
	;

r_expr:
	r_expr EQUALS r_expr
	| r_expr ATLEAST r_expr
	| r_expr ATMOST r_expr
	| r_expr LESS r_expr
	| r_expr MORE r_expr
	| r_expr AND r_expr
	| r_expr OR r_expr
	| r_expr NOT r_expr
	;

r_expr:
	r_expr DOT IDENT '(' actual_args ')'
	| IDENT '(' actual_args ')'
	;

actual_args:
	//empty
	| r_expr
	| r_expr COMMA r_expr
	;

%%
/*
int main(int, char**) {
	// open a file handle to a particular file:
	FILE *myfile = fopen("sample2.qk", "r");
	// make sure it's valid:
	if (!myfile) {
		cout << "Can't open quack file!" << endl;
		return -1;
	}
	// set lex to read from it instead of defaulting to STDIN:
	yyin = myfile;

	// parse through the input until there is no more:
	
	do {
		yyparse();
	} while (!feof(yyin));
	
}
*/


int main(int argc, char* argv[]) {

        // open a file handle to a particular file:
        FILE *myfile = fopen(argv[1], "r");
        // make sure it's valid:
        if (!myfile) {
                cout << "Can't open quack example!" << endl;
                return -1;
        }
        // set lex to read from it instead of defaulting to STDIN:
        yyin = myfile;

        // lex through the input:
        //yylex();
	// parse through the input until there is no more:
	
	do {
		yyparse();
	} while (!feof(yyin));
	printf("\nFinished parse with no errors\n");
}

void yyerror(const char *s) {
	fprintf(stderr,"%d: Parse error on token \"%s\"  \n",line_num,yytext);
	exit(-1);
}
