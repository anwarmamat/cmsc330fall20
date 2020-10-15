(* Part 1: Type inference *)

let f1 a b = a + b;;
(*int -> int -> int*)
let f2 a b = if a then b else a;;
(*bool -> bool -> bool*)
let f3 a b c = if (a +. b) == 0.0 then "Hi" else c;;
(*float -> float -> string -> string*)
(* Part 2: Type definition *)

let tf1 a = if ("" ^ a) = a then 1 else 0;;

let tf2 a b c = if b = c then true else false;;

let tf3 a b = 
  match a@b with
  | (h::a) -> h;;
  

  (*returns a type a ('a)*)


(* Part 3: Functions *)

let concat str1 str2 = str1 ^ str2;;

let add_to_float integer flt = (float) integer +. flt;;

let rec fib n = 
  if n = 0 then 0 else
  if n > 0 && n < 3 then 1 else
  fib(n - 2) + fib(n - 1);;

(* Part 4: Lists *)

let rec add_three lst = match lst with
| [] -> lst
| h::a -> (h + 3)::(add_three a);;


let rec filter n lst = 
  match lst with
  | [] -> lst
  | (x::t) -> if x <= n then x::(filter n t) else (filter n t);;


let rec double lst = 
  match lst with
  | [] -> lst
  | (x::t) -> x::x::(double t);;
  