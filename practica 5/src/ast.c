#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>
#include "../include/ast.h"

#define NEW(type) (type*)Malloc(sizeof(type))

void* Malloc(unsigned n) {
  void* p;
  if (!(p = malloc(n))) {
     fflush(stderr);
     abort();
   }

   return p;
}

/* Funciones para crear los nodos del árbol */

Program* make_program(Class* classes) {
  Program* p = NEW(Program);
  p->classes = classes;
  return p;
}

Class* make_class(char* type, char* super, Feature* feats) {
  Class* p = NEW(Class);
  p->name = type;
  p->super = super;
  p->features = feats;
  p->next = NULL;
  return p;
}

Feature* make_feature_attribute(Attribute* att) {
  Feature* p = NEW(Feature);
  p->kind = attribute_k;
  p->val.attribute_t = att;
  p->next = NULL;
  return p;
}

Feature* make_feature_method(Method* meth) {
  Feature* p = NEW(Feature);
  p->kind = method_k;
  p->val.method_t = meth;
  p->next = NULL;
  return p;
}

Attribute* make_attribute(char* type, char* id, Expr* exp) {
  Attribute* p = NEW(Attribute);
  p->name = id;
  p->type = type;
  p->expression = exp;
  return p;
}

Method* make_method(char* type, char* id, Formal* forms, Expr* exp, Expr* ret) {
  Method* p = NEW(Method);
  p->name = id;
  p->type = type;
  p->formals = forms;
  p->expression = exp;
  p->return_ = ret;
  return p;
}

Formal* make_formal(char* type, char* id) {
  Formal* p = NEW(Formal);
  p->name = id;
  p->type = type;
  p->next = NULL;
  return p;
}

Value* make_value(char* id) {
  Value* p = NEW(Value);
  p->kind = idK;
  p->val.idL = id;
  return p;
}

Expr* make_expr_value(Value* val) {
  Expr* p = NEW(Expr);
  p->type = NULL;
  p->kind = valK;
  p->val.valE = val;
  p->next = NULL;
  return p;
}

Expr* make_expr_intconst(int value) {
  Expr* p = NEW(Expr);
  p->type = NULL;
  p->kind = intconstK;
  p->val.intconstE = value;
  p->next = NULL;
  return p;
}

Expr* make_expr_boolconst(int value) {
  Expr* p = NEW(Expr);
  p->type = NULL;
  p->kind = boolconstK;
  p->val.boolconstE = value;
  p->next = NULL;
  return p;
}

Expr* make_expr_stringconst(char* value) {
  Expr* p = NEW(Expr);
  p->type = NULL;
  p->kind = stringconstK;
  p->val.stringconstE = value;
  p->next = NULL;
  return p;
}

Expr* make_expr_nullconst(char* value) {
  Expr* p = NEW(Expr);
  p->type = NULL;
  p->kind = nullconstK;
  p->val.nullconstE = value;
  p->next = NULL;
  return p;
}

Expr* make_expr_assignment(Value* lval, Expr* right) {
  Expr* p = NEW(Expr);
  p->type = NULL;
  p->kind = assignmentK;
  p->val.assignmentE.left = lval;
  p->val.assignmentE.right = right;
  p->next = NULL;
  return p;
}

Expr* make_expr_method_call(Expr* expr, Value* val, Expr* args) {
  Expr* p = NEW(Expr);
  p->type = NULL;
  p->kind = method_callK;
  p->val.method_callE.id = val;
  p->val.method_callE.exp = expr;
  p->val.method_callE.args = args;
  p->next = NULL;
  return p;
}

Expr* make_expr_if(Expr* cond, Expr* body) {
  Expr* p = NEW(Expr);
  p->type = NULL;
  p->kind = ifK;
  p->val.ifE.condition = cond;
  p->val.ifE.body = body;
  p->next = NULL;
  return p;
}

Expr* make_expr_if_else(Expr* cond, Expr* body, Expr* else_) {
  Expr* p = NEW(Expr);
  p->type = NULL;
  p->kind = ifelseK;
  p->val.ifelseE.condition = cond;
  p->val.ifelseE.body = body;
  p->val.ifelseE.else_ = else_;
  p->next = NULL;
  return p;
}

Expr* make_expr_while(Expr* cond, Expr* body) {
  Expr* p = NEW(Expr);
  p->type = NULL;
  p->kind = whileK;
  p->val.whileE.condition = cond;
  p->val.whileE.body = body;
  p->next = NULL;
  return p;
}

Expr* make_expr_switch(Value* cond, Case* cases) {
  Expr* p = NEW(Expr);
  p->type = NULL;
  p->kind = switchK;
  p->val.switchE.condition = cond;
  p->val.switchE.cases = cases;
  p->next = NULL;
  return p;
}

