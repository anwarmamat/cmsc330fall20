open OUnit2
open P4a.Utils
open P4a.Lexer
open P4a.Parser
open P4a.SmallCTypes
open P4a.TokenTypes

(* Assertion wrappers for convenience and readability *)
let assert_true b = assert_equal true b
let assert_false b = assert_equal false b
let assert_succeed () = assert_true true

(* parse utils *)

let input_handler f =
  try
    let _ = f () in assert_failure "Expected InvalidInputException, none received" with
  | InvalidInputException(_) -> assert_succeed ()
  | ex -> assert_failure ("Got " ^ (Printexc.to_string ex) ^ ", expected InvalidInputException")

let assert_stmt_fail (s : string) =
  input_handler (fun _ ->
    let toks = tokenize s in
    parse_main toks)

let assert_expr_fail s =
  assert_stmt_fail ("int main() { printf(" ^ s ^ "); }")

let assert_ast_equal
    (es : string)
    (output : stmt) : unit =
  let toks = tokenize_from_file es in
  let ast = parse_main toks in
  assert_equal ast output

let build_data_filename p =
    let rec aux = function
        | [] -> ""
        | h :: [] -> h
        | h :: p -> h ^ Filename.dir_sep ^ (aux p) in
    (Filename.dirname Sys.argv.(0)) ^ Filename.dir_sep ^ "data" ^ Filename.dir_sep ^ aux p

let create_system_test
    (es : string list)
    (output : stmt) : (test_ctxt -> unit) =
  (fun _ -> assert_ast_equal (build_data_filename es) output)
