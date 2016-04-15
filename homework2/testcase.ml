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
assert(evalExp (BinOp(BinOp(BinOp(BinOp(Num 1.,Plus,Num 5.),Minus,Num 3.),Times,Num 3.),Divide,BinOp(Num 1.,Plus,Num 1.)))=4.5);;
assert(evalExp (BinOp(BinOp(BinOp(Num 6.,Divide,Num 2.),Minus,Num 1.),Plus,BinOp(Num 3.,Times,Num 4.)))=14.);;

assert(execute([Push 1.0; Push 2.0; Calculate Plus; Push 3.0; Calculate Times])=9.);;
assert(execute ([Push 3.; Push 1.; Push 5.; Calculate Plus; Push 3.; Calculate Minus; Calculate Times; Push 2.; Calculate Divide])=4.5);;
assert(execute([Push 1.; Push 5.; Calculate Plus; Push 3.; Calculate Minus; Push 3.; Calculate Times; Push 1.; Push 1.; Calculate Plus; Calculate Divide])=4.5);;
assert(execute ([Push 6.; Push 2.; Calculate Divide; Push 1.; Calculate Minus; Push 3.; Push 4.; Calculate Times; Calculate Plus])=14.);;
assert(execute([Push 3.])=3.);;

assert(execute(compile (BinOp(BinOp(Num 1.0, Plus, Num 2.0), Times, Num 3.0))) = 9.);;
assert(execute(compile (BinOp(BinOp(BinOp(BinOp(Num 1.,Plus,Num 5.),Minus,Num 3.),Times,Num 3.),Divide,BinOp(Num 1.,Plus,Num 1.))))=4.5);;
assert(execute(compile (BinOp(BinOp(BinOp(Num 6.,Divide,Num 2.),Minus,Num 1.),Plus,BinOp(Num 3.,Times,Num 4.))))=14.)


