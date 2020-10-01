val map : ('a -> 'b) -> 'a list -> 'b list
val foldl : ('a -> 'b -> 'a) -> 'a -> 'b list -> 'a
val foldr : ('a -> 'b -> 'b) -> 'a list -> 'b -> 'b 

val mul_n: int -> int list -> int list
val join: string list -> string -> string
val list_of_option: 'a option -> 'a list
val match_key: 'k -> 'k*'v -> 'v option

type 'a lengthlist = 
    Cons of ('a * int * 'a lengthlist)
    | Empty
;;

val list_of_lengthlist: 'a lengthlist -> 'a list
val map_lengthlist: ('a -> 'b) -> 'a lengthlist -> 'b lengthlist
val decrement_count: 'a lengthlist -> 'a lengthlist