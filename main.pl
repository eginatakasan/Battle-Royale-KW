:- include('winston.pl').

/* Compiler: GNU Prolog */
/* :-dynamic diperlukan untuk buat fakta yang bisa diubah */
/* retract artinya menghapus fakta atau rule dari database */
/* asserta artinya menambah fakta atau rule dari database ditaruh di awal database*/
/* assertz artinya menambah fakta atau rule dari database ditaruh di akhir database*/
:- dynamic(player_at/2). 
:- dynamic(is_deadzone/2).
:- dynamic(timer/1).
:- dynamic(inventory/1).
:- dynamic(inventory/2).	/* khusus ammo */
:- dynamic(equipped_weapon/2).
:- dynamic(equipped_armor/1).
:- dynamic(item_at/4).
:- dynamic(item_at/5). /* khusus ammo */
:- dynamic(health/1).
:- dynamic(ammo/2).
:- dynamic(enemy_at/3).
:- dynamic(enemy/4).

/* Deklarasi fakta statik (sementara selagi belum ada fungsi spawn) */

/* enemy_at(nomor enemy(enemy ke berapa), koordinat X, koordinat Y) */
enemy_at(1,3,3).
enemy_at(2,3,3).
enemy_at(3,3,3).
enemy_at(4,3,3).
enemy_at(5,3,3).
enemy_at(6,3,3).

/*deklarasi item*/
enemy(1,100,0,pistol).  /* enemy(NomorEnemy,HealthEnemy,ArmorEnemy,WeaponEnemy) */
enemy(2,100,5,pistol).
enemy(3,100,20,ak47).
enemy(4,100,5,hand).
enemy(5,100,20,frying_pan).
enemy(6,100,5,chicken).
item(weapon,ak47).
item(weapon,pistol).
item(weapon,chicken).
item(weapon,frying_pan).
item(weapon,shotgun).
item(weapon,hand).
item(armor,helmet).
item(armor,shoes).
item(armor,vest).
item(medicine,bandage).
item(medicine,medicine).
item(ammo,ak47_ammo).
item(ammo,pistol_ammo).
item(ammo,shotgun_ammo).

/*deklarasi list barang (statik)*/
/*weapon(nama,kekuatan,byk ammo)*/
weapon(ak47,50,2).
weapon(pistol,35,1).
weapon(chicken,25,0).
weapon(frying_pan,30,0).
weapon(shotgun,60,3).
weapon(hand,10,0).
armor(helmet,10).
armor(shoes,5).
armor(vest,20).
armor(none,0).
medicine(bandage,15).
medicine(medicine,30).
ammo(pistol_ammo,pistol).
ammo(ak47_ammo,ak47).
ammo(shotgun_ammo,shotgun).

/* item_at(jenis item, nama item, koordinat X, koordinat Y) */
/* yang termasuk item: weapon, medicine, armor, ammo */

/* Deklarasi fakta dinamik */
player_at(3,3).
timer(0).
health(100).
equipped_weapon(hand,0).
equipped_armor(none).


/* Deklarasi rules */
item_at(medicine,bandage,3,3).

/*fungsi map*/
map :- drawmap(15,15).

/*fungsi quit*/
quit :- end_game.

help :-
        nl,
        write('Program dilaksanakan dengan bahasa Prolog'), nl,
        write('List command yang tersedia :'), nl,
        write('start.                   -- mulai permainan.'), nl,
		write('n. s. e. w.              -- arah pergerakan.'), nl,
		write('map.                     -- menampilkan map dari game'), nl,
        write('take(Object).            -- mengambil barang dari tanah ke inventory'), nl,
        write('drop(Object).            -- menaruh barang dari inventory ke tanah'), nl,
        write('use(Object)              -- memakai Object yang ada di di-inventory'), nl,
		write('unequip(Object).         -- melepaskan equipment dan dimasukkan dalam inventory'), nl,
		write('lihatinv.                -- melihat list inventory yang sedang dipegang.'), nl,
        write('attack.                  -- menyerang musuh dengan equipment yang digunakan'), nl,
        write('look.                    -- melihat daerah sekitar dengan ukuran 3x3.'), nl,
        write('help.                    -- melihat list command yang tersedia'), nl,
		write('save.                    -- menyimpan game yang telah dilaksanakan'), nl,
		write('load.                    -- load game yang pernah disave.'), nl,
        write('quit.                    -- end game dan quit.'), nl,
        nl.

spawn_player_position:-
	random(1,15,X),
	random(1,15,Y),
	player_at(M,N),
	retract(player_at(M,N)),
	asserta(player_at(X,Y)).

