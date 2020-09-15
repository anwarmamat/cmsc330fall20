open OUnit2
open Basics

let test_rev_tup _ =
  assert_equal (1, 2, 3) (rev_tup (3, 2, 1)) ~msg:"rev_tup (1)";
  assert_equal (3, 2, 1) (rev_tup (1, 2, 3)) ~msg:"rev_tup (2)";
  assert_equal (3, 1, 1) (rev_tup (1, 1, 3)) ~msg:"rev_tup (3)";
  assert_equal (1, 1, 1) (rev_tup (1, 1, 1)) ~msg:"rev_tup (4)"

let test_abs _ =
  assert_equal 1 (abs 1) ~msg:"abs (1)";
  assert_equal 1 (abs (-1)) ~msg:"abs (2)";
  assert_equal 13 (abs 13) ~msg:"abs (3)";
  assert_equal 13 (abs (-13)) ~msg:"abs (4)"

let test_area _ =
  assert_equal 1 (area (1, 1) (2, 2)) ~msg:"area (1)";
  assert_equal 2 (area (1, 1) (2, 3)) ~msg:"area (2)";
  assert_equal 2 (area (1, 1) (3, 2)) ~msg:"area (3)";
  assert_equal 4 (area (1, 1) (3, 3)) ~msg:"area (4)"

let test_volume _ =
  assert_equal 1 (volume (1, 1, 1) (2, 2, 2)) ~msg:"volume (1)";
  assert_equal 4 (volume (1, 1, 1) (2, 3, 3)) ~msg:"volume (2)";
  assert_equal 4 (volume (1, 1, 1) (3, 2, 3)) ~msg:"volume (3)";
  assert_equal 4 (volume (1, 1, 1) (3, 3, 2)) ~msg:"volume (4)";
  assert_equal 8 (volume (1, 1, 1) (3, 3, 3)) ~msg:"volume (5)"

let test_factorial _ =
  assert_equal 1 (factorial 1) ~msg:"factorial (1)";
  assert_equal 2 (factorial 2) ~msg:"factorial (2)";
  assert_equal 6 (factorial 3) ~msg:"factorial (3)";
  assert_equal 120 (factorial 5) ~msg:"factorial (4)"

let test_pow _ =
  assert_equal 2 (pow 2 1) ~msg:"pow (1)";
  assert_equal 4 (pow 2 2) ~msg:"pow (2)";
  assert_equal 3 (pow 3 1) ~msg:"pow (3)";
  assert_equal 27 (pow 3 3) ~msg:"pow (4)";
  assert_equal 625 (pow 5 4) ~msg:"pow (5)";
  assert_equal (-27) (pow (-3) 3) ~msg:"pow (6)"

let test_log _ =
  assert_equal 1 (log 4 4) ~msg:"log (1)";
  assert_equal 2 (log 4 16) ~msg:"log (2)";
  assert_equal 1 (log 4 15) ~msg:"log (3)";
  assert_equal 3 (log 4 64) ~msg:"log (4)"

let test_is_prime _ =
  assert_equal false (is_prime 1) ~msg:"is_prime (1)";
  assert_equal true (is_prime 2) ~msg:"is_prime (2)";
  assert_equal true (is_prime 3) ~msg:"is_prime (3)";
  assert_equal false (is_prime 4) ~msg:"is_prime (4)";
  assert_equal true (is_prime 5) ~msg:"is_prime (5)";
  assert_equal false (is_prime 60) ~msg:"is_prime (6)";
  assert_equal true (is_prime 61) ~msg:"is_prime (7)"

let test_next_prime _ =
  assert_equal 2 (next_prime 1) ~msg:"next_prime (1)";
  assert_equal 2 (next_prime 2) ~msg:"next_prime (2)";
  assert_equal 3 (next_prime 3) ~msg:"next_prime (3)";
  assert_equal 5 (next_prime 4) ~msg:"next_prime (4)";
  assert_equal 61 (next_prime 60) ~msg:"next_prime (5)"

let test_get _ =
  assert_equal 26 (get 0 [26; 11; 99]) ~msg:"get (1)";
  assert_equal 11 (get 1 [26; 11; 99]) ~msg:"get (2)";
  assert_equal 99 (get 2 [26; 11; 99]) ~msg:"get (3)";
  assert_raises (Failure ("Out of bounds")) (fun () -> get 3 [26; 11; 99]) ~msg:"get (4)"

let test_larger _ =
  assert_equal [1; 2; 3] (larger [1; 2; 3] [5; 6]) ~msg:"larger (1)";
  assert_equal [1; 2; 3] (larger [5; 6] [1; 2; 3]) ~msg:"larger (2)";
  assert_equal [1; 2; 3] (larger [] [1; 2; 3]) ~msg:"larger (3)";
  assert_equal [1; 2; 3] (larger [1; 2; 3] []) ~msg:"larger (4)";
  assert_equal [1] (larger [1] []) ~msg:"larger (5)"

let test_reverse _ =
  assert_equal [1] (reverse [1]) ~msg:"reverse (1)";
  assert_equal [3; 2; 1] (reverse [1; 2; 3]) ~msg:"reverse (2)"

let test_combine _ =
  assert_equal [1; 2] (combine [1] [2]) ~msg:"combine (1)";
  assert_equal [1; 2; 3] (combine [1] [2; 3]) ~msg:"combine (2)";
  assert_equal [1; 2; 3] (combine [1; 2] [3]) ~msg:"combine (3)";
  assert_equal [1; 2; 3; 4] (combine [1; 2] [3; 4]) ~msg:"combine (4)"

let suite =
  "public" >::: [
    "rev_tup" >:: test_rev_tup;
    "abs" >:: test_abs;
    "area" >:: test_area;
    "volume" >:: test_volume;
    "factorial" >:: test_factorial;
    "pow" >:: test_pow;
    "log" >:: test_log;
    "is_prime" >:: test_is_prime;
    "next_prime" >:: test_next_prime;
    "get" >:: test_get;
    "larger" >:: test_larger;
    "reverse" >:: test_reverse;
    "combine" >:: test_combine
  ]

let _ = run_test_tt_main suite
