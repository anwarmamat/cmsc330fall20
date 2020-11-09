open P4b
open EvalUtils
open Eval

type run_context = {filename : string option; print_report : bool; unparse : bool };;

let print_usage () =
  print_string "\nThis file functions as a driver for interfacing with the SmallC language\n\n";
  print_string "Usage:\n";
  print_string "\tinterface <filename> : Simply run the SmallC program in file <filename> and exit\n";
  print_string "Flags:\n";
  print_string "\t--unparse / -U : Add one of these flags to print the stmt datatype representing the program in <filename> instead of evaluating it\n";
  print_string "\t--report / -R : Add one of these flags to add a listing of variable bindings created by your program. Great for debugging!\n\n";
  exit 1
;;

(* Make sure there are args given *)
let args = match Array.to_list Sys.argv with
  | _::t -> t
  | _ -> print_usage ()
;;

(* Process command line arguments to set up run context *)
let ctxt = List.fold_left (fun {filename = f; print_report = r; unparse = u} -> function
    | "--unparse" | "-U" -> {filename = f; print_report = r; unparse = true}
    | "--report" | "-R" -> {filename = f; print_report = true; unparse = u}
    | x -> {filename = Some(x); print_report = r; unparse = u})
    {filename = None; print_report = false; unparse = false} args;;

match ctxt.filename with
| None -> print_usage ()
| Some(filename) ->
  let ast = parse_from_file filename in
  if ctxt.unparse then begin
    print_string @@ unparse_stmt ast;
  end else
    let final_env = eval_stmt [] ast in
    if ctxt.print_report then begin print_eval_env_report final_env; print_newline () end
;;

print_newline ();
