# Sets module

## `insert x a`

- Type: `'a -> 'a list -> 'a list`
- Description: Inserts `x` into the set `a`.
- Examples:
```
insert 2 []
insert 3 (insert 2 [])
insert 3 (insert 3 (insert 2 []))
```

## `elem x a`

- Type: `'a -> 'a list -> bool`
- Description: Returns true iff `x` is an element of the set `a`.
- Examples:
```
elem 2 [] = false
elem 3 (insert 5 (insert 3 (insert 2 []))) = true
elem 4 (insert 3 (insert 2 (insert 5 []))) = false
```

## `subset a b`

- Type: `'a list -> 'a list -> bool`
- Description: Return true iff `a` **is a** subset of `b`. Formally, A ⊆ B ⇔ ∀x(xϵA ⇒ xϵB).
- Examples:
```
subset (insert 2 (insert 4 [])) [] = false
subset (insert 5 (insert 3 [])) (insert 3 (insert 5 (insert 2 []))) = true
subset (insert 5 (insert 3 (insert 2 []))) (insert 5 (insert 3 [])) = false
```


## `eq a b`

- Type: `'a list -> 'a list -> bool`
- Description: Returns true iff `a` and `b` are equal as sets. Formally, A = B ⇔ ∀x(xϵA ⇔ xϵB). (Hint: The subset relation is anti-symmetric.)
- Examples:
```
eq [] (insert 2 []) = false
eq (insert 2 (insert 3 [])) (insert 3 []) = false
eq (insert 3 (insert 2 [])) (insert 2 (insert 3 [])) = true
```

## `remove x a`

- Type: `'a -> 'a list -> 'a list`
- Description: Removes `x` from the set `a`.
- Examples:
```
elem 3 (remove 3 (insert 2 (insert 3 []))) = false
eq (remove 3 (insert 5 (insert 3 []))) (insert 5 []) = true
```


## `diff a b`

- Type: `'a list -> 'a list -> 'a list`
- Description: Subtracts the set `b` from the set `a`.

## `union a b`

- Type: `'a list -> 'a list -> 'a list`
- Description: Returns the union of the sets `a` and `b`. Formally, A ∪ B = {x | xϵA ∨ xϵB}.
- Examples:
```
eq (union [] (insert 2 (insert 3 []))) (insert 3 (insert 2 [])) = true
eq (union (insert 5 (insert 2 [])) (insert 2 (insert 3 []))) (insert 3 (insert 2 (insert 5 []))) = true
eq (union (insert 2 (insert 7 [])) (insert 5 [])) (insert 5 (insert 7 (insert 2 []))) = true
```

## `intersection a b`

- Type: `'a list -> 'a list -> 'a list`
- Description: Returns the intersection of sets `a` and `b`. Formally, A ∩ B = {x | xϵA ∧ xϵB}.
- Examples:
```
eq (intersection (insert 3 (insert 5 (insert 2 []))) []) [] = true
eq (intersection (insert 5 (insert 7 (insert 3 (insert 2 [])))) (insert 6 (insert 4 []))) [] = true
eq (intersection (insert 5 (insert 2 [])) (insert 4 (insert 3 (insert 5 [])))) (insert 5 []) = true
```
