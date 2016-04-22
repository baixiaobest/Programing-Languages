print_string "vplus";;
vplus [] [];;
vplus [1.1;2.2] [2.2;3.3];;

print_string "mplus";;
mplus [] [];;
mplus [[]] [[]];;
mplus [[];[]] [[];[]];;
mplus [[1.;2.;3.];[4.;5.;6.];[7.;8.;9.]] [[1.;2.;3.];[4.;5.;6.];[7.;8.;9.]];;

print_string "transpose";;
transpose [];;
transpose [[]];; (* impossible to obtain 0 * 1 matrix *)
transpose [[];[]];; (* impossible to obtain 0 * 2 matrix *)
transpose [[1.]];;
transpose [[1.;2.;3.;4.;5.;]];;
transpose [[1.;2.;3.];[4.;5.;6.];[7.;8.;9.]];;
transpose [[1.;2.;3.;4.;5.];[6.;7.;8.;9.;10.]];;

print_string "mmult";;
mmult [[1.;2.;3.];[4.;5.;6.];[7.;8.;9.]] [[1.;2.;3.];[4.;5.;6.];[7.;8.;9.]];;
mmult [] [];;
mmult [[]] [];;
mmult [[];[]] [];;
mmult (transpose [[1.;2.;3.;4.;5.];[6.;7.;8.;9.;10.]]) [[1.;2.];[3.;4.]];;

print_string "evalExp";;
evalExp (Num 5.0);;
evalExp (BinOp(BinOp(Num 1.0, Plus, Num 2.0), Times, Num 3.0));;

print_string "execute";;
execute [Push 1.0; Push 2.0; Calculate Plus; Push 3.0; Calculate Times];;

print_string "compile";;
compile (BinOp(BinOp(Num 1.0, Plus, Num 2.0), Times, Num 3.0));;

print_string "decompile";;
decompile [Push 1.0; Push 2.0; Calculate Plus; Push 3.0; Calculate Times];;
decompile [Push 1.0; Push 2.0; Calculate Plus; Push 3.0; Swap; Calculate Times;];;

print_string "compileOpt";;
compileOpt (BinOp(BinOp(Num 1.0, Plus, Num 2.0), Times, Num 3.0));;
compileOpt (BinOp((Num 1.0), Minus, BinOp(Num 2.0, Plus, Num 3.0)));;
compileOpt (BinOp(BinOp(Num 2.0, Plus, Num 3.0), Divide, BinOp(Num 2.0, Minus, BinOp(Num 2.0, Times, Num 3.0))));;
compileOpt (BinOp(Num 1.0, Minus, BinOp(Num 2.0, Plus, BinOp(Num 3.0, Times, BinOp(Num 4.0, Divide, Num 5.0)))));;