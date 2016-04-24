
(* A simple test harness for the MOCaml interpreter. *)

(* put your tests here:
   each test is a pair of a MOCaml declaration and the expected
   result:
     - the MOCaml declaration is a string of exactly what you would type into the interpreter prompt,
       without the trailing ";;"
     - the expected result is a string of exactly what you expect the interpreter to print as a result
   use the string "dynamic type error" as the result if a DynamicTypeError is expected to be raised.
   use the string "match failure" as the result if a MatchFailure is expected to be raised.
   use the string "implement me" as the result if an ImplementMe exception is expected to be raised

   call the function runtests() to run these tests
*)
let tests = [
    (* YOU NEED TO ADD A LOT MORE TESTS! *)
		("3", "3"); 
		("false", "false");
		("let x = 34", "val x = 34");
		("y", "dynamic type error");
		("x + 4", "38");
    ("(-(1-3))*3+1=7","true");
    ("let y = 10","val y = 10");
    ("let rec f x = (x+y)*2","val f = <fun>");
    ("f 5","30");
    ("let rec f x = if x>1 then x*(f (x-1)) else 1","val f = <fun>");
    ("f 10","3628800");
    ("(1,2,3)","(1, 2, 3)");
    ("let rec f (a,b,c) = a+b+c","val f = <fun>");
    ("f (1,2,3)","6");
    ("let rec f i = match i with 1 -> 2 | true -> false | (a,b,c) -> a+b+c | _ -> true","val f = <fun>");
    ("f 1","2");
    ("f true","false");
    ("f (1,2,3)","6");
    ("f 100","true");
    ("let rec double i = i*2", "val double = <fun>");
    ("let rec quadruple i = double(double(i))", "val quadruple = <fun>");
    ("let rec twice f = f(f(10))","val twice = <fun>");
    ("twice double", "40");
    ("quadruple 10", "40");
    ("let x = Node","val x = Node");
    ("let y = Leaf (1,2)","val y = Leaf (1, 2)");
    ("let z =  Node(Node(Leaf 1,Node(Node(Leaf 2,Leaf 4),Leaf 5)),Leaf 6)","val z = Node (Node (Leaf 1, Node (Node (Leaf 2, Leaf 4), Leaf 5)), Leaf 6)");
    ("let rec f x = match x with Node -> 1 | Leaf(a,b) -> a+b | x -> false", "val func = <fun>");
    ("f x","1");
    ("f y","2");
    ("f z","false");
    ("let rec sum t = match t with Leaf x -> x | Node(a,b) -> (sum a)+(sum b)", "val sum = <fun>");
    ("sum z","18")
		]

(* The Test Harness
   You don't need to understand the code below.
*)
  
let testOne test env =
  let decl = main token (Lexing.from_string (test^";;")) in
  let res = evalDecl decl env in
  let str = print_result res in
  match res with
      (None,v) -> (str,env)
    | (Some x,v) -> (str, Env.add_binding x v env)
      
let test tests =
  let (results, finalEnv) =
    List.fold_left
      (fun (resultStrings, env) (test,expected) ->
	let (res,newenv) =
	  try testOne test env with
	      Parsing.Parse_error -> ("parse error",env)
	    | DynamicTypeError _ -> ("dynamic type error",env)
	    | MatchFailure -> ("match failure",env)
	    | ImplementMe s -> ("implement me",env) in
	(resultStrings@[res], newenv)
      )
      ([], Env.empty_env()) tests
  in
  List.iter2
    (fun (t,er) r ->
      let out = if er=r then "ok" else "expected " ^ er ^ " but got " ^ r in
      print_endline
	(t ^ "....................." ^ out))
      tests results

(* CALL THIS FUNCTION TO RUN THE TESTS *)
let runtests() = test tests
  
