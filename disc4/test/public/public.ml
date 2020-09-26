open OUnit2
open Disc4

let test_mul_thresh _ =
    assert_equal (mul_thresh [1;3;5;7] 6) (15, 7) ;
    assert_equal (mul_thresh [] 6) (1, 1) ;
    assert_equal (mul_thresh [6;7] 6) (1, 42) ;
    assert_equal (mul_thresh [9;5;4] 1) (1, 180)

let test_multi_map _ =
    assert_equal (multi_map (fun x -> x ^ " is cool") [["shilpa"; "minya"];["vinnie";"pavan"]]) [["shilpa is cool"; "minya is cool"]; ["vinnie is cool"; "pavan is cool"]] ;
    assert_equal (multi_map float_of_int [[1;3;5];[2;4;6]]) [[1.;3.;5.];[2.;4.;6.;]] ;
    assert_equal (multi_map float_of_int [[];[]]) [[];[]]

let test_update_database _ =
    assert_equal (update_database [("alice", 21, 4.);("bob", 20, 3.85);("jess", 22, 2.9)]) [{name = "alice"; age = 21; gpa = 4.}; {name = "bob"; age = 20; gpa = 3.85}; {name = "jess"; age = 22; gpa = 2.9}]  ;
    assert_equal (update_database []) []

let test_stalin_sort _ =
    assert_equal (stalin_sort []) [] ;
    assert_equal (stalin_sort [1;0;2;1;4;4]) [1;2;4;4] ;
    assert_equal (stalin_sort [9;1;2;3;4;5]) [9] ;
    assert_equal (stalin_sort ["330";"is";"horrendous";"terrific"]) ["330"; "is"; "terrific"]

let test_stalin_sort_right _ = 
    assert_equal (stalin_sort_right []) [] ;
    assert_equal (stalin_sort_right [1;0;2;1;4;4]) [0;1;4;4] ;
    assert_equal (stalin_sort_right [9;1;2;3;4;5]) [1; 2; 3; 4; 5] ;
    assert_equal (stalin_sort_right ["216";"is";"terrific"; "lame"]) ["216"; "is"; "lame"]
;;

let suite =
    "public" >::: [
        "mul_thresh" >:: test_mul_thresh;
        "multi_map" >:: test_multi_map;
        "update_database" >:: test_update_database;
        "stalin_sort" >:: test_stalin_sort;
        "stalin_sort_right" >:: test_stalin_sort_right
    ]

let () =
    run_test_tt_main suite
