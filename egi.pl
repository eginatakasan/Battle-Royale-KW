/* Compiler: GNU Prolog */
/* :-dynamic diperlukan untuk buat fakta yang bisa diubah */
/* retract artinya menghapus fakta atau rule dari database */
/* asserta artinya menambah fakta atau rule dari database ditaruh di awal database*/
/* assertz artinya menambah fakta atau rule dari database ditaruh di akhir database*/
:- dynamic(player_at/2). 
:- dynamic(is_deadzone/2).
:- dynamic(timer/1).

/* Deklarasi fakta statik (sementara selagi belum ada fungsi spawn) */

/* enemy_at(nomor enemy(enemy ke berapa), koordinat X, koordinat Y) */
enemy_at(1,2,2).
/* item_at(jenis item, nama item, koordinat X, koordinat Y) */
/* yang termasuk item: weapon, medicine, armor, ammo */
item_at(ammo,pistol_ammo,2,3).
item_at(ammo,ak47_ammo,2,4).
item_at(weapon,pistol,3,4).
item_at(medicine,medicine,3,2).


/* Deklarasi fakta dinamik */
player_at(3,3).
timer(1).

/* Deklarasi rules */
map :- drawmap(15,15).

quit :- end_game.

n :- go(n).
e :- go(e).
s :- go(s).
w :- go(w).

look :- 
	write_legend,nl,
	player_at(X,Y),
	A is X-1, 
	B is Y-1,
	C is Y+1,
	D is X+1,
	show_whats_around(A,B),write(' '),
	show_whats_around(A,Y),write(' '),
	show_whats_around(A,C),nl,
	show_whats_around(X,B),write(' '),
	show_whats_around(X,Y),write(' '),
	show_whats_around(X,C),nl,
	show_whats_around(D,B),write(' '),
	show_whats_around(D,Y),write(' '),
	show_whats_around(D,C),nl,nl,
	write('To the northwest '),describe_around(A,B),
	write('To the north '),describe_around(A,Y),
	write('To the northeast '),describe_around(A,C),nl,
	write('To the west '),describe_around(X,B),
	write('Near you '),describe_around(X,Y),
	write('to the east '),describe_around(X,C),nl,
	write('to the southwest '),describe_around(D,B),
	write('to the south '),describe_around(D,Y),
	write('to the southeast '),describe_around(D,C),nl.

go(n) :-
	player_at(X,Y),
	A is X-1,
	is_deadzone(A,Y),!,
	write('Anda memasuki dead zone!'),nl,
	end_game.

go(n) :- 
	retract(player_at(X,Y)), 
	Z is X-1, 
	asserta(player_at(Z,Y)),
	update.

go(e) :-
	player_at(X,Y),
	A is Y+1,
	is_deadzone(X,A),!,
	write('Anda memasuki dead zone!'),nl,
	end_game.

go(e) :- 
	retract(player_at(X,Y)), 
	Z is Y+1, 
	asserta(player_at(X,Z)),
	update.

go(s) :- 
	player_at(X,Y),
	A is X+1,
	is_deadzone(A,Y),!,
	write('Anda memasuki dead zone!'),nl,
	end_game.	

go(s) :- 
	retract(player_at(X,Y)), 
	Z is X+1, 
	asserta(player_at(Z,Y)),
	update.

go(w) :- 
	player_at(X,Y),
	A is Y-1, 
	is_deadzone(X,A),!,
	write('Anda memasuki dead zone!'),nl,
	end_game.
go(w) :- 
	retract(player_at(X,Y)), 
	Z is Y-1, 
	asserta(player_at(X,Z)),
	update.


update :-
	timer(X),
	Z is X mod 7,
	Z =:= 0,
	Y is X+1,
	V is X / 7,!,
	shrink_map(V),
	write('Safe zone telah mengecil!'),
	retract(timer(X)),
	asserta(timer(Y)).

update :-
	timer(X),
	Z is X mod 7,
	Z \= 0,
	Y is X+1,!,
	retract(timer(X)),
	asserta(timer(Y)).


shrink_map(Z) :-
	A is 15-Z,
	asserta( (is_deadzone(X,_) :- X =:= Z+1) ),
	asserta( (is_deadzone(X,_) :- X =:= A) ),
	assertz( (is_deadzone(_,Y) :- Y =:= Z+1) ),
	assertz( (is_deadzone(_,Y) :- Y =:= A) ).


show_whats_around(X,Y) :- is_deadzone(X,Y), write('X'),!.
show_whats_around(X,Y) :- enemy_at(_,X,Y), write('E'),!.
show_whats_around(X,Y) :- item_at(medicine,_,X,Y), write('M'),!.
show_whats_around(X,Y) :- item_at(weapon,_,X,Y), write('W'),!.
show_whats_around(X,Y) :- item_at(armor,_,X,Y), write('A'),!.
show_whats_around(X,Y) :- item_at(ammo,_,X,Y), write('O'),!.
show_whats_around(X,Y) :- player_at(X,Y), write('P'),!.
show_whats_around(_,_) :- write('-'),!.

describe_around(X,Y) :- is_deadzone(X,Y), write(',is a deadzone. '),!.
describe_around(X,Y) :- enemy_at(_,X,Y), write(',you see an enemy. '),!.
describe_around(X,Y) :- item_at(medicine,_,X,Y), write(',you see a medicine. '),!.
describe_around(X,Y) :- item_at(weapon,Name,X,Y), write(',you see a '),write(Name),write('.'),!.
describe_around(X,Y) :- item_at(armor,Name,X,Y), write(',you see a '),write(Name),write('.'),!.
describe_around(X,Y) :- item_at(ammo,Name,X,Y), write('you see some '),write(Name),write('.'),!.
describe_around(_,_) :- write('you see nothing. '),!.



is_deadzone(X,_) :- X =:= 15.
is_deadzone(X,_) :- X =:= 1.
is_deadzone(_,Y) :- Y =:= 15.
is_deadzone(_,Y) :- Y =:= 1.

drawmap(X,_) :- X<1.
drawmap(X,Y) :- is_deadzone(X,Y), X >0, Y>1,!, write('X'),!, drawmap(X,Y-1),!.
drawmap(X,Y) :- is_deadzone(X,Y), X >0, Y>0,!, write('X'),nl,!, drawmap(X-1,15),!.
drawmap(X,Y) :- player_at(U,V),T is 16-U, X =:= T, S is 16-V, S =:= Y, X>0 , Y>0,!,  write('P'), drawmap(X,Y-1).
drawmap(X,Y) :- X>1,Y>0,!, write('-'), drawmap(X,Y-1).

write_legend :-
	write('Legends:'),nl,
	write('W = weapon'),nl,
	write('A = armor'),nl,
	write('M = medicine'),nl,
	write('O = ammo'),nl,
	write('P = player'),nl,
	write('E = enemy'),nl,
	write('- = accessible'),nl,
	write('X = inaccessible'),nl.
	
end_game :- write('***** Game Over *****'), halt.