(* Name: Baixiao Huang

   UID: 504313981

   Others With Whom I Discussed Things: Null

   Other Resources I Consulted: Null
   
*)

(* EXCEPTIONS *)

(* This is a marker for places in the code that you have to fill in.
   Your completed assignment should never raise this exception. *)
exception ImplementMe of string

(* This exception is thrown when a type error occurs during evaluation
   (e.g., attempting to invoke something that's not a function).
   You should provide a useful error message.
*)
exception DynamicTypeError of string

(* This exception is thrown when pattern matching fails during evaluation. *)  
exception MatchFailure  

(* EVALUATION *)

(* See if a value matches a given pattern.  If there is a match, return
   an environment for any name bindings in the pattern.  If there is not
   a match, raise the MatchFailure exception.
*)
let rec patMatch (pat:mopat) (value:movalue) : moenv =
  match (pat, value) with
      (* an integer pattern matches an integer only when they are the same constant;
	 no variables are declared in the pattern so the returned environment is empty *)
      (IntPat(i), IntVal(j)) when i=j -> Env.empty_env()
    | _ -> raise (ImplementMe "pattern matching not implemented")

    
(* Evaluate an expression in the given environment and return the
   associated value.  Raise a MatchFailure if pattern matching fails.
   Raise a DynamicTypeError if any other kind of error occurs (e.g.,
   trying to add a boolean to an integer) which prevents evaluation
   from continuing.
*)
let rec evalExpr (e:moexpr) (env:moenv) : movalue =
  match e with
      (* an integer constant evaluates to itself *)
      IntConst(i) -> IntVal(i)
    | BoolConst(b) -> BoolVal(b)
    | Var(name) -> Env.lookup name env
    | BinOp(a,op,b) -> (match ((evalExpr a env),(evalExpr b env)) with
                        (IntVal(inta), IntVal(intb)) -> (match op with
                                                          Plus -> IntVal(inta+intb)
                                                        | Minus -> IntVal(inta-intb)
                                                        | Times -> IntVal(inta*intb)
                                                        | Eq -> BoolVal(inta=intb)
                                                        | Gt -> BoolVal(inta>intb) 
                                                        )
                        | (x,y) -> raise (DynamicTypeError "Operand must be Integer =_=||")
                       )
    | Negate(exp) -> (match (evalExpr exp env) with
                        IntVal(myInt) -> IntVal(-myInt)
                      | randomShit -> raise (DynamicTypeError "Operand must be Integer `(^o^)") 
                     )
    | If(con,e1,e2) ->(match (evalExpr con env) with
                          BoolVal(bcon) -> if bcon then (evalExpr e1 env) else (evalExpr e2 env)
                        | x -> raise (DynamicTypeError "Condition needs to be evaluated to boolean type x.x !!")
                      )
    
    | _ -> raise (ImplementMe "expression evaluation not implemented")


(* Evaluate a declaration in the given environment.  Evaluation
   returns the name of the variable declared (if any) by the
   declaration along with the value of the declaration's expression.
*)
let rec evalDecl (d:modecl) (env:moenv) : moresult =
  match d with
      (* a top-level expression has no name and is evaluated to a value *)
      Expr(e) -> (None, evalExpr e env)
    | Let(name,exp) -> (Some name, evalExpr exp env)
    | _ -> raise (ImplementMe "let and let rec not implemented")

