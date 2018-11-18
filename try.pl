:- dynamic(player_at/2).
:- dynamic(is_deadzone/2).

enemy_at(2,2).
ammo_at(2,3).
weapon_at(2,4).
medicine_at(3,2).
armor_at(3,4).
player_at(3,3).

map :- drawmap(15,15).

n :- go(n).
e :- go(e).
s :- go(s).
w :- go(w).

shrink_map(Z) :-
	A is 15-Z,
	asserta( (is_deadzone(X,_) :- X =:= Z+1) ),
	asserta( (is_deadzone(X,_) :- X =:= A) ),
	assertz( (is_deadzone(_,Y) :- Y =:= Z+1) ),
	assertz( (is_deadzone(_,Y) :- Y =:= A) ).

look :- 
	player_at(X,Y),
	A is X-1, 
	B is Y-1,
	C is Y+1,
	D is X+1,
	show_whats_around(A,B),
	show_whats_around(A,Y),
	show_whats_around(A,C),nl,
	show_whats_around(X,B),
	show_whats_around(X,Y),
	show_whats_around(X,C),nl,
	show_whats_around(D,B),
	show_whats_around(D,Y),
	show_whats_around(D,C),nl.

show_whats_around(X,Y) :- is_deadzone(X,Y), write('X'),!.
show_whats_around(X,Y) :- enemy_at(X,Y), write('E'),!.
show_whats_around(X,Y) :- medicine_at(X,Y), write('M'),!.
show_whats_around(X,Y) :- weapon_at(X,Y), write('W'),!.
show_whats_around(X,Y) :- armor_at(X,Y), write('A'),!.
show_whats_around(X,Y) :- ammo_at(X,Y), write('O'),!.
show_whats_around(X,Y) :- player_at(X,Y), write('P'),!.
show_whats_around(_,_) :- write('-'),!.

is_deadzone(X,_) :- X =:= 15.
is_deadzone(X,_) :- X =:= 1.
is_deadzone(_,Y) :- Y =:= 15.
is_deadzone(_,Y) :- Y =:= 1.

drawmap(X,_) :- X<1.
drawmap(X,Y) :- is_deadzone(X,Y), X >0, Y>1,!, write('X'),!, drawmap(X,Y-1),!.
drawmap(X,Y) :- is_deadzone(X,Y), X >0, Y>0,!, write('X'),nl,!, drawmap(X-1,15),!.
drawmap(X,Y) :- player_at(U,V),T is 16-U, X =:= T, S is 16-V, S =:= Y, X>0 , Y>0,!,  write('P'), drawmap(X,Y-1).
drawmap(X,Y) :- X>1,Y>0,!, write('-'), drawmap(X,Y-1).

go(n) :- 
	retract(player_at(X,Y)), 
	Z is X-1, 
	asserta(player_at(Z,Y)).

go(e) :- 
	retract(player_at(X,Y)), 
	Z is Y+1, 
	asserta(player_at(X,Z)).

go(s) :- 
	retract(player_at(X,Y)), 
	Z is X+1, 
	asserta(player_at(Z,Y)).

go(w) :- 
	retract(player_at(X,Y)), 
	Z is Y-1, 
	asserta(player_at(X,Z)).

