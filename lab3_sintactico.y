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
      | prog
;


//programa
prog: PROGRAMA IDENTIFICADOR ';' blq '.'
| PROGRAMA IDENTIFICADOR '(' prog2 ')' ';' blq '.'
;


//programa2
prog2: IDENTIFICADOR
| IDENTIFICADOR ',' prog2
;


//bloque
blq: blqcte blqini
| blqtipo blqini
| blqvar blqini
| blqdecl blqini
| blqcte blqtipo blqini
| blqcte blqvar blqini
| blqcte blqdecl blqini
| blqtipo blqvar blqini
| blqtipo blqdecl blqini
| blqvar blqdecl blqini
| blqcte blqtipo blqvar blqini
| blqcte blqtipo blqdecl blqini
| blqcte blqvar blqdecl blqini
| blqtipo blqvar blqdecl blqini
| blqcte blqtipo blqvar blqdecl blqini
| blqini
;


//bloque_constante
blqcte: CONSTANTE blqcte2;


//bloque_constante2
blqcte2: IDENTIFICADOR '=' const ';' blqcte2
| IDENTIFICADOR '=' const ';'
;


//bloque_tipo
blqtipo: TIPO blqtipo2;

//bloque_tipo2
blqtipo2: IDENTIFICADOR '=' tipo ';' blqtipo2
| IDENTIFICADOR '=' tipo ';'
;


//bloque_variable
blqvar: VARIABLE blqvar2;

//bloque_variable2
blqvar2: blqvar3 ':' tipo ';' blqvar2
| blqvar3 ':' tipo ';'
;

//bloque_variable3
blqvar3: IDENTIFICADOR ',' blqvar3
| IDENTIFICADOR
;


//bloque_declaracion
blqdecl: dec_pf ';' IDENTIFICADOR ';' blqdecl
| dec_pf ';' IDENTIFICADOR ';'
| dec_pf ';' blq ';' blqdecl
| dec_pf ';' blq ';'
;


//bloque_inicio
blqini: INICIO blqini2 FIN ;

//bloque_inicio2
blqini2: sent
| sent ';' blqini2
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

//sentencia-inicio aux
sen_ini: sent
| sent ';' sen_ini
;

//sentencia-caso aux1
sen_cas1: const
| const ',' sen_cas1
;

//sentencia-caso aux2
sen_cas2: sen_cas1 ':' sent
| sen_cas1 ':' sent ';' sen_cas2
;

//sentencia-repetir aux
sen_rep: sent
| sent ';' sen_rep
;

//sentencia
sent: id_var ASIGNACION exp
| id_fun ASIGNACION exp
| id_proc
| id_proc list_pa
| INICIO sen_ini FIN
| SI exp ENTONCES sent
| SI exp ENTONCES sent SINO sent
| CASO exp DE sen_cas2 FIN
| MIENTRAS exp HACER sent
| REPETIR sen_rep HASTA exp
| PARA id_var ASIGNACION exp ABAJO exp HACER sent
| PARA id_var ASIGNACION exp A exp HACER sent
| 
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