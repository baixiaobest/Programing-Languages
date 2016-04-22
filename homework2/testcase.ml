vplus [1.1;2.2;3.3] [4.4;5.5;6.6];;
assert(vplus [1.] [1.]=[2.]);;
assert(vplus [] []=[]);;

assert(mplus [[1.;2.];[3.;4.]] [[1.;2.];[3.;4.]]=[[2.;4.];[6.;8.;]]);;
assert(mplus [] []=[]);;
assert(mplus [[1.]] [[2.]]=[[3.]]);;

assert(dotprod [1.;2.;3.;4.;100.] [5.;6.;7.;8.;0.]=70.);;
assert(dotprod [3.] [7.]=21.);;
assert(dotprod [] []=0.);;

assert(transpose [[1.;2.;3.];[4.;5.;6.]]=[[1.;4.];[2.;5.];[3.;6.]]);;
assert(transpose [[1.;2.];[3.;4.]]=[[1.;3.];[2.;4.]]);;
assert(transpose [[1.];[2.]]=[[1.;2.]]);;
assert(transpose [[1.]]=[[1.]]);;
assert(transpose [[];[]]=[]);;

mmult [[]] [[]];;
mmult [[2.]] [[3.]];;
mmult [[1.;2.]] [[3.];[4.]];;
mmult [[1.;2.;3.]] [[4.];[5.];[6.]];;
mmult [[1.;2.;3.];[3.;3.;3.;]] [[4.];[5.];[6.]];;
mmult [[1.;2.;3.];[3.;3.;3.;]] [[4.;10.];[5.;11.];[6.;12.]];;
mmult [[1.;2.;3.];[3.;3.;3.;];[3.;4.;5.]] [[4.;10.];[5.;11.];[6.;12.]];;
mmult [[1.;2.;3.];[3.;3.;3.;];[3.;4.;5.]] [[4.;10.;7.];[5.;11.;8.];[6.;12.;9.]];;

assert(evalExp (BinOp(BinOp(Num 1.0, Plus, Num 2.0), Times, Num 3.0))=9.) ;;
(* 3*((1+5)-3)/(1+1) *)
assert(evalExp (BinOp(BinOp(BinOp(BinOp(Num 1.,Plus,Num 5.),Minus,Num 3.),Times,Num 3.),Divide,BinOp(Num 1.,Plus,Num 1.)))=4.5);;
(* (6/2-1) + 3*4 *)
assert(evalExp (BinOp(BinOp(BinOp(Num 6.,Divide,Num 2.),Minus,Num 1.),Plus,BinOp(Num 3.,Times,Num 4.)))=14.);;

(* 3*(1+2) *)
assert(execute([Push 1.0; Push 2.0; Calculate Plus; Push 3.0; Calculate Times])=9.);;
(* 3*((1+5)-3)/2 *)
assert(execute ([Push 3.; Push 1.; Push 5.; Calculate Plus; Push 3.; Calculate Minus; Calculate Times; Push 2.; Calculate Divide])=4.5);;
(* 3*((1+5)-3)/(1+1) *)
assert(execute([Push 1.; Push 5.; Calculate Plus; Push 3.; Calculate Minus; Push 3.; Calculate Times; Push 1.; Push 1.; Calculate Plus; Calculate Divide])=4.5);;
(* 6/2-1+3*4 *)
assert(execute ([Push 6.; Push 2.; Calculate Divide; Push 1.; Calculate Minus; Push 3.; Push 4.; Calculate Times; Calculate Plus])=14.);;
assert(execute([Push 3.])=3.);;
assert(execute ([Push 1.; Push 2.; Swap; Calculate Divide])=2.);;

assert(execute(compile (BinOp(BinOp(Num 1.0, Plus, Num 2.0), Times, Num 3.0))) = 9.);;
(* 3*((1+5)-3)/(1+1) *)
assert(execute(compile (BinOp(BinOp(BinOp(BinOp(Num 1.,Plus,Num 5.),Minus,Num 3.),Times,Num 3.),Divide,BinOp(Num 1.,Plus,Num 1.))))=4.5);;
(* 6/2-1+3*4 *)
assert(execute(compile (BinOp(BinOp(BinOp(Num 6.,Divide,Num 2.),Minus,Num 1.),Plus,BinOp(Num 3.,Times,Num 4.))))=14.);;

