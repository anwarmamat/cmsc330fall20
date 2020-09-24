# Discussion 4 Notes 
**What you learned in lecture this week** 
- Let statements 
- Tuples & Records 
- Higher Order Functions
- Tail Recursion 

The video and associated exercise (if any) will focus primarily on higher order functions and let statements and how they're used for problem-solving in OCaml.  

## Let Statements 
Not going into too much depth here. Let statements simply let you define some value and use it later on. If you were wondering how on earth you do multi-line functions in OCaml, well now you have your answer. 
Here's some code in Java (gross, I know)
```java 
int x = 3; 
int y = f(x); 
<some computation>
return some_value;
``` 
and the "same" code in OCaml 
```ocaml 
let x = 3 in 
let y = (f x) in 
<some computation> in 
<some_value>
```
You can do cool stuff with it too, like pattern matching within a let! 
```ocaml 
let lst = [1;2;3;4;5] in
let (x::xt) = lst in
x
``` 
Obviously, utop will yell at you for not making the pattern matching exhaustive ("But what if lst is empty?!"), but it'll still soldier through it.  

## Tuples and Records 
Tuples are Records are just different types of data structures that OCaml supports. 
####Tuples 
A tuple is probably the most straightforward: it's a way to package $n$ different (potentially heterogeneous!) things into one data structure. 
```ocaml 
let x = (1,"a",4.6, "c", 4+9) in 
match x with 
| (some_int, _, _, _, _) -> some_int 
``` 
Remember that the `_` in a pattern match is a wildcard. It can mean "I'll match on anything", and it can also mean "I don't care what value comes here, just discard it". I can't rave enough about tuples - they are SO useful (you'll become best friends during Project 4a and 4b if you aren't already best friends with them by then). Here are some cool things you can do:
```ocaml 
let name = "Shilpa" in 
let age = 21 in 
let ssn = "lol-you-thought" in
<some computation>
``` 
Disgusting! Instead try: 
```ocaml
let (name, age, ssn) = ("Shilpa", 21, "lol you thought") in 
<some computation>
```
I'm trying to write a helper function for this one part of the project and I need to return 2 different things: a list and that list's length. Not to fear: 
```ocaml
let your_weird_function = 
(your_list, its_length)
```
**Important Note** The way we write the type of some arbitrary tuple is: `type1 * type2`. 
Here some examples: 
```ocaml 
(1, "hello")  int * string
[(1, "a");(2, "b")]   (int * string) list
``` 
**Another important note**: As you've probably noticed, elements of a list are separated by semi-colons `[1;2;3;4]` and elements of a tuple are separated by commas `(1,2,3)`. So, doing `[1,2,3]` does not create a list with 1, 2, and 3 in it! It instead creates a list with a single tuple, namely the tuple `(1,2,3)`. 

####Records  
Records won't be as widely used as tuples for most of the stuff you'll do in this class (Project 3 is a humongous exception to this rule), but they're still pretty cool and worth mentioning, because once you get used to them, they're super easy to use. 
```ocaml 
type <record name> = 
    
    {
        field name> : <type>; 
        <field name> : <type>; 
        ... 
    } 

type student_record = 
    { 
        name : string; 
        age : int; 
        ssn : string;
    }
```
We can now create a record type simply by doing the following 
```ocaml
let <var name> = 
    { 
        <field name 1> = <value>; 
        <field name 2> = <value>; 
        ...;
    }  

let blah = 
    { 
        name = "Shilpa Roy"; 
        age = 21; 
        ssn = "think-again-dummy";
    }
```
OCaml, in its infinite wisdom, will infer that the type of blah is actually `student_record`. 
I can access fields of this new struct by simply using the familiar `.` syntax. EX. `blah.age`. Remember though, that though you can access fields of a record in this way, to modify them, you have to actually create it all over again, just like with any type in ocaml! 

So if I wanted to update my information to contain my actual social security number, I'd do:
```ocaml
let blah = 
    { 
        name = blah.name; 
        age = blah.age; 
        ssn = "555-55-5555"
    } 
```
And that's it. Obiously, you can do cool stuff with records, but as far as this course goes (and also industry from my experience), this is all you need. As always though, read more [here](https://dev.realworldocaml.org/records.html). 


## Higher Order Functions : An Overview 
Higher order functions are functions that can take other functions as arguments and can return functions. Functions in OCaml are said to be **first class** - that is, they're treated just like any other value. Whatever you can do with an int in OCaml, you can do with a function, but this is not the case in languages like C and Ruby, which treat our poor functions like second-class citizens and create things like function pointers and code blocks to make up for it. 

As with many things in life, the utility of being able to do this off the cuff in OCaml is something you'll only learn to appreciate as you program extensively in the language, and then at the end of the semester, when you're programming in JavaScript and C++ again and thinking of passing around a function like nobody's business, it'll hit you. 

Obviously, you can (and will) define your own higher order functions in this class, but two *really* important higher order functions (and by that I mean a lot of what functional programming is relies on these guys) is **map** and **fold**. 

## Map 
A map is very easy to understand, or at the very least, a lot easier to understand than a fold. A map simply takes a function and a list, and returns a new list where every element of the list has had the function applied to it. 

