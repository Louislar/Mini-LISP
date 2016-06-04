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
%token MOD
%token DEFINE IF FUN
%token SEPARATOR
%token PRINT_BOOL PRINT_NUM
%left AND OR
%left NOT '='
%left '<' '>'
%left '+' '-'
%left '*' '/' MOD
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
    : BOOL_VAL { printf("Match exp\n"); }
    | NUMBER { printf("Match exp\n"); }
    | VARIABLE { printf("Match exp\n"); }
    | num-op { printf("Match exp\n"); }
    | logical-op { printf("Match exp\n"); }
    | fun-exp { printf("Match exp\n"); }
    | fun-call { printf("Match exp\n"); }
    | if-exp { printf("Match exp\n"); }
;

exp-lrecursive  /** Left recursive of non-terminal Expression **/
    : separator exp exp-lrecursive { printf("Match exp-lrecursive\n"); }
    | separator exp { printf("Match exp-lrecursive\n"); }
    ;

num-op          /** Numerical Operations (NUM-OP) **/
    : plus-op { printf("Match num-op\n"); }
    | minus-op { printf("Match num-op\n"); }
    | multiply-op { printf("Match num-op\n"); }
    | divide-op { printf("Match num-op\n"); }
    | modulus-op { printf("Match num-op\n"); }
    | greater-op { printf("Match num-op\n"); }
    | smaller-op { printf("Match num-op\n"); }
    | equal-op { printf("Match num-op\n"); }
;

    plus-op 
        : '(' '+' separator exp exp-lrecursive ')' { printf("Match plus-op\n"); }
    ;

    minus-op 
        : '(' '-' separator exp exp-lrecursive ')' { printf("Match minus-op\n"); }
    ;

    multiply-op 
        : '(' '*' separator exp exp-lrecursive ')' { printf("Match multiply-op\n"); }
    ;

    divide-op 
        : '(' '/' separator exp exp-lrecursive ')' { printf("Match divide-op\n"); }
    ;

    modulus-op 
        : '(' MOD separator exp exp-lrecursive ')' { printf("Match modulus-op\n"); }
    ;

    greater-op 
        : '(' '>' separator exp exp-lrecursive ')' { printf("Match greater-op\n"); }
    ;

    smaller-op 
        : '(' '<' separator exp exp-lrecursive ')' { printf("Match smaller-op\n"); }
    ;

    equal-op 
        : '(' '=' separator exp exp-lrecursive ')' { printf("Match equal-op\n"); }
    ;

logical-op     /** Logical Operations **/
    : and-op { printf("Match logical-op\n"); }
    | or-op { printf("Match logical-op\n"); }
    | not-op { printf("Match logical-op\n"); }
;

    and-op 
        : '(' AND separator exp exp-lrecursive ')' { printf("Match and-op\n"); }
    ;

    or-op 
        : '(' OR separator exp exp-lrecursive ')' { printf("Match or-op\n"); }
    ;

    not-op 
        : '(' NOT separator exp ')' { printf("Match not-op\n"); }
    ;

def-stmt       /** 
                  Define Statement 
                  Note: Redefining is not allowed.
               **/
    : '(' DEFINE separator variable exp ')' { printf("Match def-stmt\n"); }
;

    variable
        : VARIABLE { printf("Match variable\n"); }
    ;

fun-exp        /** Function **/
    : '(' FUN separator fun-ids fun-body ')' { printf("Match fun-exp\n"); }
;

    fun-ids 
        : '(' VARIABLE ')' { printf("Match fun-ids\n"); }
    ;

    fun-body 
        : exp { printf("Match fun-body\n"); }
    ;

    fun-call 
        : '(' fun-exp separator param ')'  { printf("Match fun-call\n"); }
        | '(' fun-exp separator ')' { printf("Match fun-call\n"); }
        | '(' fun-name separator param ')' { printf("Match fun-call\n"); }
        | '(' fun-name separator ')' { printf("Match fun-call\n"); }
    ;

    param 
        : exp-lrecursive { printf("Match param\n"); }
    ;

    last-exp 
        : exp { printf("Match last-exp\n"); }
    ;

    fun-name 
        : VARIABLE { printf("Match fun-name\n"); }
    ;

if-exp         /** if Expression **/
    : '(' IF separator test-exp separator then-exp separator else-exp ')' { printf("Match if-exp\n"); }
;

    test-exp 
        : exp  { printf("Match test-exp\n"); }
    ;

    then-exp 
        : exp { printf("Match then-exp\n"); }
    ;

    else-exp 
        : exp { printf("Match else-exp\n"); }
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
