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
      | dec_pf
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

//lista parametros actuales
list_pa: '(' list_pa2')' ;

//lista parametros actuales aux
list_pa2: id_var
| id_var ',' list_pa2
| exp
| exp ',' list_pa2
| id_proc
| id_proc ',' list_pa2
| id_fun
| id_fun ',' list_pa2
;

//exp_aux = expresion simple aux
exp_aux: '+' termino exp_aux
| '-' termino exp_aux
| O termino exp_aux
| 
;

termino: factor term_aux;

//term_aux = termino_aux
term_aux: '*' factor term_aux
| '/' factor term_aux
| DIVIDIR factor term_aux
| MODULO factor term_aux
| Y factor term_aux
| 
;

factor: cons_ss
| id_var
| id_fun
| id_fun list_pa
| '(' exp ')'
| NO factor
;

//exp = expresion 
exp: exp_s
| exp_s '=' exp_s
| exp_s '<' exp_s
| exp_s '>' exp_s
| exp_s DISTINTO exp_s
| exp_s MENOR_IGUAL exp_s
| exp_s MAYOR_IGUAL exp_s
;

//exp_s = expresion_simple
exp_s: termino exp_aux
| '+' termino exp_aux
| '-' termino exp_aux
;

tipo: id_tipo
| '(' tipo_aux ')'
| const RANGO const
;

tipo_aux: IDENTIFICADOR
| IDENTIFICADOR ',' tipo_aux
;

//declaracion procedimiento funcion
dec_pf: PROCEDIMIENTO IDENTIFICADOR
| PROCEDIMIENTO IDENTIFICADOR list_pf
| FUNCION IDENTIFICADOR
| FUNCION IDENTIFICADOR ':' id_tipo
| FUNCION IDENTIFICADOR list_pf ':' id_tipo
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