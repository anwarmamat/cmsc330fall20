# Notes for Discussion Exercise #3
Surprise! We're now done with Ruby and moving onto a new programming language: OCaml. This discussion will go over OCaml basics, including typing/type inference, lists, tuples, functions, and testing!

## OCaml Overview

Remember that we called Ruby a *dynamically typed, implicitly declared, interpreted* programming language. In turn, those mean:
 - dynamically typed - the type of everything is determined at runtime, not compile time
 - implicitly declared - variables can be assigned to without declaring them beforehand (i.e. not like C)
 - interpreted - programs are not compiled - the source code is literally what is ran

OCaml, on the other hand:
 - compiled - the source code is turned into a binary file that runs directly on your CPU
 - statically typed - types are determined prior to runtime (in this case, at compile time)
 - implicitly declared
 - has _type inference_ - every variables type is automatically determined by the compiler(!)

That last bullet is one of the single most important features of OCaml. Coincidentally, it's also one of the most confusing. A good understanding of typer inferencing is _invaluable_ when it comes to debugging OCamls esoteric error messages, so we're going to do a bunch of examples today to try and understand it. By the end of this, you should be a typing master.

## UTop
Before we get started, I'd like to give a recommended way to follow along with these notes - this, of course, is with the magic of `utop`.    
Much like Ruby's `irb`, `utop` is a top level shell for OCaml. You can use utop to write out and test lines of OCaml code, to make sure they do exactly what you want them to. Upon running the `utop` command, you should see:
```
─( 16:39:00 )─< command 0 >──────────────────────────────────────────────────────────────────────────────{ counter: 0 }─
utop #
┌───┬─────┬───────────┬──────────────┬────────┬────┬──────┬─────┬───────────┬────────┬──────────────────┬──────────────┐
│Arg│Array│ArrayLabels│Assert_failure│Bigarray│Bool│Buffer│Bytes│BytesLabels│Callback│CamlinternalFormat│CamlinternalFo│
└───┴─────┴───────────┴──────────────┴────────┴────┴──────┴─────┴───────────┴────────┴──────────────────┴──────────────┘

```

`utop` will let you type in any valid line of ocaml code, followed by `;;` and have it evaluated immediately. This is incredibly useful when you're just starting out, and want to test out your ideas. I would recommend following along and trying the code I show for yourself.  
In particular, anything written in `code text` is executable in `utop` (from this point onwards).

## Types 
In OCaml, data types are one of the single most important concepts. First, we should get familiar with the players - you'll likely be familiar with the vast majority of these types, but a few of them are different. Some basic OCaml types are:
 - int: things like `-1`, `0`, `1`, `5`, etc.
 - float: things like `0.0`, `1.3`, `3.14`. Note that all operators on floats are proceded by `.`, like `+., *., etc`
 - bool: `true` and `false`. Unlike C and Ruby, OCaml does not support things like `0 = false`, 
 - string: `"hello, world"`

These should all be mostly familiar to you! But, not everything in OCaml is exactly the same - if it was, we wouldn't be teaching it! 

Note that OCaml has what's called **type inference**. This means that the compiler itself magically figures out the type of every expression purely by considering what each statement does!
A quick example: 
```
 a + b;;
```
Without worrying about the details, ask yourself what type this statement is? You probably notice quickly that this clearly is an int, and `a` and `b` are also ints, as the `+` operator acts on ints! The compiler goes through the same process to figure out all data types.

Another example:
```
a +. b;;
```
This is almost the same, but now it's the `+.` operator. Now, of course, everything changes! We know that `a`, `b`, and the result must all be floats.

These are basic examples to get you thinking about the kinds of things you should be looking for when evaluating the types of statements. You should be looking for things like operators or functions that are used to figure out what types things are required to be.

One final note: in some cases, there might be multiple possible options for a type - in fact, it might be the case that any type fits in. In these cases, you would denote that variable as being a generic type. In OCaml, these are listed as `\`a`, `\`b`, etc.

