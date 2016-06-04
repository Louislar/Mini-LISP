#yacc compiler
bison -d Mini-LISP.y
cc -c -g -I.. Mini-LISP.tab.c

#lex compiler
flex -o Mini-LISP.yy.c Mini-LISP.l
cc -c -g -I.. Mini-LISP.yy.c

#compile and link bison and lex
cc -o csmli Mini-LISP.tab.o Mini-LISP.yy.o -ll