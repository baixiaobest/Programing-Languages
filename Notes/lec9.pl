/* Arithmatic
	not reversible in general

	- solving diophantine equations is undecidable
	  ploy(x1,..,xn) = 0

	- solvable but intractable:
	  - factoring large numbers

	- solvable efficiently
	  - solving linear in equalityies

Upshot: prolog has regular (non-reversible) arithmatic
*/


temp(C,F) :- F is 1.8*C +32.0.

len([],0).
len(.(H,T),L) :- len(T,LL), L is 1+LL.


/*
	N-Queens

	how to represent each queen?

	queen(R,C), R is row (1...8)
	and C is column(1...8)

*/

// attack rules
attacks(queen(R,_), queen(R,_)).
attacks(queen(_,C), queen(_,C)).
attacks(queen(R1,C1),queen(R2,C2)) :- Rdiff is R1-R2, Cdiff is C1-C2, Rdiff=Cdiff.
attacks(queen(R1,C1),queen(R2,C2)) :- Rdiff is R1-R2, Cdiff is C2-C1, Rdiff=Cdiff.

// no attack
noAttack(_,[]).
noAttack(Q, .(Q1,Qrest)) :- noAttack(Q,Qrest),\+(attacks(Q,Q1)).

// bruteforce search
nqueens([]).
nqueens(.(Q,Qs)) :- nqueens(Qs),
					Q = queen(R,C),
					member(R,[1,2,3,4,5,6,7,8]),
					member(C,[1,2,3,4,5,6,7,8]),
					noAttack(Q,Qs).



/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/* Traveling salesman problem */

dist(ucla, ucsd, 124).
dist(ucla, uci, 45).
dist(ucla, ucsb, 97).
dist(ucla, ucb, 338).
dist(ucla, ucd, 392).
dist(ucla, ucsc, 346).
dist(ucsd, uci, 72).
dist(ucsd, ucsb, 203).
dist(ucsd, ucb, 446).
dist(ucsd, ucd, 505).
dist(ucsd, ucsc, 460).
dist(uci, ucsb, 148).
dist(uci, ucb, 382).
dist(uci, ucd, 440).
dist(uci, ucsc, 395).
dist(ucsb, ucb, 323).
dist(ucsb, ucd, 378).
dist(ucsb, ucsc, 260).
dist(ucb, ucd, 64).
dist(ucb, ucsc, 79).
dist(ucd, ucsc, 135).

symmetricDist(C1,C2,L) :- dist(C1,C2,L).
symmetricDist(C1,C2,L) :- dist(C2,C1,L).

sumDistances([C1,C2], Length) :- 
	symmetricDist(C1,C2,Length).

sumDistances([C1|C2|Rest], Length) :-
	symmetricDist(C1,C2,D1),
	sumDistances([C2|Rest],D2),
	Length is D1 + D2.

/* shorthand for list patterns:
	.(H,T) gives you the head and tail of a list
	[H|T] is equivalent

	[H1,H2|T] matches a list of two or more items.
*/

tsp(Campuses, Tour, Length) :- 
	Tour = .(First, Rest),
	length(Tour,L),
	nth(L, Tour, Last),   
	First = Last, // last element of Tour equals First element, tour starts and ends in the same place
	permutation(Rest, Campuses), // The Rest is one of permutation of campuses
	sumDistances(Tour, Length).   // sum the distance of tour

/*
Starting from ucb back to ucb
$ tsp([ucla,ucsd,ucb,ucsb,ucd,ucsc,uci],[ucb|REST],Length)
*/
