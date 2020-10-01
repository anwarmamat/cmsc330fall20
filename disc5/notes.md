# Discussion 5 

 This is (likely) our wrap up discussion on OCaml. We'll focus on data types (i.e. records, non-variant and variant types), as well as closures/partial application. Since we have a quiz
## Administrative
- Project 2b due soon (October 8th)
- M1 on (October 13th), covers upto closures

## Data Types
 - Last week we went over records, which are similar to structs in C
 - OCaml has the ability to create other types as well
    - Non-Variant types. These are simplar to `typedef` statements in C. They basically take some other type and give it a name. Ex:
    ```ocaml
    type ('k, 'v) dict_entry = 'k*'v;;
    ```
    - Variant types. These are much more interesting than the types we've learned about before, as they're not really present in the other languages you've worked with. This allows you to "encode information that may take on multiple different forms". This basically means that type has a variety of options that it can take on, but it can only take on one at a time.
    Examples:
    ```ocaml
    type 'a option = Some of 'a | None;;
    ```
    The option type is a very typical early example of this.    
    Example: In OCaml, there's not always a great way to express when you've received an invalid argument. Take this function:
    ```ocaml
    let sub_pos a b = a - b;;;
    ```
    It's not a very exciting function, all it does is subtract. Imagine, that for some reason, you only want to accept positive arguments to this function, but you also don't want the program to crash when it's been supplied an invalid argument. Options are a great way to implement this feature!
    ```ocaml
    let sub_pos a b = if a < 0 or b < 0 then None else Some(a-b)
    ```

    Variant types are also great for implementing _recursive data structures_! Take for example, a linked list:
    ```ocaml
    type 'a linked_list = Cons of 'a*'a linked_list | Empty
    ```
    or a binary tree
    ```ocaml
    type 'a btree = Node of 'a*'a*btree | Leaf
    ```

## Closures
- In OCaml, when you create a function, you're essentially creating what's called a "closure"
  - A closure contains two things - function code, and bindings for variables
  - `let f x y = x + y;;`
    - When first created, this is the code of the function with no bindings
    - Arguments can be applied one at a time
    - `let g = f 6;;`
      - This assigns g to be the closure defined by f, with a binding x=6
      - If g is called with an argument, now a value is returned

## Currying
- In OCaml, functions do not actually take multiple arguments.    
- Consider this function: `add_th x y z = x + y + z`
  - This is the same as `let add_th x = (fun y -> (fun z -> x+y+z))`
    - `add_th` has type `int -> (int -> (int -> int))`
  - We can evaluate the function like so:
   - `add_th 4` has type `int -> (int -> int)`
    - This is because we partially evaluated the function with one value. We plugged in 4 for `x`. `x` is bound to 4 in the result of this function
   - `add 4 5` has type `int -> int` because this partial evaluation results in a function that takes one int and returns an int
   - `add 4 5 6` has type `int` because it evaluates to 15.
- OCaml evaluates arguments to functions right to left.
  - However, OCaml function application is left associative:
  - `add_th 4 5 6` = `(add_th 4) 5 6` = `((add_th 4) 5) 6`
   - This naturally makes sense since this is the order OCaml curries arguments.
   - First `add_th 4` then evaluate the result of that with one argument, 5, then evaluate the result of that with one argument, 6.
- _However_, remember that types are right associative:
  - Example, these types are equivalent:
    - `int -> bool -> int -> int ` =
    - `int -> (bool -> int -> int)` =
    - `int -> (bool -> (int -> int))`
    - but these are *NOT* equivalent to
      - `(int -> bool) -> int -> int`
- Currying and closures tend to have a very strong theoretic base, which you'll learn more about when we get to lambda calculus!

## 4) Scoping
- This works the opposite way too; defined variables can be associated with a closure
- `let x = 5;; let f y = x + y;;`
  - Now, f is a closure where x is bound to 5
  - There are two ways this can work
- Static scoping (what OCaml actually does)
  - If x is redefined, f stays the same
    - ```
        let x = 5;;
        let f y = x + y;; (* Note x is bound to 5 here! This is carried with the function*)
        let x = 0;;
        f 2;; (*this returns 7, not 2!*)
    ```
    - The value of x in f is the one assigned most recently **before** function definition
- Dynamic scoping
  - If x is redefined, the closure associated with f changes to account for the new definition
    - `let x = 0;; f 2;; (\* this returns 2 \*)`
    - The value of in f is the one most recently assigned
  - Very few languages use this kind of scoping, because it leads to unexpected results

## 5) Discussion Problems
- These are advanced problems that utilize currying, variant types and higher order functions
