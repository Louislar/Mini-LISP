# Mini-LISP
Compiler final project

The language that the project’s interpreter will process is a subset of [LISP](https://en.wikipedia.org/wiki/LISP), which call it Mini-LISP for convenience. This handout first offers a general description, then goes into details such as lexical structure and grammar of the subset.



## Overview

 LISP is an ancient programming language based on [S-expressions](https://en.wikipedia.org/wiki/S-expression) and [lambda calculus](https://en.wikipedia.org/wiki/Lambda_calculus).

 All operations in Mini-LISP are written in parenthesized [prefix notation](https://en.wikipedia.org/wiki/Polish_notation). For example, a simple mathematical formula “(1 + 2) * 3” written in Mini-LISP is: (* (+ 1 2) 3)

 As a simplified language, Mini-LISP has only three types (Boolean, number and function) and a few operations.

- How to run the standard inter?
<pre><code>$ ./smli < example.lsp</code></pre>

###Type Definition###

- Boolean: Boolean type includes two values, #t for true and #f for false.
- Number: Signed integer from −(2^31 ) to 2^31 – 1, behavior out of this range is not defined.
- Function:See [grammar](https://github.com/ScarlettCanaan/Mini-LISP/blob/master/README.md#grammar-overview).

## Lexical Details

#### Preliminary Definitions:

<pre><code>separator ::= ‘\t’(tab) | ‘\n’ | ‘\r’ | ‘ ’(space)

letter ::= [a-z]

digit ::= [0-9]
</code></pre>

#### Token Definitions:
<pre><code>number ::= 0 | [1-9]digit * | -[1-9]digit *
</code></pre>
   _Examples: 0, 1, -23, 123456_
<pre><code>ID ::= letter (letter | digit | ‘-’) *
</code></pre>
   _Examples: x, y, john, cat-food_
<pre><code>bool-val ::= #t | #f
</code></pre>
## Grammar Overview

<pre><code>PROGRAM ::= STMT +

STMT ::= EXP | DEF-STMT | PRINT-STMT

PRINT-STMT ::= print-num EXP | print-bool EXP

EXP ::= bool-val | number | VARIABLE | NUM-OP | LOGICAL-OP | FUN-EXP | FUN-CALL | COND-EXP

NUM-OP ::= PLUS | MINUS | MULTIPLY | DIVIDE | MODULUS | GREATER | SMALLER | EQUAL
      
         PLUS ::= (+ EXP EXP + )

         MINUS ::= (- EXP EXP)
       
         MULTIPLY ::= ( * EXP EXP + )
       
         DIVIDE ::= (/ EXP EXP)
       
         MODULUS ::= (mod EXP EXP)
       
         GREATER ::= (> EXP EXP)
       
         SMALLER ::= (< EXP EXP)
       
         EQUAL ::= (= EXP EXP + )
       
LOGICAL-OP ::= AND-OP | OR-OP | NOT-OP

         AND-OP ::= (and EXP EXP + )

         OR-OP ::= (or EXP EXP + )
       
         NOT-OP ::= (not EXP)
       
DEF-STMT ::= (define VARIABLE EXP)

         VARIABLE ::= id
         
FUN-EXP ::= (fun FUN_IDs FUN-BODY)
        
        FUN-IDs ::= (id*)

        FUN-BODY ::= EXP

        FUN-CALL ::= (FUN-EXP PARAM*) | (FUN-NAME PARAM*)

        PARAM ::= EXP
        
        LAST-EXP ::= EXP

        FUN-NAME ::= id

IF-EXP::= (if TEST-EXP THAN-EXP ELSE-EXP)

        TEST-EXP ::= EXP

        THEN-EXP ::= EXP

        ELSE-EXP ::= EXP
</code></pre>