spawn_enemy_position(A):-
	random(1,15,X), write(X), nl,
	random(1,15,Y), write(Y), nl,
	enemy_at(A,M,N),
	retract(enemy_at(A,M,N)),
	asserta(enemy_at(A,X,Y)).

/* Fungsi Start */
start :-
		write('Selamat datang di permainan PUBG ecek-ecek.'),
		write('\nKetik help. untuk melihat command yang tersedia dan ketik map. untuk melihat kondisi kamu sekarang.\n'),
		help,
		spawn_player_position,
		spawn_enemy_position(1),
		spawn_enemy_position(2),
		spawn_enemy_position(3),
		spawn_enemy_position(4),
		spawn_enemy_position(5),
		spawn_enemy_position(6),
		map.


/*fungsi gerak*/
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
	write('Kamu melihat sekelilingmu:'),nl,
	write('Di dekat kamu '),listing_stuff(X,Y),nl,
	write('Di sebelah barat laut '),listing_stuff(A,B),nl,
	write('Di sebelah utara '),listing_stuff(A,Y),nl,
	write('Di timur laut '),listing_stuff(A,C),nl,
	write('Di sebelah barat '),listing_stuff(X,B),nl,
	write('Di sebelah timur '),listing_stuff(X,C),nl,
	write('Di tenggara '),listing_stuff(D,B),nl,
	write('Di selatan '),listing_stuff(D,Y),nl,
	write('Di barat daya '),listing_stuff(D,C),nl.

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


/*fungsi update: mengupdate timer dan memperkecil safe zone tiap 7 gerakan*/
update :-
	timer(X),
	Z is X mod 7,
	Z =:= 0,
	Y is X+1,
	V is X / 7,!,
	shrink_map(V),
	retract(timer(X)),
	asserta(timer(Y)),
	player_at(A,B),
	is_deadzone(A,B),
	write('Anda memasuki dead zone!'),nl,
	end_game.

update :-
	timer(X),
	Z is X mod 7,
	Z =:= 0,
	Y is X+1,
	V is X / 7,!,
	shrink_map(V),
	check_win,
	retract(timer(X)),
	asserta(timer(Y)).

update :-
	timer(X),
	Z is X mod 7,
	Z \= 0,
	Y is X+1,!,
	check_win,
	retract(timer(X)),
	asserta(timer(Y)).

shrink_map(Z) :-
	A is 15-Z,
	asserta( (is_deadzone(X,_) :- X =:= Z) ),
	asserta( (is_deadzone(X,_) :- X =:= A) ),
	assertz( (is_deadzone(_,Y) :- Y =:= Z) ),
	assertz( (is_deadzone(_,Y) :- Y =:= A) ),
	write('safe zone telah mengecil!').


show_whats_around(X,Y) :- is_deadzone(X,Y), write('X'),!.
show_whats_around(X,Y) :- enemy_at(_,X,Y), write('E'),!.
show_whats_around(X,Y) :- item_at(medicine,_,X,Y), write('M'),!.
show_whats_around(X,Y) :- item_at(weapon,_,X,Y), write('W'),!.
show_whats_around(X,Y) :- item_at(armor,_,X,Y), write('A'),!.
show_whats_around(X,Y) :- item_at(ammo,_,X,Y,_), write('O'),!.
show_whats_around(X,Y) :- player_at(X,Y), write('P'),!.
show_whats_around(_,_) :- write('-'),!.

listing_stuff(X,Y) :- 
	is_deadzone(X,Y),write(', adalah deadzone. '),!.
listing_stuff(X,Y) :- 
	is_there(enemy,X,Y,E), 
	is_there(medicine,X,Y,M), 
	is_there(weapon,X,Y,W),
	is_there(armor,X,Y,A),
	is_there(ammo,X,Y,O), 
	E =:= 0, M =:= 0, W =:= 0, A =:= 0, O =:=0, write('tidak ada apa-apa.'),!.
listing_stuff(X,Y) :- 
	is_there(enemy,X,Y,E), 
	is_there(medicine,X,Y,M), 
	is_there(weapon,X,Y,W),
	is_there(armor,X,Y,A),
	is_there(ammo,X,Y,O),
	describe(enemy,X,Y,E),is_there_more(M),
	describe(medicine,X,Y,M), is_there_more(W),
	describe(weapon,X,Y,W), is_there_more(A),
	describe(armor,X,Y,A),is_there_more(O),
	describe(ammo,X,Y,O),write('.'),!.

