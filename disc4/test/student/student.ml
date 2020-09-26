open OUnit2
open Disc4

let test_sanity _ =
    assert_equal [] (map float_of_int []) ~msg:"What happened here"

let suite =
  "student" >::: [
    "sanity" >:: test_sanity
  ]

let _ = run_test_tt_main suite
