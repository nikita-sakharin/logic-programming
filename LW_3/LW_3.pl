empty_(List) :-
	List == [].

length_([], 0).
length_([_|Tail], Len) :-
	length_(Tail, M), Len is M + 1.

member_(Mem, [Mem|_]).
member_(Mem, [_|Tail]) :-
	member_(Mem, Tail).

append_([], List, List).
append_([X|First], Second, [X|Result]) :-
	append_(First, Second, Result).

reverse__([], Result, Result).
reverse__([Head|Tail], Accum, Result) :-
	reverse__(Tail, [Head|Accum], Result).

reverse_(List, Result) :-
	reverse__(List, [], Result).

move([], _, _, _) :-
	false.
move([First1|FirstTail], Second, FirstTail, [First1|Second]).

left_to_deadlock(Left, Deadlock, NewLeft, NewDeadlock) :-
	move(Left, Deadlock, NewLeft, NewDeadlock).
deadlock_to_right(Deadlock, Right, NewDeadlock, NewRight) :-
	move(Deadlock, Right, NewDeadlock, NewRight).
left_to_right(Left, Right, NewLeft, NewRight) :-
	move(Left, Right, NewLeft, NewRight).

check_sequence([], _).
check_sequence([Head|Tail], Cond) :-
	Cond \== Head,
	check_sequence(Tail, Head).

check_solution(Left, Deadlock, [RightHead|RightTail]) :-
	empty_(Left),
	empty_(Deadlock),
	check_sequence(RightTail, RightHead).



depth_first_search_(Left, Deadlock, Right, N, Solution, Result) :-
	length_(Solution, SLen),
	SLen =< N,
	check_solution(Left, Deadlock, Right)->
	(reverse_(Solution, Result), !);

	(left_to_deadlock(Left, Deadlock, NewLeft1, NewDeadlock1),
	depth_first_search_(NewLeft1, NewDeadlock1, Right, N, ['Left->Deadlock'|Solution], Result));

	(deadlock_to_right(Deadlock, Right, NewDeadlock2, NewRight2),
	depth_first_search_(Left, NewDeadlock2, NewRight2, N, ['Deadlock->Right'|Solution], Result));

	(left_to_right(Left, Right, NewLeft3, NewRight3),
	depth_first_search_(NewLeft3, Deadlock, NewRight3, N, ['Left->Right'|Solution], Result)).

depth_first_search(Left, Result) :-
	length_(Left, N),
	ItCount is 3 * N / 2 - 1,
	depth_first_search_(Left, [], [], ItCount, [], Result).



actions([], [_|Queue], _, Queue).
actions(['Left->Deadlock'|Actions], [position(state(Left, Deadlock, Right), Path)|Queue], Visited, ResultQueue) :-
	(left_to_deadlock(Left, Deadlock, NewLeft, NewDeadlock),
	\+member_(state(NewLeft, NewDeadlock, Right), Visited))->

	(append_(Path, ['Left->Deadlock'], NewPath),
	append_([position(state(Left, Deadlock, Right), Path)|Queue], [position(state(NewLeft, NewDeadlock, Right), NewPath)], NewQueue),
	actions(Actions, NewQueue, Visited, ResultQueue));

	actions(Actions, [position(state(Left, Deadlock, Right), Path)|Queue], Visited, ResultQueue).

actions(['Deadlock->Right'|Actions], [position(state(Left, Deadlock, Right), Path)|Queue], Visited, ResultQueue) :-
	(deadlock_to_right(Deadlock, Right, NewDeadlock, NewRight),
	\+member_(state(Left, NewDeadlock, NewRight), Visited))->

	(append_(Path, ['Deadlock->Right'], NewPath),
	append_([position(state(Left, Deadlock, Right), Path)|Queue], [position(state(Left, NewDeadlock, NewRight), NewPath)], NewQueue),
	actions(Actions, NewQueue, Visited, ResultQueue));

	actions(Actions, [position(state(Left, Deadlock, Right), Path)|Queue], Visited, ResultQueue).

actions(['Left->Right'|Actions], [position(state(Left, Deadlock, Right), Path)|Queue], Visited, ResultQueue) :-
	(left_to_right(Left, Right, NewLeft, NewRight),
	\+member_(state(NewLeft, Deadlock, NewRight), Visited))->

	(append_(Path, ['Left->Right'], NewPath),
	append_([position(state(Left, Deadlock, Right), Path)|Queue], [position(state(NewLeft, Deadlock, NewRight), NewPath)], NewQueue),
	actions(Actions, NewQueue, Visited, ResultQueue));

	actions(Actions, [position(state(Left, Deadlock, Right), Path)|Queue], Visited, ResultQueue).

breadth_first_search_([position(state(Left, Deadlock, Right), Path)|QueueTail], Visited, Solution) :-
	(check_solution(Left, Deadlock, Right),
	Solution = Path);

	append_([state(Left, Deadlock, Right)], Visited, NewVisited),
	actions(['Left->Deadlock', 'Deadlock->Right', 'Left->Right'], [position(state(Left, Deadlock, Right), Path)|QueueTail], NewVisited, NewQueue),
	breadth_first_search_(NewQueue, NewVisited, Solution).

breadth_first_search(Left, Solution) :-
	breadth_first_search_([position(state(Left, [], []), [])], [], Solution).



iterative_deepening_dfs_(Left, MaxIt, TotalLimit, Result) :-
	depth_first_search_(Left, [], [], MaxIt, [], Result),
	length_(Result, MaxIt);

	NewMax is MaxIt + 1,
	NewMax =< TotalLimit,
	iterative_deepening_dfs_(Left, NewMax, TotalLimit, Result).

iterative_deepening_dfs(Left, N, Result) :-
	length_(Left, Len),
	TotalLimit is Len * 2,
	iterative_deepening_dfs_(Left, 1, TotalLimit, Result),
	length_(Result, N).	