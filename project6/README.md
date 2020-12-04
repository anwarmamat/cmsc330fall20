# Project 6: Stark Suit Repair
Due: 11 December 2020 at 11:59pm (Late 12 December)

public: 48pts, semipublic: 52pts

Ground Rules
---------------------------
**This is an individual assignment. You must work on this project alone.**

For this project you are allowed to use the library functions found in `std`, including `Vec`, `String`, `collections::HashMap`, and `Box`.

However, you may **NOT** use `collections::BinaryHeap` for your implementation.  You must create your own.

Also, you may not use any external crates for your implementation.

Introduction
------------
Tony Stark, a genius and master engineer who received his education at MIT, is best known under the alias Iron Man.  Stark built the Iron Man suit for his protection and went on to run his father's company, where he continues to improve his super suit.

You have been hired to work for Stark Industries!

Recently, Stark has been feeling skeptical of his suit's software.  Fearing for his safety, he decides to rewrite his code from C to Rust.  Rust is a type-safe language with no garbage collector where the developer does not have to worry about managing memory.  The proper amount of memory is promised to be allocated for you and objects are also deallocated for you too.  Typically unmanaged code has performance gains but is vulnerable to security risks such as buffer overflows where attackers can steal data or modify memory, as would happen in C if the code isn't managed properly.  However, in Rust, we can write fast/efficient unmanaged code AND be memory safe!

This is where you come in.  Stark is unfamiliar with the language and needs you to help him fix his suit as well as add some additional features.

Project Files
-------------
* Rust Files
    * __src/lib.rs__: This file describes the structure of the Rust library you are making.  You should not modify it.
    * __src/basics.rs__: This file contains the functions you must implement for part 1.
    * __src/locator.rs__: This file contains the functions you must implement for parts 2 and 3.
    * __src/communicator.rs__: This file contains the functions you must implement for part 4.
    * __tests/public/mod.rs__: These are the public tests.  Feel free to write your own.

Compilation and Tests
---------------------
In order to compile the project, simply run `cargo build`. To test, run `cargo test` in the root directory of the project. The tests won't run if any part of the project does not compile.

Installing Rust and Cargo
-------------------------
If you are working in grace, run `module avail rust` every time you log in.

