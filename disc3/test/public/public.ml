open OUnit2
open Disc3

let test_concat _ =
    assert_equal "abc" (concat "ab" "c");
    assert_equal "d" (concat "" "d")

let test_add_to_float _ =
    assert_equal 6.0 (add_to_float 2 4.0);
    assert_equal 0.0 (add_to_float 2 (-2.0))

let test_fib _ =
    assert_equal 0 (fib 0);
    assert_equal 1 (fib 1);
    assert_equal 5 (fib 5);
    assert_equal 8 (fib 6)

let test_add_three _ =
    assert_equal [9;8;7] (add_three [6;5;4]);
    assert_equal [] (add_three [])

let test_filter _ =
    assert_equal [1; 2] (filter 2 [1; 2; 3; 4]);
    assert_equal [] (filter 5 []);
    assert_equal [1;2;3;4] (filter 5 [1;2;3;4]);
    assert_equal [] (filter 0 [1;2;3;4])

let test_double _ =
    assert_equal [1;1;2;2;3;3] (double [1;2;3]);
    assert_equal ["a"; "a"; "b"; "b"] (double ["a"; "b"]);
    assert_equal [] (double [])

let test_func_defn _ = 
    let _ = (tf1 "test") == 1 in
    let _ = (tf2 1 "test" "test") == true in
    let _ = (tf3 [1;2] [3;4]) == 1 in
    ()
;;

let suite =
    "public" >::: [
        "concat" >:: test_concat;
        "add_to_float" >:: test_add_to_float;
        "fib" >:: test_fib;
        "add_three" >:: test_add_three;
        "filter" >:: test_filter;
        "func_defn" >:: test_func_defn
    ]

let () =
    run_test_tt_main suite
