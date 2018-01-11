%{
#include <stdlib.h>
#include "../include/ast.h"
#include "../parser-output/parser.tab.h"

extern void yyerror(char*);
int commentDepth = 0;
%}
%x commentsc
%%
<commentsc>
{
\n                        ++yylineno;
"*/"                      { commentDepth--; if(commentDepth == 0)
                            BEGIN(INITIAL); }
"/*"                      commentDepth++;
"//"[^\n]*                ; /* Los comentarios de una línea tienen mayor
                            precedencia que los multilínea  */
<<EOF>>                   yyerror("Comentario sin cerrar");
[^*/\n]*                  ; // ignorar todo lo que no sea '*' o '/'
.                         ; // Ignorar cualquier otro caracter
}

[ \f\r\t\v]               ; // ignorar espacios en blanco
"/*"                      { commentDepth++; BEGIN(commentsc);}
\n                        ++yylineno;
"//"[^\n]*                ++yylineno; // ignorar comentarios de una sola línea

"<="                      return LTE;
"=="                      return EQ;
[-+/*()=<>!{}:;.,]        return *yytext;
class                     return CLASS;
inherits                  return INHERITS;
int                       { yylval.stringconst = strdup(yytext); return TYPE; }
boolean                   { yylval.stringconst = strdup(yytext); return TYPE; }
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
this                      { yylval.identifier = strdup(yytext); return ID; }
null                      return NULL_;
0|([1-9][0-9]*)           { yylval.intconst = atoi(yytext); return INTEGER; }
true                      { yylval.boolconst = 1; return TRUE_; }
false                     { yylval.boolconst = 0; return FALSE_; }

[A-Z][A-Za-z0-9_]*        { yylval.stringconst = strdup(yytext);
                                     return TYPE; }
[A-Za-z_][A-Za-z0-9_]*    { yylval.identifier = strdup(yytext);
                                     return ID; }

\"[^\"\n\0<<EOF>>]*\"     { yytext[strlen(yytext)-1]='\0';
                            yylval.stringconst = strdup(yytext+1);
                            return STRING; }

.                         { yyerror("Caracter inválido"); }
%%

int yywrap(void) {
 return 1;
}
