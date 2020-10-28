open OUnit2
open P4a.SmallCTypes
open TestUtils

let public_test_assign1 = create_system_test ["assign1.c"]
  (Seq(Declare(Int_Type, "a"), Seq(Assign("a", Int 100), NoOp)))
let public_test_assign_exp = create_system_test ["assign-exp.c"]
  (Seq(Declare(Int_Type, "a"), Seq(Assign("a", Mult(Int 100, ID "a")), Seq(Print(ID "a"), NoOp))))
let public_test_define_1 = create_system_test ["define1.c"]
  (Seq(Declare(Int_Type, "a"), NoOp))
let public_test_equal = create_system_test ["equal.c"]
  (Seq(Declare(Int_Type, "a"), Seq(Assign("a", Int 100), Seq(If(Equal(ID "a", Int 100), Seq(Assign("a", Int 200), Seq(Print(ID "a"), NoOp)), NoOp), NoOp))))
let public_test_exp_1 = create_system_test ["exp1.c"]
  (Seq(Declare(Int_Type, "a"), Seq(Assign("a", Add(Int 2, Mult(Int 5, Pow(Int 4, Int 3)))), Seq(Print(ID "a"), NoOp))))
let public_test_exp_2 = create_system_test ["exp2.c"]
  (Seq(Declare(Int_Type, "a"), Seq(Assign("a", Add(Int 2, Pow(Mult(Int 5, Int 4), Int 3))), Seq(Print(ID "a"), NoOp))))
let public_test_greater = create_system_test ["greater.c"]
  (Seq(Declare(Int_Type, "a"), Seq(Assign("a", Int 100), Seq(If(Greater(ID "a", Int 10), Seq(Assign("a", Int 200), Seq(Print(ID "a"), NoOp)), NoOp), NoOp))))
let public_test_if = create_system_test ["if.c"]
  (Seq(Declare(Int_Type, "a"), Seq(Assign("a", Int 100), Seq(If(Greater(ID "a", Int 10), Seq(Assign("a", Int 200), NoOp), NoOp), NoOp))))
let public_test_ifelse = create_system_test ["ifelse.c"]
  (Seq(Declare(Int_Type, "a"), Seq(Assign("a", Int 100), Seq(If(Greater(ID "a", Int 10), Seq(Assign("a", Int 200), NoOp), Seq(Assign("a", Int 300), NoOp)), NoOp))))
let public_test_if_else_while = create_system_test ["if-else-while.c"]
  (Seq(Declare(Int_Type, "a"), Seq(Assign("a", Int 100), Seq(Declare(Int_Type, "b"), Seq(If(Greater(ID "a", Int 10), Seq(Assign("a", Int 200), NoOp), Seq(Assign("b", Int 10), Seq(While(Less(Mult(ID "b", Int 2), ID "a"), Seq(Assign("b", Add(ID "b", Int 2)), Seq(Print(ID "b"), NoOp))), Seq(Assign("a", Int 300), NoOp)))), NoOp)))))
let public_test_less = create_system_test ["less.c"]
  (Seq(Declare(Int_Type, "a"), Seq(Assign("a", Int 100), Seq(If(Less(ID "a", Int 200), Seq(Assign("a", Int 200), Seq(Print(ID "a"), NoOp)), NoOp), NoOp))))
let public_test_main = create_system_test ["main.c"]
  NoOp
let public_test_nested_if = create_system_test ["nested-if.c"]
  (Seq(Declare(Int_Type, "a"), Seq(Assign("a", Int 100), Seq(If(Greater(ID "a", Int 10), Seq(Assign("a", Int 200), Seq(If(Less(ID "a", Int 20), Seq(Assign("a", Int 300), NoOp), Seq(Assign("a", Int 400), NoOp)), NoOp)), NoOp), NoOp))))
let public_test_nested_ifelse = create_system_test ["nested-ifelse.c"]
  (Seq(Declare(Int_Type, "a"), Seq(Assign("a", Int 100), Seq(If(Greater(ID "a", Int 10), Seq(Assign("a", Int 200), Seq(If(Less(ID "a", Int 20), Seq(Assign("a", Int 300), NoOp), Seq(Assign("a", Int 400), NoOp)), NoOp)), Seq(Assign("a", Int 500), NoOp)), NoOp))))
let public_test_nested_while = create_system_test ["nested-while.c"]
  (Seq(Declare(Int_Type, "i"), Seq(Declare(Int_Type, "j"), Seq(Assign("i", Int 1), Seq(Declare(Int_Type, "sum"), Seq(Assign("sum", Int 0), Seq(While(Less(ID "i", Int 10), Seq(Assign("j", Int 1), Seq(While(Less(ID "j", Int 10), Seq(Assign("sum", Add(ID "sum", ID "j")), Seq(Assign("j", Add(ID "j", Int 1)), NoOp))), Seq(Assign("i", Add(ID "i", Int 1)), NoOp)))), NoOp)))))))
let public_test_print = create_system_test ["print.c"]
  (Seq(Declare(Int_Type, "a"), Seq(Assign("a", Int 100), Seq(Print(ID "a"), NoOp))))
