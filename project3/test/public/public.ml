open OUnit2
open P3.Nfa
open P3.Regexp
open TestUtils

let test_nfa_accept _ =
  let m1 =
    {qs= [0; 1]; sigma= ['a'; 'b']; delta= [(0, Some 'a', 1)]; q0= 0; fs= [1]}
  in
  assert_nfa_deny m1 "" ;
  assert_nfa_accept m1 "a" ;
  assert_nfa_deny m1 "b" ;
  assert_nfa_deny m1 "ba" ;
  let m2 =
    { qs= [0; 1; 2]
    ; sigma= ['a'; 'b']
    ; delta= [(0, Some 'a', 1); (0, Some 'b', 2)]
    ; q0= 0
    ; fs= [2] }
  in
  assert_nfa_deny m2 "" ;
  assert_nfa_deny m2 "a" ;
  assert_nfa_accept m2 "b" ;
  assert_nfa_deny m2 "ba"

let test_nfa_to_dfa _ =
  let m1 =
    { qs= [0; 1; 2; 3]
    ; sigma= ['a'; 'b']
    ; delta= [(0, Some 'a', 1); (0, Some 'a', 2); (2, Some 'b', 3)]
    ; q0= 0
    ; fs= [1; 3] }
  in
  let m1' = nfa_to_dfa m1 in
  assert_dfa m1' ;
  assert_nfa_deny m1' "" ;
  assert_nfa_accept m1' "a" ;
  assert_nfa_accept m1' "ab" ;
  assert_nfa_deny m1' "b" ;
  assert_nfa_deny m1' "ba" ;
  let m2 =
    { qs= [0; 1; 2]
    ; sigma= ['a'; 'b']
    ; delta= [(0, Some 'a', 1); (0, Some 'b', 2)]
    ; q0= 0
    ; fs= [2] }
  in
  let m2' = nfa_to_dfa m2 in
  assert_dfa m2' ;
  assert_nfa_deny m2' "" ;
  assert_nfa_deny m2' "a" ;
  assert_nfa_accept m2' "b" ;
  assert_nfa_deny m2' "ba"

let test_nfa_closure _ =
  let m1 =
    {qs= [0; 1]; sigma= ['a']; delta= [(0, Some 'a', 1)]; q0= 0; fs= [1]}
  in
  assert_nfa_closure m1 [0] [0] ;
  assert_nfa_closure m1 [1] [1] ;
  let m2 = {qs= [0; 1]; sigma= []; q0= 0; delta= [(0, None, 1)]; fs= [1]} in
  assert_nfa_closure m2 [0] [0; 1] ;
  assert_nfa_closure m2 [1] [1] ;
  let m3 =
    { qs= [0; 1; 2]
    ; sigma= ['a'; 'b']
    ; q0= 0
    ; fs= [2]
    ; delta= [(0, Some 'a', 1); (0, Some 'b', 2)] }
  in
  assert_nfa_closure m3 [0] [0] ;
  assert_nfa_closure m3 [1] [1] ;
  assert_nfa_closure m3 [2] [2] ;
  let m4 =
    { qs= [0; 1; 2]
    ; sigma= ['a']
    ; q0= 0
    ; fs= [2]
    ; delta= [(0, None, 1); (0, None, 2)] }
  in
  assert_nfa_closure m4 [0] [0; 1; 2] ;
  assert_nfa_closure m4 [1] [1] ;
  assert_nfa_closure m4 [2] [2]

let test_nfa_move _ =
  let m1 =
    {qs= [0; 1]; sigma= ['a']; delta= [(0, Some 'a', 1)]; q0= 0; fs= [1]}
  in
  assert_nfa_move m1 [0] (Some 'a') [1] ;
  assert_nfa_move m1 [1] (Some 'a') [] ;
  let m2 = {qs= [0; 1]; sigma= ['a']; delta= [(0, None, 1)]; q0= 0; fs= [1]} in
  assert_nfa_move m2 [0] (Some 'a') [] ;
  assert_nfa_move m2 [1] (Some 'a') [] ;
  let m3 =
    { qs= [0; 1; 2]
    ; sigma= ['a'; 'b']
    ; q0= 0
    ; fs= [2]
    ; delta= [(0, Some 'a', 1); (0, Some 'b', 2)] }
  in
  assert_nfa_move m3 [0] (Some 'a') [1] ;
  assert_nfa_move m3 [1] (Some 'a') [] ;
  assert_nfa_move m3 [2] (Some 'a') [] ;
  assert_nfa_move m3 [0] (Some 'b') [2] ;
  assert_nfa_move m3 [1] (Some 'b') [] ;
  assert_nfa_move m3 [2] (Some 'b') [] ;
  let m4 =
    { qs= [0; 1; 2]
    ; sigma= ['a'; 'b']
    ; q0= 0
    ; fs= [2]
    ; delta= [(0, None, 1); (0, Some 'a', 2)] }
  in
  assert_nfa_move m4 [0] (Some 'a') [2] ;
  assert_nfa_move m4 [1] (Some 'a') [] ;
  assert_nfa_move m4 [2] (Some 'a') [] ;
  assert_nfa_move m4 [0] (Some 'b') [] ;
  assert_nfa_move m4 [1] (Some 'b') [] ;
  assert_nfa_move m4 [2] (Some 'b') []


