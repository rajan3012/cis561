%{
#include  <stdlib.h>
#include  <stdio.h>
#include  <iostream>
#include "quackParser.tab.h"

using namespace std;
#define YY_DECL extern "C" int yylex()
int line_num = 1;

const char* BAD_ESC_MSG =
  "Illegal escape code; only \\\\, \\0, \\t, \\n, \\r, \\n are permitted";
const char* BAD_NL_STR =
  "Unclosed string?  Encountered newline in quoted string."; 
/*
void yyerror (const char *msg) {
   fprintf(stderr,"%d: %s (at '%s')\n", yylineno,  msg, yytext);
}
*/

%}


%x mlcomment
%x slcomment
%x string1
%x string2

%%

"class"                   { printf("%d CLASS \"%s\"\n",line_num,yytext); return CLASS ;}
"def"                     { printf("%d DEF \"%s\"\n",line_num,yytext); return DEF ;}
"extends"                 { printf("%d EXTENDS \"%s\"\n",line_num,yytext); return EXTENDS ;}
"if"                      { printf("%d IF \"%s\"\n",line_num,yytext); return IF ;}
"elif"                    { printf("%d ELIF \"%s\"\n",line_num,yytext); return ELIF ;}
"else"                    { printf("%d ELSE \"%s\"\n",line_num,yytext); return ELSE ;}
"while"                   { printf("%d WHILE \"%s\"\n",line_num,yytext); return WHILE ;}
"return"                  { printf("%d RETURN \"%s\"\n",line_num,yytext); return RETURN ;}

"="                       { printf("%d GETS \"%s\"\n",line_num,yytext); return GETS ;}
"+"                       { printf("%d PLUS \"%s\"\n",line_num,yytext); return PLUS ;}
"-"                       { printf("%d MINUS \"%s\"\n",line_num,yytext); return MINUS ; }
"*"                       { printf("%d TIMES \"%s\"\n",line_num,yytext); return TIMES ;}
"/"                       { printf("%d DIVIDE \"%s\"\n",line_num,yytext);return DIVIDE ;}

"=="                      { printf("%d EQUALS \"%s\"\n",line_num,yytext); return EQUALS ;}
"<="                      { printf("%d ATMOST \"%s\"\n",line_num,yytext); return ATMOST ;}
">="                      { printf("%d ATLEAST \"%s\"\n",line_num,yytext); return ATLEAST ;}
"<"                       { printf("%d LESS \"%s\"\n",line_num,yytext); return LESS;}
">"                       { printf("%d MORE \"%s\"\n",line_num,yytext); return MORE;}

"and"                     { printf("%d AND \"%s\"\n",line_num,yytext); return AND ;}
"or"                      { printf("%d OR \"%s\"\n",line_num,yytext); return OR ;}
"not"                     { printf("%d NOT \"%s\"\n",line_num,yytext); return NOT ;}

"("                       { printf("%d ( \"%s\"\n",line_num,yytext); return '(' ;}
")"                       { printf("%d ) \"%s\"\n",line_num,yytext); return ')' ;}
"{"                       { printf("%d { \"%s\"\n",line_num,yytext); return '{' ;}
"}"                       { printf("%d } \"%s\"\n",line_num,yytext); return '}' ;}
";"                       { printf("%d ; \"%s\"\n",line_num,yytext); return SCOLON ;}
","                       { printf("%d , \"%s\"\n",line_num,yytext); return COMMA ;}
"."                       { printf("%d . \"%s\"\n",line_num,yytext); return DOT ;}
":"                       { printf("%d : \"%s\"\n",line_num,yytext); return COLON ;}

[0-9][0-9]+               { printf("%d INTEGER_LIT \"%s\"\n",line_num,yytext); return INT_LIT ;}

[_a-zA-Z0-9]+              { printf("%d IDENT \"%s\"\n",line_num,yytext); return IDENT ;}

[\n]                      { ++line_num;}
[\t]			  ;
[\r]			  ;
	
"/*"                      BEGIN(mlcomment); 
<mlcomment><<EOF>>        { fprintf(stderr,"%d Syntax Error ; Multiline has been started but has not been ended at end of the file. Program Exiting\n",line_num); BEGIN(INITIAL);}
<mlcomment>[^*\n]*        /* eat anything that's not a '*' */
<mlcomment>"*"+[^*/\n]*   /* eat up '*'s not followed by '/'s */
<mlcomment>[\n]*          ++line_num;
<mlcomment>"*"+"/"        BEGIN(INITIAL);   

"//"			  BEGIN(slcomment);
<slcomment>[^\n]
<slcomment>[\n]		  line_num++;


"\"\"\""                  { BEGIN(string2);printf("%d STRING_LIT \"\"\"",line_num);}
<string2>[\n]             line_num++;
<string2>^["]["]["]       printf("%s",yytext);
<string2><<EOF>>          { fprintf(stderr,"%d Syntax Error ; Incorrect end\n",line_num-1); BEGIN(INITIAL); return STRING_LIT;}
<string2>"\"\"\""         { printf("\"\"\"\n");  BEGIN(INITIAL); return STRING_LIT; }


["]                       { BEGIN(string1);printf("%d STRING_LIT \"\"",line_num); }
<string1>[\\][0btnrf"\\]  printf("%s",yytext);
<string1>[\\][^0btnrf"\\] { printf("%s",yytext); fprintf(stderr,"%d Syntax Error : Illegal escape code: \"%s\"; only \\\\, \\0, \\t, \\n, \\r, \\n are permitted\n",line_num,yytext); return STRING_LIT;}
<string1>[\n]          	  { printf("%s\"\n",yytext);line_num++; fprintf(stderr,"%d Syntax Error ; Multiline string is not permitted for single qoute\n",line_num-1); BEGIN(INITIAL); return STRING_LIT; }
<string1><<EOF>>          { printf("\n\""); BEGIN(INITIAL); return STRING_LIT;}
<string1>[^"]             printf("%s",yytext);
<string1>["]              {printf("\"\"\n"); BEGIN(INITIAL); return STRING_LIT; }

" "			  ;
.       		  { fprintf(stderr,"%d: unexpected character \n",line_num);}

%%

/* main program in bison file - quackParser.y */


