(***********************************)
(* Part 1: Non-Recursive Functions *)
(***********************************)

let rev_tup tup = 
  match tup with
  |(a, b, c) -> (c, b, a);;

let abs x = if x < 0 then (-1) * x else x;;

let area x y = 
  match x with
  | (a, b) -> (match y with
              | (c, d) -> (c - a) * (d - b)
  );;

let volume x y = 
  match x with
  | (a, b, c) -> (match y with
              | (d, e, f) -> (d - a) * (e - b) *(f - c)
  );;

(*******************************)
(* Part 2: Recursive Functions *)
(*******************************)

let rec factorial x = if x = 1 then 1 else x * factorial (x - 1);;

let rec pow x y = if y = 1 then x else x * pow x (y - 1);;


let rec log x y = if y >= x then 1 + (log x (y/x)) else 0;;
  
let rec is_primeHelper a x =
  if a < x && (x mod a) = 0 then false
  else if a < x then is_primeHelper (a + 1) x
  else true;;

let rec is_prime x =  
  if x = 1 || x = 0 then false
  else is_primeHelper 2 x;;

let rec next_prime x = 
  if x < 0 then 2
  else if is_prime (x) = true then x
  else next_prime (x + 1);;

(*****************)
(* Part 3: Lists *)
(*****************)

(* Move down the list until you the list's first elements is what you want *)
let rec get idx lst = 
  match lst with
  | [] -> failwith "Out of bounds"
  | x::t -> if idx = 0 then x else (get (idx-1) t);;

let rec length arr =
  match arr with
  | [] -> 0
  | _::t -> 1 + (length t);;

let larger lst1 lst2 = 
  if (length lst1) > (length lst2) then lst1
  else if (length lst1) < (length lst2) then lst2
  else [];;

let rec rev_helper (l, a) = match l with
  |[] -> a
  |(x::t) -> rev_helper (t, (x::a));;

let reverse lst = rev_helper (lst, []);;
  
(*e1::(e2::.....(en::lst2)*)
let rec combine lst1 lst2 = 
  match lst1 with
  |[] -> lst2
  |(h::t) -> h::(combine t lst2);;
  

let rec rotate shift lst = failwith "unimplemented"
