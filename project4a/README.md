# Project 4a: SmallC Parser
Due: 9 November 2020, 11:59pm EST (Late 10 November)

Points: 48 public, 52 semipublic

## Introduction

In this project, you will implement as Ocaml functions a lexer and parser for SmallC. Your lexer functions will convert a SmallC program internally stored as string into a list of tokens, and your parser functions will consume these tokens to produce an abstract symbol tree (AST). The input could be an entire program, or a fragment of a program, and your parser will produce an AST that represents one or more statements (stmt) or an expression (expr). This readme describes the tokens and grammar you will use.

The only requirement for error handling is that input that cannot be lexed/parsed according to the provided rules should raise an InvalidInputException. We recommend using relevant error messages when raising these exceptions, to make debugging easier. We are not requiring intelligent messages that pinpoint an error to help a programmer debug, but as you do this project you might find you see where you could add those.

All tests will be run on direct calls to your code, comparing your return values to the expected return values. Any other output (e.g., for your own debugging) will be ignored. You are free and encouraged to have additional output.

Here is an example SmallC program:

```c
int x;
x = 2 * 3 ^ 5 + 4;
printf(x > 100);
```

An example use of the parser in Utop:

```ocaml
parse_stmt (tokenize "int x; x = 2 * 3 ^ 5 + 4; printf(x > 100);")
```

### Ground Rules

In your code, you may use any non-imperative OCaml modules and features we have taught in this class (If you come asking for help using something we have not taught we will direct you to use methods taught in this class). **Imperative Ocaml is not allowed.**

### Testing & Submitting

**NEW**: You can now submit directly from the command-line!  You must have `gradescope-submit` installed, if you don't please see [the setup page](https://github.com/anwarmamat/cmsc330fall20/tree/master/submit_setup.md).  Then you can run `gradescope-submit` from the project directory and the project will be automatically submitted (you'll have to enter your username and password the first time).