is_there(enemy,X,Y,Result) :- enemy_at(_,X,Y), Result is 1,!.
is_there(medicine,X,Y,Result) :- item_at(medicine,_,X,Y), Result is 1,!.
is_there(weapon,X,Y,Result) :- item_at(weapon,_,X,Y), Result is 1,!.
is_there(armor,X,Y,Result) :- item_at(armor,_,X,Y), Result is 1,!.
is_there(ammo,X,Y,Result) :- item_at(ammo,_,X,Y,_), Result is 1,!.
is_there(_,_,_,Result) :- Result is 0,!. 

is_there_more(1):- write(', '),!.
is_there_more(_).

describe(enemy,_,_,1):- write('ada musuh'),!.
describe(medicine,_,_,1):- write('ada medicine'),!.
describe(weapon,X,Y,1):- 
	findall(A,item_at(weapon,A,X,Y),List1), 
	panjang(List1,B),
	write_from_list(List1,B),!.
describe(armor,X,Y,1):- 
	findall(A,item_at(armor,A,X,Y),List1), 
	panjang(List1,B),
	write_from_list(List1,B),!.
describe(ammo,X,Y,1):- 
	findall(A,item_at(ammo,A,X,Y,_),List1), panjang(List1,B),
	write_from_list(List1,B).
describe(_,_,_,_).

write_from_list([],_).
write_from_list([H|T],N):-  Z is N-1, Z =:= 0, write('ada '),write(H), write_from_list(T,Z).
write_from_list([H|T],N):-  Z is N-1, Z \=0 ,write('ada '),write(H),write(', '), write_from_list(T,Z).

is_deadzone(X,_) :- X =:= 15.
is_deadzone(X,_) :- X =:= 0.
is_deadzone(_,Y) :- Y =:= 15.
is_deadzone(_,Y) :- Y =:= 0.

drawmap(X,_) :- X<0.
drawmap(X,Y) :- Z is 0-1, is_deadzone(X,Y), X >Z, Y>0,!, write('X'),!, drawmap(X,Y-1),!.
drawmap(X,Y) :- Z is 0-1, is_deadzone(X,Y), X >Z, Y>Z,!, write('X'),nl,!, drawmap(X-1,15),!.
drawmap(X,Y) :- player_at(U,V),T is 15-U, X =:= T, S is 15-V, S =:= Y, X>0 , Y>0,!,  write('P'), drawmap(X,Y-1).
drawmap(X,Y) :- Z is 0-1,X>0,Y>Z,!, write('-'), drawmap(X,Y-1).

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

/*fungsi untuk menghitung jumlah fakta*/
panjang([ ],0).
panjang([_|T],X) :- panjang(T,Length), X is Length+1.

/*fungsi take*/
take(X) :- 
	findall(A,inventory(A),B),
	panjang(B,N),
	findall(C,inventory(_,C),D), 
	panjang(D,M),
	P is M + N,
	P < 5,
	item_at(ammo,X,Y,Z,E),
	player_at(Y,Z),
	item(ammo,X),
	asserta(inventory(X,E)),
	retract(item_at(ammo,X,Y,Z,E)),
	write(X), write(' diambil'), !. 
take(X) :- 
	findall(A,inventory(A),B),
	panjang(B,N),
	findall(C,inventory(_,C),D),
	panjang(D,M),
	M+N < 5,
	player_at(Y,Z),
 	item_at(F,X,Y,Z),
	\+item(ammo,X),
	asserta(inventory(X)),
	retract(item_at(F,X,Y,Z)),
	write(X), write(' diambil'), !. 
take(_) :- 
	findall(A,inventory(A),B),
	panjang(B,N),
	findall(C,inventory(_,C),D),
	panjang(D,M),
	M+N > 4, 
	write('Inventory sudah penuh.'), nl, !, fail.
take(X) :-
	write('Tidak ada '), write(X), write(' di lokasi ini'), nl, !, fail.

/*untuk melihat list inventory*/
lihatinv :- 
	findall(A,inventory(A),Inv), 
	findall(B,inventory(B,_),Inve), 
	konso(Inve,Inv,List), panjang(List,X),
	X =:= 0,
	write('Inventory kosong'),!.

lihatinv :- 
	findall(A,inventory(A),Inv), 
	findall(B,inventory(B,_),Inve), 
	konso(Inve,Inv,List),
	write(List),!.

konso([],[],[]):-!.
konso([],B,B):-!.
konso([H|T],B,[H|X]) :- konso(T,B,X).

/*fungsi drop*/
drop(X) :- 
	inventory(X),
	retract(inventory(X)), 
	item(A,X),
	player_at(Y,Z),
	assertz(item_at(A,X,Y,Z)),
	write(X), write(' telah dijatuhkan.'), !.
