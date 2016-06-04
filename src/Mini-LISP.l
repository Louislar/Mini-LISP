%{
	#include "Mini-LISP.tab.h"
%}
letter   	[a-z]
digit 	    [0-9]
separator 	"\t"|"\n"|"\r"|" "

number 		 0|[1-9]{digit}*|\-[1-9]{digit}*
variable 	 {letter}({letter}|{digit}|'-')*
bool_val  	 #t|#f

%%
\/|\+|\-|\*|\>|\<|\=   { printf("logic_identifier:%s\n",yytext);return(yytext[0]); }
"mod"		 { return(MOD); }
"and"		 { printf("bool_identifier:%s\n", yytext);return(AND); }
"or"		 { printf("bool_identifier:%s\n", yytext);return(OR); }
"not"		 { printf("bool_identifier:%s\n", yytext);return(NOT); }
{bool_val}   { 
				 printf("bool_val:%s\n", yytext);
			     yylval.cval = yytext;
			     return(BOOL_VAL); 
			 }
{number}	 { 
				 printf("number:%s\n", yytext);
				 yylval.ival = atoi(yytext); 
				 return(NUMBER);
			 }
"define"	 { return(DEFINE); }
"if"		 { return(IF); }
"fun" 		 { return(FUN); }
"print-bool" { printf("identifier:%s\n", yytext); return(PRINT_BOOL);}
"print-num"	 { printf("identifier:%s\n", yytext); return(PRINT_NUM); }
{variable}	 {
			    printf("VARIABLE:%s\n", yytext); yylval.cval = yytext;
			     return(VARIABLE);
			 }
\(		 	 { printf("identifier:%s\n", yytext);return(yytext[0]); }
\)		 	 { printf("identifier:%s\n", yytext);return(yytext[0]); } 
{separator}  { return(SEPARATOR); }
\n 			 { return(0); }

%%

YYSTYPE yylval;

//int main(void)
//{
//    int token;
//    while ((token = yylex()) != 0)
//       printf("Token: %d (%s)\n", token, yytext);
//    return 0;
//}
