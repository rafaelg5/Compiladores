%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "../include/symbol_table.h"
#include "../include/ast.h"

extern int yylex();
extern int yylineno;
extern int yytext;

int errors = 0;
void yyerror(char*);
void install (char* sym_name, char* type, int scope);
void context_check(char* sym_name);


Program* root;

%}
%start program

%union{

  Program* program;
  Class* class_;
  Feature* feature;
  Attribute* attribute;
  Method* method;
  Formal* formal;
  Expr* expr;
  Case* case_;

  int intconst;
  int boolconst;
  char* identifier;
  char* stringconst;
  char* null;
}

%token
CLASS INHERITS BOOLEAN INT RETURN NEW IF WHILE SWITCH CASE BREAK
DEFAULT SUPER LTE EQ NULL_

%token <intconst> INTEGER
%token <stringconst> TYPE STRING
%token <boolconst> FALSE_ TRUE_
%token <identifier> ID
%token <null> NULL_

%nonassoc IFX
%nonassoc ELSE
%right '='
%nonassoc '!'
%nonassoc LTE '<' EQ
%left '+' '-'
%left '*' '/'
%nonassoc '.'
%left '(' ')'

%type <program> program;
%type <class_> class class_list;
%type <feature> feature feature_list;
%type <attribute> attribute;
%type <method> method;
%type <formal> formal formal_list;
%type <expr> expr expr_list exprs method_call;
%type <case_> case_list;

%%
program:
        class_list { root = make_program($1); };

class:
        CLASS TYPE '{' feature_list '}' { $$ = make_class($2, NULL, $4); }
      | CLASS TYPE INHERITS TYPE '{' feature_list '}'
        { $$ = make_class($2, $4, $6); }
      ;

class_list:
        class { $$ = $1; }
      | class class_list {$$ = $1; $$->next = $2;}

feature_list:
        feature feature_list {$$ = $1; $$->next = $2; }
      | /* epsilon */ { $$ = NULL; }
      ;

feature:
        attribute { $$ = make_feature_attribute($1); }
      | method { $$ = make_feature_method($1); }
      ;

attribute:
        TYPE ID ';' { install($2, $1, GLOBAL); $$ = make_attribute($1, $2, NULL); }
      | TYPE ID '=' expr ';' { install($2, $1, GLOBAL); $$ = make_attribute($1, $2, $4); }
      ;

method:
        TYPE ID '(' formal_list ')' '{' expr_list RETURN expr ';' '}'
        { install($2, $1, GLOBAL); $$ = make_method($1, $2, $4, $7, $9); }
      ;

formal_list:
        formal { $$ = $1; }
      | formal ',' formal_list { $$ = $1; $$->next = $3; }
      | /* epsilon */ { $$ = NULL; }
      ;

formal: TYPE ID { install($2, $1, PARAMETER); $$ = make_formal($1, $2); };

expr_list:
        expr ';' expr_list { $$ = $1; $$->next = $3; }
      | /* epsilon */ { $$ = NULL; }
      ;

exprs:
        expr { $$ = $1; }
      | expr ',' exprs { $$ = $1; $$->next = $3; }
      | /* epsilon */ { $$ = NULL; }
      ;

expr:
        ID '=' expr
        { context_check($1); $$ = make_expr_assignment(make_value($1), $3); }
      | expr '.' ID '(' exprs ')'
      { context_check($3); $$ = make_expr_method_call($1, make_value($3), $5); }
      | expr '.' SUPER '.' ID '(' exprs ')'
      { context_check($5); $$ = make_expr_method_call($1, make_value($5), $7); }
      | ID '(' exprs ')'
      { context_check($1); $$ = make_expr_method_call(NULL, make_value($1), $3);}
      | IF '(' expr ')' '{' expr_list '}' %prec IFX
      { $$ = make_expr_if($3, $6); }
      | IF '(' expr ')' '{' expr_list '}' ELSE '{' expr_list '}'
      { $$ = make_expr_if_else($3, $6, $10); }
      | WHILE '(' expr ')' '{' expr_list '}' { $$ = make_expr_while($3, $6); }
      | SWITCH '(' ID ')' '{' case_list '}'
      { context_check($3); $$ = make_expr_switch(make_value($3), $6); }
      | SWITCH '(' ID ')' '{' case_list DEFAULT ':' expr_list'}'
        { context_check($3); $$ = make_expr_switch_def(make_value($3), $6, $9); }
      | NEW TYPE
      | expr '+' expr { $$ = make_expr_plus($1, $3); }
      | expr '-' expr { $$ = make_expr_minus($1, $3); }
      | expr '*' expr { $$ = make_expr_mult($1, $3); }
      | expr '/' expr { $$ = make_expr_div($1, $3); }
      | expr '<' expr { $$ = make_expr_less($1, $3); }
      | expr LTE expr { $$ = make_expr_lte($1, $3); }
      | expr EQ expr { $$ = make_expr_equals($1, $3); }
      | '!' expr { $$ = make_expr_not($2); }
      | '(' expr ')' { $$ = $2; }
      | ID { context_check($1); $$ = make_expr_value(make_value($1)); }
      | INTEGER { $$ = make_expr_intconst($1); }
      | STRING { $$ = make_expr_stringconst($1); }
      | TRUE_ { $$ = make_expr_boolconst($1); }
      | FALSE_ { $$ = make_expr_boolconst($1); }
      | NULL_ { $$ = make_expr_nullconst($1); }
      ;

case_list:
        CASE INTEGER ':' expr_list BREAK ';' case_list
        { $$ = make_case($2, $4); $$->next = $7;  }
      | /* epsilon */ { $$ = NULL; }
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

  pretty_program(root);

  fclose(yyin);
  fclose(yyout);
}
