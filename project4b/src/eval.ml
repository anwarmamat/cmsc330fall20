open SmallCTypes
open EvalUtils
open TokenTypes


exception TypeError of string
exception DeclareError of string
exception DivByZeroError

let rec eval_expr env t =
  failwith "unimplemented"

let rec eval_stmt env s =
  failwith "unimplimented"
