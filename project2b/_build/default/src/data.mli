type int_tree = IntLeaf | IntNode of int * int_tree * int_tree
val empty_int_tree : int_tree
val int_insert : int -> int_tree -> int_tree
val int_mem : int -> int_tree -> bool
val int_size : int_tree -> int
val int_max : int_tree -> int
type 'a atree = Leaf | Node of 'a * 'a atree * 'a atree
type 'a compfn = 'a -> 'a -> int
type 'a ptree = 'a compfn * 'a atree
val empty_ptree : 'a compfn -> 'a ptree
val pinsert : 'a -> 'a ptree -> 'a compfn * 'a atree
val pmem : 'a -> 'a ptree -> bool
val pinsert_all : 'a list -> 'a ptree -> 'a ptree
val p_as_list : 'a * 'b atree -> 'b list
val pmap : ('a -> 'a) -> 'a compfn * 'a atree -> 'a ptree
type lookup_table
val empty_table : unit -> lookup_table
val push_scope : lookup_table -> lookup_table
val pop_scope : lookup_table -> lookup_table
val add_var : string -> int -> lookup_table -> lookup_table
val lookup : string -> lookup_table -> int
type pt = { x : int; y : int; }
type shape =
    Circ of { radius : float; center : pt; }
  | Square of { length: float; upper: pt }
  | Rect of { width : float; height : float; upper : pt; }
val area : shape -> float
val filter : ('a -> bool) -> 'a list -> 'a list
