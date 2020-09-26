# Project 2b: OCaml Higher Order Functions and Data
Due: 8 October 2020, 11:59pm EDT (Late 9 October)

Points: 65 public, 35 semipublic

## Introduction

The goal of this project is to increase your familiarity with programming in OCaml and give you practice using higher order functions and user-defined types. You will have to write a number of small functions, the specifications of which are given below. Some of them start out as code we provide you. In our reference solution, each function typically requires writing or modifying 1-8 lines of code.

You should be able to complete Part 1 after the lecture on high-order functions and the remaining sections after the lecture on user-defined types.

### Ground Rules

In your code, you may **only** use library functions found in the [`Stdlib` module](https://caml.inria.fr/pub/docs/manual-ocaml/libref/Stdlib.html) and the functions provided in `funs.ml`. However, you **may not** use any submodules of `Stdlib`, such as `Hashtbl`, `Set`, etc. You **cannot** use the `List` module. You **may not** use any imperative structures of OCaml such as references.  You may use the `@` operator.

If you use any of these features, your grade may be reduced significantly.

### Testing & Submitting

You will submit this project to [Gradescope](https://www.gradescope.com/courses/171498/assignments/702483).  You may only submit the **data.ml** and **higher.ml** files.  To test locally, run `dune runtest -f`.

### Important Notes about this Project

* Unlike most other languages, `=` in OCaml is the operator for structural equality whereas `==` is the operator for physical equality. All functions in this project (and in this class, unless ever specified otherwise) are concerned with structural equality.
* At a few points in this project, you will need to raise an `Invalid_argument` exception. Use the `invalid_arg` function to do so:
  ```ocaml
  invalid_arg "something went wrong"
  ```
  Use the error message that the function specifies as the argument.

## Part 1: High Order Functions

Write the following functions in `higher.ml` using `map`, `fold`, or `fold_right` as defined in the file `funs.ml`. You **must** use `map`, `fold`, or `fold_right` to complete these functions, so no functions in `higher.ml` should be defined using the `rec` keyword. You will lose points if this rule is not followed. Use the other provided functions in `funs.ml` to make completing the functions easier.

Some of these functions will require just map or fold, but some will require a combination of the two. The map/reduce design pattern may come in handy: Map over a list to convert it to a new list which you then process a second time using fold. The idea is that you first process the list using map, and then reduce the resulting list using fold.


#### `count_occ lst target`

- **Type**: `'a list -> 'a -> int`
- **Description**: Returns how many elements in `lst` are equal to `target`.
- **Examples**:
  ```ocaml
  count_occ [] 1 = 0
  count_occ [1] 1 = 1
  count_occ [1; 2; 2; 1; 3] 1 = 2
  ```

#### `uniq lst`

- **Type**: `'a list -> 'a list`
- **Description**: Given a list, returns a list with all duplicate elements removed. Order does not matter.
- **Examples**:
  ```ocaml
  uniq [] = []
  uniq [1] = [1]
  uniq [1; 2; 2; 1; 3] = [2; 1; 3]
  ```

#### `assoc_list lst`

- **Type**: `'a list -> ('a * int) list`
- **Description**: Given a list, returns a list of pairs where the first integer represents the element of the list and the second integer represents the number of occurrences of that element in the list. This associative list should not contain duplicates. Order does not matter.
- **Examples**:
  ```ocaml
  assoc_list [] = []
  assoc_list [1] = [(1,1)]
  assoc_list [1; 2; 2; 1; 3] = [(2,2); (1, 2); (3, 1)]
  ```

#### `ap fns args`

- **Type**: `('a -> 'b) list -> 'a list -> 'b list`
- **Description**: Applies each function in `fns` to each argument in `args` in order.
- **Examples**:
  ```ocaml
  ap [] [1;2;3;4] = []
  ap [succ] [] = []
  ap [(fun x -> x^"?"); (fun x -> x^"!")] ["foo";"bar"] = ["foo?";"bar?";"foo!";"bar!"]
  ap [pred;succ] [1;2] = [0;1;2;3]
  ap [int_of_float;fun x -> (int_of_float x)*2] [1.0;2.0;3.0] = [1; 2; 3; 2; 4; 6]
  ```

## Part 2: Integer BSTs

The remaining sections will be implemented in `data.ml`.

Here, you will write functions that will operate on a binary search trees. We'll start with trees that only contain integers, and then we'll move to a more general form - polymorphic trees. Provided below is the type of `int_tree`.

```ocaml
type int_tree =
    IntLeaf
  | IntNode of int * int_tree * int_tree
```

According to this definition, an ``int_tree`` is either: empty (just a leaf), or a node (containing an integer, left subtree, and right subtree). An empty tree is just a leaf.

```ocaml
let empty_int_tree = IntLeaf
```

Like lists, BSTs are immutable. Once created we cannot change it. To insert an element into a tree, create a new tree that is the same as the old, but with the new element added. Let's write `insert` for our `int_tree`. Recall the algorithm for inserting element `x` into a tree:

- *Empty tree?* Return a single-node tree.
- `x` *less than the current node?* Return a tree that has the same content as the present tree but where the left subtree is instead the tree that results from inserting `x` into the original left subtree.
- `x` *already in the tree?* Return the tree unchanged.
- `x` *greater than the current node?* Return a tree that has the same content as the present tree but where the right subtree is instead the tree that results from inserting `x` into the original right subtree.

Here's one implementation:

```ocaml
let rec int_insert x t =
  match t with
    IntLeaf -> IntNode (x, IntLeaf, IntLeaf)
  | IntNode (y, l, r) when x < y -> IntNode (y, int_insert x l, r)
  | IntNode (y, l, r) when x = y -> t
  | IntNode (y, l, r) -> IntNode (y, l, int_insert x r)
```

**Note**: The `when` syntax may be unfamiliar to you - it acts as an extra guard in addition to the pattern. For example, `IntNode (y, l, r) when x < y` will only be matched when the tree is an `IntNode` and `x < y`. This serves a similar purpose to having an if statement inside of the general `IntNode` match case, but allows for more readable syntax in many cases.

Let's try writing a function which determines whether a tree contains an element. This follows a similar procedure except we'll be returning a boolean if the element is a member of the tree.

```ocaml
let rec int_mem x t =
  match t with
    IntLeaf -> false
  | IntNode (y, l, r) when x < y -> int_mem x l
  | IntNode (y, l, r) when x = y -> true
  | IntNode (y, l, r) -> int_mem x r
```

It's your turn now! Write the following functions which operate on `int_tree`.

#### `int_size t`

- **Type**: `int_tree -> int`
- **Description**: Returns the number of nodes in tree `t`.
- **Examples**:
  ```ocaml
  int_size empty_int_tree = 0
  int_size (int_insert 1 (int_insert 2 empty_int_tree)) = 2
  ```

#### `int_max t`

- **Type**: `int_tree -> int`
- **Description**: Returns the maximum element in tree `t`. Raises exception `Invalid_argument("int_max")` on an empty tree. This function should be O(height of the tree).
- **Examples**:
  ```ocaml
  int_max (int_insert_all [1;2;3] empty_int_tree) = 3
  ```

## Part 3: Polymorphic BSTs

Our type `int_tree` is limited to integer elements. We want to define a binary search tree over *any* totally ordered type. Let's define the type `'a atree` to do so.

```ocaml
type 'a atree =
    Leaf
  | Node of 'a * 'a atree * 'a atree
```

This defintion is the same as `int_tree` except it's polymorphic. The nodes may contain any type `'a`, not just integers. Since a tree may contain any value, we need a way to compare values. We define a type for comparison functions.

```ocaml
type 'a compfn = 'a -> 'a -> int
```

Any comparison function will take two `'a` values and return an integer. If the integer is negative, the first value is less than the second; if positive, the first value is greater; if 0 they're equal.

Finally, we can bundle the two previous types to create a polymorphic BST.

```ocaml
type 'a ptree = 'a compfn * 'a atree
```

Just to be clear, an `atree` is an actual tree, similar to `int_tree` above, but for an arbitrary type `'a`. A `ptree` *IS NOT* a tree itself. It contains two things, a comparison function `compfn` and an `atree`.

For the `int_tree` structure you made above, there was an obvious way to order the data. Now, think about how you would create a BST for a type like `string`'s, given that there are multiple ways to order `string`'s: you can sort them alphabetically, by length, by number of uppercase letters, and so on. The intended order in the `atree` is given by this `compfn` function.

An empty tree is just a leaf and some comparison function.

```ocaml
let empty_ptree f : 'a ptree = (f, Leaf)
```

You can modify the code from your `int_tree` functions to implement some functions on `ptree`. Remember to use the bundled comparison function!

Just as was the case in the previous part, if trying to insert an element into the tree and the element is already in the tree (i.e. compfn returns 0), then return the original tree unchanged.

#### `pinsert x t`

- **Type**: `'a -> 'a ptree -> 'a ptree`
- **Description**: Returns a tree which is the same as tree `t`, but with `x` added to it.
- **Examples**:
  ```ocaml
  let int_comp x y = if x < y then -1 else if x > y then 1 else 0;;
  let t0 = empty_ptree int_comp;;
  let t1 = pinsert 1 (pinsert 8 (pinsert 5 t0));;
  ```

#### `pmem x t`

- **Type**: `'a -> 'a ptree -> bool`
- **Description**: Returns true iff `x` is an element of tree `t`.
- **Examples**:
  ```ocaml
  (* see definitions of t0 and t1 above *)
  pmem 5 t0 = false
  pmem 5 t1 = true
  pmem 1 t1 = true
  pmem 2 t1 = false
  ```

#### `pinsert_all lst t`

- **Type**: `'a list -> 'a ptree -> 'a ptree`
- **Description**: Returns a tree which is the same as tree `t`, but with all the elements in list `lst` added to it. Try to use fold to implement this in one line.
- **Examples**:
  ```ocaml
  p_as_list (pinsert_all [1;2;3] t0) = [1;2;3]
  p_as_list (pinsert_all [1;2;3] t1) = [1;2;3;5;8]
  ```

#### `p_as_list t`

- **Type**: `'a ptree -> 'a list`
- **Description**: Returns a list where the values correspond to an [in-order traversal][wikipedia inorder traversal] on tree `t`.
- **Examples**:
  ```ocaml
  p_as_list (pinsert 2 (pinsert 1 t0)) = [1;2]
  p_as_list (p_insert 2 (p_insert 2 (p_insert 3 t0))) = [2;3]
  ```

#### `pmap f t`

- **Type**: `('a -> 'a) -> 'a ptree -> 'a ptree`
- **Description**: Returns a tree where the function `f` is applied to all the elements of `t`.
- **Examples**:
  ```ocaml
  p_as_list (pmap (fun x -> x * 2) t1) = [2;10;16]
  p_as_list (pmap (fun x -> x * (-1)) t1) = [-8;-5;-1]
  ```

## Part 4: Variable Lookup

For this part of the project, you will be trying to implement a variable lookup table. You will need to implement your own data type `lookup_table` in `data.ml`. You want to select a type that can be used to build all of the following functions. You'll find it easiest to start working on this part after you have read the directions for the entire section.

Consider the following code snippet in C that demonstrates the function of block scopes.

```c
{
  int a = 30;
  int b = 40;
  {
    int a = 20;
    int c = 10;
    // POINT A
  }
  // POINT B
}
```

As you may remember from 216, the inner braces create a new "scope" for variable bindings. At Point A (marked in a comment), `a` is bound to 20, but as soon as the scope is popped on the next line (the closing curly brace), `a` returns to 30, since it was bound to that value in the previous scope. `c` is completely dropped out of memory at Point B, since it was only defined in the inner scope. Additionally, `b` is still bound to 40 at Point A, since it was bound in the outer scope. In Part 3, you'll be trying to implement your own data structure, which you'll define as `type lookup_table`, and you'll try to replicate this behavior.

If you're a little rusty on block scoping, you can check out [this link][block scope] or play around with scopes and print statements in C using gcc. Note that you do *not* have to worry about types, since every value will be an `int`.

Since we are not forcing you to implement the lookup table in any particular way, we will only test your table through the functions that you implement (specified below). This means that there are many different ways to solve this portion of the project, and as long as all the functions behave as expected, it doesn't matter exactly how you store the data. For this part, variable names will be represented by strings, and any string can be a variable name.

#### `type lookup_table`

- **Description**: This is not a function. Rather, it is a type that you'll have to define based on what you think is necessary for the below requirements.
- **What you need to do**: Change the type definition line in the `data.ml` file to the type that you choose to represent a `lookup_table`.

#### `empty_table ()`

- **Type**: `unit -> lookup_table`
- **Description**: Returns a new empty `lookup_table` with no scopes. The implementation of this will depend on how you define the lookup table above.
- **Examples**:
  ```ocaml
  empty_table ()
  ```

#### `push_scope table`

- **Type**: `lookup_table -> lookup_table`
- **Description**: Returns a `lookup_table` that has an added inner scope.
- **Examples**:
  ```ocaml
  empty_table ()
  push_scope (empty_table ())
  ```

#### `pop_scope table`

- **Type**: `lookup_table -> lookup_table`
- **Description**: Returns a `lookup_table` that has removed its most recent scope. All of the bindings previous to the dropped scope should remain intact. If no scopes are left, throw a failure with `failwith "No scopes remain!"`
- **Examples**:
  ```ocaml
  empty_table ()
  push_scope (empty_table ())
  pop_scope (push_scope (empty_table ()))
  pop_scope (pop_scope (push_scope (empty_table ()))) = Exception
  ```

#### `add_var name value table`

- **Type**: `string -> int -> lookup_table -> lookup_table`
- **Description**: Updates the most recent scope in `table` to include a new variable named `name` with value `value`. If no scopes exist in `table`, raise a failure with `failwith "There are no scopes to add a variable to!"`
- **Examples**:
  ```ocaml
  empty_table ()
  add_var "hello" 3 (push_scope (empty_table ()))
  add_var "hi" 5 (add_var "hello" 3 (push_scope (empty_table ())))
  add_var "hello" 6 (add_var "hi" 5 (add_var "hello" 3 (push_scope (empty_table ()))))
  add_var "oops" 1 (empty_table ()) = Exception
  ```

#### `lookup name table`

- **Type**: `string -> lookup_table -> int`
- **Description**: Returns the value associated with `name` in `table` in the current environment. If multiple values have been assigned to the same variable name, the most recently bound value in the current scope should be returned. If no variable named `name` is in `table`, raise a failure with `failwith "Variable not found!"`.
- **Examples**:
  ```ocaml
  lookup "hello" (add_var "hello" 3 (push_scope (empty_table ()))) = 3
  lookup "hello" (add_var "hi" 5 (add_var "hello" 3 (push_scope (empty_table ())))) = 3
  lookup "hello" (add_var "hello" 6 (add_var "hi" 5 (add_var "hello" 3 (push_scope (empty_table ()))))) = 6
  lookup "hello" (empty_table ()) = Exception
  ```

## Part 5: Shapes with Records

For the last part of this project, you will implement functions which operate on shapes.

Here are the types for shapes. They use OCaml's record syntax.

```ocaml
type pt = { x: int; y: int };;
type shape =
    Circ of { radius: float; center: pt }
  | Square of { length: float; upper: pt }
  | Rect of { width: float; height: float; upper: pt }
```

A `pt` is record with two fields: an x and y coordinate (both represented as ints). A shape can be a `Circ` (a record with two fields for radius and center point), a `Square` (a record with two fields for edge length and upper left coordinate), or a `Rect` (a record with three fields for width, height, and upper left coordinate).

Write the following functions which operate on `shape`.

#### `area s`

- **Type**: `shape -> float`
- **Description**: Returns the area of the shape. When computing the area of a circle, use the 3.14 as the definition of pi.
- **Examples**:
  ```ocaml
  let s0 = Circ { radius = 2.0; center = { x = 5; y = 0 } }
  let s1 = Rect { width = 4.0; height = 8.0; upper = { x = 0; y = 3 } }
  let s2 = Circ { radius = 10.0; center = { x = 1; y = 1 } }
  let s3 = Square { length = 5.0; upper = { x = 1; y = 1 } }
  area s0 = 12.56
  area s1 = 32.0
  area s2 = 314.0
  area s3 = 25.0
  ```

#### `filter f lst`
- **Type**: `(shape -> bool) -> shape list -> shape list`
- **Description**: Returns a list of all the shapes in `lst` that satisfy the predicate function `f`.
- **Examples**:
  ```ocaml
  (* see definitions of s0 and s1 above *)
  filter (fun x -> match x with Circ _ -> true | Rect _ -> false) [s0;s1] = [s0]
  ```

[wikipedia inorder traversal]: https://en.wikipedia.org/wiki/Tree_traversal#In-order
[block scope]: https://www.geeksforgeeks.org/scope-rules-in-c/
