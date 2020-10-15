open Funs

(********************************)
(* Part 1: High Order Functions *)
(********************************)

let count_occ lst target = 
  match lst with
  | [] -> 0
  | (x::xs) -> fold (fun acc b -> if b = target then acc + 1 else acc) 0 lst;;

let uniq lst = 
  match lst with
  | [] -> []
  | [x] -> [x]
  | (h::t) -> fold (fun acc elem -> if count_occ acc elem = 0 then (acc@[elem]) else acc) [] lst;;

let assoc_list lst = 
  match lst with
  | [] -> []
  | (h::t) -> let newlst = uniq lst in (fold (fun acc x -> ((x, (count_occ lst x))::acc)) [] newlst);;

let ap fns args = 
  match fns, args with
  | [], _ -> []
  | _, [] -> []
  | (x::xs), (h::t) -> fold (fun acc func -> acc@(map func args)) [] fns;;
