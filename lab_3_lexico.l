%{
#include <stdio.h>
#include "y.tab.h"
%}

%option noyywrap
%option yylineno

%%
"programa"       { return PROGRAMA; }
"constante"      { return CONSTANTE; }
"tipo"           { return TIPO; }
"variable"       { return VARIABLE; }
"entero"         { return ENTERO; }
"real"           { return REAL; }
"booleano"       { return BOOLEANO; }
"procedimiento"  { return PROCEDIMIENTO; }
"adelante"       { return ADELANTE; }
"funcion"        { return FUNCION; }
"inicio"         { return INICIO; }
"fin"            { return FIN; }
"si"             { return SI; }
"entonces"       { return ENTONCES; }
"sino"           { return SINO; }
"caso"           { return CASO; }
"de"             { return DE; }
"mientras"       { return MIENTRAS; }
"hacer"          { return HACER; }
"para"           { return PARA; }
"a"              { return A; }
"abajo"          { return ABAJO; }
"repetir"        { return REPETIR; }
"hasta"          { return HASTA; }
"o"              { return O; }
"dividir"        { return DIVIDIR; }
"modulo"         { return MODULO; }
"y"              { return Y; }
"no"             { return NO; }
\;               { return ';';}
\.               { return '.';}
\=               { return '=';}
\:               { return ':';}
\,               { return ',';}
\+               { return '+';}
\-               { return '-';}

\(               { return '(';}
\)               { return ')';}
\<               { return '<';}
\>               { return '>';}
\*               { return '*';}
\/               { return '/';}
\..              { return RANGO;}
\:=              { return ASIGNACION;}
\<=              { return MENOR_IGUAL;}
\<>              { return DISTINTO;}
\>=              { return MAYOR_IGUAL;}

([a-z]|[A-Z])([a-z]|[A-Z]|[0-9])* { return IDENTIFICADOR; }
[0-9]+           { return ENTEROS; }
([0-9]+)(,[0-9]+)    { return DECIMAL; }
([0-9]+)(,[0-9]+)?E(\+|\-)?([0-9]+) { return EXPONENCIAL; }
[ \t\r\n]+       { /* ignorar espacios en blanco */ }
%%