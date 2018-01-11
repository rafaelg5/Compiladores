#include <stdlib.h>
#include <string.h>
#include "../include/symbol_table.h"
#include <stdio.h>

symbol_table* st = NULL;

symbol_table* insert(char* name, char* type, int scope)
{
  
  symbol_table* ptr = (symbol_table*)malloc(sizeof(symbol_table));
  ptr->name = (char*)malloc(strlen(name)+1);
  ptr->type = (char*)malloc(strlen(type)+1);
  ptr->scope = scope;

  strcpy (ptr->name, name);
  strcpy (ptr->type, type);
  ptr->next = (struct symbol_table*)st;
  st = ptr;
  return ptr;
}

symbol_table* lookup(char* name)
{
  symbol_table *ptr;
  for(ptr = st; ptr != (symbol_table*)0; ptr = (symbol_table*)ptr->next){
    if (strcmp(ptr->name,name) == 0){
      return ptr;
    }
  }
  return NULL;
}