Expr* make_expr_switch_def(Value* cond, Case* cases, Expr* default_) {
  Expr* p = NEW(Expr);
  p->type = NULL;
  p->kind = switchdefK;
  p->val.switchdefE.condition = cond;
  p->val.switchdefE.cases = cases;
  p->val.switchdefE.def = default_;
  p->next = NULL;
  return p;
}

Expr* make_expr_plus(Expr* e1, Expr* e2) {
  Expr* p = NEW(Expr);
  p->type = NULL;
  p->kind = plusK;
  p->val.plusE.left = e1;
  p->val.plusE.right = e2;
  p->next = NULL;
  return p;
}

Expr* make_expr_minus(Expr* e1, Expr* e2) {
  Expr* p = NEW(Expr);
  p->type = NULL;
  p->kind = minusK;
  p->val.minusE.left = e1;
  p->val.minusE.right = e2;
  p->next = NULL;
  return p;
}

Expr* make_expr_mult(Expr* e1, Expr* e2) {
  Expr* p = NEW(Expr);
  p->type = NULL;
  p->kind = multK;
  p->val.multE.left = e1;
  p->val.multE.right = e2;
  p->next = NULL;
  return p;
}

Expr* make_expr_div(Expr* e1, Expr* e2) {
  Expr* p = NEW(Expr);
  p->type = NULL;
  p->kind = divK;
  p->val.divE.left = e1;
  p->val.divE.right = e2;
  p->next = NULL;
  return p;
}

Expr* make_expr_less(Expr* e1, Expr* e2) {
  Expr* p = NEW(Expr);
  p->type = NULL;
  p->kind = lessK;
  p->val.lessE.left = e1;
  p->val.lessE.right = e2;
  p->next = NULL;
  return p;
}

Expr* make_expr_lte(Expr* e1, Expr* e2) {
  Expr* p = NEW(Expr);
  p->type = NULL;
  p->kind = lteK;
  p->val.lteE.left = e1;
  p->val.lteE.right = e2;
  p->next = NULL;
  return p;
}

Expr* make_expr_equals(Expr* e1, Expr* e2) {
  Expr* p = NEW(Expr);
  p->type = NULL;
  p->kind = equalsK;
  p->val.equalsE.left = e1;
  p->val.equalsE.right = e2;
  p->next = NULL;
  return p;
}

Expr* make_expr_not(Expr* e) {
  Expr* p = NEW(Expr);
  p->type = NULL;
  p->kind = notK;
  p->val.notE.exp = e;
  p->next = NULL;
  return p;
}

Case* make_case(int val, Expr* e) {
  Case* p = NEW(Case);
  p->val = val;
  p->case_ = e;
  p->next = NULL;
  return p;
}

static void indentprintf(int indent, const char *format, ...) {
  va_list argList;

  printf("%*s", indent*2, "");

  va_start(argList, format);
  vprintf(format, argList);
  va_end(argList);
}

/* Funciones para imprimir el ASA */

void pretty_program(Program* program) {
  printf("\nÁrbol de Sintaxis Abstracta:\n\n");
  pretty_class(1, program->classes);
  printf("\n");
}

void pretty_class(int indent, Class* classes) {
  if(classes->super == NULL)
    printf("%s {\n", classes->name);
  else
    printf("%s : %s {\n", classes->name, classes->super);


  if(classes->features != NULL)
    pretty_feature(indent, classes->features);

  printf("}\n");

  if(classes->next != NULL) {
    indentprintf(indent, "\n");
    pretty_class(indent, classes->next);
  }
}

void pretty_feature(int indent, Feature* features) {

  switch(features->kind){
    case attribute_k:
      pretty_attribute(indent, features->val.attribute_t);
      break;

    case method_k:
      pretty_method(indent, features->val.method_t);
      break;
  }

  if(features->next != NULL) {
    indentprintf(indent, "\n");
    pretty_feature(indent, features->next);
  }
}

void pretty_attribute(int indent, Attribute* att) {

  indentprintf(indent, "");
  if (att->expression == NULL)
    printf("id: %s; type: %s; expr: %s", att->name, att->type, "");
  else
    printf("id: %s; type:%s; expr: ", att->name, att->type);
    pretty_expr(indent, att->expression);
}

void pretty_method(int indent, Method* meth) {

  indentprintf(indent, "");
  printf("id: %s; type:%s; ", meth->name, meth->type);
  if(meth->formals != NULL) {
    printf("params: (");
    pretty_formal(indent, meth->formals);
    printf(")\n");
    indentprintf(indent, "");
    printf("{\n");
  }

  indentprintf(indent, " ");
  if (meth->expression != NULL){
    pretty_expr(indent, meth->expression);
  }
  printf(";");
  indentprintf(indent, "\n");
  indentprintf(indent, "");
  printf("}");
  indentprintf(indent, "\n");
}

