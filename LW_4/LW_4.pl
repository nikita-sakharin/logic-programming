member_(Mem, [Mem|_]).
member_(Mem, [_|Tail]) :-
	member_(Mem, Tail).

sentence(Result) --> human(First, 'nominative case'), filiation(Filiation), human(Second, 'genitive case'), ['?'], { (call(Filiation, First, Second) -> (Result = 'Yes'); (Result = 'No')) }.
sentence(Result) --> interrogative_pronoun, human(Human, 'possessive case'), filiation(Filiation), ['?'], { call(Filiation, Result, Human) }.
sentence(Result) --> interrogative, filiation(Filiation), human(Human, 'nominative case'), ['?'], { call(Filiation, Human, Result) }.

interrogative_pronoun --> [X], { member_(X, [kto]) }.
interrogative --> [X], { member_(X, [chei]) }.
human(Result, Case) --> [X], { case_dictionary(List), member_((Case, X), List), member_(('nominative case', Result), List), (male(Result); female(Result)) }.

filiation(Result) --> [X], { (X == brat) -> Result = brother }.

answer(Question, Answer) :-
	sentence(Answer, Question, []).

brother(X, Y) :-
	male(X),
	parent(Father, X),
	parent(Father, Y),
	male(Father),
	parent(Mother, X),
	parent(Mother, Y),
	female(Mother),
	X \= Y.



parent('Aleksandr', 'Nikolay').
parent('Maria', 'Nikolay').

parent('Aleksandr', 'Georgy').
parent('Maria', 'Georgy').

parent('Aleksandr', 'Kseniya').
parent('Maria', 'Kseniya').

parent('Aleksandr', 'Mihail').
parent('Maria', 'Mihail').

parent('Aleksandr', 'Olga').
parent('Maria', 'Olga').

parent('Nikolay', 'Sofiya').
parent('Aleksandra', 'Sofiya').

parent('Nikolay', 'Tatiana').
parent('Aleksandra', 'Tatiana').

parent('Nikolay', 'Sveta').
parent('Aleksandra', 'Sveta').

parent('Nikolay', 'Anastasia').
parent('Aleksandra', 'Anastasia').

parent('Nikolay', 'Аleksey').
parent('Aleksandra', 'Аleksey').

male('Aleksandr').
male('Nikolay').
male('Georgy').
male('Mihail').
male('Аleksey').

female('Maria').
female('Kseniya').
female('Olga').
female('Sofiya').
female('Tatiana').
female('Sveta').
female('Anastasia').

case_dictionary([('nominative case', 'Aleksandr'), ('genitive case', 'Aleksandra'), ('possessive case', 'Aleksandrin')]).
case_dictionary([('nominative case', 'Maria'),     ('genitive case', 'Marii'),      ('possessive case', 'Marin')]).
case_dictionary([('nominative case', 'Nikolay'),   ('genitive case', 'Nikolaya'),   ('possessive case', 'Nikolain')]).
case_dictionary([('nominative case', 'Georgy'),    ('genitive case', 'Georgiya'),   ('possessive case', 'Georgin')]).
case_dictionary([('nominative case', 'Kseniya'),   ('genitive case', 'Ksenii'),     ('possessive case', 'Ksenin')]).
case_dictionary([('nominative case', 'Mihail'),    ('genitive case', 'Mihaila'),    ('possessive case', 'Mihailin')]).
case_dictionary([('nominative case', 'Olga'),      ('genitive case', 'Olgi'),       ('possessive case', 'Olgin')]).
case_dictionary([('nominative case', 'Sofiya'),    ('genitive case', 'Sofii'),      ('possessive case', 'Sofin')]).
case_dictionary([('nominative case', 'Tatiana'),   ('genitive case', 'Tatiany'),    ('possessive case', 'Tatianin')]).
case_dictionary([('nominative case', 'Sveta'),     ('genitive case', 'Svety'),      ('possessive case', 'Svetin')]).
case_dictionary([('nominative case', 'Anastasia'), ('genitive case', 'Anastasii'),  ('possessive case', 'Anastasin')]).
case_dictionary([('nominative case', 'Аleksey'),   ('genitive case', 'Аlekseya'),   ('possessive case', 'Аleksein')]).