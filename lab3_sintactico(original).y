%{
#include <stdio.h>
#include <stdlib.h>
extern int yylex();
extern FILE *yyin;
extern int yylineno; 
void yyerror(char *s);
%}

%token PROGRAMA CONSTANTE TIPO VARIABLE ENTERO REAL BOOLEANO PROCEDIMIENTO
%token FUNCION INICIO FIN SI ENTONCES SINO CASO DE MIENTRAS HACER PARA A ABAJO REPETIR HASTA O DIVIDIR MODULO Y NO
%token IDENTIFICADOR ENTEROS DECIMAL EXPONENCIAL MAYOR_IGUAL MENOR_IGUAL DISTINTO ASIGNACION

%left O Y
%right NO
%right ':' //revisar
%left '-' '+'
%left '/' '*' DIVIDIR MODULO RANGO

%% 
input: /*vacío*/
      | programa
;

programa: PROGRAMA IDENTIFICADOR ';' bloque '.'
| '(' programa_aux ')' ';' bloque '.'
;

programa_aux: IDENTIFICADOR
| IDENTIFICADOR ',' programa_aux
;

bloque: bloque_constante bloque_inicio
| bloque_tipo bloque_inicio
| bloque_variable bloque_inicio
| bloque_declaracion bloque_inicio
| bloque_constante bloque_tipo bloque_inicio
| bloque_constante bloque_variable bloque_inicio
| bloque_constante bloque_declaracion bloque_inicio
| bloque_constante bloque_tipo bloque_variable bloque_inicio
| bloque_constante bloque_tipo bloque_declaracion bloque_inicio
| bloque_constante bloque_variable bloque_declaracion bloque_inicio
| bloque_constante bloque_tipo bloque_variable bloque_declaracion bloque_inicio
| bloque_tipo bloque_variable bloque_inicio
| bloque_tipo bloque_declaracion bloque_inicio
| bloque_tipo bloque_variable bloque_declaracion bloque_inicio
| bloque_variable bloque_declaracion bloque_inicio
| bloque_inicio
;

bloque_constante: CONSTANTE bloque_constante_aux;

bloque_constante_aux: IDENTIFICADOR '=' constante ';' bloque_constante_aux
| IDENTIFICADOR '=' constante ';'
;

bloque_tipo: TIPO bloque_tipo_aux;

bloque_tipo_aux: IDENTIFICADOR '=' tipo ';' bloque_tipo_aux
| IDENTIFICADOR '=' tipo ';'
;

bloque_variable: VARIABLE bloque_variable_aux;

bloque_variable_aux: bloque_variable_auxDos ':' tipo ';' bloque_variable_aux
| bloque_variable_auxDos ':' tipo ';'
;

bloque_variable_auxDos: IDENTIFICADOR ',' bloque_variable_auxDos
| IDENTIFICADOR
;

bloque_declaracion: declaracion_procedimiento_funcion ';' IDENTIFICADOR ';'
| declaracion_procedimiento_funcion ';' bloque ';'
; 

bloque_inicio: INICIO bloque_inicio_aux FIN ;

bloque_inicio_aux: sentencia
| sentencia ';' bloque_inicio_aux
;

constante: '+' identificador_constante
| '+' numero_sin_signo
| '-' identificador_constante
| '-' numero_sin_signo
| identificador_constante
| numero_sin_signo
;

identificador_constante: IDENTIFICADOR;

identificador_funcion: IDENTIFICADOR;

identificador_procedimiento: IDENTIFICADOR;

identificador_variable: IDENTIFICADOR;

numero_sin_signo: ENTEROS
| DECIMAL
| EXPONENCIAL
;

tipo: identificador_tipo
| '(' tipo_aux ')'
| constante RANGO constante
;

tipo_aux: IDENTIFICADOR
| IDENTIFICADOR ',' tipo_aux
;

identificador_tipo: IDENTIFICADOR
| BOOLEANO
| ENTERO
| REAL
;

declaracion_procedimiento_funcion: PROCEDIMIENTO IDENTIFICADOR
| PROCEDIMIENTO IDENTIFICADOR lista_parametros_formales
| FUNCION IDENTIFICADOR
| FUNCION IDENTIFICADOR ':' identificador_tipo
| FUNCION IDENTIFICADOR lista_parametros_formales ':' identificador_tipo
;

