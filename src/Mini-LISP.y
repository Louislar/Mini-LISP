%{
#include <stdio.h>
#include <stdlib.h>
#include "ASTree.h"
void yyerror(const char *message);
int result = 0;
%}
%union {
    int ival;
    char* cval;

    struct symbol_node * symbol;
    struct ast_node * ast;
    struct ast_PARAMETER_node * ast_PAR;
    struct ast_define_node * ast_def;
}

%token <ival> NUMBER
%token <cval> VARIABLE BOOL_VAL
%token AND OR NOT
%token MOD
%token DEFINE IF FUN
%token SEPARATOR
%token PRINT_BOOL PRINT_NUM
%type <ast> exp exp-lrecursive num-op logical-op
%type <ast> plus-op minus-op divide-op multiply-op modulus-op
%type <ast> and-op or-op not-op
%type <ast> greater-op smaller-op equal-op
%type <ast> param variable variable_closure
%type <ast> fun-exp fun-call fun-body fun-name fun-ids
%type <ast> test-exp then-exp else-exp if-exp

%type <ast_def> def-stmt
%left AND OR
%left NOT '='
%left '<' '>'
%left '+' '-'
%left '*' '/' MOD
%left <operator> EQUALITY
%left <operator> RELATIONAL
%right UMINUS
%left '(' ')'
%%
program         /** Program **/
    : stmt separator program _separator         { printf("Match program\n"); }
    | stmt separator                  { printf("Match program\n"); }
;

separator
    : SEPARATOR
    | SEPARATOR separator
;

_separator
    : separator
    |
;

stmt            /** Statement **/
    : exp { printf("Match stmt\n"); }
    | def-stmt { printf("Match stmt\n"); }
    | print-stmt { printf("Match stmt\n"); }
;

print-stmt      /** Print **/
    : '(' PRINT_BOOL separator exp ')' { printf("Match print-stmt\n"); }
    | '(' PRINT_NUM  separator exp ')' { printf("Match print-stmt\n"); }
;

exp             /** Expression **/
    : BOOL_VAL { $$ = new_ast_BOOL_node($1); }
    | NUMBER { $$ = new_ast_NUMBER_node ($1); }
    | VARIABLE { $$ = new_ast_PARAMETER_node($1, 0); }
    | num-op { $$ = $1; }
    | logical-op { $$ = $1; }
    | fun-exp { $$ = $1; }
    | fun-call { $$ = $1; }
    | if-exp { $$ = $1; }
;

exp-lrecursive  /** Left recursive of non-terminal Expression **/
    : separator exp exp-lrecursive { $$ = new_ast_node('R', $2, $3); }
    | separator exp { $$ = $2; }
;

num-op          /** Numerical Operations (NUM-OP) **/
    : plus-op { $$ = $1; }
    | minus-op { $$ = $1; }
    | multiply-op { $$ = $1; }
    | divide-op { $$ = $1; }
    | modulus-op { $$ = $1; }
    | greater-op { $$ = $1; }
    | smaller-op { $$ = $1; }
    | equal-op { $$ = $1; }
;

    plus-op 
        : '(' '+' separator exp exp-lrecursive ')' { $$ = new_ast_node('+', $4, $5); }
    ;

    minus-op 
        : '(' '-' separator exp exp-lrecursive ')' { $$ = new_ast_node('-', $4, $5); }
    ;

    multiply-op 
        : '(' '*' separator exp exp-lrecursive ')' { $$ = new_ast_node('*', $4, $5); }
    ;

    divide-op 
        : '(' '/' separator exp exp-lrecursive ')' { $$ = new_ast_node('/', $4, $5); }
    ;

    modulus-op 
        : '(' MOD separator exp exp-lrecursive ')' { $$ = new_ast_node('M', $4, $5); }
    ;

    greater-op 
        : '(' '>' separator exp exp-lrecursive ')' { $$ = new_ast_node('>', $4, $5); }
    ;

    smaller-op 
        : '(' '<' separator exp exp-lrecursive ')' { $$ = new_ast_node('<', $4, $5); }
    ;

    equal-op 
        : '(' '=' separator exp exp-lrecursive ')' { $$ = new_ast_node('=', $4, $5); }
    ;

logical-op     /** Logical Operations **/
    : and-op { $$ = $1; }
    | or-op { $$ = $1; }
    | not-op { $$ = $1; }
;

    and-op 
        : '(' AND separator exp exp-lrecursive ')' { $$ = new_ast_logic_node('A', NULL, $4, $5); }
    ;

    or-op 
        : '(' OR separator exp exp-lrecursive ')' { $$ = new_ast_logic_node('A', NULL, $4, $5); }
    ;

    not-op 
        : '(' NOT separator exp ')' { $$ = new_ast_logic_node('N', NULL, $4, NULL); }
    ;

def-stmt       /** 
                  Define Statement 
                  Note: Redefining is not allowed.
               **/
    : '(' DEFINE separator variable exp ')' { $$ = new_ast_define_node ($4, $5); }
;

    variable
        : VARIABLE { $$ = new_ast_PARAMETER_node($1, 0); }
    ;

fun-exp        /** Function **/
    : '(' FUN separator fun-ids fun-body ')' { $$ = new_ast_function_node($4, $5); }
;

    fun-ids 
        : '(' variable_closure ')' { $$ = $2; }
    ;

    variable_closure
        :   VARIABLE separator variable_closure { $$ = new_ast_node('P', $1, $3); }
        |   VARIABLE { $$ = $1; }
        |
    ;

    fun-body 
        : exp { $$ = $1; }
    ;

    fun-call 
        : '(' fun-exp separator param ')'  { $$ = new_ast_node('C', $2, $4); }
        | '(' fun-exp separator ')' { $$ = new_ast_node('C', $2, NULL); }
        | '(' fun-name separator param ')' { $$ = new_ast_node('C', $2, $4); }
        | '(' fun-name separator ')' { $$ = new_ast_node('C', $2, NULL); }
    ;

    param 
        : exp-lrecursive { $$ = $1; }
    ;

    last-exp 
        : exp { printf("Match last-exp\n"); }
    ;

    fun-name 
        : VARIABLE { $$ = new_ast_PARAMETER_node($1, 0); }
    ;

if-exp         /** if Expression **/
    : '(' IF separator test-exp separator then-exp separator else-exp ')' { $$ = new_ast_if_node($4, $6, $8); }
;

    test-exp 
        : exp  { $$ = $1; }
    ;

    then-exp 
        : exp { $$ = $1; }
    ;

    else-exp 
        : exp { $$ = $1; }
    ;

%%

void yyerror (const char *message)
{
        printf("%s\n", message);
		printf("Invalid format\n");
}

YYSTYPE yylval;

int main(int argc, char *argv[]) {
        yyparse();

        return(0);
}
