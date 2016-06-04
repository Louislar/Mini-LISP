%{
#include <stdio.h>
#include <stdlib.h>
void yyerror(const char *message);
struct ast_node *
new_ast_node (int node_type, int value,
              struct ast_node * left,
              struct ast_node * right);
struct ast_node *
new_ast_number_node (int value);
void
free_ast_tree (struct ast_node * ast_tree);
struct ast_node
{
  int value;
  int operation;
  struct ast_node * left;

  struct ast_node * right;
};
int result = 0;
%}
%union {
	int ival;
  char* cval;
	struct ast_node* ast;
}

%token <ival> NUMBER
%token <cval> VARIABLE BOOL_VAL
%token AND OR NOT
%token DEFINE IF FUN
%token SEPARATOR
%token PRINT_BOOL PRINT_NUM
%left AND OR
%left NOT '='
%left '<' '>'
%left '+' '-'
%left '*' '/' "MOD"
%%

program         /** Program **/
    : stmt program
    | stmt
;

stmt            /** Statement **/
    : exp 
    | def-stmt 
    | print-stmt
;

print-stmt      /** Print **/
    : PRINT_BOOL exp 
    | PRINT_NUM exp
;

exp             /** Expression **/
    : BOOL_VAL 
    | NUMBER 
    | VARIABLE 
    | num-op 
    | logical-op
    | fun-exp 
    | fun-call 
;

exp-lrecursive  /** Left recursive of non-terminal Expression **/
    : exp exp-lrecursive
    | exp
    ;

num-op          /** Numerical Operations (NUM-OP) **/
    : plus-op 
    | minus-op 
    | multiply-op 
    | divide-op 
    | modulus-op 
    | greater-op
    | smaller-op 
    | equal-op
;

    plus-op 
        : '(' '+' exp exp-lrecursive ')'
    ;

    minus-op 
        : '(' '-' exp exp-lrecursive ')'
    ;

    multiply-op 
        : '(' '*' exp exp-lrecursive ')'
    ;

    divide-op 
        : '(' '/' exp exp-lrecursive ')'
    ;

    modulus-op 
        : '(' "mod" exp exp-lrecursive ')'
    ;

    greater-op 
        : '(' '>' exp exp-lrecursive ')'
    ;

    smaller-op 
        : '(' '<' exp exp-lrecursive ')'
    ;

    equal-op 
        : '(' '=' exp exp-lrecursive ')'
    ;

logical-op     /** Logical Operations **/
    : and-op 
    | or-op 
    | not-op
;

    and-op 
        : '(' AND exp exp-lrecursive ')'
    ;

    or-op 
        : '(' OR exp exp-lrecursive ')'
    ;

    not-op 
        : '(' NOT exp-lrecursive ')'
    ;

def-stmt       /** 
                  Define Statement 
                  Note: Redefining is not allowed.
               **/
    : '(' DEFINE variable exp ')'
;

    variable
        : VARIABLE
    ;

fun-exp        /** Function **/
    : '(' FUN fun-ids fun-body ')'
;

    fun-ids 
        : '(' VARIABLE ')'
    ;

    fun-body 
        : exp
    ;

    fun-call 
        : '(' fun-exp param ')' 
        | '(' fun-exp ')' 
        | '(' fun-name param ')'
        | '(' fun-name ')'
    ;

    param 
        : exp-lrecursive
    ;

    last-exp 
        : exp
    ;

    fun-name 
        : VARIABLE
    ;

if-exp         /** if Expression **/
    : '(' IF test-exp then-exp else-exp ')'
;

    test-exp 
        : exp
    ;

    then-exp 
        : exp
    ;

    else-exp 
        : exp
    ;

%%

void yyerror (const char *message)
{
		printf("Invalid format\n");
}

int main(int argc, char *argv[]) {
        yyparse();

        return(0);
}