void pretty_formal(int indent, Formal* params) {

  printf("id: %s; type:%s", params->name, params->type);

  if(params->next != NULL){
    printf(", ");
    pretty_formal(indent, params->next);
  }
}

void pretty_expr(int indent, Expr* exprs) {

  switch(exprs->kind) {
    case valK:
      printf("%s",exprs->val.valE->val.idL);
      break;
    case intconstK:
      printf("%d",exprs->val.intconstE);
      break;
    case boolconstK:
      if (exprs->val.boolconstE == 1)
        printf("true");
      else
        printf("false");
      break;
    case stringconstK:
      printf("\"%s\"", exprs->val.stringconstE);
      break;
    case nullconstK:
      printf("null");
    case assignmentK:
      printf("%s", exprs->val.assignmentE.left->val.idL);
      printf(" = ");
      pretty_expr(indent, exprs->val.assignmentE.right);
    break;
    case method_callK:
      if (exprs->val.method_callE.exp != NULL){
        pretty_expr(indent, exprs->val.method_callE.exp);
        printf(".");
      }
      printf("%s", exprs->val.method_callE.id->val.idL);
      printf("(");
      if (exprs->val.method_callE.args != NULL)
        pretty_expr(indent, exprs->val.method_callE.args);
      printf(")");
    break;
    case ifK:
      indentprintf(indent, "if (");
      pretty_expr(indent, exprs->val.ifE.condition);
      printf(") ");
      pretty_expr(indent, exprs->val.ifE.body);
    break;
    case ifelseK:
      indentprintf(indent, "if(");
      pretty_expr(indent, exprs->val.ifelseE.condition);
      printf(") ");
      pretty_expr(indent, exprs->val.ifelseE.body);
      indentprintf(indent, "else ");
      pretty_expr(indent, exprs->val.ifelseE.else_);
    break;
    case whileK:
      indentprintf(indent, "while(");
      pretty_expr(indent, exprs->val.whileE.condition);
      printf(") ");
      pretty_expr(indent, exprs->val.whileE.body);
    break;
    case switchK:
      indentprintf(indent, "switch(");
      printf("%s",exprs->val.valE->val.idL);
      printf(") ");
      if(exprs->val.switchE.cases != NULL)
        pretty_case(indent, exprs->val.switchE.cases);
    break;
    case switchdefK:
      indentprintf(indent, "switch(");
      printf("%s",exprs->val.valE->val.idL);
      printf(") ");
      if(exprs->val.switchdefE.cases != NULL)
        pretty_case(indent, exprs->val.switchdefE.cases);
      indentprintf(indent, "default: ");
      if(exprs->val.switchdefE.def != NULL)
        pretty_expr(indent, exprs->val.switchdefE.def);
    break;
    case plusK:
      printf("(");
      pretty_expr(indent, exprs->val.plusE.left);
      printf("+");
      pretty_expr(indent, exprs->val.plusE.right);
      printf(")");
    break;
    case minusK:
      printf("(");
      pretty_expr(indent, exprs->val.minusE.left);
      printf("-");
      pretty_expr(indent, exprs->val.minusE.right);
      printf(")");
    break;
    case multK:
      printf("(");
      pretty_expr(indent, exprs->val.multE.left);
      printf("*");
      pretty_expr(indent, exprs->val.multE.right);
      printf(")");
    break;
    case divK:
      printf("(");
      pretty_expr(indent, exprs->val.divE.left);
      printf("/");
      pretty_expr(indent, exprs->val.divE.right);
      printf(")");
    break;
    case lessK:
      printf("(");
      pretty_expr(indent, exprs->val.lessE.left);
      printf("<");
      pretty_expr(indent, exprs->val.lessE.right);
      printf(")");
    break;
    case lteK:
      printf("(");
      pretty_expr(indent, exprs->val.lteE.left);
      printf("<=");
      pretty_expr(indent, exprs->val.lteE.right);
      printf(")");
    break;
    case equalsK:
      printf("(");
      pretty_expr(indent, exprs->val.equalsE.left);
      printf("==");
      pretty_expr(indent, exprs->val.equalsE.right);
      printf(")");
    break;
    case notK:
      printf("!");
      pretty_expr(indent, exprs->val.notE.exp);
    break;
  }
  if(exprs->next != NULL) {
    printf(";");
    indentprintf(indent, "\n");
    indentprintf(indent, "");
    pretty_expr(indent, exprs->next);
  }
}

void pretty_case(int indent, Case* cases) {

  printf("case %d: ", cases->val);
  pretty_expr(indent, cases->case_);

  if(cases->next != NULL) {
    printf(";");
    indentprintf(indent, "");
    pretty_case(indent, cases->next);
  }
}
