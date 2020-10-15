open P3.Nfa
open P3.Regexp
open OUnit2

let re_to_str r =
  let surround l = ("(" :: l) @ [")"] in
  let rec r2str = function
    | Empty_String -> ["E"]
    | Char c -> [String.make 1 c]
    | Union (r1, r2) ->
        let l1 = surround @@ r2str r1 and l2 = surround @@ r2str r2 in
        l1 @ ("|" :: l2)
    | Concat (r1, r2) ->
        let l1 = surround @@ r2str r1 and l2 = surround @@ r2str r2 in
        l1 @ l2
    | Star r1 ->
        let l1 = surround @@ r2str r1 in
        l1 @ ["*"]
  in
  String.concat "" (r2str r)

let assert_true x = assert_equal true x

let assert_false x = assert_equal false x

let assert_pass () = assert_equal true true

let assert_fail () = assert_equal false false

let string_of_int_list l =
  Printf.sprintf "[%s]" @@ String.concat "; " @@ List.map string_of_int l

let string_of_int_list_list l =
  Printf.sprintf "[%s]" @@ String.concat "; " @@ List.map string_of_int_list l

let assert_dfa m =
  let nondet =
    List.fold_left
      (fun res (q, c, _) ->
        match c with
        | None -> true
        | Some _ ->
            let others =
              List.filter (fun (q', c', _) -> q' = q && c' = c) m.delta
            in
            res || List.length others > 1 )
      false m.delta
  in
  if nondet then assert_failure @@ Printf.sprintf "NFA is not DFA"

(* Helpers for clearly testing the accept function *)
let assert_nfa_accept nfa input =
  if not @@ accept nfa input then
    assert_failure
    @@ Printf.sprintf "NFA should have accept string '%s', but did not" input

let assert_nfa_deny nfa input =
  if accept nfa input then
    assert_failure
    @@ Printf.sprintf "NFA should not have accepted string '%s', but did" input

let assert_nfa_closure nfa ss es =
  let es = List.sort compare es in
  let rcv = List.sort compare @@ e_closure nfa ss in
  if not (es = rcv) then
    assert_failure
    @@ Printf.sprintf "Closure failure: Expected %s, received %s"
         (string_of_int_list es) (string_of_int_list rcv)

let assert_nfa_move nfa ss mc es =
  let es = List.sort compare es in
  let rcv = List.sort compare @@ move nfa ss mc in
  if not (es = rcv) then
    assert_failure
    @@ Printf.sprintf "Move failure: Expected %s, received %s"
         (string_of_int_list es) (string_of_int_list rcv)

let assert_set_set_eq lst1 lst2 =
  let es l = List.sort_uniq compare (List.map (List.sort compare) l) in
  assert_equal (es lst1) (es lst2)

let assert_trans_eq lst1 lst2 =
  let es l =
    List.sort_uniq compare
      (List.map
         (fun (l1, t, l2) -> (List.sort compare l1, t, List.sort compare l2))
         l)
  in
  assert_equal (es lst1) (es lst2)

let assert_set_eq lst1 lst2 =
  let es = List.sort_uniq compare in
  assert_equal (es lst1) (es lst2)

let assert_regex_string_equiv rxp =
  assert_equal rxp @@ string_to_regexp @@ re_to_str rxp
