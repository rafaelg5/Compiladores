%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

extern int yylex();
extern int lineno;
extern FILE *yyin;
extern char* yytext;
void yyerror(const char* msg);

int errors = 0;

%}

%union{
  struct PROGRAM* program;
  struct CLASS* class;
  struct FEATURE_LIST* feature_list;
  struct FEATURE* feature;
  struct ATTRIBUTE* attribute;
  struct METHOD* method;

  int intconst;
  int boolconst;
  char* identifier;
  char* stringconst;
}
%start program
%token CLASS INHERITS INT RETURN NEW IF ELSE WHILE SWITCH CASE BREAK
%token DEFAULT SUPER LTE EQ

%token <intconst> INTEGER
%token <stringconst> STRING
%token <boolconst> BOOLEAN
%token <identifier> ID

%type <program> program;
%type <class> class;
%type <feature_list> feature_list;
%type <feature> feature;
%type <attribute> attribute;
%type <method> method;

%left ')'
%left ELSE
%left '='
%left '<' LTE EQ
%left '+' '-'
%left '*' '/'
%right '!'
%%
program:
        class
      | program class
      ;

class:
        CLASS type '{' feature_list '}'
      | CLASS type INHERITS type '{' feature_list '}'
      ;

feature_list:
      /* epsilon */
      | feature_list feature
      ;

feature:
        attribute
      | method
      ;

attribute:
        type ID
      | type ID '=' expr ';'
      ;

method:
        type ID '(' formal_list ')' '{' expr_list RETURN expr ';' '}'
      ;

formal_list:
      /* epsilon */
      | formal
      | formal_list ',' formal
      ;

formal: type ID ;

expr_list:
      /* epsilon */
      | expr_list expr
      ;

expr:
        ID '=' expr
      | method_call
      | IF '(' expr ')' '{' expr_list '}' ELSE '{' expr_list '}'
      | WHILE '(' expr ')' '{' expr_list '}'
      | SWITCH '(' ID ')' '{' case_list '}'
      | NEW type
      | expr '+' expr
      | expr '-' expr
      | expr '*' expr
      | expr '/' expr
      | expr '<' expr
      | expr LTE expr
      | expr EQ expr
      | '!' expr
      | ID
      | INTEGER
      | BOOLEAN
      | STRING
      ;

method_call:
        expr "." ID '(' formal_list ')'
      | ID '(' formal_list ')'
      | expr "." SUPER "." ID '(' expr ',' expr ')'
      ;

case_list:
      /* epsilon */
      | CASE type ":" expr_list BREAK ';' default_
      | case_list CASE type ":" expr_list BREAK ';' default_
      ;

default_:
      /* epsilon */
      | DEFAULT ":" expr_list
      ;

type:
        ID
      | INTEGER
      ;
%%

void yyerror(const char *s) {
  fprintf(stderr, "File.lol:%d: %s\n", lineno, yytext);
}

int main(int argc, char* argv[]){

	extern FILE* yyin;
  yyin = fopen(argv[1], "r");
  do{
    yyparse();
  }while (!feof(yyin));

  fclose(yyin);
}
