%{
  #include "symbol.h"
  int line = 0;
%}

DIGIT [0-9]
ID [_A-Za-z][_A-Za-z0-9]*
OPERATORS "<-"|"("|")"|"."|"+"|"-"|"*"|"/"|"~"|"="|"<"|":"|";"|"{"|"}"|"<="
%option noyywrap
%x comment
%x string
%%

class|if|then|else|while|do|od|case|of|new|is|void|not|true|false {
  fprintf(yyout, "%d", RESERVED);
}

\n {line++;}

{DIGIT}+  fprintf(yyout, "%d", INTEGER);

{ID} fprintf(yyout, "%d", ID);

"/*" BEGIN(comment);
<comment>[^*\n]*
<comment>"*"+[^*/\n]*
<comment>"*"+"/" {BEGIN(INITIAL); fprintf(yyout, "%d", COMMENT);}

\" BEGIN(string);
<string>[^\"\0<<EOF>>\n]*
<string>\" {BEGIN(INITIAL); fprintf(yyout, "%d", STRING);}

"//".* fprintf(yyout, "%d", COMMENT);

{OPERATORS} fprintf(yyout, "%d", OPERATOR);

[ \n\f\r\t\v] fprintf(yyout, "%d", BLANK);

. {fprintf(yyout, "%s", yytext);
  printf("Unknown symbol: %s at line %d\n", yytext, line + 1);}

%%

int main(int argc, char** argv)
{
  yyin = fopen(argv[1], "r");
  yyout = fopen(argv[2], "w");
  yylex();
  fclose(yyin);
  fclose(yyout);
}
