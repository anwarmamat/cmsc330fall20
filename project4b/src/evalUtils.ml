open Parser
open Lexer
open SmallCTypes
open TokenTypes

(* Buffers for testing prints *)
let (print_buffer : Buffer.t) = Buffer.create 100

let flush_print_buffer () : unit = Buffer.clear print_buffer;;
let assert_buffer_equal (s : string) : unit =
  let c = Buffer.contents print_buffer in
  if not (s = c) then failwith ("Printed: '" ^ c ^ "' Expected:'" ^ s ^ "'");;

(* This is the print you must use for the project *)
let print_output_string (s : string) : unit =
  Buffer.add_string print_buffer s;
  Stdlib.print_string s

let print_output_int (i : int) : unit =
  print_output_string (string_of_int i)

let print_output_bool (b : bool) : unit =
  print_output_string (string_of_bool b)

let print_output_newline () : unit =
  print_output_string "\n"

(* Parse tools *)
let parse_from_string (input : string) : stmt =
  (* Parse the tokens *)
  input |> tokenize |> parse_main

let parse_expr_from_string es =
  let (_, e) = parse_expr (tokenize es) in e

let parse_stmt_from_string s =
  let (_, s) = parse_stmt (tokenize s) in s

let read_from_file (input_filename : string) : string =
  let read_lines name : string list =
    let ic = open_in name in
    let try_read () =
      try Some (input_line ic) with End_of_file -> None in
    let rec loop acc = match try_read () with
      | Some s -> loop (s :: acc)
      | None -> close_in ic; List.rev acc in
    loop []
  in
  (* Read the file into lines *)
  let prog_lines = read_lines input_filename in
  (* Compress to a single string *)
  List.fold_left (fun a e -> a ^ e) "" prog_lines

(* Open file, read, lex, parse *)
let parse_from_file (input_filename : string) : stmt =
  (* Pass string off *)
  parse_from_string (read_from_file input_filename)

(* Unparser *)

let rec unparse_data_type (t : data_type) : string = match t with
  | Int_Type -> "Int_Type"
  | Bool_Type -> "Bool_Type"

let rec unparse_expr (e : expr) : string =
  let unparse_two (s : string) (e1 : expr) (e2 : expr) =
    s ^ "(" ^ unparse_expr e1 ^ ", " ^ unparse_expr e2 ^ ")"
  in

  match e with
  | ID(s) -> "ID \"" ^ s ^ "\""
  | Int(n) -> "Int " ^ string_of_int n
  | Bool(b) -> "Bool " ^ string_of_bool b

  | Add(e1, e2) -> unparse_two "Plus" e1 e2
  | Sub(e1, e2) -> unparse_two "Sub" e1 e2
  | Mult(e1, e2) -> unparse_two "Mult" e1 e2
  | Div(e1, e2) -> unparse_two "Div" e1 e2
  | Pow(e1, e2) -> unparse_two "Pow" e1 e2

  | Equal(e1, e2) -> unparse_two "Equal" e1 e2
  | NotEqual(e1, e2) -> unparse_two "NotEqual" e1 e2

  | Greater(e1, e2) -> unparse_two "Greater" e1 e2
  | Less(e1, e2) -> unparse_two "Less" e1 e2
  | GreaterEqual(e1, e2) -> unparse_two "GreaterEqual" e1 e2
  | LessEqual(e1, e2) -> unparse_two "LessEqual" e1 e2

  | Or(e1, e2) -> unparse_two "Or" e1 e2
  | And(e1, e2) -> unparse_two "And" e1 e2
  | Not(e) -> "Not(" ^ unparse_expr e ^ ")"

let rec unparse_stmt (s : stmt) : string = match s with
  | NoOp -> "NoOp"
  | Seq(s1, s2) -> "Seq(" ^ unparse_stmt s1 ^ ", " ^ unparse_stmt s2 ^ ")"
  | Declare(t, id) -> "Declare(" ^ unparse_data_type t ^ ", " ^ id ^ ")"
  | Assign(id, e) -> "Assign(" ^ id ^ ", " ^ unparse_expr e ^ ")"
  | If(guard, if_body, else_body) ->
    "If(" ^ unparse_expr guard ^ ", " ^ unparse_stmt if_body ^ ", " ^ unparse_stmt else_body ^ ")"
  | While(guard, body) -> "While(" ^ unparse_expr guard ^ ", " ^ unparse_stmt body ^ ")"
  | For(id, start_expr, end_expr, body) -> "For(" ^ id ^ " from " ^ unparse_expr start_expr ^ " to " ^ unparse_expr end_expr ^ "){" ^ unparse_stmt body ^ "}"
  | Print(e) -> "Print(" ^ unparse_expr e ^ ")"

(* Removes shadowed bindings from an execution environment *)
let prune_env (env : environment) : environment =
  let binds = List.sort_uniq compare (List.map (fun (id, _) -> id) env) in
  List.map (fun e -> (e, List.assoc e env)) binds

(* Eval report print function *)
let print_eval_env_report (env : environment): unit =

  print_string "*** BEGIN POST-EXECUTION ENVIRONMENT REPORT ***\n";

  List.iter (fun (var, value) ->
      let vs = begin match value with
        | Int_Val(i) -> string_of_int i
        | Bool_Val(b) -> string_of_bool b
      end in

      Printf.printf "- %s => %s\n" var vs) (prune_env env);

  print_string "***  END POST-EXECUTION ENVIRONMENT REPORT  ***\n"