drop(X) :- 
	inventory(X,Y),
	retract(inventory(X,Y)),
	item(A,X),
	player_at(B,C),
	assertz(item_at(A,X,B,C,Y)),
	write(X), write(' telah dijatuhkan.'), !.
drop(X) :- 
	\+inventory(X), 
	write(X), write(' tidak ada di inventory'), nl, !.
drop(X) :- 
	\+inventory(X,_), 
	write(X), write(' tidak ada di inventory'), nl, !.

/*fungsi use*/
use(X) :- 
	weapon(X,_,_),
	equipped_weapon(hand,Y), 
	inventory(X),
	retract(inventory(X)),
	retract(equipped_weapon(hand,Y)),
	asserta(equipped_weapon(X,0)),
	write('Weaponmu sekarang adalah '), write(X), nl, !.
use(X) :- 
	weapon(X,_,_), 
	inventory(X),
	equipped_weapon(Y,Z), Z =:= 0,
	retract(equipped_weapon(Y,Z)),
	retract(inventory(X)),
	asserta(equipped_weapon(X,0)),
	asserta(inventory(Y)),
	write('Weaponmu sekarang adalah '), write(X), nl, !.
use(X) :- 
	weapon(X,_,_), 
	inventory(X),
	equipped_weapon(Y,Z), Z \= 0,
	findall(A,inventory(A),B),
	panjang(B,N),
	findall(C,inventory(_,C),D),
	panjang(D,M),
	M+N > 4,  
	retract(equipped_weapon(Y,Z)),
	retract(inventory(X)),
	asserta(equipped_weapon(X,0)),
	asserta(inventory(Y)), asserta(inventory(Ammo)), write('Inventory penuh. '),
	drop(Ammo),!,
	write('Weaponmu sekarang adalah '), write(X), nl, !.
use(X) :- 
	weapon(X,_,_), 
	inventory(X),
	equipped_weapon(Y,Z), ammo(Ammo,Y), Z > 0, Z < 4,
	findall(A,inventory(A),B),
	panjang(B,N),
	findall(C,inventory(_,C),D),
	panjang(D,M),
	M+N =< 4,  
	retract(inventory(X)),
	retract(equipped_weapon(Y,Z)),
	asserta(equipped_weapon(X,0)),
	asserta(inventory(Y)), asserta(inventory(Ammo,Z)),
	write('Weaponmu sekarang adalah '), write(X), nl, !.
use(X) :- 
	weapon(X,_,_), 
	inventory(X),
	equipped_weapon(Y,Z), ammo(Ammo,Y), Z > 3,
	findall(A,inventory(A),B),
	panjang(B,N),
	findall(C,inventory(_,C),D),
	panjang(D,M),
	M+N =< 3,  
	retract(inventory(X)),
	retract(equipped_weapon(Y,Z)),
	asserta(equipped_weapon(X,0)), Sisa is Z -3,
	asserta(inventory(Y)), asserta(inventory(Ammo,3)), asserta(inventory(Ammo,Sisa)),!,
	write('Weaponmu sekarang adalah '), write(X), nl, !.
use(X) :- 
	weapon(X,_,_), 
	inventory(X),
	equipped_weapon(Y,Z), ammo(Ammo,Y), Z > 3,
	findall(A,inventory(A),B),
	panjang(B,N),
	findall(C,inventory(_,C),D),
	panjang(D,M),
	M+N =:= 4,  
	retract(inventory(X)),
	retract(equipped_weapon(Y,Z)),
	asserta(equipped_weapon(X,0)), Sisa is Z -3,
	asserta(inventory(Y)), asserta(inventory(Ammo,3)), asserta(inventory(Ammo,Sisa)),nl,write(Sisa),
	write('Weaponmu sekarang adalah '), write(X), nl, drop(Ammo), !.
use(X) :- 
	weapon(X,_,_), 
	inventory(X),
	equipped_weapon(Y,Z), ammo(Ammo,Y), Z > 3,
	findall(A,inventory(A),B),
	panjang(B,N),
	findall(C,inventory(_,C),D),
	panjang(D,M),
	M+N > 4,  
	retract(inventory(X)),
	retract(equipped_weapon(Y,Z)),
	asserta(equipped_weapon(X,0)), Sisa is Z -3,
	asserta(inventory(Y)), asserta(inventory(Ammo,3)), asserta(inventory(Ammo,Sisa)),
	write('Weaponmu sekarang adalah '), write(X), nl, drop(Ammo),drop(Ammo), !.
use(X) :- 
	armor(X,_),
	inventory(X),
	equipped_armor(none),
	retract(equipped_armor(none)), 
	retract(inventory(X)),
	asserta(equipped_armor(X)), 
	write('Armormu sekarang adalah '), write(X), nl, !.
