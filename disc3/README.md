# Discussion 3: Introduction to OCaml
Due: 18 September 2020, 11:59pm EDT (No late submissions will be accepted)

Points: 100 public

## Introduction

This exercise consists of a few short functions to help you familiarize yourself with OCaml.  You can review the content of the discussion in [notes.rb](notes.rb), which includes the topics and examples from the discussion video.  Also, check out [utop-tutorial.md](utop-tutorial.md) for an introduction to using `utop`.

### Testing & Submitting

You will submit this project to [Gradescope](https://www.gradescope.com/courses/171498/assignments/681774).  You may only submit the **disc3.rb** file.  To test locally, run `dune runtest -f`.

## Part 1: Type inference

At the top of [disc3.ml](src/disc3.ml), there are a few function definitions. Try determining the types of these functions and check your answers with `utop`.  This portion of the discussion is not tested (and thus not graded), but these kinds of exercises may appear on quizzes and exams!

## Part 2: Type definitions

You will have to fill in definitions for the functions `tf1`, `tf2`, `tf3` such that they have the type that is expected in the `.mli`. The operation of the function does not matter, as long as they have the correct types.

#### `tf1 a`

- **Type**: `string -> int`

#### `tf2 a b c`

- **Type**: `'a -> 'b -> 'b -> bool`

#### `tf3 a b`

- **Type**: `'a list -> 'a list -> 'a`
- **Note**: For this one, you can assume that the lists `a` and `b` are not empty.

## Part 3: Functions

#### `concat str1 str2`

- **Type**: `string -> string -> string`
- **Description**: Appends `str2` to the end of `str1`.
- **Examples**:
  ```ocaml
  concat "" "" = ""
  concat "" "abc" = "abc"
  concat "xyz" "" = "xyz"
  concat "abc" "xyz" = "abcxyz"
  ```

#### `add_to_float integer flt`

- **Type**: `int -> float -> float`
- **Description**: Adds `integer` and `flt` and returns a float representation of the sum.
- **Examples**:
  ```ocaml
  add_to_float 3 4.8 = 7.8
  add_to_float 0 0.0 = 0.0
  ```

#### `fib n`

- **Type**: `int -> int`
- **Description**: Calculates the nth [Fibonacci number](https://en.wikipedia.org/wiki/Fibonacci_number).
- **Examples**:
  ```ocaml
  fib 0 = 0
  fib 1 = 1
  fib 2 = 1
  fib 3 = 2
  fib 6 = 8
  ```

## Part 4: Lists

#### `add_three lst`

- **Type**: `int list -> int list`
- **Description**: Adds 3 to each element in `lst`.
- **Examples**:
  ```ocaml
  add_three [] = []
  add_three [1] = [4]
  add_three [1; 3; 5] = [4; 6; 8]
  ```

#### `filter n lst`

- **Type**: ``a -> `a list -> `a list`
- **Description**: Given `n` and a list `lst`, remove elements from `lst` that are greater than `n`.
- **Examples**:
  ```ocaml
  filter 2 [1; 2; 3; 3; 2; 1] = [1; 2; 2; 1]
  filter 5 [-1; 2; 3; 4] = [-1; 2; 3; 4]
  ```

#### `double lst`

- **Type**: `'a list -> 'a list`
- **Description**: Given a list `lst`, return a new list that has two copies of every element in `lst`.
- **Examples**: 
  ```ocaml
  double [1;2;3;4] = [1;1;2;2;3;3;4;4]
  double ["a"; "b"; "c"] = ["a"; "a"; "b"; "b"; "c"; "c"]
  ```
