(* IMPORTANT: YOU MAY NOT MODIFY THIS FILE!
 * OUR TESTS USE THE ORIGINAL VERSION.
 * YOUR CODE WILL NOT COMPILE IF YOU CHANGE THIS FILE. *)

(* Types *)

type ('q, 's) transition = 'q * 's option * 'q

type ('q, 's) nfa_t =
  { sigma: 's list
  ; qs: 'q list
  ; q0: 'q
  ; fs: 'q list
  ; delta: ('q, 's) transition list }

(* Part 1 *)

val e_closure : ('q, 's) nfa_t -> 'q list -> 'q list

val move : ('q, 's) nfa_t -> 'q list -> 's option -> 'q list

val accept : ('q, char) nfa_t -> string -> bool

(* Part 2 *)

val new_states : ('q, 's) nfa_t -> 'q list -> 'q list list

val new_trans : ('q, 's) nfa_t -> 'q list -> ('q list, 's) transition list

val new_finals : ('q, 's) nfa_t -> 'q list -> 'q list list

val nfa_to_dfa_step :
  ('q, 's) nfa_t -> ('q list, 's) nfa_t -> 'q list list -> ('q list, 's) nfa_t

val nfa_to_dfa : ('q, 's) nfa_t -> ('q list, 's) nfa_t