use(X) :- 
	armor(X,_), 
	inventory(X),  
	equipped_armor(Y),
	findall(A,inventory(A),B),
	panjang(B,N),
	findall(C,inventory(_,C),D),
	panjang(D,M),
	M+N < 5,
	retract(equipped_armor(Y)), 
	retract(inventory(X)),
	asserta(equipped_armor(X)),
	asserta(inventory(Y)),
	write('Armormu sekarang adalah '), write(X), nl, !.
use(X) :- 
	armor(X,_), 
	inventory(X),  
	equipped_armor(Y),
	findall(A,inventory(A),B),
	panjang(B,N),
	findall(C,inventory(_,C),D),
	panjang(D,M),
	M+N > 4,
	retract(inventory(X)),
	retract(equipped_armor(Y)), 
	asserta(equipped_armor(X)),
	asserta(inventory(Y)), write('Inventory penuh. '),drop(Y),
	write('Armormu sekarang adalah '), write(X), nl, !.
use(X) :-
	medicine(X,_),
	health(A),
	A=:=100,
	write('health masih full, tidak bisa ditambah'), !, fail.
use(X) :-
	medicine(X,Y),
	inventory(X),
	health(A),
	A+Y>=100,
	retract(inventory(X)),
	retract(health(A)),
	asserta(health(100)),
	write('health berhasil ditambah, health anda sekarang adalah 100'),!.
use(X) :-
	medicine(X,Y),
	inventory(X),
	health(A),
	A+Y<100,
	Z is A + Y,
	retract(inventory(X)),
	retract(health(A)),
	asserta(health(Z)),
	write('health berhasil ditambah, health anda sekarang adalah '), write(Z),!.
/*use ammo*/
use(X) :-
	ammo(X,Weapon),
	inventory(X,_),
	equipped_weapon(Weapon,Bykammo),
	Bykammo =:= 6,
	write('Slot ammo pada '), write(Weapon), write(' sudah full, tidak dapat melakukan reload!'), nl, !, fail.
use(X) :- 
	ammo(X,Weapon),
	inventory(X,N),
	equipped_weapon(Weapon,Bykammo),
	Bykammo >= 0,Bykammo < 4, Z is N+Bykammo,
	retract(inventory(X,N)),
	retract(equipped_weapon(Weapon,Bykammo)),
	asserta(equipped_weapon(Weapon,Z)), !.	
use(X) :- 
	ammo(X,Weapon),
	inventory(X,N),
	equipped_weapon(Weapon,Bykammo),
	Bykammo >3,Bykammo < 6,
	Z is 6 - Bykammo, Z >0, Y is 3 - Z,
	retract(inventory(X,N)), asserta(inventory(X,Y)),
	retract(equipped_weapon(Weapon,Bykammo)),
	asserta(equipped_weapon(Weapon,Z)), !.	
use(X) :-
	ammo(X,_),	
	\+inventory(X,_),
	write('Tidak ada '), write(X), write(' dalam inventory'), nl , !, fail.
use(X) :-
	ammo(X,Weapon),
	inventory(X,_),
	equipped_weapon(Y,_), Y \= Weapon,
	write(X), write(' bukan merupakan ammo dari '), write(Y), nl, !, fail.
use(X) :-
	\+inventory(X),
	write('Tidak ada '), write(X), write(' dalam inventory.'), nl, !, fail.


/*fungsi unequip*/
unequip(none) :- !,fail.
unequip(hand) :- !,fail.
unequip(X) :- equipped_weapon(Y,_), equipped_armor(Z), X \= Y, X \= Z, write('kamu sedang tidak menggunakan '),write(X),!,fail.
unequip(X) :-
	equipped_weapon(X,Z), Z =:=0, 
	findall(A,inventory(A),B),
	panjang(B,N),
	findall(C,inventory(_,C),D),
	panjang(D,M),
	M+N =< 4, 
	retract(equipped_weapon(X,Z)), 
	asserta(equipped_weapon(hand,0)),  
	asserta(inventory(X)),!.
unequip(X) :- 
	equipped_weapon(X,Z), Z =:=0, 
	findall(A,inventory(A),B),
	panjang(B,N),
	findall(C,inventory(_,C),D),
	panjang(D,M),
	M+N > 4,
	retract(equipped_weapon(X,Z)), 
	asserta(equipped_weapon(hand,0)),
	asserta(inventory(X)), write('Inventory penuh. '),
	drop(X),!.
