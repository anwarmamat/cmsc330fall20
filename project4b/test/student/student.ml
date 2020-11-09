open P4b
open OUnit2
open TokenTypes
open SmallCTypes

open Eval
open Utils
open TestUtils
open EvalUtils

let test_sanity _ = 
  assert_equal 1 1

let suite =
  "student" >::: [
    "sanity" >:: test_sanity
  ]

let _ = run_test_tt_main suite
