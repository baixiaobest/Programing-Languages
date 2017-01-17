type nat = Z | S of nat

let rec plus a b =
	match a with
	  Z -> b
	| S (x) -> S (plus x b);;

let rec leq a b =
	match (a,b) with
	 (Z,Z) -> true
	|(Z,S(x)) -> false
	|(S(x),Z) -> false
	|(S(x),S(y)) -> leq x y;;