prereq(cs1,cs2).
prereq(cs2,ee1).
prereq(ee1,cs1).

prereq2(X,Y) :- prereq(X,Z),prereq(Z,Y).


convert2number([],0).
convert2number([H|T],Num) :- convert2number(T,N),Num is H + 10*N.
to_number(L,N) :- reverse(L,R), convert2number(R,N).

verbalarithmetic(A,OP1,OP2,[H|T]) :-
	fd_all_different(A),
	fd_domain(A,0,9),
	fd_labeling(A),
	H =\= 0,
	to_number(OP1,OP1Num),
	to_number(OP2,OP2Num),
	to_number([H|T],ResultNum),
	ResultNum =:= OP1Num+OP2Num.