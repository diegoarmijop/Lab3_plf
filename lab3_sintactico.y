%{
#include <stdio.h>
#include <stdlib.h>
extern int yylex();
extern FILE *yyin;
extern int yylineno; 
void yyerror(char *s);
%}

%token PROGRAMA CONSTANTE TIPO VARIABLE ENTERO REAL BOOLEANO CARACTER PROCEDIMIENTO
%token ADELANTE FUNCION INICIO FIN SI ENTONCES SINO CASO DE MIENTRAS HACER PARA A ABAJO REPETIR HASTA O DIVIDIR MODULO Y NO
%token IDENTIFICADOR ENTEROS DECIMAL EXPONENCIAL


%right '=' ASIGNACION
%left O Y
%right NO
%left '<' '>' DISTINTO MENOR_IGUAL MAYOR_IGUAL
%left SI SINO MIENTRAS PARA REPETIR CASO
%right ENTONCES DE ':' HACER HASTA ABAJO A 
%left '-' '+'
%left '/' '*' DIVIDIR MODULO RANGO


%% 
input: /*vacío*/
      | list_pf
;

//identificador constante
id_const: IDENTIFICADOR;

//identificador funcion
id_fun: IDENTIFICADOR;

//identificador procedimiento
id_proc: IDENTIFICADOR;

//identificador variable
id_var: IDENTIFICADOR;

//numero sin signo
nro_ss: ENTEROS
| DECIMAL
| EXPONENCIAL
;

//identificador tipo
id_tipo: IDENTIFICADOR
| BOOLEANO
| ENTERO
| REAL
;

//constante sin signo
cons_ss: id_const
| nro_ss
;

//constante
const: '+' id_const
| '+' nro_ss
| '-' id_const
| '-' nro_ss
| id_const
| nro_ss
;

//lista parametros formales
list_pf: '(' list_pfb ')' ;

//lista parametros formales a
list_pfa: IDENTIFICADOR
| IDENTIFICADOR ',' list_pfa
;

//lista parametros formales b
list_pfb: list_pfa ':' id_tipo
| VARIABLE list_pfa ':' id_tipo
| list_pfa ':' id_tipo ';' list_pfb
| VARIABLE list_pfa ':' id_tipo ';' list_pfb
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