let rec joindicts a b =
	let rec helper e l =
		match l with
		[] -> None
		| (x,y)::t -> if x = e then Some y else helper e t 
		in
	match a with
	[] -> []
	| (x,y)::ta -> let res = helper y b in
	(match res with
	None -> joindicts ta b
	| Some i -> (x,i)::joindicts ta b)

let rec joindictsList a b =
	List.fold_right (fun (x,y) acc -> List.fold_right (fun (i,j) acc -> if y=i then (x,j)::acc else acc) b acc ) a[]

type tree = Leaf | Node of int * (tree list)

let rec incTree i tree =
	match tree with
	Leaf -> Leaf
	| Node(a,l) -> Node(a+i, List.map (function e -> incTree i e) l)

type lazylist = Nil | Cons of int * (unit -> lazylist)

let rec intsFrom n =
	Cons(n, (function () -> intsFrom (n+1) ))

let head l = 
	match l with
	Cons(a,f) -> a

let tail l = 
	match l with
	Cons (a,f) -> f()

let rec lazymap f l = 
	match l with
	Nil -> Nil
	| Cons(i, func) -> Cons((f i), (fun () -> lazymap f (func()) ))
