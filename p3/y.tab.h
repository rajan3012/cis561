/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 1
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    CLASS = 258,
    DEF = 259,
    EXTENDS = 260,
    IF = 261,
    ELIF = 262,
    ELSE = 263,
    WHILE = 264,
    RETURN = 265,
    ATLEAST = 266,
    ATMOST = 267,
    EQUALS = 268,
    AND = 269,
    OR = 270,
    NOT = 271,
    IDENT = 272,
    INT_LIT = 273,
    STRING_LIT = 274,
    TRI_STRING_LIT = 275,
    NEG = 276
  };
#endif
/* Tokens.  */
#define CLASS 258
#define DEF 259
#define EXTENDS 260
#define IF 261
#define ELIF 262
#define ELSE 263
#define WHILE 264
#define RETURN 265
#define ATLEAST 266
#define ATMOST 267
#define EQUALS 268
#define AND 269
#define OR 270
#define NOT 271
#define IDENT 272
#define INT_LIT 273
#define STRING_LIT 274
#define TRI_STRING_LIT 275
#define NEG 276

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 25 "quack.y" /* yacc.c:1909  */

  int intval;
  char *strval;

  r_expr_node			*reNode;
  l_expr_node			*leNode;

  program_node						*pNode;

  class_node							*cNode;
  class_sig_node					*csNode;
  class_body_node					*cbNode;
  list<class_node *>			*cNode_list;

  statement_node					*sNode;
 statement_block_node		*sbNode;
	list<statement_node *>	*sNode_list;
	list<method_node *>			*mNode_list;
	method_node							*mNode;
	vector < f_arg_pair * >	*f_arg_vector;

	list<r_expr_node *>			*argNode_list;
  elif_data								*elifNode;  

#line 121 "y.tab.h" /* yacc.c:1909  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
