val map : ('a -> 'b) -> 'a list -> 'b list
val fold : ('a -> 'b -> 'a) -> 'a -> 'b list -> 'a
val fold_right : ('a -> 'b -> 'b) -> 'a list -> 'b -> 'b
val length : 'a list -> int
val rev : 'a list -> 'a list