You can also still submit as before to [Gradescope](https://www.gradescope.com/courses/171498/assignments/786590).  You may only submit the **lexer.ml** and **parser.ml** files.  To test locally, run `dune runtest -f`.

You can run your lexer or parser directly on a SmallC program by running `dune exec bin/interface.bc lex [filename]` or `dune exec bin/interface.bc parse [filename]` where the `[filename]` argument is required.

To test from the toplevel, run `dune utop src`.  The necessary functions and types will automatically be imported for you.

All of our tests will feed C code into your program to be lexed and parsed.  You can write your own tests which only test the parser by feeding it a custom token list.  For example, to see how the expression `1 + 2 ^ 3 * 4` would be parsed, you can construct the token list manually (e.g. in Utop):

```ocaml
parse_expr [Tok_Int 1; Tok_Add; Tok_Int 2; Tok_Pow; Tok_Int 3; Tok_Mult; Tok_Int 4; EOF];;
```

This way, you can work on the parser even if your lexer is not complete yet.

## Part 1: The Lexer (aka Scanner or Tokenizer)

Before your parser can process input, the raw file must be transformed into logical units called tokens. The goal is to transform a SmallC program, represented as a string, into a list of tokens that capture the different elements of the program. This process is readily handled by use of regular expressions. Information about OCaml's regular expressions library can be found in the [`Str` module documentation][str doc]. You aren't required to use it, but you may find it very helpful. Note that a lexer is the same as a scanner, which is discussed in the lecture slides.

Your lexer must be written in `lexer.ml`. You will need to implement the following function: 

#### `tokenize`

- **Type:** `string -> token list` 
- **Description:** Converts SmallC source code (given as a string) to the associated token list.
- **Examples:**
  ```ocaml
  tokenize "1 + 2" = [Tok_Int 1; Tok_Add; Tok_Int 2; EOF]
  tokenize "" = [EOF]
  tokenize "int main() { int x; }" = [Tok_Int_Type; Tok_Main; Tok_LParen; Tok_RParen; Tok_LBrace; Tok_Int_Type; Tok_ID "x"; Tok_Semi; Tok_RBrace; EOF]
  ```

The `token` type is implemented in [`tokenTypes.ml`](./src/tokenTypes.ml).

A few important notes to consider:
- Tokens can be separated by arbitrary amounts of whitespace, which your lexer should discard. Spaces, tabs ('\t') and newlines ('\n') are all considered whitespace.
- The lexer should be case sensitive.
- Lexer output should be terminated by the `EOF` token, meaning that the shortest possible output from the lexer is `[EOF]`.
- If the beginning of a string could be multiple things, the **longest** match should be preferred, for example:
  - "while0" should not be lexed as `Tok_While`, but as `Tok_ID("while0")`, since it is an identifier
  - "1-1" should be lexed as `Tok_Int(1)` and `Tok_Int(-1)`, since "-1" is a valid integer.

Most tokens only exist in one form (for example, the only way for `Tok_Pow` to appear in the program is as `^` and the only way for `Tok_While` to appear in the program is as `while`). However, a few tokens have more complex rules. The regular expressions for these more complex rules are provided here:

- `Tok_Bool of bool`: The value will be set to `true` on the input string "true" and `false` on the input string "false".
  - *Regular Expression*: `true|false`
- `Tok_Int of int`: Valid ints may be positive or negative and consist of 1 or more digits. You may find the function `int_of_string` useful in lexing this token type.
  - *Regular Expression*: `-?[0-9]+`
- `Tok_ID of string`: Valid IDs must start with a letter and can be followed by any number of letters or numbers. Note that keywords may be contained within IDs and they should be counted as IDs unless they perfectly match a keyword!
  - *Regular Expression*: `[a-zA-Z][a-zA-Z0-9]*`
  - *Valid examples*:
    - "a"
    - "ABC"
    - "a1b2c3DEF6"
    - "while1"
    - "ifelsewhile"

In grammars given later in this project description, we use the lexical representation of tokens instead of the token name; e.g. we write `(` instead of `Tok_LParen`. This table shows all mappings of tokens to their lexical representations, excluding the three literal token types specified above:

Token Name (in OCaml) | Lexical Representation (in grammars below)
--- | ---
`Tok_LParen` | `(`
`Tok_RParen` | `)`
`Tok_LBrace` | `{`
`Tok_RBrace` | `}`
`Tok_Equal` | `==`
`Tok_NotEqual` | `!=`
`Tok_Assign` | `=`
`Tok_Greater` | `>`
`Tok_Less` | `<`
`Tok_GreaterEqual` | `>=`
`Tok_LessEqual` | `<=`
`Tok_Or` | `\|\|`
`Tok_And` | `&&`
`Tok_Not` | `!`
`Tok_Semi` | `;`
`Tok_Int_Type` | `int`
`Tok_Bool_Type` | `bool`
`Tok_Print` | `printf`
`Tok_Main` | `main`
`Tok_If` | `if`
`Tok_Else` | `else`
`Tok_For`  | `for`
`Tok_From`  | `from`
`Tok_To`  | `to`
`Tok_While` | `while`
`Tok_Add` | `+`
`Tok_Sub` | `-`
`Tok_Mult` | `*`
`Tok_Div` | `/`
`Tok_Pow` | `^`

Your lexing code will feed the tokens into your parser, so a broken lexer can cause you to fail tests related to parsing.

## Part 2: The Parser

Once the program has been transformed from a string of raw characters into more manageable tokens, you're ready to parse. The parser consists of three main functions which parse expressions, statements, and an entire program (`parse_expr`, `parse_stmt` and `parse_main`.) The three work together to parse a full program.

Each takes a stream of tokens and outputs an OCaml variant type representing an AST for the input. In the case of `parse_expr`, the root is type `expr`; for `parse_stmt`, type `stmt`; and `parse_main`, type `stmt` again (since the main function in SmallC just holds a list of statements). You can and should write `parse_expr` and `parse_stmt` in that order, to test them on small fragments of SmallC, but the parser is ultimately initiated by a call to `parse_main`.

The three functions are specified below:

#### `parse_expr`

- **Type:** `token list -> token list * expr`
- **Description:** Takes a list of tokens and returns an AST representing the expression corresponding to the given tokens, along with the new, reduced list of tokens
- **Exceptions:** If the next tokens in the token list do not represent an expression, raise `InvalidInputException`.
- **Examples:**
  ```ocaml
  parse_expr [Tok_Int(1); Tok_Add; Tok_Int(2); Tok_Semi; EOF] = ([Tok_Semi; EOF], Add (Int 1, Int 2))
  parse_expr [Tok_Int(1); EOF] = ([EOF], Int 1)
  parse_expr [Tok_Int_Type; EOF] (* InvalidInputException *)
  ```

#### `parse_stmt`

- **Type:** `token list -> token list * stmt`
- **Description:** Takes a list of tokens and returns an AST representing the statement corresponding to the given tokens, along with the new, reduced list of tokens
- **Exceptions:** If the next tokens in the token list do not represent a statement, raise `InvalidInputException`.
- **Examples:**
  ```ocaml
  parse_stmt [Tok_Int_Type; Tok_ID("x"); Tok_Semi; EOF] = ([EOF], Seq (Declare (Int_Type, "x"), NoOp))
  parse_stmt [Tok_ID("x"); Tok_Assign; Tok_Int(3); Tok_Semi; EOF] = ([EOF], Seq (Assign ("x", Int 3), NoOp))
  parse_stmt [Tok_Int(3); Tok_Add; Tok_Int(4); EOF] (* InvalidInputException *)
  ```

#### `parse_main`

- **Type:** `token list -> stmt`
- **Description:** Takes a list of tokens and returns an AST representing the list of statements in the body of the `main` function.  All tokens should be consumed, so there is no need to return the remaining tokens.
- **Exceptions:** If the list of tokens does not contain only `EOF` at the end, raise `InvalidInputException`.  Also, if the token list contains tokens before the beginning of the `main` function declaration, or after it's last closing brace, or if the `main` function doesn't exist in the token list, raie `InvalidInputException`.
- **Examples:**
  ```ocaml
  parse_main [Tok_Int_Type; Tok_Main; Tok_LParen; Tok_RParen; Tok_LBrace; Tok_Int_Type; Tok_ID("x"); Tok_Semi; Tok_RBrace; EOF] = Seq (Declare (Int_Type, "x"), NoOp)
  parse_main [Tok_Int(3); Tok_Add; Tok_Int(4); EOF] (* InvalidInputException *)
  ```

The parser must be implemented in parser.ml in accordance with the signatures found in parser.mli. parser.ml is the only file you will write code in. The functions should be left in the order they are provided, as a good implementation will rely heavily on earlier functions.

**Note**: we have provided the function `match_token` which takes the list of tokens and a single token as arguments, and will either:
- Return a new token list with the first token removed IF the first token matches the second argument, or
- Raise an exception IF the first token does not match the second argument to the function.

We have also provided the `lookahead` function which returns the first token in the list of tokens, but does NOT modify the token list.  This function will raise an exception if the token list is empty.

We provide a CFG below for the language of C expressions. This CFG is right-recursive, so something like `1 + 2 + 3` will parse as `Add (Int 1, Add (Int 2, Int 3))`, essentially implying parentheses in the form `(1 + (2 + 3))`.) As convention, in the given CFG all non-terminals are capitalized, all syntax literals (terminals) are formatted `as non-italicized code` and will come in to the parser as tokens from your lexer. Variant token types (i.e. `Tok_Bool`, `Tok_Int`, and `Tok_ID`) will be printed *`as italicized code`*.

