%{
#include "symbol.h"
#include <stdlib.h>
%}

P [&$(){}]
D [0-9]
DP [1-9]
L [a-z]
OP [=+*-^v~]

%%

"%".*                                 return COMMENT;

("n1"|"n2"|"si"|"eoc"|"dur")          return RESERVED;
[ \n\f\r\t\v]                         return BLANK;
{P}                                   return SEPARATOR;
{L}+                                  return ID;
(0|{DP}{D}*)                          return NUMBEr;
{OP}                                  return OPERATOR;

.                                     printf("error");
%%

int yywrap(void) {
 return 1;
}

int main(){
  yylex();
}
