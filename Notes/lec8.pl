/* GNU prolog */
/*
	lowercase identifier (cs31,cs32) are *atoms*
	- like the data values in MOCaml
		- Leaf

	- prereq is an atom that is used as a *predicate*
		- a uninterpreted function that takes 0 or more terms
		  as arguments and returns a boolean
*/

prereq(cs31,cs32).
prereq(cs32,cs33).
prereq(cs31,cs35L).

/*
$ prereq(cs31,32)
yes

$ prereq(X, cs32)
X = cs31

$ prereq(cs31,X),prereq(X,cs131)  //class has prereq cs31 and it is prereq of cs131

*/

/*
	Rules allow you to derive new facts

$ prereq(X,cs111),prereq(X,cs131) //prereq of both cs11 and cs131

$ prereq(X,Y),prereq(X,Z)  //prereqs of both classes

$ prereq(X, Z),prereq(Z,Y) //prereq of prereq

*/

# define new rule, preq2 is X is prereq of prereq of Y
prereq2(X,Y) :- prereq(X,Z),prereq(Z,Y).
# add one more rule for prereq2
prereq2(X,Y) :- prereq(X,Y)

# X is required before you can take Y
prereqTransitive(X,Y) :- prereq(X,Y). # base case
prereqTransitive(X,Y) :- prereq(X,Z),prereqTransitive(Z,Y). # recursive

/*
So far we have seen two kinds of terms
- atoms (lowercase identifiers)
- variables (uppercase identifiers)

- uninterpreted function
  atom(term1,term2,...,termN)

  like Node(Leaf,1,Leaf) in MOCaml

  node(leaf,1,leaf) in prolog

  [1,2,3] = cons(1,cons(2,cons(3,nil))) = .(1,.(2,.(3,nil)))
*/

/*
let rec append l1 l2 =
	match l1 with
	[] -> l2 
	| h::t -> h::(append t l2)
*/

# append (empty list)
app(L1, L2, L3) :- L1=[],L3=l2.
# non empty list
app(.(H,T),L2,.(H,L)) :- app(T,L2,L).


/*
let rec contains x l=
	match l with
	 [] -> false
	|h::t -> h=x || contains x t
*/

# base case
contains(X,.(H,T)) :- X=H.
# recursive case
contains(X,.(H,T)) :- contains(X,T).

/*
let rec reverse l =
	match l with
	  []->[]
	| h::t -> (reverse t)@[h]
*/

rev([],[]).
rev(.(H,T),L) :- rev(T, L0),app(L0,[H],L).



/*
wolf, goat, cabbage problem:
	trying to get from west bank to the east bank of a river
	with the following constraints
	1. Boat fits one item at a time
	2. You can't leave the wolf and goat alone together
	3. You can't leave the goat and cabbage alone

state: [person, wolf, goat, cabbage]
initial state: [west, west, west, west]
goal: [east, east, east, east]

*/

opposite(west, east).
opposite(east, west).

// moves from state S1 to S2
move([P,W,G,C], person, [Q,W,G,C]) :- opposite(P,Q).
move([P,W,G,C], wolf, [Q,Q,G,C]) :- P=W,opposite(G,C),opposite(P,Q).
move([P,W,G,C], goat, [Q,W,Q,C]) :- P=G,opposite(P,Q).
move([P,W,G,C], cabbage, [Q,W,G,Q]) :- P=C,opposite(W,G),opposite(P,Q).

puzzle(End,End,[]).
puzzle(Start,End,(Move,Moves)) :- move(Start, Move, S), puzzle(S,End,Moves).

/*
$ length(Moves,X),X #< 10,puzzle([west,west,west,west], [east,east,east,east], Moves)
*/