lista_parametros_formales: '(' lista_parametros_formales_aux2 ')' ;

lista_parametros_formales_aux1: IDENTIFICADOR
| IDENTIFICADOR ',' lista_parametros_formales_aux1
;

lista_parametros_formales_aux2: lista_parametros_formales_aux1 ':' identificador_tipo
| VARIABLE lista_parametros_formales_aux1 ':' identificador_tipo
| lista_parametros_formales_aux1 ':' identificador_tipo lista_parametros_formales_aux2
| VARIABLE lista_parametros_formales_aux1 ':' identificador_tipo lista_parametros_formales_aux2
;

sentencia: identificador_variable ASIGNACION expresion
| identificador_funcion ASIGNACION expresion
| identificador_procedimiento
| identificador_procedimiento lista_parametros_actuales
| INICIO sentencia_inicio FIN
| SI expresion ENTONCES sentencia
| SI expresion ENTONCES sentencia SINO sentencia
| CASO expresion DE sentencia_caso2 FIN
| MIENTRAS expresion HACER sentencia
| REPETIR sentencia_repetir HASTA expresion
| PARA identificador_variable ASIGNACION expresion ABAJO expresion HACER sentencia
| PARA identificador_variable ASIGNACION expresion A expresion HACER sentencia
| 
;

sentencia_repetir: sentencia
| sentencia ';' sentencia_repetir
;

sentencia_caso1: constante
| constante ',' sentencia_caso1
;

sentencia_caso2: sentencia_caso1 ':' sentencia
| sentencia_caso1 ':' sentencia ';' sentencia_caso2
;

sentencia_inicio: sentencia
| sentencia ';' sentencia_inicio
;

expresion: expresion_simple
| expresion_simple '=' expresion_simple
| expresion_simple '<' expresion_simple
| expresion_simple '>' expresion_simple
| expresion_simple DISTINTO expresion_simple
| expresion_simple MENOR_IGUAL expresion_simple
| expresion_simple MAYOR_IGUAL expresion_simple
;

expresion_simple: termino expresion_simple_aux
| '+' termino expresion_simple_aux
| '-' termino expresion_simple_aux
;

expresion_simple_aux: '+' termino expresion_simple_aux
| '-' termino expresion_simple_aux
| O termino expresion_simple_aux
| 
;

termino: factor termino_aux;

termino_aux: '*' factor termino_aux
| '/' factor termino_aux
| DIVIDIR factor termino_aux
| MODULO factor termino_aux
| Y factor termino_aux
| 
;

factor: constante_sin_signo
| identificador_variable
| identificador_funcion
| identificador_funcion lista_parametros_actuales
| '(' expresion ')'
| NO factor
;

constante_sin_signo: identificador_constante
| numero_sin_signo
;

lista_parametros_actuales: '(' lista_parametros_actuales_aux ')' ;

lista_parametros_actuales_aux: identificador_variable
| identificador_variable ',' lista_parametros_actuales_aux
| expresion
| expresion ',' lista_parametros_actuales_aux
| identificador_procedimiento
| identificador_procedimiento ',' lista_parametros_actuales_aux
| identificador_funcion
| identificador_funcion ',' lista_parametros_actuales_aux
;

%%



void yyerror(char *s)
{
printf("Error en la l%cnea n%cmero: %d\n",161,163,yylineno);
exit(1);
}


int main(int argc, char *argv[])
{
    FILE *archivo_entrada;
    if(argc==1){
        printf("Error: Falta par%cmetro.\nUso: sintactico.exe archivo\n",160);
        return 0;
    }
    if(argc > 2){
        printf("Error: Demasiados par%cmetros.\nUso: sintactico.exe archivo\n",160);
        return 0;
    }
    if ((archivo_entrada = fopen(argv[1], "r")))
    {
        archivo_entrada = fopen(argv[1], "r");
        yyin = archivo_entrada;
        yyparse();
        printf("\nAn%clisis sint%cctico exitoso.\n",160,160);
        fclose(archivo_entrada);
        return 0;
    }
    printf("Error: El archivo no existe.\n");
    return 0;

}