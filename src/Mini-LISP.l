%{
%}
/* Preliminary Definitions */
separator 	{ '\t' | '\n' | '\r' | ' ' }
letter   	{ [a-z] }
digit 	     	{ [0-9] }

/* Token Definitions */
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
%%
