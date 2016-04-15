type btree = Leaf | Node of btree * int * btree;;

let rec height t =
	match t with
		Leaf -> 0
	| Node(left, _, right) -> 
	1+max (height left) (height right);;
	(* let hl = height left in
	let hr = height right in
	if(hl) > (hr) then 1+ hl else hr + 1 ;; *)

let rec insert n t = 
	match t with
		Leaf -> Node(Leaf, n, Leaf)
	| Node(left, x, right) -> if n<x then Node((insert n left), x, right) 
							  else Node(left, x, (insert n right));;

(* Vairable scoping *)

(* Top Level Let *) let x = 10;;

(* let expression *) (let x = 5 in x+2)+x;;

(* pattern matching *) match [1;2;3] with h::t -> 100 | [] -> 1;;

(* function parameter *)

(* ----------------------------------------------------------------------- *)

(* static scoping or lexical scoping 
	at compile time, you can determine for each variable usage which variable declaration it refers to*)

let x = 45;;
let f = function y -> x+y;;
let x = 10;;
f 3;;  (* answer is 48 *)

(* an environment is a representation of the scope:
	- a map from variables to values *)
(* {} *)
	let x = 45;;
(* {x:45} *)
	let f = function y -> x+y;;
(* {x:45, f:(function y -> x+y)} *)
	f 3;;
(* - look up f in the environment function y -> x+y
   - substitute actual ars for fomal parameters
   - execute x+y *)

let add = fun x -> fun y -> x+y;;
(* add:(fun x y->x+y,{}) *)
let addTwo = add 2;;
(* 1. lookup add in the environment
   2. execute it in add's static environment {} bind x to 2:{x:2}. execute function body 
(function y -> x+y, {x:2}) *)
let x =10;;
addTwo 0;; (* returns 2 *)