## Mutability
One of the most important things to remember in OCaml is that your data is not mutable! Practically, this means that updating a variable means creating a new variable based on the contents of the previous variable. That may sound confusing, but after a bit of time programming in OCaml, it comes very naturally.
Some quick examples: 
```
utop # let x = 3;; (*notice the let syntax for assigning variables *)
val x : int = 3
utop # x := x+1;; (* can't do this! *)
Line 1, characters 0-1:
Error
utop # let x = x + 1;; (* this does work, but we're creating a _new_ x. It's not the same as the first one *)
val x : int = 4
```
We will go over more examples of this in a bit, once we have talked about functions.

## Lists and Tuples
 OCaml lists are the "arrays" of the language. Unlike Ruby arrays, OCaml arrays are homogeneous, i.e. OCaml lists can eonly hold things of one type
```
utop # let lst = [1;2;3];; (*note that we use semicolons as the list delimiter! Make sure you don't use commas. *)
val lst : int list = [1; 2; 3]
let lst2 = 4::lst;; (* the (::) operator is also called the _cons_ operator, short for constructor. Note that this doesn't modify lst - it creates a _new_ list that is then stored in lst2. Cons basically pushes onto the front of the list. *)
val lst2 : int list = [4; 1; 2; 3]
```
Pay attention to the types utop gives here! The type of both `lst` and `lst2` are `int list`'s. This hold's true for a list of any type! If we have a list that holds things of type `\`a`, that list has type `\`a list`. This is intuitive, but it's important to remember that lists carry their types along with them. It's also good to know that lists can hold any type, even user-defined ones!

A quick note on the cons operator - `a :: b` means you're pushing a onto list `b`. That menas if `a` has type `\`a`, `b` must have type `\`a list`. The operator also doesn't work in reverse - you can' do `[]::5` to push onto the back of the list.

Tuples are yet another way to store collections of data in OCaml. However, they're different in two ways:
 1. They can hold heterogeneous data, i.e. data of different types.
 2. They are fixed-size! You cannot "add" anything into a tuple - in fact, changing the size of a tuple completely changes the type!

Let's give some quick examples:
```
utop # let tup1 = (1, "hello!");;
val tup1 : int * string = (1, "hello!")
utop # let tup2 = (1, "hello!", false);;
val tup2 : int * string * bool = (1, "hello!", false)
utop # let tup3 = (tup1, tup2);; (*we can even combine tuples into a tuple!*)
```
Note the types! The first one is a tuple of an int and a string, so the type is `int * string`. In general, this is how you describe the types of tuples. Finally, note that the last tuple shown only has two elements! Despite the fact that it is made up of a tuple with two elements and a tuple with 3 elements, its only elements are the two tuples themselves.  
**Exercise:** What is the type of the last tuple?    
**Solution:** Watch the video! Or type it into `utop` ;)


## Functions
Finally, we arrive to the heart of OCaml. The "functional" in functional programming basically means that your functions can be treated as data, the same way that an `int` or `string` or `boolean` can. This means two things, that we'll go more into next week:
 1. A function can take another function as an argument
 2. A function can return another function

But... this means that functions must have types! The typing of functions is _essential_ to understanding and debugging OCaml code. We will go over some simple examples:
```
let foo x y = x + y
```
This is a more well-defined version of our example above - here, `foo` is a function that takes in two ints and returns an int. This means that it is of type `int -> int -> int`. In general, if `f` is a function that takes in types `a1, a2, ..., an` as arguments and returns a type `b`, the function f has type `a1 -> a2 -> ... -> an -> b`. 

Functions are where our discussion of type inference becomes more important. Often, when writing OCaml code, you'll get an error like 
```
utop # let f x y = (x+1) +. y;;
Line 1, characters 12-17:
Error: This expression has type int but an expression was expected of type
         float
```
When starting OCaml, you look at this and go "what the heck does that mean". Learning how to decipher these error messages is vital, especially as they start getting more complicated. In this case, it might be clear: the `+.` operator expects both operands to be flaots, but one of the operands we supply is an int. Why is `(x+1)` an int? Because the `+` operator acts on ints. This internal loop of looking at how things are used can be invaluable when debugging.