(* 3*(1+2) *)
assert(evalExp (decompile ([Push 1.0; Push 2.0; Calculate Plus; Push 3.0; Calculate Times]))=9.);;
(* 3*((1+5)-3)/(1+1) *)
assert(evalExp (decompile ([Push 1.; Push 5.; Calculate Plus; Push 3.; Calculate Minus; Push 3.; Calculate Times; Push 1.; Push 1.; Calculate Plus; Calculate Divide]))=4.5) ;;
(* 6/2-1+3*4 *)
assert(evalExp (decompile ([Push 6.; Push 2.; Calculate Divide; Push 1.; Calculate Minus; Push 3.; Push 4.; Calculate Times; Calculate Plus]))=14.);;

"Compile Optimization";;

(* 1-(2+3) *)
assert( compileOpt (BinOp(Num 1., Minus, BinOp(Num 2., Plus, Num 3.))) = ([Push 2.;Push 3.;Calculate Plus;Push 1.;Swap;Calculate Minus],2) );;
(* (1-((5+3)/4)) *)
assert( compileOpt (BinOp(Num 1.,Minus,BinOp(BinOp(Num 5., Plus, Num 3.),Divide,Num 4.))) = ([Push 5.;Push 3.;Calculate Plus;Push 4.;Calculate Divide;Push 1.;Swap;Calculate Minus],2) );;
(* (1+((5+3)/4)) *)
assert( compileOpt (BinOp(Num 1.,Plus,BinOp(BinOp(Num 5., Plus, Num 3.),Divide,Num 4.))) = ([Push 5.;Push 3.;Calculate Plus;Push 4.;Calculate Divide;Push 1.;Calculate Plus],2) );;
(* 10-(4-(7-6)) *)
assert( compileOpt (BinOp(Num 10.,Minus,BinOp(Num 4.,Minus,BinOp(Num 7.,Minus,Num 6.)))) = ([Push 7.;Push 6.;Calculate Minus;Push 4.;Swap;Calculate Minus;Push 10.;Swap;Calculate Minus],2) );;
(* (10-(10-9))-(4-(7-6)) *)
assert( compileOpt (BinOp(BinOp(Num 10.,Minus,BinOp(Num 10.,Minus,Num 9.)),Minus,BinOp(Num 4.,Minus,BinOp(Num 7.,Minus,Num 6.)))) = ([Push 10.;Push 9.;Calculate Minus;Push 10.;Swap;Calculate Minus;Push 7.;Push 6.;Calculate Minus;Push 4.;Swap;Calculate Minus;Calculate Minus],3) );;
(* (2+3)*(2-3) *)
assert( compileOpt (BinOp(BinOp(Num 2.,Plus,Num 3.),Times,BinOp(Num 2.,Minus, Num 3.))) = ([Push 2.;Push 3.;Calculate Plus;Push 2.;Push 3.;Calculate Minus;Calculate Times], 3) );;
(* (2+3)*(2-3)-1 *)
assert( compileOpt (BinOp((BinOp(BinOp(Num 2.,Plus,Num 3.),Times,BinOp(Num 2.,Minus, Num 3.))),Minus,Num 1.)) = ([Push 2.;Push 3.;Calculate Plus;Push 2.;Push 3.;Calculate Minus;Calculate Times;Push 1.;Calculate Minus],3) );;
(* 1-(2+3)*(2-3) *)
assert( compileOpt (BinOp(Num 1.,Minus,(BinOp(BinOp(Num 2.,Plus,Num 3.),Times,BinOp(Num 2.,Minus, Num 3.))))) = ([Push 2.;Push 3.;Calculate Plus;Push 2.;Push 3.;Calculate Minus;Calculate Times;Push 1.;Swap;Calculate Minus],3) );;
(* ((2+3)+(4+5))*((7-6)-(9-8)) *)
assert( compileOpt (BinOp(BinOp(BinOp(Num 2.,Plus,Num 3.),Plus,BinOp(Num 4.,Plus,Num 5.)),Times,BinOp(BinOp(Num 7.,Minus,Num 6.),Minus,BinOp(Num 9.,Minus,Num 8.)))) = ([Push 2.;Push 3.;Calculate Plus;Push 4.;Push 5.;Calculate Plus;Calculate Plus;Push 7.;Push 6.;Calculate Minus;Push 9.;Push 8.;Calculate Minus;Calculate Minus;Calculate Times],4) );;
