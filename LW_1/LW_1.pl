%Default predicates

length_([], 0).
length_([_|Tail], Len) :-
	length_(Tail, M), Len is M + 1.

member_(Mem, [Mem|_]).
member_(Mem, [_|Tail]) :-
	member_(Mem, Tail).
member_o(Mem, [(Mem, _)|_]).
member_o(Mem, [_|T]) :-
	member_(Mem ,T).

append_([], List, List).
append_([X|First], Second, [X|Result]) :-
	append_(First, Second, Result).

append_o(First, Second, Result) :-
	length_(First, N),
	update_idx(Second, N, X),
	append_(First, X, Result).

remove_(Mem, [Mem|T], T).
remove_(Mem, [A|Tail], [A|New_tail]) :-
	remove_(Mem, Tail, New_tail).
remove_o(Mem, [(Mem, _)|Tail], Result) :-
	update_idx(Tail, -1, Result).
remove_o(Mem, [A|Tail], [A|New_tail]) :-
	remove_o(Mem, Tail, New_tail).

permute_([],[]).
permute_(L, [X|T]) :-
	remove_(X, L, R),
	permute_(R, T).

sublist_([], _).
sublist_([X|Tail], [X|New_tail]) :-
	sublist_(Tail, New_tail), !.
sublist_([X|Tail], [_|New_tail]) :-
	sublist_([X|Tail], New_tail), !.

%Custom predicates

insert_(List, Val, 0, [Val|List]).
insert_([Head|List], Val, Pos, [Head|Res]) :-
	Pos > 0,
	New_pos is Pos - 1,
	insert_(List, Val, New_pos, Res), !.

insert_d(List, Val, 0, Result) :-
	append_([Val], List, Result).
insert_d([Head|List], Val, Pos, Result) :-
	Pos > 0,
	remove_(Head, [Head|List], Temp),
	New_pos is Pos - 1,
	insert_d(Temp, Val, New_pos, Local_temp),
	append_([Head], Local_temp, Result), !.

insert_o(T, Val, 0, [(Val, 0)|R]) :-
	update_idx(T, R, 1).
insert_o([Head|Tail], Val, Pos, [Head|Res]) :-
	Pos > 0,
	New_pos is Pos - 1,
	insert_o(Tail, Val, New_pos, Res), !.

insert_o_d(List, Val, 0, Result) :-
	append_o([(Val, 0)], List, Result), !.
insert_o_d([(V, Idx)|Tail], Val, Pos, Result) :-
	Pos > 0,
	remove_o(V, [(V, Idx)|Tail], Temp),
	New_pos is Pos - 1,
	insert_o_d(Temp, Val, New_pos, Local_temp),
	append_o([(V, Idx)], Local_temp, Result), !.

max_elem_idx([], -1).
max_elem_idx([_], 0).
max_elem_idx([Head|Tail], Result) :-
	sub_list_max_elem_idx(Tail, 1, Head, 0, Result), !.

max_elem_idx_o([], -1).
max_elem_idx_o([_], 0).
max_elem_idx_o([(Val, _)|T], Result) :-
	sub_list_max_elem_idx_o(T, Val, 0, Result), !.

%Useful predicate

max_elem_pos_insert(List, Val, Result) :-
	max_elem_idx(List, Idx),
	insert_(List, Val, Idx, Result).

%Helper predicates

update_idx([], _, []).
update_idx([(Val, Idx)|Tail], Delta, [(Val, New_idx)|New_tail]) :-
	New_idx is Idx + Delta,
	update_idx(Tail, Delta, New_tail).

sub_list_max_elem_idx([], _, _, Curr_max_idx, Curr_max_idx).
sub_list_max_elem_idx([Head|Tail], Idx, Curr_max, _, Result) :-
	Head > Curr_max,
	New_idx is Idx + 1,
	sub_list_max_elem_idx(Tail, New_idx, Head, Idx, Result).
sub_list_max_elem_idx([Head|Tail], Idx, Curr_max, Curr_max_idx, Result) :-
	Head =< Curr_max,
	New_idx is Idx + 1,
	sub_list_max_elem_idx(Tail, New_idx, Curr_max, Curr_max_idx, Result).

sub_list_max_elem_idx_o([], _, Curr_max_idx, Curr_max_idx).
sub_list_max_elem_idx_o([(Val, Idx)|Tail], Curr_max, _, Result) :-
	Val > Curr_max,
	sub_list_max_elem_idx_o(Tail, Val, Idx, Result).
sub_list_max_elem_idx_o([(Val, _)|Tail], Curr_max, Curr_max_idx, Result) :-
	Val =< Curr_max,
	sub_list_max_elem_idx_o(Tail, Curr_max, Curr_max_idx, Result).