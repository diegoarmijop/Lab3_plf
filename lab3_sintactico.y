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
| '(' programa_aux ')' ';' bloque '.'
;

programa_aux: IDENTIFICADOR
| IDENTIFICADOR ',' programa_aux
;

bloque: ;

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

sentencia: 
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