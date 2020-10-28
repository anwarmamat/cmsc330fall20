open OUnit2

let test_sanity _ =
  assert_equal 1 1

let suite =
  "student" >::: [
    "sanity" >:: test_sanity
  ]

let _ = run_test_tt_main suite