let public_test_test1 = create_system_test ["test1.c"]
  (Seq(Declare(Int_Type, "a"), Seq(Assign("a", Int 10), Seq(Declare(Int_Type, "b"), Seq(Assign("b", Int 1), Seq(Declare(Int_Type, "sum"), Seq(Assign("sum", Int 0), Seq(While(Less(ID "b", ID "a"), Seq(Assign("sum", Add(ID "sum", ID "b")), Seq(Assign("b", Add(ID "b", Int 1)), Seq(Print(ID "sum"), Seq(If(Greater(ID "a", ID "b"), Seq(Print(Int 10), NoOp), Seq(Print(Int 20), NoOp)), Seq(Print(ID "sum"), NoOp)))))), NoOp))))))))
let public_test_test2 = create_system_test ["test2.c"]
  (Seq(Declare(Int_Type, "a"), Seq(Assign("a", Int 10), Seq(Declare(Int_Type, "b"), Seq(Assign("b", Int 20), Seq(Declare(Int_Type, "c"), Seq(If(Less(ID "a", ID "b"), Seq(If(Less(Pow(ID "a", Int 2), Pow(ID "b", Int 3)), Seq(Print(ID "a"), NoOp), Seq(Print(ID "b"), NoOp)), NoOp), Seq(Assign("c", Int 1), Seq(While(Less(ID "c", ID "a"), Seq(Print(ID "c"), Seq(Assign("c", Add(ID "c", Int 1)), NoOp))), NoOp))), NoOp)))))))
let public_test_test3 = create_system_test ["test3.c"]
  (Seq(Declare(Int_Type, "a"), Seq(Assign("a", Int 10), Seq(Declare(Int_Type, "b"), Seq(Assign("b", Int 2), Seq(Declare(Int_Type, "c"), Seq(Assign("c", Add(ID "a", Mult(ID "b", Pow(Int 3, Int 3)))), Seq(Print(Equal(ID "c", Int 1)), NoOp))))))))
let public_test_test4 = create_system_test ["test4.c"]
  (Seq(Declare(Int_Type, "x"), Seq(Declare(Int_Type, "y"), Seq(Declare(Int_Type, "a"), Seq(While(Equal(ID "x", ID "y"), Seq(Assign("a", Int 100), NoOp)), Seq(If(Equal(ID "a", ID "b"), Seq(Print(Int 20), NoOp), Seq(Print(Int 10), NoOp)), NoOp))))))
let public_test_assoc1 = create_system_test ["test-assoc1.c"]
  (Seq(Declare(Int_Type, "a"), Seq(Assign("a", Add(Int 2, Add(Int 3, Int 4))), Seq(Declare(Int_Type, "b"), Seq(Assign("b", Mult(Int 2, Mult(Int 3, Int 4))), Seq(Declare(Int_Type, "c"), Seq(Assign("c", Pow(Int 2, Pow(Int 3, Int 4))), Seq(Declare(Int_Type, "d"), Seq(If(Greater(Int 5, Greater(Int 6, Int 1)), Seq(Print(Int 10), NoOp), NoOp), Seq(Print(ID "a"), Seq(Print(ID "b"), Seq(Print(ID "c"), NoOp))))))))))))
let public_test_while = create_system_test ["while.c"]
  (Seq(Declare(Int_Type, "a"), Seq(Assign("a", Int 10), Seq(Declare(Int_Type, "b"), Seq(Assign("b", Int 1), Seq(While(Less(ID "b", ID "a"), Seq(Print(ID "b"), Seq(Assign("b", Add(ID "b", Int 2)), NoOp))), NoOp))))))
let public_test_for = create_system_test ["for.c"]
  (Seq(Declare(Int_Type, "a"), Seq(For("a", Int 1, Int 10, Seq(Print(ID "a"), NoOp)), NoOp)))

let suite =
  "public" >::: [
    "public_assign1" >:: public_test_assign1;
    "public_assign_exp" >:: public_test_assign_exp;
    "public_define1" >:: public_test_define_1;
    "public_equal" >:: public_test_equal;
    "public_exp1" >:: public_test_exp_1;
    "public_exp2" >:: public_test_exp_2;
    "public_greater" >:: public_test_greater;
    "public_if" >:: public_test_if;
    "public_ifelse" >:: public_test_ifelse;
    "public_if_else_while" >:: public_test_if_else_while;
    "public_less" >:: public_test_less;
    "public_main" >:: public_test_main;
    "public_nested_if" >:: public_test_nested_if;
    "public_nested_ifelse" >:: public_test_nested_ifelse;
    "public_nested_while" >:: public_test_nested_while;
    "public_print" >:: public_test_print;
    "public_test1" >:: public_test_test1;
    "public_test2" >:: public_test_test2;
    "public_test3" >:: public_test_test3;
    "public_test4" >:: public_test_test4;
    "public_assoc1" >:: public_test_assoc1;
    "public_while" >:: public_test_while;
    "public_for" >:: public_test_for
  ]

let _ = run_test_tt_main suite
