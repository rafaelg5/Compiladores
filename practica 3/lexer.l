%{
#include "parser.tab.h"
#include <stdio.h>

int lineno = 1;
void lex_error(char*);

int commentDepth = 0;
%}
%x commentsc
%%
<commentsc>
{
\n                        lineno++;
"*/"                      { commentDepth--; if(commentDepth == 0)
                            BEGIN(INITIAL); }
"/*"                      commentDepth++;
"//"[^\n]*                ; /* Los comentarios de una línea tienen mayor
                            precedencia que los multilínea  */
<<EOF>>                   lex_error("Comentario sin cerrar");
[^*/\n]*                  ; // ignorar todo lo que no sea '*' o '/'
.                         ; // Ignorar cualquier otro caracter
}

[ \f\r\t\v]               ; // ignorar espacios en blanco
"/*"                      { commentDepth++; BEGIN(commentsc);}
\n                        lineno++;
"//"[^\n]*                ; // ignorar comentarios de una sola línea

"<="                      return LTE;
"=="                      return EQ;
"="                       return '=';
">"                       return '>';
"<"                       return '<';
"!"                       return '!';
"+"                       return '+';
"-"                       return '-';
"*"                       return '*';
"/"                       return '/';
"{"                       return '{';
"}"                       return '}';
":"                       return ':';
";"                       return ';';
"("                       return '(';
")"                       return ')';
","                       return ',';
"."                       return '.';
class                     return CLASS;
inherits                  return INHERITS;
int                       return INT;
boolean                   return BOOLEAN;
return                    return RETURN;
new                       return NEW;
if                        return IF;
else                      return ELSE;
while                     return WHILE;
switch                    return SWITCH;
case                      return CASE;
break                     return BREAK;
default                   return DEFAULT;
super                     return SUPER;
this                      return ID;
0|([1-9][0-9]*)           { yylval.intconst = atoi(yytext); return INTEGER; }
true                      { yylval.boolconst = 1; return BOOLEAN; }
false                     { yylval.boolconst = 0; return BOOLEAN; }

[A-Za-z_][A-Za-z0-9_]*    { yylval.identifier = strdup(yytext);
                                     return ID; }

\"[^\"\n\0<<EOF>>]*\"     { yytext[strlen(yytext)-1]='\0';
                            yylval.stringconst = strdup(yytext+1);
                            return STRING; }

.                         lex_error("Caracter inválido");

%%

void lex_error (char* s) {
  fprintf(stderr, "%s : '%s'\n", s, yytext);
  exit(1);
}
