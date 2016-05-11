type sign = Positive | Negative | Zero

let sign)f n = 
match n with 
	0 -> Zero
  | _ -> when n>0 then Positive else Negative

  type point = 
  	Cartesian of (float*float)
  	| Polar of (float*float);;

  let negate p =
  	match p with
  		Cartesian(x,y) -> Cartesian(-.x,-.y)
  	|   Polar(r,theta) -> Polar(r, theta+.180.);;

(* recursive type *)
type intList = Nil | Cons of (int * intList);;

let myList = Cons(1,Cons(2, Cons(3, Nil)));;

let rec length l =
	match l with
		Nil -> 0
	| Cons(x,y) -> (length y) + 1

type binaryTree = Leaf | Node of int*binaryTree*BinaryTree;;

let rec preorder tree = 
	match tree with 
		Leaf -> []
	| Node(x,l,r) -> [x]@(preorder l)@(preorder r);;

let rec inorder tree = 
	match tree with 
		Leaf -> []
	| Node(x,l,r) -> (preorder l)@[x]@(preorder r);;

List.fold_left (fun acc x-> acc^x) "" ["hello";"world";"!"];;

List.fold_right (fun x acc-> x^acc) ["hello";"world";"!"] "";;

let rec range from til step =
	if from > til then []
	else from::(range (from+step) til step);;

let mapi f l=
	let rec aux idx list=
		match list with
		[] -> []
		| h::t -> (f idx h)::(aux (idx+1) t) in
		aux 0 l;;

let mapi f l=
	let f2 = fun (x,y) -> f x y in
	List.map f2 (zip (range 0 (List.length l) 1) l);;

let isPrime n =
	let rec isPrimeHelper (n,i) =
		match n with
		  1 -> false
		| 2 -> true
		| _ when i=n -> true
		| _ when (n mod i = 0) -> false 
		| _ -> isPrimeHelper(n,i+1) in
	isPrimeHelper(n,2);;

let primesGet n =
	List.filter (fun x -> isPrime x) (range  1 n 1);;