### `parse_expr`

Expressions represent mathematical and boolean formulas that typically evaluate to either an integer or a boolean. Because expressions are a self-contained subset of the SmallC grammar, we can implement them first, and build the rest of the language on top of them later.

```ocaml
type expr =
  | ID of string
  | Int of int
  | Bool of bool
  | Add of expr * expr
  | Sub of expr * expr
  | Mult of expr * expr
  | Div of expr * expr
  | Pow of  expr * expr
  | Greater of expr * expr
  | Less of expr * expr
  | GreaterEqual of expr * expr
  | LessEqual of expr * expr
  | Equal of expr * expr
  | NotEqual of expr * expr
  | Or of expr * expr
  | And of expr * expr
  | Not of expr
```

The CFG of expressions, from which you should produce a value of `expr` AST type, is as follows:

- Expr -> OrExpr
- OrExpr -> AndExpr `||` OrExpr | AndExpr
- AndExpr -> EqualityExpr `&&` AndExpr | EqualityExpr
- EqualityExpr -> RelationalExpr EqualityOperator EqualityExpr | RelationalExpr
  - EqualityOperator -> `==` | `!=`
- RelationalExpr -> AdditiveExpr RelationalOperator RelationalExpr | AdditiveExpr
  - RelationalOperator -> `<` | `>` | `<=` | `>=`
- AdditiveExpr -> MultiplicativeExpr AdditiveOperator AdditiveExpr | MultiplicativeExpr
  - AdditiveOperator -> `+` | `-`
- MultiplicativeExpr -> PowerExpr MultiplicativeOperator MultiplicativeExpr | PowerExpr
  - MultiplicativeOperator -> `*` | `/`
- PowerExpr -> UnaryExpr `^` PowerExpr | UnaryExpr
- UnaryExpr -> `!` UnaryExpr | PrimaryExpr
- PrimaryExpr -> *`Tok_Int`* | *`Tok_Bool`* | *`Tok_ID`* | `(` Expr `)`

