assert(member 0 [] = false);;
assert(member 0 [1;0] = true);;
assert(member 0 [0;1] = true);;
assert(member 0 [1;2;3;4] = false);;

assert(add 0 [] = [0]);;
add 0 [1;2];;
add 0 [0;1;2];;

union [] [];;
union [] [1;2;3];;
union [1;2;3] [];;
union [1;2] [3];;
union [1;2;3] [3;4];;
union [1;2;3] [3;2;1];;

fastUnion [] [];;
fastUnion [1;2;3] [];;
fastUnion [] [1;2;3];;
fastUnion [1] [1];;
fastUnion [1] [2];;
fastUnion [1] [0;2];;
fastUnion [1;3] [0;1;2];;
fastUnion [0;2] [1];;
fastUnion [0;1;2] [1;3];;
fastUnion [0;1;2;3] [1;3];;

intersection [] [];;
intersection [] [1;2];;
intersection [1;2] [2;3];;
intersection [1;2] [3;4];;
intersection [3;4] [4;3];;

setify [];;
setify [1;2;3];;
setify [1;1;2;3;3];;
setify [1;2;3;2;3;4;6;4;0;1;5];;

powerset [0;1;2];;
powerset ["a";"b";"c"];;
powerset [];;
powerset [1];;

partition (fun x -> x>3) [2;4;1;0;5];;
partition (fun x -> x>3) [];;
partition (fun x -> x>3) [1;2];;
partition (fun x -> x>3) [3;4];;
partition (fun x -> x>3) [4;5];;
partition (fun x -> x>3) [1;5;4;3;2;6];;

whle (function x -> x < 10) (function x -> x * 2) 1;;
whle (function x -> x < 10) (function x -> x + 2) 1;;

let myFun x = x+1;;
let ff = pow 0 myFun;;
ff 2;;
let ff = pow 1 myFun;;
ff 2;;
let ff = pow 2 myFun;;
ff 2;;
let ff = pow 3 myFun;;
ff 2;;

