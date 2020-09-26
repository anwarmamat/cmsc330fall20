# Discussion 4: Datatypes & Higher Order Functions
Due: 27 September 2020, 11:59pm EDT (No late submissions will be accepted)

Points: 100 public

## Introduction

This exercise consists of a couple of functions to get you familiarized with tuples and records, but mostly on higher order functions.  You can review the content of the discussion in [notes.rb](notes.rb), which includes the topics and examples from the discussion video.

### Testing & Submitting

You will submit this project to [Gradescope](https://www.gradescope.com/courses/171498/assignments/694478).  You may only submit the **disc4.ml** file.  To test locally, run `dune runtest -f`.

### Implementation

#### IMPORTANT NOTE 
You may **not** add the `rec` keyword to any of the functions you implement this week, and you may **not** implement any recursive helper functions. By following the video and notes sheet, you should be able to write these functions using only map, foldl, and foldr. 

#### `mul_thresh`

- **Type**: `int list -> int -> int * int`
- **Description**: Given a list of ints and another int `thresh`, return a tuple whose first element is the product of all elements in the list *less* than `thresh`, and whose second element is the product of all elements in the list *greater than or equal to* `thresh`. In the event that the list is empty, return the tuple (1,1), since this is the multiplicative identity, $a^0$
- **Examples**:
  ```ocaml
  mul_thresh [1;3;5;7] 6 = (15, 7)
  mul_thresh [] 6 = (1, 1) 
  mul_thresh [6;7] 6 = (1, 42)
  ```

#### `multi_map`

- **Type**: `('a-> 'b) -> 'a list list -> 'b list list`
- **Description**: Given a function `f` and a 2d list (a list of lists), return a new list in which each of the elements of the original list have had the function applied to them. 
As the name suggests, you might want to implement this function using multiple maps. 
- **Examples**:
  ```ocaml
  multi_map (fun x -> x ^ " is cool") [["shilpa"; "minya"];["vinnie";"pavan"]] = [["shilpa is cool"; "minya is cool"]; ["vinnie is cool"; "pavan is cool"]]
  multi_map float_of_int [[1;3;5];[2;4;6]] = [[1.;3.;5.];[2.;4.;6.;]] 
  multi_map float_of_int [[];[]] = [[];[]]
  ```

#### `update_database`

- **Type**: `val update_database : (string * int * float) list -> student_information list` 
- **Description**: Given a list of tuples of the following form: `(name, age, gpa)`, transform this list of tuples into a list of type `student_information`.  
- **Examples**: 
    ```ocaml 
    update_database [("alice", 21, 4.);("bob", 20, 3.85);("jess", 22, 2.9)] = [{name = "alice"; age = 21; gpa = 4.}; {name = "bob"; age = 20; gpa = 3.85}; {name = "jess"; age = 22; gpa = 2.9}]  
    update_database [] = []
    ``` 

#### `stalin_sort`

- **Type**: `'a list -> 'a list` 
- **Description**: Given a list, sort it using Stalin Sort, in which every element that is out of line is simply eliminated from the list. You **must** start from the left for this function.   
- **Examples**: 
    ```ocaml 
    stalin_sort [] = [] 
    stalin_sort [1;0;2;1;4;4] = [1;2;4;4] 
    stalin_sort [9;1;2;3;4;5] = [9]
    stalin_sort ["330";"is";"horrendous";"terrific"] = ["330"; "is"; "terrific"]
    ``` 

#### `stalin_sort_right`

- **Type**: `'a list -> 'a list` 
- **Description**: Given a list, sort it using Stalin Sort, in which every element that is out of line is simply eliminated from the list. You **must** start from the *right* for this function.    
- **Examples**: 
    ```ocaml 
    stalin_sort_right [] = [] 
    stalin_sort_right [1;0;2;1;4;4] = [0;1;4;4] 
    stalin_sort_right [9;1;2;3;4;5] = [1; 2; 3; 4; 5]
    stalin_sort_right ["216";"is";"terrific"; "lame"] = ["216"; "is"; "lame"]
    ``` 
- **Note**: 216 is not lame, it is an excellent course. It just isn't as good as 330. 
