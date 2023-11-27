%{
#include <stdio.h>
#include "y.tab.h"
%}

%option noyywrap

%%
"programa"       { return PROGRAMA; }
"constante"      { return CONSTANTE; }
"tipo"           { return TIPO; }
"variable"       { return VARIABLE; }
"enteros"        { return ENTEROS; }
"real"           { return REAL; }
"booleano"       { return BOOLEANO; }
"caracter"       { return CARACTER; }
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
[a-zA-Z][a-zA-Z0-9]* { return IDENTIFICADOR; }
[0-9]+           { return ENTERO; }
[0-9]+,[0-9]+    { return DECIMAL; }
[0-9]+,[0-9]+?E[+-]?[0-9]+ { return EXPONENCIAL; }
[ \t\r\n]+       { /* ignorar espacios en blanco */ }
.                { /* ignorar otros caracteres */ }
%%