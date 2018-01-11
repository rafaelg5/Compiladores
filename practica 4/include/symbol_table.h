#ifndef SYMBOL_TABLE_H
#define SYMBOL_TABLE_H

typedef struct symbol_table
{
  char* name;
  char* type;
  int scope;
  struct symbol_table* next;
}symbol_table;

#ifndef GLOBAL
  #define GLOBAL 0
#endif

#ifndef LOCAL
  #define LOCAL 1
#endif

#ifndef PARAMETER
  #define PARAMETER 2
#endif

symbol_table* insert(char*, char*, int);
symbol_table* lookup(char*);

#endif