unequip(X) :- 
	equipped_weapon(X,Z), Z > 0, Z <4, ammo(Ammo,X), 
	findall(A,inventory(A),B),
	panjang(B,N),
	findall(C,inventory(_,C),D),
	panjang(D,M),
	M+N < 4, 
	retract(equipped_weapon(X,Z)), 
	asserta(equipped_weapon(hand,0)),  
	asserta(inventory(X)), asserta(inventory(Ammo,Z)),!.
unequip(X) :- 
	equipped_weapon(X,Z), Z > 0, Z <4, ammo(Ammo,X), 
	findall(A,inventory(A),B),
	panjang(B,N),
	findall(C,inventory(_,C),D),
	panjang(D,M),
	M+N =:= 4, 
	retract(equipped_weapon(X,Z)), 
	asserta(equipped_weapon(hand,0)),  
	asserta(inventory(X)), asserta(inventory(Ammo,Z)),write('Inventory penuh. '),
	drop(Ammo),!.
unequip(X) :- 
	equipped_weapon(X,Z), Z > 0, Z <4, ammo(Ammo,X), 
	findall(A,inventory(A),B),
	panjang(B,N),
	findall(C,inventory(_,C),D),
	panjang(D,M),
	M+N >= 5,
	retract(equipped_weapon(X,Z)), 
	asserta(equipped_weapon(hand,0)),
	asserta(inventory(X)), asserta(inventory(Ammo,Z)), write('Inventory penuh. '),
	drop(X),drop(Ammo),!.
unequip(X) :- 
	equipped_weapon(X,Z), Z >3, ammo(Ammo,X), 
	findall(A,inventory(A),B),
	panjang(B,N),
	findall(C,inventory(_,C),D),
	panjang(D,M),
	M+N < 3, 
	retract(equipped_weapon(X,Z)), 
	asserta(equipped_weapon(hand,0)), Sisa is Z-3, 
	asserta(inventory(X)), asserta(inventory(Ammo,3)),asserta(inventory(Ammo,Sisa)),!.
unequip(X) :- 
	equipped_weapon(X,Z), Z >3, ammo(Ammo,X), 
	findall(A,inventory(A),B),
	panjang(B,N),
	findall(C,inventory(_,C),D),
	panjang(D,M),
	M+N =:= 3, 
	retract(equipped_weapon(X,Z)), 
	asserta(equipped_weapon(hand,0)), Sisa is Z-3,
	asserta(inventory(X)), asserta(inventory(Ammo,3)),asserta(inventory(Ammo,Sisa)),write('Inventory penuh. '),
	drop(Ammo),!.
unequip(X) :- 
	equipped_weapon(X,Z), Z >3, ammo(Ammo,X), 
	findall(A,inventory(A),B),
	panjang(B,N),
	findall(C,inventory(_,C),D),
	panjang(D,M),
	M+N =:= 4, 
	retract(equipped_weapon(X,Z)), 
	asserta(equipped_weapon(hand,0)), Sisa is Z-3,
	asserta(inventory(X)), asserta(inventory(Ammo,3)),asserta(inventory(Ammo,Sisa)),write('Inventory penuh. '),
	drop(Ammo),drop(Ammo),!.
unequip(X) :- 
	equipped_weapon(X,Z), Z >3, ammo(Ammo,X), 
	findall(A,inventory(A),B),
	panjang(B,N),
	findall(C,inventory(_,C),D),
	panjang(D,M),
	M+N >= 5,
	retract(equipped_weapon(X,Z)), 
	asserta(equipped_weapon(hand,0)), Sisa is Z-3,
	asserta(inventory(X)), asserta(inventory(Ammo,3)), asserta(inventory(Ammo,Sisa)), write('Inventory penuh. '),
	drop(X),drop(Ammo),drop(Ammo),!.
unequip(X) :- 
	equipped_armor(X), 
	retract(equipped_armor(X)), 
	asserta(equipped_armor(none)),
	findall(A,inventory(A),B),
	panjang(B,N),
	findall(C,inventory(_,C),D),
	panjang(D,M),
	M+N =< 5, 
	asserta(inventory(X)),!.
unequip(X):-
	equipped_armor(X), 
	retract(equipped_armor(X)), 
	asserta(equipped_armor(none)),
	findall(A,inventory(A),B),
	panjang(B,N),
	findall(C,inventory(_,C),D),
	panjang(D,M),
	M+N > 4,  asserta(inventory(X)), write('Inventory penuh. '),
	drop(X),!.

/* fungsi attack */
attack :- 
	player_at(X,Y),
	\+enemy_at(_,X,Y),
	write('Tidak ada musuh dalam jarak yang dekat!'), !, fail.
