scratch paper
max([X],X).
max(.(H,T),H) :- H>=X,max(T,X).
max(.(H,T),X) :- H<X,max(T,X).

factorial(0,1).
factorial(N,F) :- 
	N>0,
	N1 is N-1,
	factorial(N1,F1),
	F is N*F1.

size([],0).
size([X],1).
size(.(H,T),len) :- size(T,tailsize), len is tailsize+1.
