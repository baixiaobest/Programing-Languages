scalarMult(3,[2,7,4], Result).

scalarMult(Scalar,[],[]).
scalarMult(Scalar,[H|T],[HResult|TResutl]) :- HResult is Scalar*H, scalarMult(Scalar, T, TResutl).


dot(List1,List2,Result).

dot([V1|],[V2|],Result) :- Result is V1*V2.
dot([V1|T1],[V2,T2],Result) :- dot(T1,T2,TResult),mulResult is V1*V2,Result is mulResult+TResult.


append_([a,b,c],[1,2,3],[a,b,c,1,2,3]).

append_([],List2,List2).
append_(List1,[],List1).
append_([H|T], List2, [H | List3]) :- append_(T,List2,List3).


prefix_(X,[a,b,c,d]).
X = [], [a], [a,b], [a,b,c]

prefix_([],[_]).
prefix_(P,L) :- append_(P,_,L).

subfix_(P,L) :- append_(_,P,L).

sublist_(SubL, L) :- prefix_(SubL,Temp),suffix_(Temp,L).


member(E,[E|T]).
member(E,[H|T]) :- member(E,T).


// index([7,8,9],8,1). yes
// index(List, Element, R).

index([H|T],H,0).
index([H|T],E,idx) :- index(T,E,newIdx),newIdx is idx-1, newIdx >= 0.
