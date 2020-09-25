open OUnit2

let assert_true x = assert_equal true x
let assert_false x = assert_equal false x

let string_of_list f xs =
  "[" ^ (String.concat "; " (List.map f xs)) ^ "]"

let string_of_pair f g (x, y) =
  "(" ^ (f x) ^ ", " ^ (g y) ^ ")"

let string_of_string_list = string_of_list (fun x -> x)
let string_of_int_pair = string_of_pair string_of_int string_of_int
let string_of_string_int_pair = string_of_pair (fun x -> x) string_of_int
let string_of_bool_int_pair = string_of_pair string_of_bool string_of_int
let string_of_float_int_pair = string_of_pair string_of_float string_of_int

let string_of_int_triple _ _ _ (x, y, z) =
  "(" ^ (string_of_int x) ^ ", " ^ (string_of_int y) ^ ", " ^ (string_of_int z) ^ ")"
let string_of_int_quad (x, y, z, a) =
  "(" ^ (string_of_int x) ^ ", " ^ (string_of_int y) ^ ", " ^ (string_of_int z) ^ ", " ^ (string_of_int a) ^ ")"

let string_of_int_list = string_of_list string_of_int
let string_of_int_pair_list = string_of_list string_of_int_pair
let string_of_bool_list = string_of_list string_of_bool
let string_of_float_list = string_of_list string_of_float
let string_of_bool_int_pair_list = string_of_list string_of_bool_int_pair
let string_of_string_int_pair_list = string_of_list string_of_string_int_pair
let string_of_float_int_pair_list = string_of_list string_of_float_int_pair
