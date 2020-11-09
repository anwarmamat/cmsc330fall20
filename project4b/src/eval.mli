exception TypeError of string
exception DeclareError of string
exception DivByZeroError

val eval_expr : SmallCTypes.environment -> SmallCTypes.expr -> SmallCTypes.value
val eval_stmt : SmallCTypes.environment -> SmallCTypes.stmt -> SmallCTypes.environment