let test_nfa_new_states _ =
  let m1 =
  { qs= [0; 1; 2; 3; 4]
  ; sigma= ['a'; 'b']
  ; delta= [(0, Some 'a', 1); (0, Some 'a', 2); (2, Some 'b', 3); (2, None, 4); (4, Some 'a', 4)]
  ; q0= 0
  ; fs= [1; 3] } in
  assert_set_set_eq [[]; []] (new_states m1 []) ;
  assert_set_set_eq [[1; 2; 4]; []] (new_states m1 [0]) ;
  assert_set_set_eq [[4]; []] (new_states m1 [3; 4]) ;
  assert_set_set_eq [[1; 2; 4]; [3]] (new_states m1 [0; 2]) ;
  assert_set_set_eq [[1; 2; 4]; [3]] (new_states m1 [0; 1; 2; 3])


let test_nfa_new_trans _ =
  let m1 =
  { qs= [0; 1; 2; 3; 4]
  ; sigma= ['a'; 'b']
  ; delta= [(0, Some 'a', 1); (0, Some 'a', 2); (2, Some 'b', 3); (2, None, 4); (4, Some 'a', 4)]
  ; q0= 0
  ; fs= [1; 3] } in
  assert_trans_eq
    [([0], Some 'a', [1; 2; 4]); ([0], Some 'b', [])]
    (new_trans m1 [0]) ;
  assert_trans_eq
    [([0; 2], Some 'a', [1; 2; 4]); ([0; 2], Some 'b', [3])]
    (new_trans m1 [0; 2])

let test_nfa_new_finals _ =
  let m1 =
  { qs= [0; 1; 2; 3; 4]
  ; sigma= ['a'; 'b']
  ; delta= [(0, Some 'a', 1); (0, Some 'a', 2); (2, Some 'b', 3); (2, None, 4); (4, Some 'a', 4)]
  ; q0= 0
  ; fs= [1; 3] } in
  assert_set_set_eq [] (new_finals m1 [0; 2]) ;
  assert_set_set_eq [[1]] (new_finals m1 [1]) ;
  assert_set_set_eq [[1; 3]] (new_finals m1 [1; 3])

let test_re_to_nfa _ =
  let m1 = regexp_to_nfa (Char 'a') in
  assert_nfa_deny m1 "" ;
  assert_nfa_accept m1 "a" ;
  assert_nfa_deny m1 "b" ;
  assert_nfa_deny m1 "ba" ;
  let m2 = regexp_to_nfa (Union (Char 'a', Char 'b')) in
  assert_nfa_deny m2 "" ;
  assert_nfa_accept m2 "a" ;
  assert_nfa_accept m2 "b" ;
  assert_nfa_deny m2 "ba"

let test_str_to_nfa _ =
  let m1 = regexp_to_nfa @@ string_to_regexp "ab" in
  assert_nfa_deny m1 "a" ;
  assert_nfa_deny m1 "b" ;
  assert_nfa_accept m1 "ab" ;
  assert_nfa_deny m1 "bb"

let suite =
  "public"
  >::: [ "nfa_accept" >:: test_nfa_accept
       ; "nfa_closure" >:: test_nfa_closure
       ; "nfa_move" >:: test_nfa_move
       ; "nfa_to_dfa" >:: test_nfa_to_dfa
       ; "re_to_nfa" >:: test_re_to_nfa
       ; "str_to_nfa" >:: test_str_to_nfa 
       ; "nfa_new_states" >:: test_nfa_new_states
       ; "nfa_new_trans" >:: test_nfa_new_trans
       ; "nfa_new_finals" >:: test_nfa_new_finals]

let _ = run_test_tt_main suite
