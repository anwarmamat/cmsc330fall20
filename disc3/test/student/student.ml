open OUnit2
open Disc3

let test_sanity _ =
    assert_equal "abc" (concat "ab" "c") ~msg:"Custom error message"

let suite =
  "student" >::: [
    "sanity" >:: test_sanity
  ]

let _ = run_test_tt_main suite