And the reason why it might come easy to you is because you've done it before! In your last discussion exercise, you had to implement a function called `add_three`, which takes a list and returns a new list where three has been added to every element: 
```ocaml 
let add_three_to_list lst = 
match lst with 
| x :: xt -> (x+3)::(add_three_list xt) 
| [] -> [] 
``` 
But this is exactly equivalent to instead doing: 
```ocaml 
let add_three x = x + 3 
let add_three_list lst = 
match lst with 
| x :: xt -> (add_three_list x) :: (add_three_list xt)
``` 
Or more succintly: 
```ocaml 
let add_three x = x + 3 
let add_three_list lst = map add_three lst 
``` 
Or EVEN MORE succintly: 
```ocaml 
let add_three_list lst = map (fun x -> x + 3) lst
```
It's clear to see now, by working backwards from this dumb function `add_three` we had you implement, exactly how a `map` works! 
```ocaml 
let map f lst = 
match lst with 
| x :: xt -> (f x) :: (map xt) 
| [] -> [] 
```
If my list is non-empty, I'm going to pluck the first element off of the list, apply the function to it, and stick it in front of my recursive call. And my recursive call maps the rest of the list, so at the end of the function, I'll have a brand new list. 
 

## Fold
Fold is one of the hardest concepts we teach you. If you can learn to understand a fold, you should give yourself a pat on the back. 
While a map modifies a list by simply applying a function over the elements of the list, a fold *processes* elements of the list in order to build this thing called an **accumulator**, which is what it ultimately returns. If a map is all about tracking how a list changes as a function is applied to it, a fold is all about how this accumulator changes. 
So how does it change? Essentially, in a fold, you pluck the first element out of a list (just like in map), and you take the current accumulator and this element you just plucked off, and run *both* of them through a function in order to get a **new** accumulator. Once you've run out of elements to *process*, you return the resulting accumulator. 
```ocaml 
let fold f a l = 
match l with 
| x :: xt -> fold f (f a x) xt 
| [] -> a
``` 
The function doesn't lie - so long as there are elements for me to process, I'll pluck one out from the list, combine it with my current accumulator (`a`), and then return a **new** accumulator (`f a x`), which I'm then going to use as my accumulator as I process the rest of the list. 
If you didn't gain an intuitive understanding for fold just from that blurb, that's fine! High level stuff like this almost always needs a bunch of examples to really stick in your mind (so if you still don't quite get it even after this example, the way forward is to do more!). At a high level, here's all you need to know: when you think of **fold**, you think **accumulator**. What does a fold return? It returns the accumulator. What does the function that is passed into a fold return? The accumulator. What contains all the information we need as we process the list? The accumulator.

#### Tracing Problems 
-`Problem`: Specify the output of the following:     
```ocaml 
fold (fun a x -> if x mod 3 = 0 then x::a else a) 
[] 
[1;9;4;3;27]
``` 
Remember, a fold is all about the accumulator, and the result of the fold *is* the accumulator, so to find out what this returns, let's just trace the accumulator! 
We start with `[]`, and we're now going to process the elements of the list one by one. First we grab 1 and `[]` to make a new accumulator, but 1 isn't divisible by 3, so our new accumulator is just our old one. Next we grab 9 and `[]` and this is divisible by 3, so the function tells us to cons 9 onto the list to give us `[9]`. Next we grab 4 and `[9]`, but 4 isn't divisible by 3, so our accumulator is unchanged. Next we grab 3, and it is, so we cons onto the list to get `[3;9]`. Next, we grab 27, and it also is, so we cons onto the list to get `[27;3;9]`. Next we...we ran out of elements, so there is no next, now we just return! 
-`Solution`: [27;3;9] 

The reason this type of question trips people up is because at first glance, it seems like the answer ought to be `[9;3;27]`, especially if we're thinking in the context of a map. 9 comes before 3 and 27 in the original list, so it should come first...right? This is not completely wrong, because 9 does actually get *processed* first, but turns out being processed first means getting cons'd onto a list and getting shoved to the back as other things gets consd onto the list in front of you. This seems like a phenomenal time to mention to you the existence of the function `foldr`. 

### Foldr: fold, but worse
I'm going to plop the definition here, take 3 seconds to figure out what it does: 
```ocaml
let foldr f lst acc = 
    match lst with 
    | x :: xt -> f x (foldr f xt acc) 
    | [] -> acc 
```
Alright, let's decode this. We know that a fold plucks elements off of the list, combines it with the accumulator, and creates a new accumulator that we use for the rest of the fold. Foldr is doing this in reverse. It gets all the way to the empty list, and then works backwards in order to create the accumulator. So, life hack: if you're asked to trace a foldr, just reverse the list and process it like a normal fold.
Several **really** important things to note here: 
1. when you actually call a foldr, the function comes first, then the ***list*** (**NOT** the accumulator), and then finally the accumulator comes last. 
2. Similarly, for the function passed into foldr, `f`, the element you're processing comes first, and *then* the accumulator. `(fun x acc -> ...)` instead of `(fun acc x -> ...)` 

The reason I'm giving you this disclaimer now is to avoid the hundreds of you who will come to office hours with perfectly logical code but you got the order of the arguments wrong because you were confused about which one of the fold twins you were using. 

#### Design Problems 

- `Problem`: Using only fold, return the sum of all the elements in a list.  
- `Examples`:
    ```ocaml
    sum [1;2;3;4] = 10 (*should return true*)
    sum [] = 0 (*should return true*)
    ```
    This is an easy example by itself. In fact, you probably saw this same example in lecture. But by taking it step by step for this really easy example, you'll see that these same steps scale really well for harder problems. 
    Alright, when I say fold you say? (Accumulator!) 
    And that's half of solving the hardest fold problem you'll ever see - just figuring out what the accumulator is and how you should use it. In this one, remember, a fold returns its accumulator, and the thing *we* want to return is the sum of all the elements (i.e. an int!). So our accumulator had better be an int that's going to change thorughout the course of the fold. How do you determine the initial value of your accumulator? Well, use boundary conditions. In this case, that means an empty list. What should the sum of an empty list be? Well, it's got nothing in it, so it should be 0. 
    Now that we have our accumulator, let's work out what the function should be, and then we're quite literally done. Remember, when I say fold, you say accumulator. This mysterious function that we have yet to write must take two arguments, just by nature of the fold, and what's more, we know that it returns the accumulator, so its return type had better be an int! Now we have the type of this function down (**int** *(accumulator)* **-> int** *(element of list)* **-> int** *(**new** accumulator)*), we just need to consider the logic. What do we want our function to do? Let's consider the problem. The problem wants us to sum things up, so the function should also sum things up: namely, add the current element to the accumulator and then keep going until I've added everything I can. 
- `Solution` 
    ```ocaml 
    let sum lst = 
        fold (fun a x -> a + x) 0 lst 

    (*Clever way*) 
    let sum_clever lst = 
        fold (+) 0 lst  (*`+` is a function 
        that takes two ints and sums them up!*)
    ```
- `Problem`: Write a function even_indexes, which will only return the indexes 0, 2, ..., 2$n$ from a list lst. 
- `Examples` 
    ```ocaml 
    even_indexes [1;3;3;5;7] = [1;3;7] 
    ```
    Before we gain a rough understanding of the problem, we might be eager to go: well, we want a fold, and a fold is all about the accumulator, so let's make the accumulator a list! This is a bad idea, but let's try it out anyway: 
    ```ocaml 
    fold (fun a x -> ?????) [] lst
    ```
    What should go in our function? We have no concept of what index it is into the input of our function, so we have no clue whether we're at an even index or an odd index. This example is teaching you how to use fold as a tool as opposed to something that you return. Remember, the only thing that you have access to as you keep folding over elements in the list is the accumulator! So any extra information we need has to be packaged in the accumulator! So let's relax our constraint on making the accumulator a list. Instead, we're going to have it carry a list that we're building AND information about the index. 
    ```ocaml 
    fold 
    (fun (index, my_list) x -> 
        if index mod 2 = 0 
        then (index + 1, my_list @ [x]) 
        else (index + 1, my_list))
    (0, []) 
    lst
    ```
    There's a lot of subtlety going on here. 
    1. My initial accumulator is 0, [], to indicate the 0th index and an initially empty list 
    2. In my anonymous function, I pattern match my accumulator in the definition. This is just to save me some space so I don't have to do
        ```ocaml
        fun a x -> match a with 
        | (idx, lst) -> .... 
        | _ -> a 
        ``` 
    3. If the index is even, like I want, I do `my_list@[x]`. This is because we have to be careful about the ordering of the fold. In order to avoid the cons, which adds to the beginnning and effectively buries things that come first, we instead do `my_list @ [x]`, to ensure the elements get added at the end. However, because the @ operator only concatenates two *lists*, we have to package x into a list in order for the magic to work. 

The more receptive of you will realize that you could do this "the normal way" if we used a fold right. We just have to be a bit more careful with our initial accumulator and associated function. 
- `Solution`
    ```ocaml 
    let even_indexes lst = 
        let (_, final_lst) = (fold 
            (fun (idx, currlst) x -> 
                if idx mod 2=0 then (idx+1, currlst @ [x]) 
                else (idx+1, currlst)) 
            (0, []) 
            lst)
        in 
        final_lst
    ``` 

    ```ocaml 
    let even_indexes lst = 
        let (_, final_lst) = (foldr 
            (fun x (idx, currlst) -> 
                if idx mod 2=0 then (idx-1, x::currlst) 
                else (idx-1, currlst))
            (List.length lst - 1, []) 
            lst) 
        in 
        final_lst
        )
    ``` 
    Note the order of the arguments in the foldr, the fact that my initial index has changed, and the fact that I decrement the index each time now. 

Fold is better than foldr mainly because its **tail-recursive**, which means the "last" thing the function does is the recursive call. Fold is tail-recursive because the though we compute (f a x) to get our new accumulator, we then immediately go into our recursive call and never look back. Foldr isn't tail recursive, because we do our recursive call through the rest of the list *first*, and then we have to come back and apply the function and the current element to that result. 

 
