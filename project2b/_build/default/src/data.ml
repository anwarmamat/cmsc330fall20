open Funs

(************************)
(* Part 2: Integer BSTs *)
(************************)

type int_tree =
  | IntLeaf
  | IntNode of int * int_tree * int_tree

let empty_int_tree = IntLeaf;;

let rec int_insert x t =
  match t with
  | IntLeaf -> IntNode(x, IntLeaf, IntLeaf)
  | IntNode (y, l, r) when x > y -> IntNode (y, l, int_insert x r)
  | IntNode (y, l, r) when x = y -> t
  | IntNode (y, l, r) -> IntNode (y, int_insert x l, r)
;;
let rec int_mem x t =
  match t with
  | IntLeaf -> false
  | IntNode (y, l, r) when x > y -> int_mem x r
  | IntNode (y, l, r) when x = y -> true
  | IntNode (y, l, r) -> int_mem x l
;;
(* Implement the functions below. *)

let rec int_size t = 
  match t with
  | IntLeaf -> 0
  | IntNode (y, l, r) -> 1 + (int_size l) + (int_size r)
  ;;

let rec int_max t =
  match t with
  | IntNode (y, l, r) when r = IntLeaf -> y
  | IntNode (y, l, r) -> int_max r
  | IntLeaf -> raise (Invalid_argument ("int_max"))
  ;;

(****************************)
(* Part 3: Polymorphic BSTs *)
(****************************)

type 'a atree =
  | Leaf
  | Node of 'a * 'a atree * 'a atree
type 'a compfn = 'a -> 'a -> int
type 'a ptree = 'a compfn * 'a atree

let empty_ptree f : 'a ptree = (f,Leaf);;

(* Implement the functions below. *)
(*This function "atreeH f x t" inserts an 'a atree to the existing tree by creating a new tree and 
adding a new node with value x into it and returns an 'a atree*)
(*Like lists, BSTs are immutable. Once created we cannot change it.
 To insert an element into a tree, create a new tree that is the same as the old, 
 but with the new element added.*)
let rec atreeH f x t =
  match t with
  | Leaf -> Node(x, Leaf, Leaf)
  | Node (y, l, r) when (f x y) = 1 -> Node (y, l, atreeH f x r)
  | Node (y, l, r) when (f x y) = 0 -> t
  | Node (y, l, r) -> Node (y, atreeH f x l, r)
;;
let pinsert x t = 
  match t with
  | (f, Leaf) -> (f, Node(x, Leaf, Leaf))
  | (f, Node (y, l, r)) when (f x y) = 1 -> (f, Node(y, l, atreeH f x r))
  | (f, Node (y, l, r)) when (f x y) = 0 -> t
  | (f, Node (y, l, r)) -> (f, Node(y, atreeH f x l, r))
;;

let rec pmem x t = match t with
| (f, Leaf) -> false
| (f, Node (y, l, r)) when (f x y) = 1 -> pmem x (f, r)
| (f, Node (y, l, r)) when (f x y) = 0 -> true
| (f, Node (y, l, r)) -> pmem x (f, l)
;;

let pinsert_all lst t = fold (fun acc x -> pinsert x acc) t lst;;


(*In the details, it first recurse down the left until we get to the leaf then it 
goes back to the parent and add that to the array (In the beginning,
the last node on the left subtree will have left leaf then it returns a [] then the last node
is added to [y], then the right is also a leaf which returns a []. Visually, firstly, []@[y]
for left leaf to last node of left subtree. Secondly, the right leaf returns [] and then
[]@[y]@[] = [y]. Second iteration adds the lastnode's parent next and then right child of the parent
[y]@[y]@[y] = [y;y;y]. This process is repeat all through the entire `a ptree*)
let rec p_as_list t = 
  match t with
  | (f, Node (y, l, r)) -> ((p_as_list (f, l))@[y]) @ (p_as_list (f, r))
  | (f, Leaf) -> []
;;

let pmap f t =
  match t with
  | (s, Leaf) -> (s, Leaf)
  | (x, Node(y, l, r)) -> let m = (map f (p_as_list t)) in pinsert_all m (x, Leaf);;


(***************************)
(* Part 4: Variable Lookup *)
(***************************)

(* Modify the next line to your intended type *)
type lookup_table = 
  | EndScope
  | Scopes of (string * int) list list
  ;;
  
  let empty_table () : lookup_table = EndScope;;

(*Essentially, an empty_table returns {}, else it the pattern was a table with var and values
and endscope in it then return a Scope of {, variable, value, and a connecting table (could be an Endscope)*)

let push_scope (table: lookup_table) : lookup_table = 
  match table with
  | EndScope -> Scopes([[]])
  | Scopes(h::t) -> Scopes([]::h::t)
  | Scopes _ -> EndScope;;

  let pop_scope (table: lookup_table) : lookup_table = 
    match table with
    | Scopes([]) -> failwith "No scopes remain!"
    | Scopes(y::t) -> Scopes(t)
    | EndScope -> EndScope
  ;;

(*let rec  (table: lookup_table) : lookup_table =
  match table with
    | EndScope -> failwith "No scopes remain!"
    | Table([x]) -> EndScope
    | Table(y::z::t) -> if z = EndScope then m else Table(y::(pop_scope (Table(z::t)))::[])
    | Table ([]) -> EndScope
    | Scopes _ -> EndScope;;*)

let add_var name value (table: lookup_table) : lookup_table = 
  match table with
  | Scopes([]) -> failwith "There are no scopes to add a variable to!"
  | Scopes(y::t) -> Scopes(((name, value)::y)::t)
  | _ -> EndScope;;

let rec lookHelper scope name =
  match scope with
  | [] -> (-1, false)
  | (n, v)::t -> if n = name then (v, true) else (lookHelper t name)
;;

let rec lookup name (table: lookup_table) = 
  match table with
  | Scopes([]) -> failwith "Variable not found!"
  | Scopes(y::t) -> let (v, ch) = (lookHelper y name) in if ch = true then v else (lookup name (Scopes(t)))
  | _ -> -1;;
  

(*******************************)
(* Part 5: Shapes with Records *)
(*******************************)

type pt = { x: int; y: int };;
type shape =
  | Circ of { radius: float; center: pt }
  | Square of { length: float; upper: pt }
  | Rect of { width: float; height: float; upper: pt }
;;

(* Implement the functions below. *)

let area s = 
  match s with 
  | Rect {width=w; height=h; upper=_} -> w *. h
  | Circ {radius=r; center=_} -> r *. r *. 3.14
  | Square {length = l; upper=_} -> l *. l
  ;;
  

let filter f lst = fold (fun acc x -> if (f x) = true then acc@[x] else acc) [] lst;;
