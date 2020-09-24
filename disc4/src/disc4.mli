(*The functions we give you*)
val map : ('a -> 'b) -> 'a list -> 'b list
val foldl : ('a -> 'b -> 'a) -> 'a -> 'b list -> 'a
val foldr : ('a -> 'b -> 'b) -> 'a list -> 'b -> 'b 
val get_last_element : 'a list -> 'a
val rev : 'a list -> 'a list

type student_information = { name : string; age : int; gpa : float; }

(*The functions we have you implement*) 
val mul_thresh : int list -> int -> int * int 
val multi_map : ('a -> 'b) -> 'a list list -> 'b list list 
val update_database : (string * int * float) list -> student_information list
val stalin_sort : 'a list -> 'a list 
val stalin_sort_right : 'a list -> 'a list