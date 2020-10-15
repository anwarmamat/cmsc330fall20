(*The following functions have been provided
  for your convenience*) 

  let rec map f xs = match xs with
  | [] -> []
  | x :: xt -> (f x)::(map f xt)
  
  let rec foldl f a xs = match xs with
  | [] -> a
  | x :: xt -> foldl f (f a x) xt
  
  let rec foldr f xs a = match xs with
  | [] -> a
  | x :: xt -> f x (foldr f xt a) 

  (* You may want to use these functions for stalin_sort_right *)
  let rec rev lst = match lst with 
    | [] -> [] 
    | x :: xt -> (rev xt) @ [x] 

  let rec get_last_element lst = 
    match lst with 
    | [x] -> x 
    | _ :: xt -> get_last_element xt 
    | [] -> failwith "empty list has no elements"
  

  (*This record type will be used for the 
  update_database problem*) 
  type student_information = 
    { 
        name : string;
        age : int; 
        gpa : float;
    } 

  (*Implement these functions*) 
  (*Will use pattern in the (fun ...)*)
  let mul_thresh lst thresh = 
      foldl (fun (less, greaterEqual) x -> if x < thresh then (less * x, greaterEqual) else (less, greaterEqual * x)) (1,1) lst;;
  
  let multi_map f lst = 
      map (fun x -> map f x) lst;; (*take a listA out of lst (list of list) and apply the func f to all elements in listA*)
  
  let update_database lst = 
      map (fun (a, b, c) -> {name = a; age = b; gpa = c}) lst;;
  
  let stalin_sort lst = 
      match lst with
      | [] -> []
      | h::t -> match (foldl (fun (prev_elem, acc) x -> if x >= prev_elem then (x, acc @ [x]) else (prev_elem, acc)) (h, []) lst) with
                  |(elem, acc_result) -> acc_result;;

  
  let stalin_sort_right lst = 
      match lst with
      | [] -> []
      | h::t -> match (foldr (fun x (prev_elem, acc) -> if x <= prev_elem then (x, (x::acc)) else (prev_elem, acc)) lst (get_last_element lst, [])) with
                  |(elem, acc_result) -> acc_result;;
  