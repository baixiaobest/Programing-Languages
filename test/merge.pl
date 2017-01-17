merge(X,[],X).
merge([],X,X).
merge([XH|XT],[YH|YT],[XH|TMerge]) :- XH < YH,merge(XT,[YH|YT],TMerge).
merge([XH|XT],[YH|YT],[YH|TMerge]) :- XH > YH,merge([XH|XT],YT, TMerge).

member_(X, [_|T]) :- member(X, T).
member_(H, [H|_]).