For more information on how we constructed this CFG, see [ambiguity.md][./ambiguity.md].  We encourage you to familiarize yourself with this process.

As an example, see how the parser will break down an input mixing a few different operators with different precedence:

**Input:**
```c
2 * 3 ^ 5 + 4
```

**Output (after lexing and parsing):**
```ocaml
Add(
  Mult(
    Int(2),
    Pow(
      Int(3),
      Int(5))),
  Int(4))
```

### `parse_stmt`

The next step to parsing is to build statements up around your expression parser. When parsing, a sequence of statements should be terminated as a `NoOp`, which you will remember as a do-nothing instruction from the interpreter. Recall the `stmt` type:

```ocaml
type stmt =
  | NoOp
  | Seq of stmt * stmt
  | Declare of data_type * string
  | Assign of string * expr
  | If of expr * stmt * stmt
  | For of string * expr * expr * stmt
  | While of expr * stmt
  | Print of expr
```

The `stmt` type isn't self-contained like the `expr` type, and instead refers both to itself and to `expr`; use your `parse_expr` function to avoid duplicate code! Again, we provide a CFG for you to refer to when building your parser:

- Stmt -> StmtOptions Stmt | ε
  - StmtOptions -> DeclareStmt | AssignStmt | PrintStmt | IfStmt | ForStmt | WhileStmt
    - DeclareStmt -> BasicType ID `;`
      - BasicType -> `int` | `bool`
    - AssignStmt -> ID `=` Expr `;`
    - PrintStmt -> `printf` `(` Expr `)` `;`
    - IfStmt -> `if` `(` Expr `)` `{` Stmt `}` ElseBranch
      - ElseBranch -> `else` `{` Stmt `}` | ε
    - ForStmt -> `for` `(` ID `from` Expr `to` Expr `)` `{` Stmt `}`
    - WhileStmt -> `while` `(` Expr `)` `{` Stmt `}`

As with the expression grammar, the process we used to enable the grammar to be parsable can be found in [ambiguity.md][./ambiguity.md].

If we expand on our previous example, we can see how the expression parser integrates directly into the statement parser:

**Input:**
```c
int x;
x = 2 * 3 ^ 5 + 4;
printf(x > 100);
```

**Output (after lexing and parsing):**
```ocaml
Seq(Declare(Int_Type, "x"),
Seq(Assign("x",
  Add(
    Mult(
      Int 2,
      Pow(
        Int 3,
        Int 5)),
    Int 4)),
Seq(Print(Greater(ID "x", Int 100)), NoOp)))
```

**Input:**
```c
int main(){
  int a;
  for (a from 1 to 10){
    printf(a);
  }
}
```

**Output:**
```ocaml
(Seq
  (Declare (Int_Type, "a"),
   Seq (For ("a", Int 1, Int 10, Seq (Print (ID "a"), NoOp)),
        NoOp)))
```

### `parse_main`

The last and shortest step is to have your parser handle the function entry point. This is where `parse_main : token list -> stmt` comes in. This function behaves the exact same way as `parse_stmt`, except for two key semantic details:
- `parse_main` will parse the function declaration for main, not just the body.
- `parse_main` validates that a successful parse terminates in `EOF`. A parse not ending in `EOF` should raise an `InvalidInputException` in `parse_main`. As such, `parse_main` does NOT return remaining tokens, since it validates ensures that the token list is emptied by the parse.

The grammar for this parse is provided here:

- Main -> `int` `main` `(` `)` `{` Stmt `}` `EOF`

For this slightly modified input to the example used in the previous two sections, the exact same output would be produced:

**Input:**
```c
int main() {
  int x;
  x = 2 * 3 ^ 5 + 4;
  printf(x > 100);
}
```

The output is the exact same as in the statement parser, but `parse_main` also trims off the function header and verifies that all tokens are consumed.

## Academic Integrity

Please **carefully read** the academic honesty section of the course syllabus. **Any evidence** of impermissible cooperation on projects, use of disallowed materials or resources, or unauthorized use of computer accounts, **will be** submitted to the Student Honor Council, which could result in an XF for the course, or suspension or expulsion from the University. Be sure you understand what you are and what you are not permitted to do in regards to academic integrity when it comes to project assignments. These policies apply to all students, and the Student Honor Council does not consider lack of knowledge of the policies to be a defense for violating them. Full information is found in the course syllabus, which you should review before starting.

[str doc]: https://caml.inria.fr/pub/docs/manual-ocaml/libref/Str.html
