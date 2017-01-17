Idea of unifcation

////////////////////////////

$ a = a.

yes

$ f(X,b) = f(a,Y).

X=a
Y=b

yes

$ f(X,b) = f(a,X).

no

$ f(X,Y) = f(a,Y).

X=a

yes

/////////////////////////////////////////////////////////////////

term ::= c | X | c(term1,...,termN)

term1 = term2 --> 
	- produces an environment E from variables to terms
	such that E(term1) is syntactically identical to E(term2)

Cases:

(1)
c = c --> {}

(2)
X = t --> {X:t}
t = X --> {X:t}

(3)
c(t1,t2) = c(t3,t4) --> 
	t1 = t3 --> E1
	t2 = t4 --> E2
	[if either returns "no", then return "no"]
	return E1 U E2
(4)
else
	"no"

The U (union) operator is a bit more complicated:

1. It has to merge E1 and E2:
	- whenever E1(X) is t1 and E2(X) is t2,
	then the union should map X to result of
	unifying t1 and t2 - or fail if that fails

2. The result E of the union should be in SOLVED FORM


Given:
prereq2(X,Y) :- prereq(X,Z),prereq(Z,Y).

Query:
$ prereq2(cs32,U)

Unification:
{X:cs32 U:Y}

new goal:
prereq(cs32,Z),prereq(Z,Y)

solve: prereq(cs32, Z) to find all Z {Z:cs32 Z:cs111 Z:cs118 Z:cs131 ...}

for each Z:
solve: prereq(Z,Y) {Y:U}


pitfall: consider the query prereq2(cs32, X)
	rename every variable to distinguish Xs.

////////////////////////////////////////////////////////

$ prereq3(X,Y) :- prereq2(X,Z),prereq(Z,Y).


query: [prereq3(cs32,U)]

1 child: [prereq2(cs32,Z), prereq(Z,U)]

1 child: [prereq(cs32,ZZ), prereq(ZZ,Z), prereq(Z,U)]

17 children: [prereq(cs33,Z), prereq(Z,U)]

17 children:
	line 8 child: [prereq(cs111,U)]

17 children:
	line 13 child: Solution U = cs118

///////////////////////////////////////////////////////////

isANumber(zero).
isANumber(succ(N)) :- isANumber(N).


							[isANumber(N)]
				 +----------------+
				 |                |
			[] N=Zero    [isANumber(N0)] N = succ(N0)
							  +----------+----------+
							  |                     |
						[] N0=zero     [isANumber(N1)] N0=succ(N1)

if the order of declaration is:
isANumber(succ(N)) :- isANumber(N).
isANumber(zero).

query for isANumber(N), there is infinite search. Because the tree is mirrored.


/////////////////////////////////////////////////////////////



