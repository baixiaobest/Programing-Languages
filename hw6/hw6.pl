duplist([],[]).
duplist([H|T],[H|[H|TT]]) :- duplist(T,TT).


subseq([],[]).
subseq([H|SubT],[H|T]) :- subseq(SubT,T).
subseq(L,[_|T]) :- subseq(L,T).


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


execute(world([I|ST],S2,S3,none), pickup(I, stack1), world(ST,S2,S3,I)).
execute(world(S1,[I|ST],S3,none), pickup(I, stack2), world(S1,ST,S3,I)).
execute(world(S1,S2,[I|ST],none), pickup(I, stack3), world(S1,S2,ST,I)).

execute(world(S1,S2,S3,I), putdown(I,stack1), world([I|S1],S2,S3,none)).
execute(world(S1,S2,S3,I), putdown(I,stack2), world(S1,[I|S2],S3,none)).
execute(world(S1,S2,S3,I), putdown(I,stack3), world(S1,S2,[I|S3],none)).

blocksworld(W,[],W).
blocksworld(InitialWorld, [H|T], FinalWorld) :- 
	execute(InitialWorld, H, TempWorld),
	blocksworld(TempWorld, T, FinalWorld).