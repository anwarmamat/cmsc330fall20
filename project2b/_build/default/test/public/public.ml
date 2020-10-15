open OUnit2
open TestUtils
open P2b.Data
open P2b.Funs
open P2b.Higher

let public_count_occ _ =
  let y = ["a";"a";"b";"a"] in
  let z = [1;7;7;1;5;2;7;7] in
  let a = [true;false;false;true;false;false;false] in
  let b = [] in

  assert_equal ~printer:string_of_int_pair (3,1) @@ (count_occ y "a", count_occ y "b");
  assert_equal ~printer:string_of_int_quad (2,4,1,1) @@ (count_occ z 1, count_occ z 7, count_occ z 5, count_occ z 2);
  assert_equal ~printer:string_of_int_pair (2,5) @@ (count_occ a true, count_occ a false);
  assert_equal ~printer:string_of_int_pair (0,0) @@ (count_occ b "a", count_occ b 1)

let public_uniq _ =
  let y = ["a";"a";"b";"a"] in
  let z = [1;7;7;1;5;2;7;7] in
  let a = [true;false;false;true;false;false;false] in
  let b = [] in
  let cmp x y = if x < y then (-1) else if x = y then 0 else 1 in

  assert_equal ~printer:string_of_string_list ["a";"b"] @@ List.sort cmp (uniq y);
  assert_equal ~printer:string_of_int_list [1;2;5;7] @@ List.sort cmp (uniq z);
  assert_equal ~printer:string_of_bool_list [false;true] @@ List.sort cmp (uniq a);
  assert_equal ~printer:string_of_int_list [] @@ uniq b

let public_assoc_list _ =
  let y = ["a";"a";"b";"a"] in
  let z = [1;7;7;1;5;2;7;7] in
  let a = [true;false;false;true;false;false;false] in
  let b = [] in
  let cmp x y = if x < y then (-1) else if x = y then 0 else 1 in

  assert_equal ~printer:string_of_string_int_pair_list [("a",3);("b",1)] @@ List.sort cmp (assoc_list y);
  assert_equal ~printer:string_of_int_pair_list [(1,2);(2,1);(5,1);(7,4)] @@ List.sort cmp (assoc_list z);
  assert_equal ~printer:string_of_bool_int_pair_list [(false,5);(true,2)] @@ List.sort cmp (assoc_list a);
  assert_equal ~printer:string_of_int_pair_list [] @@ assoc_list b

let public_ap _ =
  let x = [5;6;7;3] in
  let y = [5;6;7] in
  let z = [7;5] in
  let a = [3;5;8;10;9] in
  let b = [3] in
  let c = [] in

  let fs1 = [((+) 2) ; (( * ) 7)] in
  let fs2 = [pred] in

  assert_equal ~printer:string_of_int_list [7;8;9;5;35;42;49;21] @@ ap fs1 x;
  assert_equal ~printer:string_of_int_list [7;8;9;35;42;49] @@ ap fs1 y;
  assert_equal ~printer:string_of_int_list [9;7;49;35] @@ ap fs1 z;
  assert_equal ~printer:string_of_int_list [5;7;10;12;11;21;35;56;70;63] @@ ap fs1 a;
  assert_equal ~printer:string_of_int_list [5;21] @@ ap fs1 b;
  assert_equal ~printer:string_of_int_list [] @@ ap fs1 c;

  assert_equal ~printer:string_of_int_list (map pred x) @@ ap fs2 x;
  assert_equal ~printer:string_of_int_list (map pred y) @@ ap fs2 y;
  assert_equal ~printer:string_of_int_list (map pred z) @@ ap fs2 z;
  assert_equal ~printer:string_of_int_list (map pred a) @@ ap fs2 a;
  assert_equal ~printer:string_of_int_list (map pred b) @@ ap fs2 b;
  assert_equal ~printer:string_of_int_list (map pred c) @@ ap fs2 c

