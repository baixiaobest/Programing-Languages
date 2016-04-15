(*reference:
https://ocaml.org/learn/tutorials/basics.html
https://realworldocaml.org/v1/en/html/variables-and-functions.html
*)
(* Problem 1 *)
            
let rec (member : 'a -> 'a list -> bool) =
   fun x l -> match l with
    [] -> false
| h::t -> if h=x then true else member x t ;;

let rec (add : 'a -> 'a list -> 'a list) =
  fun x l -> match l with 
      [] -> [x]
  | h::t -> if x=h then h::t else h::(add x t) ;;

let rec (union : 'a list -> 'a list -> 'a list) =
  fun a b -> match a with
      [] -> b
  | h::t -> add h (union t b) ;;

let rec (fastUnion : 'a list -> 'a list -> 'a list) =
  fun a b -> match (a,b) with 
	  (al, []) -> al
	| ([], bl) -> bl
	| (ah::at, bh::bt) -> if bh < ah then bh::(fastUnion a bt)
						 else if bh = ah then bh::(fastUnion at bt)
						 else ah::(fastUnion at b);;
                
let (intersection : 'a list -> 'a list -> 'a list) =
  fun a b -> List.filter(fun x -> member x b) a ;;
                
let rec (setify : 'a list -> 'a list) =
  fun l -> match l with
	    [] -> []
    | h::t -> add h (setify t);;
         
let rec (powerset : 'a list -> 'a list list) =
	fun s -> match s with
		[] -> [[]]
	| h::t -> let pt = powerset t in 
		pt@(List.map(fun l -> h::l) pt);;

        
(* Problem 2 *)        
        
let rec (partition : ('a -> bool) -> 'a list -> 'a list * 'a list) =
  fun f l -> match l with
	[] -> ([],[])
  | h::t -> match (partition f t) with
			(p1, p2) -> if f h then (h::p1, p2)
						else (p1,h::p2);;

let rec (whle : ('a -> bool) -> ('a -> 'a) -> 'a -> 'a) =
  fun p f x -> if p x then whle p f (f x) else x;;
                                    
let rec (pow : int -> ('a -> 'a) -> ('a -> 'a)) =
  fun (x: int) (f: 'a -> 'a) (v:'a) -> match x with
	0 -> v
  | b -> f (pow (x-1) f v);;