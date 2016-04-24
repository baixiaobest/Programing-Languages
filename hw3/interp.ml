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
    | (BoolPat(i), BoolVal(j)) when i=j -> Env.empty_env()
    | (WildcardPat,_) -> Env.empty_env()
    | (VarPat(name), x) -> let emptyEnv = Env.empty_env() in Env.add_binding name x emptyEnv
    | (TuplePat(a),TupleVal(b)) -> if (List.length a) = (List.length b) 
                                   then 
                                      (match (a,b) with 
                                      (ha::ta,hb::tb) -> Env.combine_envs (patMatch ha hb) (patMatch (TuplePat ta) (TupleVal tb) )
                                      )
                                   else raise MatchFailure;
    | _ -> raise MatchFailure

(* ************************Illegal Helper********************************* *)

(* let rec structure (e:moexpr) : string list =
  match e with
    IntConst(i) -> [string_of_int i]
  | Var(name) -> [name]
  | BinOp(a,op,b) -> let left = structure a in
                     let right = structure b in
                     ["op"]@left@["|"]@right@["end"]
  | Function(arg,exp) ->(match arg with IntPat(i) -> ["func";(string_of_int i)]@(structure exp)
                                      | VarPat(name) -> ["func";name]@(structure exp)
                                      | x -> raise (ImplementMe "other patter matching") 
                        )
  | If(con, e1, e2) -> let conli = structure con in
                       let e1li = structure e1 in
                       let e2li = structure e2 in
                       ["If"]@conli@["then"]@e1li@["else"]@e2li@["fi"]
  | FunctionCall(e1, e2) -> let name = structure e1 in
                            let arg = structure e2 in
                            ["("]@name@arg@[")"]

let rec print_list = function 
[] -> ()
| e::l -> print_string e ; print_string " " ; print_list l *)

(* ************************************************************************** *)

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
    | Var(name) -> (try 
                      Env.lookup name env 
                    with 
                      Env.NotBound -> raise (DynamicTypeError "Variable is not declared")
                   )
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
    | Function(arg,exp) -> FunctionVal(None, arg, exp, env)
    | FunctionCall(e1,e2) -> let value = evalExpr e2 env in
                             let funcVal = evalExpr e1 env in
                            (match funcVal with
                              FunctionVal(Some name, arg, exp, env) -> let env2 = patMatch arg value in             (* match the argument *)
                                                                  let env3 = Env.combine_envs env2 env in           (* combine with old environment *)
                                                                  let newEnv = Env.add_binding name funcVal env3 in (* Bind function to environment if function is recursive *)
                                                                  evalExpr exp newEnv                               (* Evaluate the function *)
                                                                  
                            | x -> raise (DynamicTypeError "No such function")
                            )
    | Match(exp, matchList) -> let value = evalExpr exp env in
                                (match matchList with 
                                  (pattern, exe)::tail ->(try 
                                                            let newEnv = patMatch pattern value in
                                                            evalExpr exe newEnv
                                                          with MatchFailure -> evalExpr (Match(exp, tail)) env
                                                         )
                                | [] -> raise MatchFailure
                                )
    | Tuple (tl) -> TupleVal( List.map (fun exp -> evalExpr exp env) tl )
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
    | LetRec(name,exp) -> ( match (evalExpr exp env) with FunctionVal(n, arg, ex, en) -> (Some name,FunctionVal(Some name,arg,ex,en)) )
    