For instructions on installing Rust, please see the [Install Rust](https://www.rust-lang.org/tools/install) page.

Part 1: Basic Warmups
---------------------
As mentioned earlier, Stark does not know the syntax of the rust language very well.  He attempted to write a few simple functions but failed to do so.

In this part of the project, you will be tasked with implementing the simple functions that Stark had trouble with.

`fn gauss(n: i32) -> i32`
* **Description**: Returns the sum 1 + 2 + ... + n.  If n is negative, return -1.
* **Examples**:
```
gauss(3) => 6
gauss(10) => 55
gauss(-17) => -1
```

`fn in_range(lst: &[i32], s: i32, e: i32) -> i32`
* **Description**: Returns the number of elements in the list that are in the range [s,e].
* **Examples**:
```
in_range(&[1,2,3], 2, 4) => 2
in_range(&[1,2,3], 4, 7) => 0
```

`fn subset<T: PartialEq>(set: &[T], target: &[T]) -> bool`
* **Description**: Returns true if target is a subset of set, false otherwise.
* **Examples**:
```
subset(&[1,2,3,4,5], &[1,5,2]) => true
subset(&[1,2,3,4,5], &[1,2,7]) => false
subset(&['a','b','c'], &[]) => true
```

`fn mean(lst: &[f64]) -> Option<f64>`
* **Description**: Returns the mean of elements in lst. If the list is empty, return None.
* **Examples**:
```
mean(&[2.0, 4.0, 9.0]) => Some(5.0)
mean(&[]) => None
```

`fn to_decimal(lst: &[i32]) -> i32`
* **Description**: Converts a binary number to decimal, where each bit is stored in order in the array.
* **Examples**:
```
to_decimal(&[1,0,0]) => 4
to_decimal(&[1,1,1,1]) => 15
```

`fn factorize(n: u32) -> Vec<u32>`
* **Description**: Decomposes an integer into its prime factors and returns them in a vector.  You can assume factorize will never be passed anything less than 2.
* **Examples**:
```
factorize(5) => [5]
factorize(12) => [2,2,3]
```

`fn rotate(lst: &[i32]) -> Vec<i32>`
* **Description**: Takes all of the elements of the given slice and creates a new vector.  The new vector takes all the elements of the original and rotates them, so the first becomes the last, the second becomes first, and so on.
* **Examples**:
```
rotate(&[1,2,3,4]) => [2,3,4,1]
rotate(&[6,7,8,5]) => [7,8,5,6]
```

`fn substr(s: &String, target: &str) -> bool`
* **Description**: Returns true if target is a subtring of s, false otherwise.  You should not use the contains function of the string library in your implementation.
* **Examples**:
```
substr(&"rustacean".to_string(), &"ace") => true
substr(&"rustacean".to_string(), &"rcn") => false
substr(&"rustacean".to_string(), &"") => true
```

`fn longest_sequence(s: &str) -> Option<&str>`
* **Description**: Takes a string and returns the first longest substring of consecutive equal characters.
* **Examples**:
```
longest_sequence(&"ababbba") => Some("bbb")
longest_sequence(&"aaabbb") => Some("aaa")
longest_sequence(&"xyz") => Some("x")
longest_sequence(&"") => None
```

Part 2: Min Heap Priority Queue
-------------------------------
In this part, you will be responsible for creating a min heap.  This data structure will be helpful in making part 3 easier (although not necessary for completion).  

Before implementing the following methods, it may be helpful to review how heaps work.  A min heap is a tree like structure where each node is smaller in value than it's children.  Instead of implementing the structure with a tree, we will use an array based implementation for efficiency.

If we index each node of a tree in level-order (starting at 0) we can calculate the parent index, left child index, and right child index as (idx-1 / 2), (2 * idx + 1), and (2 * idx + 2) respectively.

All the functions in this part belong to the `PriorityQueue` trait.  Traits are a neat feature in Rust (similar to Java interfaces) that allow us to add functionality to existing types.  In this project, we implement the `PriorityQueue` trait for the `Vec` type, allowing us to use three new functions in all vector types.

* `fn enqueue(&mut self, ele: T) -> ()`

The first function you will write is the **enqueue** method.  This method inserts an element into the heap.  For insertion, the first step is to find the first available spot in the array, placing the new element at the end of the array.  Then you must re-shape the structure so that it maintains the heap property of all children being larger than the parent.  Keep swapping the newly added element with its parent until the constraint is satisfied.  There is no return value for this method.

* `fn dequeue(&mut self) -> Option<T>`

The second function you will write is the **dequeue** method.  This method removes and returns the root element (or first element of array) from the heap.  Once we remove the root element, we must replace it with the last element in the array and again re-shape the structure so that it maintains the heap property of all children being larger than the parent.  Keep swapping the parent element with its smallest child until the constraint is satisfied.  The return element should be returned in the form of an option.  Return `Some(T)` if the heap is not empty.  Otherwise return `None` if the heap is empty.

* `fn peek(&self) -> Option<&T>`

The last function you will write is the **peek** method.  This method should return the element at the root of the heap without removing it in the form of an option.  Return `Some(T)` if the heap is not empty.  Otherwise return `None` if the heap is empty.

Part 3: Target Locator
----------------------
When in a large battle with the rest of The Avengers, it can be unclear what is the best strategy to help the team fight crime.  Stark wants to add a new feature to his suit that allows him to quickly determine which enemy he should fight whenever he is in large battles.

* `fn distance(p1: (i32,i32), p2: (i32,i32)) -> i32`

First, you will write a method called **distance**, that computes the orthogonal distance between two coordinates represented as tuples.

Orthogonal distance is not direct like Euclidean distance.  Instead, think about what is the least number of steps you need to move horizontally and vertically to get from one point to another.

For instance, the orthogonal distance between (2, 3) and (5, 1) is 5 (3 steps to the right and 2 steps down).

* `fn target_locator<'a>(allies: &'a HashMap<&String, (i32,i32)>, enemies: &'a HashMap<&String, (i32,i32)>) -> (&'a str,i32,i32)`

Next, you will write a method called **target_locator**, that will return the name and coordinates of the enemy that Stark will fight.

You are given the location of Stark, the location of your allies, and the location of the enemies in hashmaps, mapping names to coordinates.  The number of enemies will always equal the number of allies (including Stark) so every enemy matches up with exactly one ally and no one is left out.

Every ally will prioritize the closest enemy to them.  But if another ally is closer and will beat them to the enemy, they will have to find the next closest enemy to battle.

You should use the distance method to determine how close each ally is to each enemy.

You may find it very helpful to use the priority queue from part 2 in pair with the provided Node struct to assist you in your implementation.

To avoid ambiguity, assume no two pairs of allies and enemies have the same distance.
An example battle is shown below.
```
 ___________________
| A1 |    |    |    |
|____|____|____|____|
|    |    | E1 |    |
|____|____|____|____|
|    | A2 |    |    |
|____|____|____|____|
|    |    |    | E2 |
|____|____|____|____|
```

A1 and A2 represent the two allies (including Stark) and E1 and E2 represent the two enemies.  In this scenario, A2 will battle E1 while A1 would battle E2 despite being closer to E1.

Part 4: Communicator
--------------------
Stark is often in communication with his suit.  The suit is programmed with an intelligent AI that is able to listen to Stark and translate his words into a coherent string.  Stark needs his AI to listen for specific key words to trigger an event.

You are provided with an enum for all the commands Stark's suit can respond to:

```
enum Command
{
    Power(bool,i32),  
    Missiles(bool,i32), 
    Shield(bool),   
    Try,              
    Invalid
}
```
In order for the enum to have any functionality associated with it, you must complete the implementation provided for you.

* `fn as_str(&self) -> String`

First, you will write a function **as_str** that operates when called from a Command enum.  This method will check which command is calling this function and return the command's string representation.  Below is a chart outlining how each command is to be converted, matching commands with regular expressions corresponding to its output string.

```
    Command     |     String format
    ---------------------------------------------------------
    Power       |  /Power (increased|decreased) by [0-9]+%/
    Missiles    |  /Missiles (increased|decreased) by [0-9]+/
    Shield      |  /Shield turned (on|off)/
    Try         |  /Call attempt failed/
    Invalid     |  /Not a command/
```

For the boolean value in Power, Missiles, and Shield, a true value corresponds to "increased" and "on" while a false value corresponds to "decreased" and "off".

* `fn to_command(s: &str) -> Command`

Lastly, you will write a function **to_command** that takes a string slice and converts it to a command.  Below is a chart outlining how the strings will be passed into this method.  You can assume that any string that does not match the regular expressions provided will be considered an Invalid command.

```
    Command     |     String format
    ---------------------------------------------
    Power       |  /power (inc|dec) [0-9]+/
    Missiles    |  /(fire|add) [0-9]+ missiles/
    Shield      |  /shield (on|off)/
    Try         |  /try calling Miss Potts/
    Invalid     |  Anything else
```

As before, "inc", "add", and "on" correspond to a boolean value of true while "dec", "fire", and "off" correspond to a boolean value of false.

Resources
---------
Below we've listed some helpful links to functions you may want to consider using for your project.  The Rust-lang online textbook is a terrific resource.  You can find just about anything you need for this project in the book.

* [integers][integers]
* [vectors][vectors]
* [strings][strings]
* [str][str]
* [iterators][iterators]: some notable functions being collect, enumerate, zip 
* [options][options]

Project Submission
------------------

The easiest way to submit is to navigate to the project directory and run `gradescope-submit`.

If you submit another way, you must submit the files `basics.rs`, `locator.rs`, and `communicator.rs` containing your solution. You may submit other files, but they will be ignored during grading. We will run your solution as individual tests just as in the provided public test file. **No tests will pass on the submit server if the project does not compile!**

Be sure to follow the project description exactly! Your solution will be graded automatically, so any deviation from the specification will result in lost points.

Academic Integrity
------------------
Please **carefully read** the academic honesty section of the course syllabus. **Any evidence** of impermissible cooperation on projects, use of disallowed materials or resources, or unauthorized use of computer accounts, **will** be submitted to the Student Honor Council, which could result in an XF for the course, or suspension or expulsion from the University. Be sure you understand what you are and what you are not permitted to do in regards to academic integrity when it comes to project assignments. These policies apply to all students, and the Student Honor Council does not consider lack of knowledge of the policies to be a defense for violating them. Full information is found in the course syllabus, which you should review before starting.

[integers]: https://doc.rust-lang.org/std/primitive.i32.html
[vectors]: https://doc.rust-lang.org/std/vec/struct.Vec.html
[strings]: https://doc.rust-lang.org/std/string/struct.String.html
[str]: https://doc.rust-lang.org/std/primitive.str.html
[iterators]: https://doc.rust-lang.org/std/iter/trait.Iterator.html
[options]: https://doc.rust-lang.org/std/option/enum.Option.html
