open OUnit2
open P2b.Data
open P2b.Funs
open P2b.Higher

let test_sanity _ = 
  assert_equal 1 1

let suite =
  "student" >::: [
    "sanity" >:: test_sanity
  ]

let _ = run_test_tt_main suite
