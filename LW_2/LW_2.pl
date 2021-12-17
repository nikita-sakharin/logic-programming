member_(Mem, [Mem|_]).
member_(Mem, [_|Tail]) :-
	member_(Mem, Tail).

unique([]).
unique([Head|Tail]) :-
	member_(Head, Tail), !, false;
	unique(Tail).

candidate('A'). %А
candidate('B'). %Б
candidate('V'). %В
candidate('G'). %Г
candidate('D'). %Д
candidate('E'). %Е

post(chairman). %Председатель
post(vice_chairman). %Зам. председателя
post(secretary). %Секретарь

%serve(Candidate, Post) кандидат Candidate занимает должность Post

solve(Solution) :-
	Solution = [
		serve(X_cand, X_post),
		serve(Y_cand, Y_post),
		serve(Z_cand, Z_post)
	],

	candidate(X_cand),
	candidate(Y_cand),
	candidate(Z_cand),
	unique([X_cand, Y_cand, Z_cand]),

	post(X_post),
	post(Y_post),
	post(Z_post),
	unique([X_post, Y_post, Z_post]),

	%А не хочет входить в состав руководства, если Д не будет председателем.
	(\+member_(serve('A', _), Solution); member_(serve('D', chairman), Solution)),

	%Б не хочет входить в состав руководства, если ему придется быть старшим над В.
	(\+member_(serve('B', chairman), Solution); \+member_(serve('V', _), Solution)),
	(\+member_(serve('B', vice_chairman), Solution); \+member_(serve('V', secretary), Solution)),

	%Б не хочет работать вместе с Е ни при каких условия.
	(\+member_(serve('B', _), Solution); \+member_(serve('E', _), Solution)),

	%В не хочет работать, если в состав руководства войдут Д и Е вместе.
	(\+member_(serve('V', _), Solution); \+member_(serve('D', _), Solution); \+member_(serve('E', _), Solution)),

	%В не будет работать, если Е будет председателем, или если Б будет секретарем.
	((\+member_(serve('B', secretary), Solution), \+member_(serve('E', chairman), Solution)); \+member_(serve('V', _), Solution)),

	%Г не будет работать с В или Д, если ему придется подчиняться тому или другому.
	(\+member_(serve('V', chairman), Solution); \+member_(serve('G', _), Solution)),
	(\+member_(serve('V', vice_chairman), Solution); \+member_(serve('G', secretary), Solution)),
	(\+member_(serve('D', chairman), Solution); \+member_(serve('G', _), Solution)),
	(\+member_(serve('D', vice_chairman), Solution); \+member_(serve('G', secretary), Solution)),

	%Д не хочет быть заместителем председателя.
	\+member_(serve('D', vice_chairman), Solution),

	%Д не хочет быть секретарем, если в состав руководства войдет Г.
	(\+member_(serve('D', secretary), Solution); \+member_(serve('G', _), Solution)),

	%Д не хочет работать вместе с А, если Е не войдет в состав руководства.
	(\+member_(serve('A', _), Solution); \+member_(serve('D', _), Solution); member_(serve('E', _), Solution)),

	%Е согласен работать только в том случае, если председателем будет либо он, либо В.
	(member_(serve('V', chairman), Solution); member_(serve('E', chairman), Solution); \+member_(serve('E', _), Solution)).

solution(Solution):-
	Solution = [serve(_, chairman), serve(_, vice_chairman), serve(_, secretary)], solve(Solution), !.