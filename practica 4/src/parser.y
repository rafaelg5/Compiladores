%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "../include/symbol_table.h"

extern int yylex();
extern int yylineno;
extern int yytext;

int errors = 0;
void yyerror(char*);
void install (char* sym_name, char* type, int scope);
void context_check(char* sym_name);
%}

%union{
  int intconst;
  int boolconst;
  char* identifier;
  char* stringconst;
}

%start program
%token
CLASS INHERITS BOOLEAN INT RETURN NEW IF WHILE SWITCH CASE BREAK
DEFAULT SUPER LTE EQ NULL_

%token <intconst> INTEGER
%token <stringconst> TYPE STRING
%token <boolconst> FALSE_ TRUE_
%token <identifier> ID

%nonassoc IFX
%nonassoc ELSE

%right '='
%left EQ
%nonassoc LTE '<'
%left '+' '-'
%left '*' '/'
%nonassoc '!'
%left '(' ')' '.'

%%
program:
        class
      | program class
      ;

class:
        CLASS TYPE '{' feature_list '}'
      | CLASS TYPE INHERITS TYPE '{' feature_list '}'
      ;

feature_list:
        feature_list feature
      | /* epsilon */
      ;

feature:
        attribute
      | method
      ;

attribute:
        TYPE ID ';' { install($2, $1, GLOBAL); }
      | TYPE ID '=' expr ';' { install($2, $1, GLOBAL); }
      ;

method:
        TYPE ID '(' formal_list')' '{' expr_list RETURN expr ';' '}'
        { install($2, $1, GLOBAL); }
      ;

formal_list:
        formal
      | formal_list ',' formal
      | /* epsilon */
      ;

formal: TYPE ID { install($2, $1, PARAMETER); }

expr_list:
        expr_list expr ';'
      | /* epsilon */
      ;

expr:
        ID '=' expr { context_check($1); }
      | method_call
      | IF '(' expr ')' '{' expr_list '}' %prec IFX
      | IF '(' expr ')' '{' expr_list '}' ELSE '{' expr_list '}'
      | WHILE '(' expr ')' '{' expr_list '}'
      | SWITCH '(' ID ')' '{' case_list '}' { context_check($3); }
      | SWITCH '(' ID ')' '{' case_list DEFAULT ":" expr_list'}'
        { context_check($3); }
      | NEW TYPE
      | expr '+' expr
      | expr '-' expr
      | expr '*' expr
      | expr '/' expr
      | expr '<' expr
      | expr LTE expr
      | expr EQ expr
      | '!' expr
      | '(' expr ')'
      | ID { context_check($1); }
      | INTEGER
      | STRING
      | TRUE_
      | FALSE_
      | NULL_
      ;

method_call:
        expr "." ID '(' formal_list ')' { context_check($3); }
      | ID '(' formal_list ')' { context_check($1); }
      | expr "." SUPER "." ID '(' formal_list ')' { context_check($5); }
      ;

case_list:
        case_list CASE INTEGER ":" expr_list BREAK ';'
      | /* epsilon */
      ;
%%


void yyerror(char *s)
{
  errors++;
  fprintf(stderr, "línea %d: %s <%s>\n", yylineno, s, yytext);
}

void install (char* sym_name, char* type, int scope)
{
  symbol_table* s;
  s = lookup(sym_name);

  if (s == NULL){
    s = insert(sym_name, type, scope);
  } else {
    errors++;
    printf("línea %d: El identificador '%s' ya está definido\n", yylineno, sym_name);
  }
}

void context_check(char* sym_name)
{
  if (lookup(sym_name) == NULL) {
    printf("El identificador '%s' no está declarado\n", sym_name);
  }
}

int main(int argc, char* argv[])
{

	extern FILE* yyin;
  yyin = fopen(argv[1], "r");
  extern FILE* yyout;
  yyout = fopen(argv[2], "w");
  yyparse();
  if(errors > 0){
    if(errors == 1){
      printf("1 error\n");
    } else {
      printf("%d errores\n", errors);
    }
    exit(1);
  }
  fclose(yyin);
  fclose(yyout);
}
