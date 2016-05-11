(* Exception *)

(* Lookup a key's value in list of key-value map *)

let rec lookup k l =
	match l with
	  [] -> None
	| (k',v')::rest -> if k=k' then Some v' else lookup k rest;;

(* This style of error signaling doesn't compose well *)

let lookupAndDouble k l =
	match (lookup k l) with
	  None -> None
	| Some v -> Some (v*2);;

(* Error handling is messing with lookup logic *)
let rec lookupAll ks l =
	match ks with
	  []-> Some []
	| k::rest -> match (lookupAll rest l) with
					None -> None
				| Some resList -> 
					match (lookup k l) with
					  None -> None
					| Some v -> Some (v::resList);;


(* Use exception *)
exception Not_found

let rec lookupE k l =
	match l with
	  [] -> raise Not_found
	| (k',v')::rest -> if k=k' then v' else lookupE k rest;;

let lookupAndDouble k l=
	(lookupE k l)*2;;

let lookupAllE ks l =
	List.map(fun k -> lookupE k l) ks;;

(* This catch the exception and return empty list *)
let safeLookupAllE ks l =
	try
		lookupAllE ks l
	with
		Not_found -> []

(* Parametric Polymorphism *)
let rec length l =
	match l with
		[] -> 0
	| _::t -> 1+length t;;

(* type: 'a list -> int
		 'a is a *type valirable*
		 can think of it as an extra parameter to the funciton
		 length <int> [1;2;3]
		 length <string> ["hi";"bye"] 

	The type instantiation (passing the implicit type parameter) happens
	at compile time

	1 piece of code can be safely passed arguments of many different types

	overloading need many pieces of code
*)

let swap (x,y) = (y,x);;

(* don't confuse parametric polymorphism with static overloading
   static overloading: Many different pieces of code, all with the same name.
*)


(* Module *)

(* need a way to separate "interface" from "implementation":
	Implementation: a list
	Interface: a set

	ensure that sets can't have duplicates
*)



module type SET = module
	type t
	val emptyset : t
	val member : int -> t -> bool
	val add : int -> t -> t
	val union : t -> t -> t
end


module Set : SET = struct
	type t = int list

	let emptyset = []

	let rec member =
		fun x s -> ...
	

end;;


