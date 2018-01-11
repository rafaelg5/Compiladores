#include "../include/symbol_table.h"

#ifndef AST_H
#define AST_H

/* Definiciones para tipos de los nodos del ASA */

typedef struct program_s Program ;
typedef struct class_s Class;
typedef struct feature_s Feature;
typedef struct attribute_s Attribute;
typedef struct method_s Method;
typedef struct formal_s Formal;
typedef struct value_s Value;
typedef struct expr_s Expr;
typedef struct case_s Case;

struct program_s {
  Class* classes;
};


struct class_s {
  char* name;
  char* super;
  Feature* features;
  Class* next;
};

struct feature_s {
  enum {attribute_k, method_k} kind;

  union {
    Attribute* attribute_t;
    Method* method_t;
  } val;
  Feature* next;
};

struct attribute_s {
  char* name;
  char* type;

  Expr* expression;
};

struct method_s {
  char* name;
  char* type;

  Formal* formals;
  Expr* expression;
  Expr* return_;
};

struct formal_s {
  char* name;
  char* type;

  Formal* next;
};

struct value_s {
  symbol_table* symbol;
  enum {idK} kind;
  union {
    char* idL;
  } val;
};

struct expr_s {
  int lineno;
  char* type;

  enum {valK, intconstK, boolconstK, stringconstK, nullconstK,  method_callK,
        assignmentK, ifK, ifelseK, whileK, switchK, switchdefK, newK, plusK,
        minusK, multK, divK, lessK, lteK, equalsK, notK} kind;
  union {

    Value* valE;
    int intconstE;
    int boolconstE;
    char* stringconstE;
    char* nullconstE;

    struct {
      Value* left;
      Expr* right;
    } assignmentE;

    struct {
      Value* id;
      Expr* exp;
      Expr* args;
    } method_callE;

    struct {
      Expr* condition;
      Expr* body;
    } ifE;

    struct {
      Expr* condition;
      Expr* body;
      Expr* else_;
    } ifelseE;

    struct {
      Expr* condition;
      Expr* body;
    } whileE;

    struct {
      Value* condition;
      Case* cases;
    } switchE;

    struct {
      Value* condition;
      Case* cases;
      Expr* def;
    } switchdefE;

    struct {
      Value* id;
      Expr* exp;
      Expr* args;
    } newE;

    struct {
      Expr* left;
      Expr* right;
    } plusE;

    struct {
      Expr* left;
      Expr* right;
    } minusE;

    struct {
      Expr* left;
      Expr* right;
    } multE;

    struct {
      Expr* left;
      Expr* right;
    } divE;

    struct {
      Expr* left;
      Expr* right;
    } lessE;

    struct {
      Expr* left;
      Expr* right;
    } lteE;

    struct {
      Expr* left;
      Expr* right;
    } equalsE;

    struct {
      Expr* exp;
    } notE;

  } val;
  Expr* next;
};

struct case_s {
  int val;
  Expr* case_;
  Case* next;
};

Program* make_program(Class*);

Class* make_class(char*, char*, Feature*);

Feature* make_feature_attribute(Attribute*);
Feature* make_feature_method(Method*);

Attribute* make_attribute(char*, char*, Expr*);

Method* make_method(char*, char*, Formal*, Expr*, Expr*);

Formal* make_formal(char*, char*);

Value* make_value(char*);

Expr* make_expr_value(Value*);
Expr* make_expr_intconst(int);
Expr* make_expr_boolconst(int);
Expr* make_expr_stringconst(char*);
Expr* make_expr_nullconst(char*);
Expr* make_expr_assignment(Value*, Expr*);
Expr* make_expr_method_call(Expr*, Value*, Expr*);
Expr* make_expr_if(Expr*, Expr*);
Expr* make_expr_if_else(Expr*, Expr*, Expr*);
Expr* make_expr_while(Expr*, Expr*);
Expr* make_expr_switch(Value*, Case*);
Expr* make_expr_switch_def(Value*, Case*, Expr*);
Expr* make_expr_plus(Expr*, Expr*);
Expr* make_expr_minus(Expr*, Expr*);
Expr* make_expr_mult(Expr*, Expr*);
Expr* make_expr_div(Expr*, Expr*);
Expr* make_expr_less(Expr*, Expr*);
Expr* make_expr_lte(Expr*, Expr*);
Expr* make_expr_equals(Expr*, Expr*);
Expr* make_expr_not(Expr*);

Case* make_case(int val, Expr* e);

void pretty_program(Program*);
void pretty_class(int, Class*);
void pretty_feature(int, Feature*);
void pretty_attribute(int, Attribute*);
void pretty_method(int, Method*);
void pretty_formal(int, Formal*);
void pretty_expr(int, Expr*);
void pretty_case(int, Case*);

#endif
