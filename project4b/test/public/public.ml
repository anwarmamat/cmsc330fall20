open P4b
open OUnit2
open TokenTypes
open SmallCTypes

open Eval
open Utils
open TestUtils


let env1 = [("var1", Int_Val 4); ("var2", Bool_Val false)]

let test_expr_basic _ =
  let i = 5 in assert_equal (Int_Val i) (eval_expr [] (Int i));
  let i = (-10) in assert_equal (Int_Val i) (eval_expr [] (Int i));
  assert_equal (Bool_Val true) (eval_expr env1 (Bool true));
  assert_equal (Bool_Val false) (eval_expr env1 (Bool false));
  assert_equal (Int_Val 4) (eval_expr env1 (ID "var1"));
  assert_equal (Bool_Val false) (eval_expr env1 (ID "var2"))

let test_expr_ops _ =
  assert_equal (Int_Val 8) (eval_expr env1 (Add ((ID "var1"), (Int 4))));
  assert_equal (Int_Val (-2)) (eval_expr env1 (Add ((ID "var1"), (Int (-6)))));
  assert_equal (Int_Val 42) (eval_expr [] (Sub (Int 50, Int 8)));
  assert_equal (Int_Val (-2)) (eval_expr env1 (Sub (ID "var1", Int 6)));
  assert_equal (Int_Val 64) (eval_expr [] (Mult (Int 8, Int 8)));
  assert_equal (Int_Val (-10)) (eval_expr [] (Mult (Int 5, Int (-2))));
  assert_equal (Int_Val 10) (eval_expr [] (Div (Int 70, Int 7)));
  assert_equal (Int_Val (50/3)) (eval_expr [] (Div (Int 50, Int 3)));
  assert_equal (Int_Val 9) (eval_expr [] (Pow (Int 3, Int 2)));

  assert_equal (Bool_Val true) (eval_expr [] (Or (Bool false, Bool true)));
  assert_equal (Bool_Val false) (eval_expr env1 (Or (Bool false, ID "var2")));
  assert_equal (Bool_Val false) (eval_expr [] (And (Bool false, Bool true)));
  assert_equal (Bool_Val true) (eval_expr [] (And (Bool true, Bool true)));
  assert_equal (Bool_Val true) (eval_expr [] (Not (Bool false)));
  assert_equal (Bool_Val false) (eval_expr [] (Not (Bool true)));

  assert_equal (Bool_Val false) (eval_expr env1 (Equal (ID "var1", Int 10)));
  assert_equal (Bool_Val true) (eval_expr env1 (Equal (ID "var2", Bool false)));
  assert_equal (Bool_Val true) (eval_expr env1 (NotEqual (ID "var1", Int 10)));
  assert_equal (Bool_Val false) (eval_expr env1 (NotEqual (ID "var2", ID "var2")));

  assert_equal (Bool_Val true) (eval_expr env1 (Greater (ID "var1", Int 2)));
  assert_equal (Bool_Val false) (eval_expr env1 (Greater (Int 2, ID "var1")));
  assert_equal (Bool_Val true) (eval_expr env1 (Less (ID "var1", Int 10)));
  assert_equal (Bool_Val false) (eval_expr env1 (Less (ID "var1", Int 2)));
  assert_equal (Bool_Val true) (eval_expr [] (GreaterEqual (Int 0, Int 0)));
  assert_equal (Bool_Val false) (eval_expr [] (GreaterEqual (Int 0, Int 1)));
  assert_equal (Bool_Val false) (eval_expr [] (LessEqual (Int 1, Int 0)))

let test_expr_fail _ =
  assert_expr_fail expr_env "1 + p";
  assert_expr_fail expr_env "false * y";
  assert_expr_fail expr_env "q - 1";
  assert_expr_fail expr_env "y / false";
  assert_expr_fail expr_env "x ^ true";
  assert_expr_fail expr_env "1 || q";
  assert_expr_fail expr_env "p && 0";
  assert_expr_fail expr_env "!x";
  assert_expr_fail expr_env "x > p";
  assert_expr_fail expr_env "q < y";
  assert_expr_fail expr_env "q >= x";
  assert_expr_fail expr_env "x <= q";
  assert_expr_fail expr_env "p == x";
  assert_expr_fail expr_env "p != x";
  assert_expr_fail expr_env "x + (y + true)";
  assert_expr_fail expr_env "(x * false) * y";
  assert_expr_fail expr_env "x - (false - 1)";
  assert_expr_fail expr_env "y / (true / x)";
  assert_expr_fail expr_env "x ^ (false ^ y)";
  assert_expr_fail expr_env "(q || 1) || p";
  assert_expr_fail expr_env "q && (1 && q)";
  assert_expr_fail expr_env "!p && !1";
  assert_expr_fail expr_env "p == (y > false)";
  assert_expr_fail expr_env "q && (true < y)";
  assert_expr_fail expr_env "(y >= true) || q";
  assert_expr_fail expr_env "(x <= true) != q";
  assert_expr_fail expr_env "(x == false) == q";
  assert_expr_fail expr_env "(y == true) == p"

