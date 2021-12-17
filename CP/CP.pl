prolong([X|T], [Y,X|T]) :-
	parent(X, Y), \+(member(Y, [X|T]));
	parent(Y, X), \+(member(Y, [X|T])).

fill_next_relative(F, S, L1, L) :-
	parent(F, S), sex(F, 'male'), append(['-> father'], L1, L);
	parent(F, S), sex(F, 'female'), append(['-> mother'], L1, L);
	parent(S, F), sex(F, 'male'), append(['-> son'], L1, L);
	parent(S, F), sex(F, 'female'), append(['-> daughter'], L1, L).
								 
search_in_depth([X|_], X, []).
search_in_depth(X, Y, L) :-
	prolong(X, Z),
	search_in_depth(Z, Y, L1),
	Z = [F, S|_],
	fill_next_relative(F, S, L1, L).

transform([],[]).
transform(L1, L):- 
	L1 = ['-> son', '-> son'|T], transform(T, T1), append(['-> grandson '], T1, L);
	L1 = ['-> daughter', '-> son'|T], transform(T, T1), append(['-> grandson '], T1, L);
	L1 = ['-> son', '-> daughter'|T], transform(T, T1), append(['-> granddaughter '], T1, L);
	L1 = ['-> daughter', '-> daughter'|T], transform(T, T1), append(['-> granddaughter '], T1, L);
	L1 = ['-> father', '-> father'|T], transform(T, T1), append(['-> grandfather '], T1, L);
	L1 = ['-> mother', '-> father'|T], transform(T, T1), append(['-> grandfather '], T1, L);
	L1 = ['-> father', '-> mother'|T], transform(T, T1), append(['-> grandmother '], T1, L);
	L1 = ['-> mother', '-> mother'|T], transform(T, T1), append(['-> grandmother '], T1, L);
	L1 = ['-> father', '-> daughter'|T], transform(T, T1), append(['-> sister '], T1, L);
	L1 = ['-> mother', '-> daughter'|T], transform(T, T1), append(['-> sister '], T1, L);
	L1 = ['-> father', '-> son'|T], transform(T, T1), append(['-> brother '], T1, L);
	L1 = ['-> mother', '-> son'|T], transform(T, T1), append(['-> brother '], T1, L);
	L1 = ['-> father', '-> mother', '-> daughter'|T], transform(T, T1), append(['-> aunt '], T1, L);
	L1 = ['-> father', '-> mother', '-> son'|T], transform(T, T1), append(['-> uncle '], T1, L);
	L1 = ['-> mother', '-> mother', '-> daughter'|T], transform(T, T1), append(['-> aunt '], T1, L);
	L1 = ['-> mother', '-> mother', '-> son'|T], transform(T, T1), append(['-> uncle '], T1, L);
	L1 = ['-> father', '-> father', '-> daughter'|T], transform(T, T1), append(['-> aunt '], T1, L);
	L1 = ['-> father', '-> father', '-> son'|T], transform(T, T1), append(['-> uncle '], T1, L);
	L1 = ['-> mother', '-> father', '-> daughter'|T], transform(T, T1), append(['-> aunt '], T1, L);
	L1 = ['-> mother', '-> father', '-> son'|T], transform(T, T1), append(['-> uncle '], T1, L);
	L1 = ['-> father', '-> son', '-> mother'|T], transform(T, T1), append(['-> wife '], T1, L);
	L1 = ['-> father', '-> daughter', '-> mother'|T], transform(T, T1), append(['-> wife '], T1, L);
	L1 = ['-> mother', '-> son', '-> father'|T], transform(T, T1), append(['-> husband '], T1, L);
	L1 = ['-> mother', '-> daughter', '-> father'|T], transform(T, T1), append(['-> husband '], T1, L);
	L1 = ['-> son'|T], transform(T, T1), append(['-> son '], T1, L);
	L1 = ['-> daughter'|T], transform(T, T1), append(['-> daughter '], T1, L);
	L1 = ['-> father'|T], transform(T, T1), append(['-> father '], T1, L);
	L1 = ['-> mother'|T], transform(T, T1), append(['-> mother '], T1, L).

relative(X, Y, L) :-
	search_in_depth([X], Y, L1),
	transform(L1, L), !.

sib(X, Y) :-
	parent(Parent, X),
	parent(Parent, Y),
	X \== Y.

cousin(X, Y) :-
	sex(X, 'male'),
	parent(XPar, X),
	sib(XPar, YPar),
	parent(YPar, Y),
	X \== Y.

sex('Aleksandr Sakharin', 'male').
sex('Yuliya Shanina', 'female').
sex('Nikita Sakharin', 'male').
sex('Arkadiy Sakharin', 'male').
sex('Aleksei Sakharin', 'male').
sex('Aleksandr Shanin', 'male').
sex('Egor Sakharin', 'male').
sex('Alena Sakharina', 'female').
sex('Maksim Shanin', 'male').
sex('Igor Kolganov', 'male').

parent('Aleksandr Sakharin', 'Nikita Sakharin').
parent('Yuliya Shanina', 'Nikita Sakharin').
parent('Arkadiy Sakharin', 'Aleksandr Sakharin').
parent('Galina Kulikova', 'Aleksandr Sakharin').
parent('Arkadiy Sakharin', 'Aleksei Sakharin').
parent('Galina Kulikova', 'Aleksei Sakharin').
parent('Aleksandr Shanin', 'Yuliya Shanina').
parent('Tatyana Sukhorukova', 'Yuliya Shanina').
parent('Aleksandr Shanin', 'Maksim Shanin').
parent('Tatyana Sukhorukova', 'Maksim Shanin').
parent('Aleksei Sakharin', 'Alena Sakharina').
parent('Svetlana Yakovleva', 'Alena Sakharina').
parent('Aleksei Sakharin', 'Egor Sakharin').
parent('Svetlana Yakovleva', 'Egor Sakharin').
parent('Elena Eroveeva', 'Svetlana Yakovleva').
parent('Igor Kolganov', 'Svetlana Yakovleva').