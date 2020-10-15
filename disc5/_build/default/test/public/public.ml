open OUnit2
open Disc5

let test_mul_n _ = 
    assert_equal (mul_n 5 [1;2;3;4;5]) [5;10;15;20;25];
    assert_equal (mul_n 100 []) [];
    assert_equal (mul_n 0 [1;-1;50;10000]) [0;0;0;0]

let test_join _ =
    assert_equal (join ["a"; "b"; "c"] ", ") "a, b, c";
    assert_equal (join ["hello"; ""; "goodbye"] ";") "hello;;goodbye";
    assert_equal (join [] "hello!") ""

let test_list_of_option _ =
    assert_equal (list_of_option (Some "b")) ["b"];
    assert_equal (list_of_option None) [];
    assert_equal (list_of_option (Some 4)) [4]

let test_match_key _ =
    assert_equal (match_key 3 (3, 4)) (Some 4);
    assert_equal (match_key 2 (3, 4)) None;
    assert_equal (match_key "hi" ("hi", [1;2;3])) (Some [1;2;3]);
    assert_equal (match_key "h" ("hi", [1;2;3])) None

let test_list_of_lengthlist _ =
    assert_equal (list_of_lengthlist Empty) [];
    assert_equal (list_of_lengthlist (Cons(1, 4, Cons(2, 3, Cons(3, 2, Cons(4, 1, Empty)))))) [1;1;1;1;2;2;2;3;3;4];
    assert_equal (list_of_lengthlist (Cons("test", 4, Cons("hi", 2, Empty)))) ["test";"test";"test";"test";"hi"; "hi"]

let test_map_lengthlist _ =
    assert_equal (map_lengthlist (fun a -> a) Empty) Empty;
    assert_equal (map_lengthlist (fun a -> string_of_int a) 
                    (Cons(1, 4, Cons(2, 3, Cons(3, 2, Cons(4, 1, Empty)))))) 
                 (Cons("1", 4, Cons("2", 3, Cons("3", 2, Cons("4", 1, Empty)))))

let test_decrement_count _ = 
    assert_equal (decrement_count (Cons(1, 4, Cons(2, 3, Cons(3, 2, Cons(4, 1, Empty)))))) (Cons(1, 3, Cons(2, 2, Cons(3, 1, Empty))));
    assert_equal (decrement_count (Cons(1, 4, Cons(2, 3, Empty)))) (Cons(1, 3, Cons(2, 2, Empty)));
    assert_equal (decrement_count (Cons("str", 1, Empty))) Empty;
    assert_equal (decrement_count Empty) Empty


let suite =
    "public" >::: [
        "mul_n" >:: test_mul_n;
        "join" >:: test_join;
        "list_of_option" >:: test_list_of_option;
        "match_key" >:: test_match_key;
        "list_of_lengthlist" >:: test_list_of_lengthlist;
        "map_lengthlist" >:: test_map_lengthlist;
        "decrement_count" >:: test_decrement_count
    ]

let () =
    run_test_tt_main suite