(* Simple sequence *)
let test_stmt_basic _ =
  let env = [("a", Bool_Val true); ("b", Int_Val 7)] in
  assert_stmt_success env env "int main(){}";
  assert_stmt_success [] [("a", Int_Val 0); ("b", Int_Val 0); ("x", Bool_Val false); ("y", Bool_Val false)] "int main() {int a;int b;bool x; bool y;}";
  assert_stmt_success [] [("a", Int_Val 0)] "int main() {int a; printf(a);}"
    ~output:"0\n";
  assert_stmt_success [] [("a", Bool_Val false)] "int main() {bool a; printf(a);}"
    ~output:"false\n"

(* Simple if true and if false *)
let test_stmt_control _ =
  assert_stmt_success [("a", Bool_Val true)] [("a", Bool_Val true); ("b", Int_Val 5)] "int main() {int b;if(a) { b=5;} else { b=10;}}";
  assert_stmt_success [("a", Bool_Val false)] [("a", Bool_Val false); ("b", Int_Val 10)] "int main() {int b;if(a) { b=5;} else { b=10;}}"

(* Simple define int/ bool - test defaults *)
let test_define_1 = create_system_test [] [("a", Int_Val 0)] ["define1.c"]
let test_define_2 = create_system_test [] [("a", Bool_Val false)] ["define2.c"]

(* Simple assign int/bool/exp*)
let test_assign_1 = create_system_test [] [("a", Int_Val 100)] ["assign1.c"]
let test_assign_2 = create_system_test [] [("a", Bool_Val true)] ["assign2.c"]
let test_assign_exp = create_system_test [] [("a", Int_Val 0)] ["assign-exp.c"]
    ~output:"0\n"

(* equal & not equal & less *)
let test_notequal = create_system_test [] [("a", Int_Val 100)] ["notequal.c"]
    ~output:"100\n"
let test_equal = create_system_test [] [("a", Int_Val 200)] ["equal.c"]
    ~output:"200\n"
let test_less = create_system_test [] [("a", Int_Val 200)] ["less.c"]
    ~output:"200\n"

(* Some expressions *)
let test_exp_1 = create_system_test [] [("a", Int_Val 322)] ["exp1.c"]
    ~output:"322\n"
let test_exp_2 = create_system_test [] [("a", Int_Val 8002)] ["exp2.c"]
    ~output:"8002\n"
let test_exp_3 = create_system_test [] [("a", Int_Val (-1))] ["exp3.c"]
    ~output:"-1\n"

(* If/ Else/ While *)
let test_ifelse = create_system_test [] [("a", Int_Val 200)] ["ifelse.c"]
let test_if_else_while = create_system_test [] [("b", Int_Val 0);("a", Int_Val 200)] ["if-else-while.c"]
let test_while = create_system_test [] [("a", Int_Val 10); ("b", Int_Val 11)] ["while.c"]
                   ~output:"1\n3\n5\n7\n9\n"
let test_for = create_system_test [] [("a", Int_Val 51); ("b", Int_Val 41)] ["for.c"]
let test_nested_ifelse = create_system_test [] [("a", Int_Val 400)] ["nested-ifelse.c"]
let test_nested_while = create_system_test [] [("sum", Int_Val 405);("j", Int_Val 10); ("i", Int_Val 10)] ["nested-while.c"]

(* NoOp *)
let test_main = create_system_test [] [] ["main.c"]

(* More Comprehensive *)
let test_test_1 = create_system_test [] [("a", Int_Val 10);("sum", Int_Val 45); ("b", Int_Val 10)] ["test1.c"]
    ~output:"1\n10\n1\n3\n10\n3\n6\n10\n6\n10\n10\n10\n15\n10\n15\n21\n10\n21\n28\n10\n28\n36\n10\n36\n45\n20\n45\n"
