(*Provided for your benefit*)
let rec map f xs = match xs with
| [] -> []
| x :: xt -> (f x)::(map f xt)

let rec foldl f a xs = match xs with
| [] -> a
| x :: xt -> foldl f (f a x) xt

let rec foldr f xs a = match xs with
| [] -> a
| x :: xt -> f x (foldr f xt a) 

(********************)
(* Currying Functions and Partial Application *)
(********************)

let mul_n n lst = map (fun x -> x * n) lst;;

(* Joins together the strings in xs by separator sep
   e.g. join ["cat"; "dog"; "fish"] "," = "cat,dog,fish". *)

   (*First we want, ["cat"; "dog"; "fish"] -> ["cat"; "(sep)dog"; "(sep)fish"] *)
let join xs sep = 
   match xs with
   | [] -> ""
   | (h::t) -> foldl (^) h (map((^) sep) t);; (*So h (map((^) sep) t) (returns cat, dog, fish) where h is "cat"*)
(*Always have a strategy before pattern matching. foldl concat "cat" with the return mapped list*)
(********************)
(* Option Functions *)
(********************)

(* Converts an option to a list. Some is a singleton containing
   the value, while None is an empty list. *)
let list_of_option (o : 'a option) : 'a list = 
   match o with
   | None -> []
   | Some v -> [v]
   ;;

(* If the pair's key matches k returns the value as an option. Otherwise
   return None. *)
let match_key (k : 'k) (p : ('k * 'v)) : 'v option = 
   match p with
   |(x, y) when x = k -> Some (y)
   |_ -> None
   ;;

(******************)
(*LENGTHLIST FUNCTIONS*)
(******************)

(*This list encodes the idea of a list having multiple elements in a row*)
(*Ex: [1;2;3;4] = Cons(1, 1, Cons(2, 1, Cons(3, 1, Cons(4, 1, Empty))))*)
(*Ex: [1; 1; 1; 1; 2; 2; 2; 3; 3; 4] = Cons(1, 4, Cons(2, 3, Cons(3, 2, Cons(4, 1, Empty))))*)

type 'a lengthlist = 
    Cons of ('a * int * 'a lengthlist)
    | Empty
;;

(*let rec count_h h lst =
  match lst with
  | [] -> (0,[])
  | (h1::t) when h1 = h -> let (rest_count, tail) = (count_h h t) in (rest_count + 1, tail)
  | (h1::t) -> (0,lst);;

let rec list_of_lengthlist llst = 
   match llst with
   | [] -> Empty
   | (h::t) -> let (count,tail) = (count_h h llst) in Cons(h, count, (list_of_lengthlist tail));;*)

let rec n_lst_m n m = match n with
   | 0 -> []
   | _ -> m::(n_lst_m (n-1) m)
   ;;


let rec list_of_lengthlist llst = 
   match llst with
   | Empty -> []
   | Cons(a, b, lst) -> (n_lst_m b a) @ (list_of_lengthlist lst)
   ;;

let rec map_lengthlist fn llst =  
   match llst with
   | Empty -> Empty
   | Cons(a, b, lst) -> Cons((fn a), b, (map_lengthlist fn lst))


let rec decrement_count llst = 
   match llst with
   | Empty -> Empty
   | Cons(a, count, lst) -> if (count - 1) = 0 then Empty else Cons(a, count - 1, (decrement_count lst)) ;;