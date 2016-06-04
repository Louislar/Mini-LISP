%{
	#include "Mini-LISP.tab.h"
%}
/* Preliminary Definitions */
separator 	{ '\t' | '\n' | '\r' | ' ' }
letter   	{ [a-z] }
digit 	     	{ [0-9] }

/* Token Definitions */
<<<<<<< HEAD
NUMBER 		 {0|[1-9]{digit}*|-[1-9]{digit}*}		/* Examples: 0, 1, -23, 123456 */
VARIABLE 	 {{letter}({letter}|{digit}|'-')*}      /* Examples: x, y, john, cat-food */
BOOL-VAL  	 {#t|#f}

%%
\+     		 { return(yytext[0]); }
\-			 { return(yytext[0]); }
\*			 { return(yytext[0]); }
\/			 { return(yytext[0]); }
"mod"		 { return(yytext); }
'>'			 { return(yytext[0]); }
'<'			 { return(yytext[0]); }
'=' 		 { return(yytext[0]); }
"and"		 { return(AND); }
"or"		 { return(OR); }
"not"		 { return(NOT); }
BOOL-VAL  	 { 
			     yylval.cval = yytext;
			     return(BOOL_VAL); 
			 }
NUMBER		 { 
				 yylval.ival = atoi(yytext); 
				 return(NUMBER);
			 }
VARIABLE	 {
			     yylval.cval = yytext;
			     return(VARIABLE);
			 }
"define"	 { return(DEFINE); }
"if"		 { return(IF); }
"fun" 		 { return(FUN); }
"print-bool" { return(PRINT_BOOL);}
"pint-num"	 { return(PRINT_NUM); }
\(		 	 { return(yytext[0]); }
\)		 	 { return(yytext[0]); }
separator	 { return(SEPARATOR); }
=======
NUMBER 		{0|[1-9]{digit}*|-[1-9]{digit}*}	/* Examples: 0, 1, -23, 123456 */
VARIALBE 	{{letter}({letter}|{digit}|'-')*}      /* Examples: x, y, john, cat-food */
BOOL-VAL  	{#t|#f}

%%
\+     		{ return(yytext[0]); }
\-		{ return(yytext[0]); }
\*		{ return(yytext[0]); }
\/		{ return(yytext[0]); }
"mod"		{ return(yytext); }
'>'		{ return(yytext[0]); }
'<'		{ return(yytext[0]); }
'=' 		{ return(yytext[0]); }
"and"		{ return(AND); }
"or"		{ return(OR); }
"not"		{ return(NOT); }
BOOL-VAL  	{ 
			yylval.cval = yytext;
			return(BOOL-VAL); 
		}
NUMBER		{ 
			yylval.ival = atoi(yytext); 
			return(NUMBER);
		}
VARIALBE	{
			 yylval.cval = yytext;
			 return(VARIALBE);
		}
"define"	{ return(DEFINE); }
"if"		{ return(IF); }
"fun" 		{ return(FUN); }
\(		{ return(yytext[0]); }
\)		{ return(yytext[0]); }
separator	{ return(SEPARATOR); }
>>>>>>> ba6b8e59ec19ad1c9efb8b1a1e0628113d533ae9
%%
