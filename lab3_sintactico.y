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