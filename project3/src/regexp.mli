(* IMPORTANT: YOU MAY NOT MODIFY THIS FILE!
 * OUR TESTS USE THE ORIGINAL VERSION.
 * YOUR CODE WILL NOT COMPILE IF YOU CHANGE THIS FILE. *)

(* This is the type used to describe the form of a regexp *)

type regexp_t =
  | Empty_String
  | Char of char
  | Union of regexp_t * regexp_t
  | Concat of regexp_t * regexp_t
  | Star of regexp_t

(* These are the regexp functions you must implement *)

val regexp_to_nfa : regexp_t -> (int, char) Nfa.nfa_t

val string_to_regexp : string -> regexp_t

val string_to_nfa : string -> (int, char) Nfa.nfa_t

exception IllegalExpression of string