let test_test_2 = create_system_test [] [("a", Int_Val 10);("c", Int_Val 0); ("b", Int_Val 20)] ["test2.c"]
    ~output:"10\n"
let test_test_3 = create_system_test [] [("a", Int_Val 10);("c", Int_Val 64); ("b", Int_Val 2)] ["test3.c"]
    ~output:"64\nfalse\n"

let test_stmt_fail_basic _ =
  assert_stmt_fail stmt_env "printf((x + y) > false);" ~expect:DeclareExpect;
  assert_stmt_fail stmt_env "printf(!(p || q));" ~expect:DeclareExpect;
  assert_stmt_fail stmt_env "int y; int x;" ~expect:DeclareExpect;
  assert_stmt_fail stmt_env "bool q; bool p;" ~expect:DeclareExpect;
  assert_stmt_fail stmt_env "int y; bool x;" ~expect:DeclareExpect;
  assert_stmt_fail stmt_env "bool q; int p;" ~expect:DeclareExpect;
  assert_stmt_fail stmt_env "x = false;";
  assert_stmt_fail expr_env "x = y + (p && q);";
  assert_stmt_fail stmt_env "y = 1;" ~expect:DeclareExpect;
  assert_stmt_fail expr_env "x = (y + x) > z;" ~expect:DeclareExpect;
  assert_stmt_fail stmt_env "p = 1;";
  assert_stmt_fail expr_env "q = p || (x && q);";
  assert_stmt_fail stmt_env "q = false;" ~expect:DeclareExpect;
  assert_stmt_fail expr_env "q = q || !(p && r);" ~expect:DeclareExpect

let test_stmt_fail_control _ =
  assert_stmt_fail stmt_env "if (0) {x = 0;} else {x = 1;}";
  assert_stmt_fail stmt_env "if (p || q) {x = 0;} else {x = 1;}" ~expect:DeclareExpect;
  assert_stmt_fail expr_env "if (x / (y * 2)) {x = 0;} else {x = 1;}";
  assert_stmt_fail stmt_env "if (true) {printf(!p); p = !(p && q);} else {x = x - x;}" ~expect:DeclareExpect;
  assert_stmt_fail expr_env "if (false) {x = y * y;} else {printf(x * (p && x)); x = 1;}";
  assert_stmt_fail stmt_env "if (false) {p = !p;} else {x = (x * x) / y; printf(x);}" ~expect:DeclareExpect;
  assert_stmt_fail stmt_env "while (0) {x = x + 1;}";
  assert_stmt_fail stmt_env "while ((p || q) !=  false) {x = x + 1;}" ~expect:DeclareExpect;
  assert_stmt_fail expr_env "while (x - (x + y)) {x = x + 1; printf(x * x);}";
  assert_stmt_fail expr_env "while (true) {p = p && q; printf(x + (p < q));}"

(* val eval_expr : Types.eval_environment -> Types.expr -> Types.value_type *)
let public =
  "public" >::: [
    "public_expr_basic" >:: test_expr_basic;
    "public_expr_ops" >:: test_expr_ops;
    "public_expr_fail" >:: test_expr_fail;
    "public_stmt_basic" >:: test_stmt_basic;
    "public_stmt_control" >:: test_stmt_control;
    "public_define_1" >:: test_define_1;
    "public_define_2" >:: test_define_2;
    "public_assign_1" >:: test_assign_1;
    "public_assign_2" >:: test_assign_2;
    "public_assign_exp" >:: test_assign_exp;
    "public_notequal" >:: test_notequal;
    "public_equal" >:: test_equal;
    "public_less" >:: test_less;
    "public_exp_1" >:: test_exp_1;
    "public_exp_2" >:: test_exp_2;
    "public_exp_3" >:: test_exp_3;
    "public_ifelse" >:: test_ifelse;
    "public_if_else_while" >:: test_if_else_while;
    "public_while" >:: test_while;
    "public_for" >:: test_for;
    "public_nested_ifelse" >:: test_nested_ifelse;
    "public_nested_while" >:: test_nested_while;
    "public_main" >:: test_main;
    "public_test_1" >:: test_test_1;
    "public_test_2" >:: test_test_2;
    "public_test_3" >:: test_test_3;
    "public_stmt_fail_basic" >:: test_stmt_fail_basic;
    "public_stmt_fail_control" >:: test_stmt_fail_control
  ]

let _ = run_test_tt_main public