attack :- 
	player_at(X,Y),
	enemy_at(NomorEnemy,X,Y),
	enemy(NomorEnemy,_,_,WeaponEnemy), 
	equipped_weapon(Weapon,JlhAmmo),
	weapon(Weapon,_,AmmoNeeded),
	JlhAmmo < AmmoNeeded,
	write('Ammo tidak cukup! '),nl, 
	write('Musuh menyerang kembali!'),nl,
	health(Health), equipped_armor(NamaArmor), armor(NamaArmor,Armor), weapon(WeaponEnemy,DmgEnemy,_),
	calculate_health(Health,Armor,DmgEnemy),
	health(NewHealth),
	write('Health kamu tinggal '), write(NewHealth), nl,!.

attack :- 
	player_at(X,Y), 
	enemy_at(NomorEnemy,X,Y),
	enemy(NomorEnemy,HealthEnemy,ArmorEnemy,_),
	equipped_weapon(Weapon,JlhAmmo),
	weapon(Weapon,Dmg,AmmoNeeded),
	JlhAmmo >= AmmoNeeded,
	C is JlhAmmo-AmmoNeeded, C =< 0, retract(equipped_weapon(Weapon,JlhAmmo)), asserta(equipped_weapon(Weapon,0)),
	calculate_damage(NomorEnemy,HealthEnemy,ArmorEnemy,Dmg),
	write('Kamu menyerang musuh dengan '), write(Weapon), write('. '), nl,
	write('Health musuh tersisa '),
	enemy(NomorEnemy,B,_,_),
	write(B), nl,
	counter_attack(NomorEnemy),!.

attack :- 
	player_at(X,Y), 
	enemy_at(NomorEnemy,X,Y),
	enemy(NomorEnemy,HealthEnemy,ArmorEnemy,_),
	equipped_weapon(Weapon,JlhAmmo),
	weapon(Weapon,Dmg,AmmoNeeded),
	JlhAmmo >= AmmoNeeded,
	C is JlhAmmo-AmmoNeeded, C > 0,retract(equipped_weapon(Weapon,JlhAmmo)), asserta(equipped_weapon(Weapon,C)), 
	calculate_damage(NomorEnemy,HealthEnemy,ArmorEnemy,Dmg),
	write('Kamu menyerang musuh dengan '), write(Weapon), write('. '), nl,
	write('Health musuh tersisa '),
	enemy(NomorEnemy,B,_,_),
	write(B), nl,
	counter_attack(NomorEnemy),!.

/* counter_attack (BELUM LENGKAP): musuh melakukan attack pada player jika musuh diserang, atau musuh mati setelah diserang */
counter_attack(NomorEnemy) :-
	enemy(NomorEnemy,HealthEnemy,_,WeaponEnemy),
	HealthEnemy > 0,
	health(Health), equipped_armor(NamaArmor),
	armor(NamaArmor,Armor), weapon(WeaponEnemy,DmgEnemy,_),
	write('Musuh menyerang kembali!'),nl,
	calculate_health(Health,Armor,DmgEnemy),
	health(NewHealth),
	write('Health kamu tinggal '), write(NewHealth), nl,!.
counter_attack(NomorEnemy) :- /* musuh tidak memakai senjata atau armor */ 
	enemy(NomorEnemy,HealthEnemy,0,hand),
	HealthEnemy =:= 0,
	write('Musuh telah mati! '),nl,
	enemy_at(NomorEnemy,X,Y),
	retract(enemy_at(NomorEnemy,X,Y)),
	retract(enemy(NomorEnemy,HealthEnemy,0,hand)),
	write('Namun musuh tidak memiliki apa-apa.'),nl,!.
counter_attack(NomorEnemy) :- /* musuh tidak memakai armor namun pakai weapon berammo*/ 
	enemy(NomorEnemy,HealthEnemy,0,WeaponEnemy),
	HealthEnemy =:= 0,
	WeaponEnemy \= hand,
	weapon(WeaponEnemy,_,JlhAmmo), JlhAmmo \= 0,
	ammo(NamaAmmo,WeaponEnemy),
	write('Musuh telah mati! '),nl,
	enemy_at(NomorEnemy,X,Y),
	retract(enemy_at(NomorEnemy,X,Y)),
	retract(enemy(NomorEnemy,HealthEnemy,0,WeaponEnemy)),
	asserta(item_at(weapon,WeaponEnemy,X,Y)),
	asserta(item_at(ammo,NamaAmmo,X,Y,3)),
	write('Musuh telah menjatuhkan inventorynya:'),nl,
	konso([WeaponEnemy],[NamaAmmo],List1),
	write(List1),nl,check_win,!.
