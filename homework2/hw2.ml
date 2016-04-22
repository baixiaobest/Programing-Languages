
(* Reference
http://caml.inria.fr/pub/docs/manual-ocaml/libref/List.html
https://en.wikipedia.org/wiki/Shunting-yard_algorithm
https://en.wikipedia.org/wiki/Binary_expression_tree
 *)

(* Problem 1: Vectors and Matrices *)

(* type aliases for vectors and matrices *)            
type vector = float list                                 
type matrix = vector list

let (vplus : vector -> vector -> vector) =
  fun a b -> List.map2 (fun x y -> x+.y) a b;;

let (mplus : matrix -> matrix -> matrix) =
  fun m1 m2 -> List.map2 (fun v1 v2 -> vplus v1 v2) m1 m2;;

let (dotprod : vector -> vector -> float) =
  fun a b -> List.fold_left (fun acc x -> acc +. x) 0. (List.map2 (fun y z -> y*.z) a b);;

(* Build new transposed matrix by reading original one row by row. Match the row to the column *)
let (transpose : matrix -> matrix) =
  fun m -> List.fold_left (fun newM row -> 
                            match newM with 
                               [] -> newM@List.map (fun x -> [x]) row 
                              | z -> List.map2 (fun newMele rowEle -> newMele@[rowEle]) z row
                          ) [] m;;

(* matrix multiplication of m1 and m2 is dot product of every row in m1 with every row in transpose of m2 *)
let (mmult : matrix -> matrix -> matrix) =
  fun m1 m2 -> let m2' = transpose m2 in 
    List.fold_left (fun acc m1Row -> acc@[(List.fold_left (fun acc2 m2'Row -> acc2@[(dotprod m1Row m2'Row)] ) [] m2')] ) [] m1

        
(* Problem 2: Calculators *)           
           
(* a type for arithmetic expressions *)
type op = Plus | Minus | Times | Divide
type exp = Num of float | BinOp of exp * op * exp

let rec (evalExp : exp -> float) =
  fun tree -> match tree with
    Num x -> x
  | BinOp (left, oper, right) -> 
      let leftVal = evalExp left in
      let rightVal = evalExp right in
        match oper with
          Plus -> leftVal +. rightVal
        | Minus -> leftVal -. rightVal
        | Times -> leftVal *. rightVal
        | Divide ->  leftVal /. rightVal ;;

(* a type for stack instructions *)	  
type instr = Push of float | Swap | Calculate of op

let (execute : instr list -> float) =
  fun insl -> let r = List.fold_left( fun acc inst -> match inst with
                              Push x -> x::acc
                            | Swap   -> (match acc with h1::h2::t-> h2::h1::t | a->a)
                            | Calculate oper -> (match acc with v1::v2::t ->
                                                 (match oper with
                                                 Plus   -> (v2+.v1)::t
                                                | Minus  -> (v2-.v1)::t
                                                | Times  -> (v2*.v1)::t
                                                | Divide -> (v2/.v1)::t) | a->a)
                        ) [] insl in
                  match r with [] -> 0. | a::t -> a;;
      
let
  (compile : exp -> instr list) =
  fun t -> let rec construct tree acc = 
    (match tree with
      Num x -> acc@[Push x]
    | BinOp (left, oper, right) -> (construct right (construct left acc))@[Calculate oper]
    )in
  construct t [];;

let (decompile : instr list -> exp) =
  fun ins -> let r = List.fold_left ( fun acc inst -> match inst with 
                                  Push x -> (Num x)::acc
                                | Swap   -> (match acc with h1::h2::t -> h2::h1::t | a->a)
                                | Calculate oper -> (match acc with v1::v2::t ->
                                                      BinOp(v2, oper,v1)::t
                                                                    | a->a
                                                    )
                              ) [] ins in
              match r with [] -> Num 0. | a::_ -> a;;

(* EXTRA CREDIT *)        
let rec (compileOpt : exp -> (instr list * int)) =
  fun tree -> match tree with
                Num n -> ([Push n],1)
              | BinOp (left, op, right) -> let (leftOpt, leftS) = compileOpt left in
                                           let (rightOpt, rightS) = compileOpt right in
                                           if(rightS > leftS) then
                                            match op with
                                              Minus -> (rightOpt@leftOpt@[Swap; Calculate Minus], rightS)
                                            | Divide -> (rightOpt@leftOpt@[Swap; Calculate Divide], rightS)
                                            | otherOp -> (rightOpt@leftOpt@[Calculate otherOp], rightS)
                                           else if (rightS=leftS) then
                                              (leftOpt@rightOpt@[Calculate op], rightS+1) 
                                           else
                                              (leftOpt@rightOpt@[Calculate op], leftS);; 
                      