We will give more examples:
```
let push a lst = a::lst
```
This function is fairly simple: we take an element a and a list, and we return a new list with a appended to the front of the list. So what's the functions type?

Well... we know `lst` is a list, so the second argument will have the form `type list`, where `type` is just whatever the type of `a` is. So what is the type of `a`? It could actually be anything! For variables like this, where there's nothing limiting the variables type, the type is bound to be _generic_. We denote that by the variables `\`a`, `\`b`, etc. In this case, that means `a` has type `\`a` and `lst` has type `\`a list`. Finally, what does the function return? Simply another `\`a list`. This means the function `push`'s type is `\`a -> \`a list -> \`a list`

What if we want to create a function that does limit the type of the generic `\`a`? Say, we only want to allow ints. Well, we just have to do some operation with `a` that guarantees it to be an int! Here's one that works:
```
let push a lst = (a+0)::lst;;
```
This function now has type `int -> int list -> int list`.

Note that sometimes, you'll have multiple different generic types, as in the following case:
```
let tuplist a b lst =
(a, b, a::lst)
```
Now, notice that the type of `a` must match the type of `lst`, as we use the cons operator on both of them. _But_, the type of `b` has no such restriction! That makes the type of this function `\`a -> \`b -> \`a list -> \`a * \`b * \`a list`. Note that the thing returned is a _tuple_ composes of things of the type of a, things of the type of b, and things of the type of a list containing the type of a.

Notice that though these are different, _that does not mean you cannot pass things of the same type in!_
For example, these are both valid calls to the `tuplist` function:
```
tuplist 1 2 [3;4] = (1, 2, [1;3;4])
tuplist "abc" true ["def"] = ("abc", true, ["abc"; "def"]) 
```
## Control Flow and Pattern Matching
There are two main structures that you will be using for control flow in OCaml. These are the gentle `if` statement, and the beast that is pattern matching.
We will not dwell on if statements for too long, they are almost exactly what you expect, with _one important_ caveat.   
Consider the following function:
```
let f b = 
if b then
3
else
"hi"
```
In a language like ruby, this would be allowed. However, in OCaml, both branches of the if statement _must_ evaluate to the same type. This is a very common source of errors and one you should look for while programming. 

On the other hand, pattern matching and `match` statements can be more complicated. The basic idea is this: for any type that can be broken down, you can use a `match` statement to break it down. That might not make full sense right now, so let's look at some examples.
```
let f lst = 
match lst with
| [] -> -1 
| h::t -> h
```
This function takes an `int list`, and outputs the first element of the list or, if the list is empty, -1. It does this by asking what the list could look like. It turns out, there are two cases for the list: either it is an empty list, or it is not. If it is not, then it necessarily has the form h::t, where `h` is an int, and `t` is an `int list`. To see this, let's consider an example: notice that `[1;2;3;4] = 1::[2;3;4]`. Further, notice that we could further repeat this decomposition and note that `[1;2;3;4] = 1::[2;3;4] = 1::2::[3;4] = 1::2::3::[4] = 1::2::3::4::[]. This observation is one of the keys to understanding recursion in OCaml!

You might notice that we haven't talked about loops. In OCaml, we don't use explicit for and while loops; instead, we use lots and lots of recursion! Here's an example of simple recursive function:
```
let sum lst = 
match lst with
|[] -> 0
|h :: t -> h + sum t
```
the `sum` function computes the sum over an `int list`. The way it does this is relatively simple; you match against the list. In the case that it's empty, you return 0. If it's nonempty, you add the head onto the sum of the tail of the list.

You can also match other objects! An important example is tuples, demonstrated below:
```
let sum_3_tup tup = 
match tup with
| (x, y, z) -> x+y+z
```
In this case, remember the tuple is a fixed size. In fact, we know that _every_ tuple that comes in will look like `(x, y, z)`, with no room for variability.

You can match against any type in OCaml, including ints, strings, etc. For most of these, the `match` statement essentially becomes a fancy case statement. But, the match statement will become invaluable in P2B when we start talking about user defined variant types.


## Exercise
Hopefully, these notes should give you enough info to complete the discussion exercise. If not, go ahead and watch the discussion video as well!
