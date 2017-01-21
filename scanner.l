%{
#include  <stdio.h>

#include <iostream>

using namespace std;
#define YY_DECL extern "C" int yylex()
int line_num = 1;
%}


%x mlcomment
%x slcomment
%x string1
%x string2
%%

"class"                   { printf("%d CLASS \"%s\"\n",line_num,yytext);}
"def"                     { printf("%d DEF \"%s\"\n",line_num,yytext);}
"extends"                 { printf("%d EXTENDS \"%s\"\n",line_num,yytext);}
"if"                      { printf("%d IF \"%s\"\n",line_num,yytext);}
"elif"                    { printf("%d ELIF \"%s\"\n",line_num,yytext);}
"else"                    { printf("%d ELSE \"%s\"\n",line_num,yytext);}
"while"                   { printf("%d WHILE \"%s\"\n",line_num,yytext);}
"return"                  { printf("%d RETURN \"%s\"\n",line_num,yytext);}
"String"                  { printf("%d STRING \"%s\"\n",line_num,yytext);}
"Integer"                 { printf("%d INTEGER \"%s\"\n",line_num,yytext);}
"Obj"                     { printf("%d OBJ \"%s\"\n",line_num,yytext);}
"Boolean"                 { printf("%d BOOLEAN \"%s\"\n",line_num,yytext);}
"true"                    { printf("%d TRUE \"%s\"\n",line_num,yytext);}
"false"                                   { printf("%d FALSE \"%s\"\n",line_num,yytext);}
"Nothing"                                 { printf("%d NOTHING \"%s\"\n",line_num,yytext);}
"none"                                    { printf("%d NONE \"%s\"\n",line_num,yytext);}


"="                       { printf("%d ASSIGN \"%s\"\n",line_num,yytext);}
"+"                       { printf("%d PLUS \"%s\"\n",line_num,yytext);}
"-"                       { printf("%d MINUS \"%s\"\n",line_num,yytext);}
"*"                       { printf("%d TIMES \"%s\"\n",line_num,yytext);}
"/"                       { printf("%d DIVIDE \"%s\"\n",line_num,yytext);}

"=="                      { printf("%d EQUALS \"%s\"\n",line_num,yytext);}
"<="                      { printf("%d ATMOST \"%s\"\n",line_num,yytext);}
">="                      { printf("%d ATLEAST \"%s\"\n",line_num,yytext);}
"<"                       { printf("%d LESS \"%s\"\n",line_num,yytext);}
">"                       { printf("%d MORE \"%s\"\n",line_num,yytext);}

"and"                     { printf("%d AND \"%s\"\n",line_num,yytext);}
"or"                      { printf("%d OR \"%s\"\n",line_num,yytext); }
"not"                     { printf("%d NOT \"%s\"\n",line_num,yytext);}

"("                       { printf("%d ( \"%s\"\n",line_num,yytext); }
")"                       { printf("%d ) \"%s\"\n",line_num,yytext);}
"{"                       { printf("%d { \"%s\"\n",line_num,yytext);}
"}"                       { printf("%d } \"%s\"\n",line_num,yytext);}
";"                       { printf("%d ; \"%s\"\n",line_num,yytext);}
","                       { printf("%d , \"%s\"\n",line_num,yytext);}
"."                       { printf("%d . \"%s\"\n",line_num,yytext);}
":"                       { printf("%d : \"%s\"\n",line_num,yytext);}

[0-9]+                    { printf("%d INTEGER_LIT \"%s\"\n",line_num,yytext);}


[a-zA-Z0-9]+              { printf("%d IDENT \"%s\"\n",line_num,yytext); }
\n                        { ++line_num;
                                                         printf("%d STRING_LIT \"%s\"\n",line_num,yytext);}


"/*"                      BEGIN(mlcomment); 
<mlcomment><<EOF>>      fprintf(stderr,"%d: Syntax Error ; Multiline has been started but has not been ended at end of the file. Program Exiting\n",line_num);BEGIN(INITIAL);
<mlcomment>[^*\n]*        /* eat anything that's not a '*' */
<mlcomment>"*"+[^*/\n]*   /* eat up '*'s not followed by '/'s */
<mlcomment>[\n]*           ++line_num;
<mlcomment>"*"+"/"        BEGIN(INITIAL);   

"//"			  BEGIN(slcomment);
<slcomment>[^\n]
<slcomment>[\n]		  line_num++;

"\"\"\""                BEGIN(string2);printf("%d  STRING_LIT \"\"\"",line_num);
<string2>[\n]          line_num++;
<string2>^["]["]["]    printf("%s",yytext);
<string2><<EOF>>       fprintf(stderr,"%d: Syntax Error ; Incorrect end\n",line_num-1);BEGIN(INITIAL);
<string2>"\"\"\""      printf("\"\"\"\n");BEGIN(INITIAL);


["]                     BEGIN(string1);printf("%d  STRING_LIT \"\"",line_num);
<string1>[\\][0btnrf"\\]   printf("%s",yytext);
<string1>[\\][^0btnrf"\\]  printf("%s",yytext);fprintf(stderr,"%d: Syntax Error : Illegal escape code: \"%s\"; only \\\\, \\0, \\t, \\n, \\r, \\n are permitted\n",line_num,yytext);
<string1>[\n]          printf("%s\"\n",yytext);line_num++; fprintf(stderr,"%d: Syntax Error ; Multiline string is not permitted for single qoute\n",line_num-1);BEGIN(INITIAL);
<string1><<EOF>>       printf("\n\"");BEGIN(INITIAL);
<string1>[^"]          printf("%s",yytext);
<string1>["]           printf("\"\"\n");BEGIN(INITIAL);

.       ;

%%
int main(int argc, char* argv[]) {

        // open a file handle to a particular file:
        FILE *myfile = fopen(argv[1], "r");
        // make sure it's valid:
        if (!myfile) {
                cout << "I can't open quack_example!" << endl;
                return -1;
        }
        // set lex to read from it instead of defaulting to STDIN:
        yyin = myfile;

        // lex through the input:
        yylex();
}

