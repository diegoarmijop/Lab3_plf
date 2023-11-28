%{
#include <stdio.h>
#include <stdlib.h>
extern int yylex();
extern FILE *yyin;
//extern int yylineno; cuenta las lineas. 
void yyerror(char *s);
%}

%token PROGRAMA CONSTANTE TIPO VARIABLE ENTEROS REAL BOOLEANO CARACTER PROCEDIMIENTO
%token ADELANTE FUNCION INICIO FIN SI ENTONCES SINO CASO DE MIENTRAS HACER PARA A ABAJO REPETIR HASTA O DIVIDIR MODULO Y NO
%token IDENTIFICADOR ENTERO DECIMAL EXPONENCIAL 

//falta agregar las prioridades. 

%% 
input: /*vacío*/
| input line
;

line: exp '\n'
| exp FIN      
| '\n'
;

exp: ENTERO 
| DECIMAL 
| EXPONENCIAL
| IDENTIFICADOR
;

programa: PROGRAMA IDENTIFICADOR ';' bloque '.'
| '(' IDENTIFICADOR ')' ';' bloque '.'
#PREGUNTAR COMO HAGO LA CLAUSURA
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
| '(' IDENTIFICADOR ')'
| '(' IDENTIFICADOR ',' ')' //FALTA LA CLAUSURA
| constante RANGO constante
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

lista_parametros_formales: '(' IDENTIFICADOR ':' identificador_tipo ')'
| '(' VARIABLE IDENTIFICADOR ':' identificador_tipo ')'
| '(' VARIABLE IDENTIFICADOR ',' IDENTIFICADOR ':' identificador_tipo ')' #la CLAUSURA
| '(' IDENTIFICADOR ',' IDENTIFICADOR ':' identificador_tipo ')'
| '(' IDENTIFICADOR ':' identificador_tipo ';' IDENTIFICADOR ':' identificador_tipo ')'
//no esta completa y falta clausura 

sentencia: identificador_variable ASIGNACION expresion
| identificador_funcion ASIGNACION expresion
| identificador_procedimiento
| identificador_procedimiento lista_parametros_actuales
| SI expresion ENTONCES sentencia
| SI expresion ENTONCES sentencia SINO sentencia
| MIENTRAS expresion HACER sentencia
| PARA identificador_variable ASIGNACION expresion ABAJO expresion HACER sentencia
| PARA identificador_variable ASIGNACION expresion A expresion HACER sentencia
//COMO HAGO LA PALABRA VACIA
;

expresion: expresion_simple
| expresion_simple '=' expresion_simple
| expresion_simple '<' expresion_simple
| expresion_simple '>' expresion_simple
| expresion_simple DISTINTO expresion_simple
| expresion_simple MENOR_IGUAL expresion_simple
| expresion_simple MAYOR_IGUAL expresion_simple
;

expresion_simple: termino
| '+' termino
| '-' termino
| termino '+' termino
| termino '-' termino
| termino O termino
| '+' termino '+' termino
| '+' termino '-' termino
| '+' termino O termino
| '-' termino '+' termino
| '-' termino '-' termino
| '-' termino O termino
//falta la clausura
;

termino: factor
| factor '*' factor
| factor '/' factor
| factor DIVIDIR factor
| factor MODULO factor
| factor Y factor
//PREGUNTAR CLAUSURA
;

constante: + identificador_constante
| '+' numero_sin_signo
| '-' identificador_constante
| '-' numero_sin_signo
| identificador_constante
| numero_sin_signo
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

lista_parametros_actuales: '(' identificador_variable ')'
| '(' expresion ')'
| '(' identificador_procedimiento ')'
| '(' identificador_funcion ')'
//no esta completa

%%

void yyerror(char *s)
{
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