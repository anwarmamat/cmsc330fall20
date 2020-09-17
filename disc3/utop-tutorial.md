## How to use utop

Utop is an incredibly useful tool to have when you're writing OCaml. If you
don't already have it, you can install it through opam (`opam install utop`).
Here's a few tips you might find useful.

Utop is based off the original toplevel for OCaml, which you can use by just
running `ocaml`. However, the default toplevel is very sparse in features - it
doesn't even remember previous inputs.

### Quitting
To quit utop, input `CTRL-D`. You can also enter `#quit;;`.

### Colors
Utop has support for syntax highlighting. To set it up, see
[here](https://github.com/ocaml-community/utop#colors).

### Loading in a file
Assume you have a file called `foo.ml` with the following contents:
```ocaml
let is_positive n =
  n > 0
```

You can use it in utop with `#use`:
```ocaml
utop # #use "foo.ml";;
val is_positive : int -> bool = <fun>

utop # is_positive 4;;
- : bool = true
```

You can also use `#mod_use` to keep it within the Foo module:
```ocaml
utop # #mod_use "foo.ml";;
module Foo : sig val is_positive : int -> bool end

utop # Foo.is_positive (-10);;
- : bool = false
```

### Dune
`#use` works well for small, self-contained modules. However, if a module
depends on other modules, they will all have to be loaded in order, which can be
tedious. Thankfully, all of our projects use [dune](https://dune.build) to
compile. Dune will automatically resolve any dependencies between modules.

If you have several related modules in a directory called `src`
(like all of our projects do), you can start utop with them loaded by running
```sh
dune utop src
```
from the project's directory.

The functions will be contained in modules, named after the files. For example,
in project 2A, all the functions will be in the `Basics` module.

### Saving your work
If you want to save what you've done for later, you can use `#utop_stash`.
This will save the commands you entered, alongside their output. The output
will be commented, so the end result is still a valid OCaml file.

For example, to save your work to a file called `stuff.ml`:
```ocaml
utop # #utop_stash "stuff.ml";;
```


### Further reading
- [UTop homepage](https://github.com/ocaml-community/utop)
- [Manual for the default toplevel](http://caml.inria.fr/pub/docs/manual-ocaml/toplevel.html) - Most of what's written here also applies to utop.