let public_int_tree _ =
  let t0 = empty_int_tree in
  let t1 = (int_insert 3 (int_insert 11 t0)) in
  let t2 = (int_insert 13 t1) in
  let t3 = (int_insert 17 (int_insert 3 (int_insert 1 t2))) in

  assert_equal ~printer:string_of_int 0 @@ (int_size t0);
  assert_equal ~printer:string_of_int 2 @@ (int_size t1);
  assert_equal ~printer:string_of_int 3 @@ (int_size t2);
  assert_equal ~printer:string_of_int 5 @@ (int_size t3);

  assert_raises (Invalid_argument("int_max")) (fun () -> int_max t0);
  assert_equal ~printer:string_of_int 11 @@ int_max t1;
  assert_equal ~printer:string_of_int 13 @@ int_max t2;
  assert_equal ~printer:string_of_int 17 @@ int_max t3

let public_ptree_1 _ =
  let r0 = empty_ptree Stdlib.compare in
  let r1 = (pinsert 2 (pinsert 1 r0)) in
  let r2 = (pinsert 3 r1) in
  let r3 = (pinsert 5 (pinsert 3 (pinsert 11 r2))) in
  let a = [5;6;8;3;11;7;2;6;5;1]  in
  let x = [5;6;8;3;0] in
  let z = [7;5;6;5;1] in
  let r4a = pinsert_all x r1 in
  let r4b = pinsert_all z r1 in

  let strlen_comp x y = Stdlib.compare (String.length x) (String.length y) in
  let k0 = empty_ptree strlen_comp in
  let k1 = (pinsert "hello" (pinsert "bob" k0)) in
  let k2 = (pinsert "sidney" k1) in
  let k3 = (pinsert "yosemite" (pinsert "ali" (pinsert "alice" k2))) in
  let b = ["hello"; "bob"; "sidney"; "kevin"; "james"; "ali"; "alice"; "xxxxxxxx"] in

  assert_equal ~printer:string_of_bool_list [false;false;false;false;false;false;false;false;false;false] @@ map (fun y -> pmem y r0) a;
  assert_equal ~printer:string_of_bool_list [false;false;false;false;false;false;true;false;false;true] @@ map (fun y -> pmem y r1) a;
  assert_equal ~printer:string_of_bool_list [false;false;false;true;false;false;true;false;false;true] @@ map (fun y -> pmem y r2) a;
  assert_equal ~printer:string_of_bool_list [true;false;false;true;true;false;true;false;true;true] @@ map (fun y -> pmem y r3) a;

  assert_equal ~printer:string_of_bool_list [false;false;false;false;false;false;false;false] @@ map (fun y -> pmem y k0) b;
  assert_equal ~printer:string_of_bool_list [true;true;false;true;true;true;true;false] @@ map (fun y -> pmem y k1) b;
  assert_equal ~printer:string_of_bool_list [true;true;true;true;true;true;true;false] @@ map (fun y -> pmem y k2) b;
  assert_equal ~printer:string_of_bool_list [true;true;true;true;true;true;true;true] @@ map (fun y -> pmem y k3) b;

  assert_equal ~printer:string_of_bool_list [true;true;true;true;true] @@ map (fun y -> pmem y r4a) x;
  assert_equal ~printer:string_of_bool_list [true;true;false;false;false] @@ map (fun y -> pmem y r4b) x;
  assert_equal ~printer:string_of_bool_list [false;true;true;true;true] @@ map (fun y -> pmem y r4a) z;
  assert_equal ~printer:string_of_bool_list [true;true;true;true;true] @@ map (fun y -> pmem y r4b) z

let public_ptree_2 _ =
  let q0 = empty_ptree Stdlib.compare in
  let q1 = pinsert 1 (pinsert 2 (pinsert 0 q0)) in
  let q2 = pinsert 5 (pinsert 11 (pinsert (-1) q1)) in
  let q3 = pinsert (-7) (pinsert (-3) (pinsert 9 q2)) in
  let f = (fun x -> x + 10) in
  let g = (fun y -> y * (-1)) in

  assert_equal ~printer:string_of_int_list [] @@ p_as_list q0;
  assert_equal ~printer:string_of_int_list [0;1;2] @@ p_as_list q1;
  assert_equal ~printer:string_of_int_list [-1;0;1;2;5;11] @@ p_as_list q2;
  assert_equal ~printer:string_of_int_list [-7;-3;-1;0;1;2;5;9;11] @@ p_as_list q3;

  assert_equal ~printer:string_of_int_list [] @@ p_as_list (pmap f q0);
  assert_equal ~printer:string_of_int_list [10;11;12] @@ p_as_list (pmap f q1);
  assert_equal ~printer:string_of_int_list [9;10;11;12;15;21] @@ p_as_list (pmap f q2);
  assert_equal ~printer:string_of_int_list [3;7;9;10;11;12;15;19;21] @@ p_as_list (pmap f q3);

  assert_equal ~printer:string_of_int_list [] @@ p_as_list (pmap g q0);
  assert_equal ~printer:string_of_int_list [-2;-1;0] @@ p_as_list (pmap g q1);
  assert_equal ~printer:string_of_int_list [-11;-5;-2;-1;0;1] @@ p_as_list (pmap g q2);
  assert_equal ~printer:string_of_int_list [-11;-9;-5;-2;-1;0;1;3;7] @@ p_as_list (pmap g q3)

