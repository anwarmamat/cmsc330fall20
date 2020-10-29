# Discussion 8 Notes Sheet (Fall 2020)

## Contents
1. Preamble (the why)
2. Context Free Grammars (in theory) 
    2.1. Basic Vocab 
    2.2. Ambiguity 
    2.3. Associativity and Recursion
    2.4. Precedence
    2.5. DIY 
    * 2.5.1 Regex Questions
    * 2.5.2 Questions where vars depend on each other
3. Context Free Grammars (in practice) 
    3.1. Lexing 
    3.2. Parsing 
    * 3.2.1 First Sets 
    * 3.2.2 Recursive Descent Parsing
4. A gentle introduction to Project 4

## Preamble 
Ah, it's that time of the semester again, when projects and exams pick up, and everyone seriously considers dropping out of the major. It's a coming of age for all CS majors, so if you feel this way, rest assured that so did everyone else, and we somehow made it, so you probably will too. 
For 330, this means we are raising the stakes. Throughout this whole semester, we've been talking about regular expressions, and in Project 3, we amped that up to talk about NFAs and DFAs which by now I hope you know are just as powerful as NFAs - not more, not less. Any NFA can be expressed as a regular expression and vice-versa. And while these are actually super useful, they are at the bottom of the food chain in terms of expressivity and raw power. Hopefully by now we've convinced you that you can do a whole lot with regular expressions...but you can't do everything. 
You are now advanced enough to learn the next rung of the ladder, Context Free Grammars, affectionately dubbed CFGs (not to be confused with Control Flow Graphs). These are strictly more **powerful** than regular expressions (and NFAs), and by **power**, we mean that a CFG can not only express every language a regular expression can, it can express strictly *more* languages than a regular expression can. There are secrets that regular expressions will never be able to uncover that the CFG can. (Not even CFGs have full computational power, but we'll save that final boss for a later time). 

## CFGs (in theory)
So why do regular expressions suck (in comparison to CFGs)? Regular expressions have no concept of **memory**. It has no idea of where it has been and where it's necessarily going.
Take the regular expression `/ab/`. Here, the `b` has no knowledge of what comes before or after it. All it knows if what to do with where it's currently at, and in fact, we can see this if we think about NFAs! If we put this into finite automata speak, it looks something like `(S0) --a-> (S1) --b-> ((S2))`. Now, imagine that I am processing the string `"ab"`. The minute I process `'a'`, I am at `(S1)`, and the only thing I can process is `b`. From our current viewpoint when we're processing the string, the entire NFA is just `(S1) --b-> ((S2))`, because that's all we can do! In fact, it's almost like the state that got us to `S1` never even existed!
Not having a memory turns out to be a huge downfall of regular expressions. Most types of string patterns, a regex will be able to match, but the big, tough guys will forever elude it. A CFG on the other hand, has a memory, a sense of state. It's almost like a living thing, that we breathe life into when we define its **rules**. 
Speaking of which, a CFG is defined by a set of **rules** that dictate how the CFG can expand. We always start at some sort of "start state", which we usually denote S (for start). What follows is our *rule* for how to expand S into what we want.  
```
S -> aS | ε
``` 
Once we start with S, we can either expand that S such that we add an a to the front of it, or we can make it the empty string. What follows is now a recursive process of this string. 
```
S -> aS -> a(aS) -> a(a(aS)) -> (a(a(a(ε)))) = aaa
``` 
Here, I explicitly put parens so it's easy to see how the string "aaa" is **derived** (this is the word we use to mean how we create a string), but normally, you'd do something like: 
```
S -> aS -> aaS -> aaaS -> aaa
``` 
Note that I stopped here at 3 because I felt like it, but you could keep going on and on, forever adding an a to your heart's content. Which means, although we just showed the derivation for "aaa", the true language this CFG can represent is an arbitrary number of "a"s, aka the regular expression a*. 
**Key Concept: The language a CFG can represent is the collection of all strings that can be derived from the CFG**
Of course, we can have multiple rules, that lead us to even more derivations, and we can have rules depend on rules, and so on: 
```
S -> A | T 
A -> bA | b | C 
C -> c 
T -> tT | t
``` 
And let's try deriving out the string "bbbbb" 
```
S -> A -> bA -> bbA -> bbbA -> bbbbA -> bbbbb
```
Before we get into why this is cool, we need some ground rules, that are going to make your understanding of a CFG much better: 
### Basic Vocab
* `Nonterminal` : A nonterminal, usually represented by a capital letter (like S, A, C, or T from the example above) is something for which a rule is defined. It is called a nonterminal, because it isn't a *fixed* thing that terminates - you can always expand it by following the rule! 
* `Terminal` : A terminal, usually represented by lowercase characters (like +, or b, or c, or t) are things that are fixed and terminate. For instance, in the example above, the minute I replace `A` with `b` (the second option specified in `A`'s rule), I'm left with `bbbbb`. I can't do anything with `b` (because there's no rule for it!) so it *terminates*, which means it is a terminal. 

In the CFG above,
* S is a special non terminal that represents the starting point of the grammar
* T is a non terminal
* a, b, c, and t are terminals
* ε is the empty string.
* C -> c is a production
* You can read it as:
    S can be A or T. A can be bA, b, or C. C can be c. T can be tT or t. 
### Ambiguity 
Sometimes, we'll come across a CFG that looks like this 
```
S -> S + S | T 
T -> 1 
``` 
Just by inspection (for instance, running through this CFG in your head), it clearly just gives you a way to sum together a bunch of 1s (forever, if you willed it). For the hell of it, let's try to derive out the string `1 + 1 + 1`. Alright, we know we're starting with S, and then we just have to expand it. Clearly, since we want `+` to appear in our string, we'll need to use the first option of the `S` rule at least twice: 
```
S -> S + S -> S + S + S 
```
Here's a question for you, how did I get from step 2 (S + S) to step 3 (S + S + S)? In other words, **which of the two S's did I expand to get from step 2 to step 3**? I will give $100 to whoever can guess the right answer (Hint: you will always be wrong ; here's a super complex function I perfected that shows you why: 
```
let will_kids_win_100_from_shilpa guess = 
    if guess = "left" then "Nope, I expanded the right one" 
    else "Try again loser, I expanded the left one"
```
) 
The reason why you will never win against me is because this CFG is **ambiguous**. Some might even call it *non-deterministic* :smiling_imp: (people don't really call it that, but I wanted to insert a reference to project 3 in here). This CFG is ambiguous because there are two *identical* non-terminals here and I have a **choice** as to which one I get to expand out. I can either ALWAYS choose to expand the left non-terminal (this is called a **leftmost derivation**) or the right non-terminal (this is called a **rightmost derivation**)
**Key Concept: A CFG is ambiguous if there are multiple leftmost derivations for the SAME string** (*wink wink*, on an exam, if we ask you if a CFG is ambiguous, this is what we want from you). 
In general (for a random CFG) it is hard to show ambiguity purely by inspection, but if you see something like `S -> SS` or `S -> S <some_operation> S` or `S->SSS` (I'm using `S` here but remember the same holds for any nonterminal), you should be very suspicious.
Let's show the above CFG is anonymous by using the same string from before: "1 + 1 + 1": Remember, to show ambiguity, we need to show two leftmost derivations for the same string, and since we are showing a leftmost derivation, at every point, we are going to use the production rule for the leftmost nonterminal (in this case, the only nonterminal is S, so S) 
```
# Derivation 1 
S -> S + S -> S + S + S -> T + S + S -> 1 + S + S -> 
1 + T + S -> 1 + 1 + S -> 1 + 1 + T -> 1 + 1 + 1    (yay) 
# Derivation 2 
S -> S + S -> T + S -> 1 + S -> 1 + S + S -> 
1 + T + S -> 1 + 1 + S -> 1 + 1 + T -> 1 + 1 + 1    (oh no)
``` 
So this CFG is ambiguous. And maybe someone might think that it doesn't matter if its ambiguous so long as you can express the language that you want...and they'd be right. But if you want a *computer* to be able to recognize a certain language and accept or reject input (we call this **parsing**), ambiguity is a huge no-no!
To get rid of ambiguity, we simple *remove* the reason for the ambiguitiy: the ability of **choice**. Our problem was that there were two S's in our rule, so at any point, we could choose to do different things to both of them to result in the same string. To remove this, we recognize that eventually, somewhere down the line, S *has* to result in T (because that's the only way we can terminate), so we can replace our CFG with: 
``` 
# Option 1 
S -> T + S | T 
# Option 2 
S -> S + T | T 
``` 
Convince yourself by trying out a couple of strings that the rules I've proposed above hold the same meaning as the original CFG (aka every string you can make with the original, you can make with my new and improved one). 
Also convince yourself that there is no more ambiguity here. For every possible string that you can come up with, there will only ever be one way to produce that string if you're using my new and improved CFG. 
By the way, this rule scales. You can cure multiple types of ambiguity, by just repeating this all the way down: 
```
S -> S + S | M 
M -> M * M | N 
N -> n | (S) 
``` 
cured by doing: 
```
S -> M + S | M 
M -> N * M | N 
N -> n | (S) 
``` 

Sometimes, it might be hard to see how we remove ambiguity 
```
S -> S + S | 1 | 2 | 3 
``` 
This is clearly ambiguous, but how on earth do we mitigate this? Well, by simply aggregting all the terminals into a nonterminal and applying the simple trick! 
``` 
S -> S + S | M 
M -> 1 | 2 | 3 

# And now the miracle cure 
S -> S + M | M 
M -> 1 | 2 | 3 
```

### Associativity and Recursion
You'll notice that I gave two valid CFGs above when I was removing ambiguity. Sometimes I replaced `S + S` with `M + S` and other times, I replaced it with `S + M`. I told you they were both valid (and they are!), but in terms of how strings are derived, they have different names. 
``` 
S -> S + M | M 
M -> M * N | N 
N -> n
``` 
is what we call a **left recursive** grammar. Why? Because the nonterminal we are trying to expand out occurs on the left hand side. So you'll see that when we recurse, we always recurse "leftwards". (EX. `S -> S + M -> (S + M) + M -> ((S + M) + M) + M)` Notice how the left is how we constantly recurse and build up the string. Note that M is also a nonterminal, but S is the nonterminal we are expanding out. For the same reason we call the (+) operator here a **left associative operator** because the nonterminal we are expanding (S), occurs to the *left* of the operator (+). By taking the logic a step down, we can see (*) is also a left-recursive operator. 
``` 
S -> M + S | M 
M -> N * M | N 
N -> n 
``` 
is a **right recursive** grammer, because the non-terminal occurs on the right hand side. For similar reasons, (+) here is a **right associative** operator. (And so is (*)).
``` 
S -> M + S | M 
M -> M * N | N 
N -> n 
``` 
This is neither right nor left recursive as a grammar, because the individual rule S is right recursive, and the individual rule for M is left recursive. So here + is right associative and * is left associative. (You'll see why this distinction matters soon, but for now, keep the vocab in mind).  

### Precedence 
Another thing to note in the CFG above is how the operators are **ordered**. For instance, clearly, the language at the end of the previous section just allows you to multiply and add numbers together (where n is a number, let's say). So would the following CFG be equivalent to the one from before? 
```
S -> M * S | M 
M -> N + M | N 
N -> n
``` 
The answer is **NO**. The order the operators come actually matters.
```
S -> M + S | M 
M -> N * M | N 
N -> n 
```
Multiplication (i.e. the `*` operator) has higher **precedence** than addition (i.e. `+`). It might be a little hard to see intuitively, so trust me on this one for now, but you might be able to see it if we derive out a couple of strings. 
``` 
S -> M + S -> M + M
``` 
At this point in the derivation, we have `M + M`, aka one quantity added to another quantity, but of course, we know that both of these quantities are multiplications! 
```
_M_ + ^M^ -> _N * M_ + ^N * M^ -> _1 * 2_ + ^3 * 4^
```
(I skipped a bunch of derivations here for the sake of space, but you can work out how we got to these strings). At the end of the derivation, we still have two quantities being added together, but notice how by the very nature of how the CFG is organized, multiplication necessarily comes before addition! In the toy CFG I presented at the beginning of the section (where multiplication occurs above addition) the reverse is true! 
**Key Concept: The further down you go in a CFG, the higher the precedence**

### DIY 
Often times, just like we tell you to write regular expressions that will match certain strings (like in the Ruby programming section), we'll also give you a random language we want you to express and ask you to write a CFG for it. And this is very hard. In fact, I would wager that aside from OCaml programming questions, CFG design questions are the hardest questions on the exam, and unlike NFA->DFA, or RE->NFA, or Operational Semantics and Lambda Calculus (coming soon), there's no handy algorithm that you can blindly apply! You really have to stare at your paper (or screen, now) and hope that something comes to you. With that said, there are a couple of things we can do to make the sting of these questions a little less prominent. 
#### Regex Questions 
Who on earth would ever use something as holy as a CFG to represent regular expressions? Us, sometimes. Just as a sanity check so you know what to do, so here are some common implementations of regex in CFG language. (Remember A and B here are arbitrarily complex regular expressions themselves)
* `A` : `S -> A`
* `A*`      :   `S -> AS | ε` 
* `A+`      :   `S -> AS | A`
* `A|B`     :   `S -> A | B` 
* `AB`      :   `S -> AB`
* `A?`      :   `S -> A | ε`

EX. (a|b)+c 
Blindly applying our algorithm:
```
S -> PC 
P -> TP | T 
T -> A | B 
A -> a 
B -> b 
C -> c
```  
Using a little intuition: 
```
S -> Pc 
P -> TP | T 
T -> a | b
``` 
#### Questions where vars depend on each other 
These are the most common kinds of questions (and the ones that are hardest). These are questions like the canonical question: Define a CFG that accepts the language a^x^b^x^ 
We know that the answer here is `S -> aSb | ε`. If we dissect this language, we see that our restriction was that a and b occur the same number of times, and we enforce that restriction because in our CFG, every time an a appears, so does a b! We can generalize this in this form: For instance a^x^b^2x^. This tells us every time we see an `a`, we also need two `b`s. 
So our CFG is just 
```
S -> aSbb | ε
```
What if we place an additional restriction that x >= 1?
Then, we need it to occur at least once, so we get 
```
S -> aSbb | abb
```
What if we place another restriction that x <= 2? 
Then, we need to ensure it only occurs at most twice. This is impossible to do if we are allowed to recurse, because I could keep going forever. In this case, we have to harcode: 
```
S -> aabbbb | abb
```
What if we have a^x^b^y^ where y >= x? Then: 
```
S -> AB 
A -> aA | ε 
B -> bB | b
```
Sure, this enforces that there is at least one b, but it DOESN'T enforce that the number of b's exceed the number of a's. (Try it out: you'll be able to generate the invalid string aaaaab from this buggy CFG). The real answer is: 
```
S -> AB 
A -> aAb | ε 
B -> bB | b
```
Now, no matter how many a's I try to generate, I'll always generate a b too!
This stuff can get really hard really fast, so rewatch the lectures and the discussion video for some harder examples because explanations in text almost always fall flat. 
### Practice
* Practice terminlogy
    ```
        S -> S * T | S / T | (S) | T
        T ->  1 | 2 | 3 | 4 | 5
    ```
    * How many productions do we have?
        **Answer:** 9 as seen when written out in full form i.e
        ```
            S -> S * T
            S -> S / T
            S -> (S) 
            S -> T 
            T -> 1 
            T -> 2 
            T -> 3 
            T -> 4 
            T -> 5
        ```
    * What are the terminals?
        **Answer:**  *, /, (, ), 1, 2, 3, 4, 5
    * What are the nonterminals?
        **Answer:** S and T

* Practice derivation
    * Derive (2 * 3)/4
        **Answer:**
        ```
            S -> S/T -> (S)/T -> (S*T)/T -> (S * 3)/4 -> (2 * 3)/4
        ```

    * Can we derive (2 * 3) + (4/5)?
        **Answer:** No since + is not a terminal in our CFG


* Practice designing grammars
    * Write a CFG for a^x b^x c^y | a^x (where x >= 0 and y >= 1)
        **Answer:** 
        Think of it kinda like a regular expression. We have one thing (a^xb^xc^y) unioned with another thing (a^x). So let's simplify and focus on them separately. (and then we notice the left hand side is a concat, so we can simplify further, and so on)
        ```
            S -> A | B      (for a union of 2 languages)
            A -> CD         (for a concatenation of 2 languages)
            C -> aCb | ε    (for the same # a's and b's)
            D -> cD | c     (for 1 or more c's)
            B -> aB | ε     (for 0 or more a's)
        ```

## CFGs (in practice) 
OK, after all of that, we are finally ready to transcribe all of this into code and see how cool this stuff really is. Up until now, you've programmed in Java, in C, in Ruby, and in OCaml, but you've never really worried about how it is that Java knows what you mean when you give it instructions, and how it knows that what you typed out in your IDE is valid code. As seen in lecture, Java syntax can be represented by a CFG, and we use CFGs to derive out strings. If we represent all valid Java programs as just a long string (where whitespace doesn't matter), then we have the following: **All valid Java programs can be derived using its CFG. Any Java program that cannot be derived from the CFG must be invalid and result in a compilation error**. 
At a microscopic scale, let's try this on for size: 
```
DeclarationStatement -> Type VarName ; 
Type -> int | bool | char 
VarName -> <string> 
```
With this toy example, you can see the string `int x;` is valid, but `int x` is not valid, because we missed a semi-colon and the CFG insists that a semi-colon must follow `VarName`! In project 4, you are going to be working behind the scenes just like this to validate programs in a language we made up called Small C, and while you're working out huge bugs, you might easily miss just how cool what you're doing is, so before or after you finish it, take a second to really marvel at how awesome you are for being able to build your own lexer and parser. 

### Lexing 
The first step to "validate" code (and not necessarily code, but anything you can express using a CFG), is to take this string (which can be arbitrary crazy), and transform them into **tokens**. For instance, look at the following valid strings from the dumb CFG from above: 
```
bool          wwwwwwwwwwwww        ; 
int y; 
``` 
Clearly, both of those strings represent valid derivations of our CFG, but maybe you can see why its so ugly - they differ in length, in whitespace, and in general, a bunch of other things. String processing is famously hard (if you take CMSC420 and/or CMSC451 you'll get a taste for how hard), so instead we **tokenize** to make things a whole lot nicer. 
```
[Bool ; VarName "wwwwwwwwwwwww"; SemiColon] 
[Int ; VarName "y" ; SemiColon] 
``` 
Here, the lists containing these tokens are of the same length, and we just have to traverse the list and make sure our tokens match what we have.  

In fact, let's create an OCaml type to represent our newfound tokens 
```
type token =      Bool 
                | Int  
                | Char
                | VarName of string 
                | SemiColon
``` 
(In your project, we'll use different names, but really, they're just names, so you could name a token after yourself, but then everyone would hate you because now they have to remember that "ShilpaIsCool" just means "Int", which is annoying).

### Parsing
Now that we have tokenized our strings, it's time to parse (aka "process" our tokens and ensure that they match our CFG). Remember that at this point, we now have a dandy token list that we are processing to check for validity, which is great, but how do we actually process it? Our CFG looked like this: 
```
DeclStmt -> Type VarName ; 
Type -> bool | int | char 
VarName -> <string>
``` 
If we think about all possible valid strings, ALL of them must start with either "bool" or "int" or "char" (or in our new terminology: Bool, Int, or Char), so our function that processes strings should include those first. This is the idea behind **First Sets**
#### First Sets 
First Sets involve taking the first "thing" out of each rule in a CFG. There are some really nice complex examples in the slides, so please do take a look at those if the examples below don't solidify it for you. (In general though, just pretend you have a valid string and decide what comes first for those) 
```
S -> aSa | Bct | AS 
A -> z | x 
B -> m | ε 
``` 
In order to be able to parse S, we need an indication of what comes first, so we compute First(S). Imagine all the strings that are valid starting from S, and just pluck the first letter off of them! So for instance, from S, we can generate `aSa`, so any valid string that starts with this production must start with `a`! So we have {a}. Now, if we consider the second production `Bct`, we know that strings from this branch must start with whatever `B` starts with! What is First(B)? Well it looks like B is either m or ε, so {m, ε}. Which means, coming back to S, that either the string must start with `m` OR it must start with `c`. In the first case, we go to `B` and decide to produce m, giving us the string `mct` whereas in the second case, we go to B, decide to produce ε, and the resulting string is `ct`. So now we have {a, m, c}. Finally, the last production starts with A, so we need to compute First(A), which is pretty simple, since it's just {z, x}. Thus, First(S) = {a, m, c, z, x}. 

Now we can parse it: 
``` 
let rec parse_S token_list = 
    match lookahead token_list with 
    | 'a' -> let toklist1 = process_token 'a' token_list in
                     let toklist2 = parse_S toklist1 in 
                     let toklist3 = process_token 'a' toklist2 in 
                     if toklist3 <> [] then failwith "Error, extra tokens" 
                     else []
    | 'm' | 'c' -> let toklist1 = parse_B token_list in 
                     let toklist2 = process_token 'c' toklist1 in 
                     let toklist3 = process_token 't' toklist2 in
                     if toklist3 <> [] then failwith "Error, extra tokens" 
                     else []
    | 'z' | 'x' -> let toklist1 = parse_A token_list in 
                    let toklist2 = parse_S toklist1 in 
                    if toklist3 <> [] then failwith "Error, extra tokens" 
                    else [] 

and parse_B token_list = 
    match token_list with 
    | 'm' :: rest -> process_token 'm' token_list 

and parse_A token_list = 
    match token_list with 
    | 'z' :: rest -> process_token 'z' token_list  
    | 'x' :: rest -> process_token 'x' token_list
```
The syntax may look confusing, but all we're doing is following the CFG! I match on everything that I can possible get in my subset, and then I do as the CFG guides. Essentially, since I can go to three possible branches from S, I decide to **lookahead** and see what's on my token list (basically take the first element out of the token list), and based on what I see, I then decide which of the three branches I should go in. If I see an `a`, I must be in the first production, so let me process the `a` by removing it from my token list, and then let me parse S all over again, and then finally, process that last trailing `a`. At this point, I should have processed my whole token list, so if I haven't, I yell at whoever gave me the input. 
The `and` keyword is probably something you haven't seen yet, but it's nothing to be afraid of : `and` just means mutually recursive. So if I have two functions, `func1` and `func2`, and they call each other, we know OCaml will yell at us, so `and` is just a way to get around that roadblock:
```
let func1 () = func2 () 
let func2 () = func1 () 
 -> Error: Unbound value func2
```
#### Recursive Descent Parsing 
With all of that, our work is still not done (ok, it's mostly done, but there's a consideration here). The type of parsing that we just did in the earlier section is something called **Recursive Descent Parsing**. This is because we *recursively* *descend* through the CFG (first S, then B, then A) and process our tokens as we go along. This is a type of **top-down parsing** where we start from the top and go down. There are other ways to parse that are bottom-up, but we won't learn that in this class. 
However, to make Recursive Descent Parsing work, we need our CFGs to be in a very specific form. Namely, they need to be right recursive, AND all operators need to be right associative. To see why, let's take a left-recursive grammar: 
```
S -> S + M | M 
M -> 1 
``` 
If we try to define an OCaml function to parse this, we get: 
```
let rec parse_S token_list = 
    parse_S token_list
``` 
and we are now in an infinite loop, because with each of these successive calls, our token list isn't getting any smaller, so we're not making progress! On the other hand, take a right recursive grammar:
```  
S -> M + S | M 
M -> 1 

let rec parse_S token_list = 
    let toklist2 = parse_M token_list in 
    match lookahead toklist2 with 
    | `+` -> let toklist3 = process_token `+` toklist2 in 
             let toklist4 = parse_S toklist3 in 
             if toklist4 <> [] then failwith "NOOO" else [] 
    | _ -> if toklist2 <> [] then failwith "NOOOO" else []
```
Since in both branches, we have to parse M first, we do that, and since parse_M will get rid of tokens for us, at every point, we're making progress!
**Key Concept: Recursive descent parsers require right recursive grammars** 
**Key Concept: Recursive descent parsers are examples of top-down parsing**


## A gentle introduction to Project 4 
In project 4, we're going to ask you to lex strings and then parse them following the CFG. Today's discussion exercise is designed to be an introduction to the type of thing that you will do. Watch the video for details - I'm tired of typing 

Here are some tips though: 
If you think your parser is right, and by right I mean you'd be willing to bet your least favorite hand on it, but you're still failing tests, the issue is probably your lexer. Unless your lexer is perfect, none of the stuff you do in your parser will ever matter, because the parser relies on the token generation you do in your lexer.  
For that matter, if you're willing to bet your least favorite hand on your lexer being correct AND your parser being correct, then take a look at how you're generating your errors and how you handle complex strings that are valid. Also, you should be more careful with how you bet your body parts, because you'll almost certainly run out if you keep gambling them away on projects in undergrad CS courses. 

## Resources 
[Here](https://web.stanford.edu/class/archive/cs/cs103/cs103.1156/tools/cfg/) is a link to a helpful CFG tool  that you can use to construct and test CFGs.