counter_attack(NomorEnemy) :- /* musuh tidak memakai senjata */ 
	enemy(NomorEnemy,HealthEnemy,ArmorEnemy,hand),
	HealthEnemy =:= 0,
	ArmorEnemy \= 0,
	armor(NamaArmor,ArmorEnemy),
	write('Musuh telah mati! '),nl,
	enemy_at(NomorEnemy,X,Y),
	retract(enemy_at(NomorEnemy,X,Y)),
	retract(enemy(NomorEnemy,HealthEnemy,ArmorEnemy,hand)),
	write('Musuh telah menjatuhkan inventorynya:'),nl,
	konso([NamaArmor],[],List1),
	write(List1),nl,check_win,!.
counter_attack(NomorEnemy) :- /* musuh memakai senjata yang tidak pakai ammo */ 
	enemy(NomorEnemy,HealthEnemy,ArmorEnemy,WeaponEnemy),
	HealthEnemy =:= 0,
	write('Musuh telah mati! '),nl,
	enemy_at(NomorEnemy,X,Y),
	retract(enemy_at(NomorEnemy,X,Y)),
	retract(enemy(NomorEnemy,HealthEnemy,ArmorEnemy,WeaponEnemy)),
	weapon(WeaponEnemy,_,0),
	asserta(item_at(armor,ArmorEnemy,X,Y)),
	armor(NamaArmor,ArmorEnemy),
	asserta(item_at(weapon,WeaponEnemy,X,Y)),
	write('Musuh telah menjatuhkan inventorynya:'),nl,
	konso([WeaponEnemy],[NamaArmor],List1),
	write(List1),nl,check_win,!.
counter_attack(NomorEnemy) :- /* atribut musuh lengkap */
	enemy(NomorEnemy,HealthEnemy,ArmorEnemy,WeaponEnemy),
	HealthEnemy =:= 0,
	write('Musuh telah mati! '),nl,
	enemy_at(NomorEnemy,X,Y),
	retract(enemy_at(NomorEnemy,X,Y)),
	retract(enemy(NomorEnemy,HealthEnemy,ArmorEnemy,WeaponEnemy)),
	asserta(item_at(armor,ArmorEnemy,X,Y)),
	armor(NamaArmor,ArmorEnemy),
	asserta(item_at(weapon,WeaponEnemy,X,Y)),
	ammo(NamaAmmo,WeaponEnemy),
	asserta(item_at(ammo,NamaAmmo,X,Y,3)),
	write('Musuh telah menjatuhkan inventorynya:'),nl,
	konso([WeaponEnemy],[NamaArmor],List1), konso(List1,[NamaAmmo],List2),
	write(List2),nl,check_win,!.

/*calculate_health*/

calculate_health(Health,Armor,Dmg) :-
	X is Dmg - Armor, X > 0,
	Y is Health - X, Y =< 0,
	Z is 0,
	retract(health(Health)),
	asserta(health(Z)),!,
	write('Health kamu sekarang 0. Kamu mati diserang musuh.'),nl,
	end_game.

calculate_health(Health,Armor,Dmg) :-
	X is Dmg - Armor, X > 0,
	Y is Health - X,
	retract(health(Health)),
	asserta(health(Y)),!.

calculate_health(_,Armor,Dmg) :-
	X is Dmg - Armor, X =< 0,!.


/* fungsi calculate_damage: menghitung damage yang dilakukan kepada musuh */
calculate_damage(NomorEnemy,Health,Armor,Dmg) :- 
	X is Dmg - Armor,
	X > 0, 
	Y is Health - X, 
	Y =< 0,
	retract(enemy(NomorEnemy,Health,Armor,WeaponEnemy)),
	asserta(enemy(NomorEnemy,0,Armor,WeaponEnemy)),!.

calculate_damage(NomorEnemy,Health,Armor,Dmg) :-  
	X is Dmg - Armor, 
	X > 0, 
	Y is Health - X, 
	Y > 0,
	retract(enemy(NomorEnemy,Health,Armor,WeaponEnemy)),
	asserta(enemy(NomorEnemy,Y,Armor,WeaponEnemy)),!.

calculate_damage(_,_,Armor,Dmg) :-  
	X is Dmg - Armor,
	X =< 0,nl, 
	write('Armor musuh terlalu kuat! '),!.

check_win :-
	findall(A,enemy_at(A,_,_),List1),
	panjang(List1,B), B \= 0,!.
check_win :- 
	findall(A,enemy_at(A,_,_),List1),
	panjang(List1,B), B =:= 0,
	write('***** Kamu Menang *****'),halt.

end_game :- write('***** Game Over *****'), halt.