## Discussion 8 - CMSC330 Fall 2020

# Graded Exercise
* To go from source code to a running program, there are 3 steps (at least for our purposes):
    * Tokenizing/Lexing (separating text into smaller tokens)
    * Parsing (generating something meaningful from the tokens - an AST)
    * Interpreting (evaluating the result of the AST)

* Consider the following grammar:
    * S -> M + S | M
    * M -> N * M | N
    * N -> n | (S)
    * where n is any integer

* The above grammar is right associative/recursive because the parsing strategy we use in this class, predictive recursive descent parsing, cannot handle left recursive CFGs. Left recursive CFGs can make a recursive descent parser get stuck in an infinite loop, as it might apply the same production over and over again, not making any changes to the list of tokens that will cause a change in its predictions.

* The above grammar gives \* a higher precedence over +, and () a higher precedence over + and \*. This happens because the parser using this grammar to create an Abstract Syntax Tree will always go as deep as possible before returning to previous uncompleted productions to finish up. Therefore, the deeper an operator is in our grammar, the higher its precedence.
For example, in parsing the expression `(1 + 2) * 3 + 4`, the parser, starting from S, has no option but to take the production specified by the non terminal M because the two possible rules of this production require it first. M's production also gives the parser no option than to take the production specified by the non terminal N. At this point, the parser can lookahead. If it sees an integer token, it can match it and return. If it sees a left paren token, it can match it (therefore consuming it), and apply a production specified by the non terminal S. This will cause more tokens to be matched or a failure to occur. In our example, no failure will occur. After this, we will come back to match the right paren token and return to the production M from which we came. Now the parser can lookahead again in an attempt to distinguish between the rules it has available. If it sees a multiplication token then it knows it was the first rule all along. It can match the multiplication and continue to the production specified by M. If not, in an attempt to continue until it is certain of a failure, it assumes that you intended to use the second rule (because it has no reason to assume otherwise) and it is therefore done with the production specified by M. It then returns to the production specified by S and peforms similar actions as previously described.