let public_var _ =
  let t = push_scope (empty_table ()) in
  let t = add_var "x" 3 t in
  let t = add_var "y" 4 t in
  let t = add_var "asdf" 14 t in
  assert_equal 3 (lookup "x" t) ~msg:"public_var (1)";
  assert_equal 4 (lookup "y" t) ~msg:"public_var (2)";
  assert_equal 14 (lookup "asdf" t) ~msg:"public_var (3)";
  assert_raises (Failure ("Variable not found!")) (fun () -> lookup "z" t) ~msg:"public_var (2)"

let public_scopes _ =
  let a = push_scope (empty_table ()) in
  let a = add_var "a" 10 a in
  let a = add_var "b" 40 a in
  let b = push_scope a in
  let b = add_var "a" 20 b in
  let b = add_var "c" 30 b in
  let c = pop_scope b in
  assert_equal 10 (lookup "a" c) ~msg:"public_scopes (1)";
  assert_equal 40 (lookup "b" c) ~msg:"public_scopes (2)";
  assert_equal 20 (lookup "a" b) ~msg:"public_scopes (3)";
  assert_equal 30 (lookup "c" b) ~msg:"public_scopes (4)";
  assert_raises (Failure ("Variable not found!")) (fun () -> lookup "c" c) ~msg:"public_scopes (5)"

let public_shape _ =
  let s0 = Circ {radius=3.0; center={x=5; y=5}} in
  let s1 = Circ {radius=7.0; center={x=1; y=7}} in
  let s2 = Rect {width=2.0; height=9.0; upper={x=3; y=4}} in
  let s3 = Rect {width=11.0; height=8.0; upper={x=0;y=0}} in
  let s4 = Square { length = 7.0; upper = { x = 1; y = 1 } } in
  let f x = match x with
    Circ {radius=_; center=c} -> if c.x > 2 then true else false
    | Square {length=_;upper=u} -> if u.x > 2 then true else false
    | Rect {width=_;height=_;upper=u} -> if u.x > 2 then true else false in
  let g y = match y with Circ _ -> true | Square _ -> false | Rect _ -> false in
  let h z = ((>) (area z) 100.0) in
  let cmp x y = if (area x) < (area y) then (-1) else if (area x) = (area y) then 0 else 1 in

  assert_equal ~printer:string_of_int 28 @@ int_of_float (area s0);
  assert_equal ~printer:string_of_int 153 @@ int_of_float (area s1);
  assert_equal ~printer:string_of_int 18 @@ int_of_float (area s2);
  assert_equal ~printer:string_of_int 88 @@ int_of_float (area s3);
  assert_equal ~printer:string_of_int 49 @@ int_of_float(area s4);

  assert_equal [s2;s0] @@ List.sort cmp (filter f [s0;s1;s2;s3;s4]);
  assert_equal [s0;s1] @@ List.sort cmp (filter g [s0;s1;s2;s3]);
  assert_equal [s1] @@ filter h [s0;s1;s2;s3]

let suite =
  "public" >::: [
    "count_occ" >:: public_count_occ;
    "uniq" >:: public_uniq;
    "assoc_list" >:: public_assoc_list;
    "ap" >:: public_ap;
    "int_tree" >:: public_int_tree;
    "ptree_1" >:: public_ptree_1;
    "ptree_2" >:: public_ptree_2;
    "var" >:: public_var;
    "scopes" >:: public_scopes;
    "shape" >:: public_shape
  ]

let _ = run_test_tt_main suite
