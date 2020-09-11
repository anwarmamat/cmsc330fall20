# Notes for Discussion Exercise #2

Today's discussion exercise is focused entirely on increasing your understanding of regular expressions and code blocks. All of this information and worked out examples will be in the video!

## Code Blocks

A code block is essentially just an anonymous function - it binds on some variable or variables you pass in and does something with them. The only thing confusing about them is the weird syntax surrounding them and the dreaded `yield` keyword - gross.

But it won't be quite so gross after a quick example. Just know that the following valid Ruby code:
```ruby
arr = [1,2,3,4]
arr.each {|x| puts x + 2}
```
can be simplified to:
```ruby
arr = [1,2,3,4]

def anon_func(x)
    puts x + 2
end

for i in arr
    anon_func i
end
```
You can do something similar with a hash!
```ruby
hash = {}
hash.each {|k, v|
    do something
}
```
Like I said, the `yield` keyword is gross, but all it's doing is "calling" the function! But because the code block is kind of like an "anonymous function", we don't know what to call it! So we just "yield" the argument over to the code block.
```ruby
arr = [1,2,3]
for i in 0...arr.length
    yield arr[i] #call the function
end
```

The fantastic thing about Ruby is that any and every function has an "implicit" code block. As in, you can give a code block to anything!

```ruby
def shilpas_dumb_function()
    print "my grandmother hates crocheting"
end

shilpas_dumb_function() {|x| "this does nothing lol"}
```
I passed in a random code block to `shilpas_dumb_function`, but because `shilpas_dumb_function` doesn't do anything with it, it's just ignored! But if I wanted to actually access whatever code block was given, I can do that with a handy function called `block_given?`. Here I'll show you:

- **Problem** : Given an array of elements and a code block, if whatever is returned by the code block is divisible by 2, print out that element. If no code block is give, print out "Nothing"
- **Solution** :
```ruby
def print_div_by_2_w_codeblock(arr)
    if block_given?
        for i in 0...arr.length
            # call my function
            # and check divisibility
            if yield(arr[i]) %2 == 0
                puts arr[i]
            end   
        end
    else
        puts "Nothing"
    end
    arr
end
```

## Regular Expressions

A regular expression is like sand - you will never escape it. It will show up no matter where you go - data science, software engineering, cybersecurity, software testing, you name it. The reason why is because it is a powerful (and simple!) tool to detect input.

### The Basics

```
if string =~ /your regular expression here/
    do something
end
```

- `^` : Outside a character class, indicates that the regular expression better occur at the start of the string
- `$` : the regular expression better occur at the end of the string *(Hint: When used in conjunction with `^`, you guarantee that the whole string matches the regex exactly)*
- `[]` : A character class - put whatever you want in here and the regex will accept one of those things. Ex. `[a-zA-Z]` will accept all upper and lowercase letters! This is essentially shorthand for doing `a | b | c | d ... | A | B | C | ...` *(Hint: you can also specify what you DON'T want by using `^`. Ex. `[^abc]` means anything but a, b, or c.)*
- `|` : I'll accept either / or. Ex. `cash | credit`
- `?` : One or none. It could be there, or maybe not. Who knows.
- `*` : Zero or more. There could be nothing at all, or 500. Who knows.
- `+` : 1 or more, at least one. Essentially `a+` is the same thing as `aa*`.  
- `()` : used for **capture groups** :smiling_imp:

### Capture Groups

Congratulations, you now know how to detect if some input string passes your rigorous regex check. But how do we extract information we need from it (*Wink wink: project 1*)?
Capture groups!

Say that some user is going to give you their name, age, and their four digit pin, all comma separated, and for whatever reason, you wanted to take this information and put it in some data structure (*wink, P1, wink*)

Let's say we have a text file (shown below), and we want to extract the personal info from the file below. The first "column" contains the names of some our TAs, the second "column" is their age, and the third "column" is their PIN.

```
Shilpa, 25, 1234
Pavan, 7, 5678
Minya, 12, 4658
Vinnie, 50, 9512
```

Here's what you have to do:
First, let's create our regex (we're going to pretend people don't live past 99 here):
`/^[A-Z][a-z]*, [1-9]?[0-9], [0-9]{4}$/`
To capture them, surround the relevant parts in parens.
`/^([A-Z][a-z]*), ([1-9]?[0-9]), ([0-9]{4})$/`
And now, `$1` refers to the name, `$2` refers to the age, and `$3` refers to their PIN.

Essentially just surround the thing you want to extract from the regex in parentheses and then backtrack using global variables (`$`) to grab what you want. *(This is pretty simplified. For extra, more complex, beyond the scope of this class, we won't test you on this, seriously this aint for the faint of heart, info, go [here](https://www.regular-expressions.info/refcapture.html))*

### Designing a Regular Expression to Solve a Problem

There are two main considerations involving creating a regular expression:

1. Accept what you expect.
2. Reject what you don't.

The general workflow behind creating a regular expression in this way is to first start with rule 1, with a rough outline of what you expect (If I tell you I'm giving you a name, starting with `[A-Z][a-z]*` is a pretty good idea.) Tweak as you go along to make sure you're not being overly conservative (for instance, if your regex is too strict to allow valid input to pass through).

Next, use boundary conditions to make sure your regular expression isn't overly free. For instance, if I asked you to write a regular expression for `[0,100]` (worked out in video), you first want to check that your regex accepts 0, 50, and 100. Next, you want to check that your regex does NOT accept 101 and -1. Further, read the description carefully - if I asked precisely for a number between 0 and 100 and NOTHING else, you should also surround your internal regex with `^` and `$`, to indicate that the whole string must be what I asked for.

**Hint**: In general, I find it easier and more robust to use character classes as opposed to the shorthand. EX. It's easier to use `[0-9]` as opposed to `\d` because there's less stuff for you to remember and you can see exactly what you're accepting. Character classes are really powerful because you can also indicate what you DON'T want. Ex. `[^abc]` means give me a character that isn't `a` OR `b` OR `c`.


## Doing the Discussion Exercise

In theory, with the info here, you should be fine. But if you ever get stuck, give the video a watch - I work through some examples that are very similar to the video
