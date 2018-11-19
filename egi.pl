/* Compiler: GNU Prolog */
/* :-dynamic diperlukan untuk buat fakta yang bisa diubah */
/* retract artinya menghapus fakta atau rule dari database */
/* asserta artinya menambah fakta atau rule dari database ditaruh di awal database*/
/* assertz artinya menambah fakta atau rule dari database ditaruh di akhir database*/
:- dynamic(player_at/2).
:- dynamic(is_deadzone/2).
:- dynamic(timer/1).
:- dynamic(inventory/1).
:- dynamic(equipped_weapon/1).
:- dynamic(equipped_armor/1).
:- dynamic(item_at/4).
:- dynamic(health/1).
:- dynamic(ammo/3).

/* Deklarasi fakta statik (sementara selagi belum ada fungsi spawn) */

/* enemy_at(nomor enemy(enemy ke berapa), koordinat X, koordinat Y) */
enemy_at(1,2,2).

/*deklarasi item*/
item(weapon,ak47).
item(weapon,pistol).
item(weapon,ayam).
item(weapon,frying_pan).
item(weapon,shotgun).
item(weapon,hand).
item(armor,helmet).
item(armor,shoes).
item(armor,vest).
item(medicine,medicine).
item(ammo,ak47_ammo).
item(ammo,pistol_ammo).
item(shotgun_ammo,ammo).

/*deklarasi list barang (statik)*/
/*weapon(nama,kekuatan,byk ammo)*/
weapon(ak47,50,2).
weapon(pistol,35,1).
weapon(ayam,25,0).
weapon(frying_pan,30,0).
weapon(shotgun,60,3).
weapon(hand,10,0).
armor(helmet,10).
armor(shoes,5).
armor(vest,20).
medicine(medicine,20).
ammo(ak47_ammo,ak47).
ammo(pistol_ammo,pistol).
ammo(shotgun_ammo,shotgun).

/* item_at(jenis item, nama item, koordinat X, koordinat Y) */
/* yang termasuk item: weapon, medicine, armor, ammo */
item_at(ammo,pistol_ammo,2,3).
item_at(ammo,ak47_ammo,2,4).
item_at(weapon,pistol,3,4).
item_at(armor,shoes,3,5).
item_at(medicine,medicine,3,2).


/* Deklarasi fakta dinamik */
player_at(3,3).
timer(1).
equipped_weapon(hand).
health(70).
ammo(ak47_ammo,ak47,1). /*ammo(nama ammo, senjata, jumlah ammo)*/
enemy(1,100,20,ak47). /*enemy(NomorEnemy,HealthEnemy,ArmorEnemy,WeaponEnemy) */

/* Deklarasi rules */

/*fungsi map*/
map :- drawmap(15,15).

/* help */
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

/* Fungsi Start */
start :-
		write('Selamat datang di permainan PUBG ecek-ecek.'),
		write('\nKetik help. untuk melihat command yang tersedia dan ketik map. untuk melihat kondisi kamu sekarang.\n'),
		help,
		map.

/*fungsi quit*/
quit :- end_game.
end_game :- write('***** Game Over *****'), halt.

/*fungsi save*/

/*fungsi load*/

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


/*fungsi update: mengupdate timer dan memperkecil safe zone tiap 7 gerakan*/
update :-
	timer(X),
	Z is X mod 7,
	Z =:= 0,
	Y is X+1,
	V is X / 7,!,
	shrink_map(V),
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
	N<5,
	player_at(Y,Z),
 	item_at(M,_,Y,Z),
	asserta(inventory(X)),
	retract(item_at(M,X,Y,Z)),
	write(X), write(' diambil'), !. 
take(X) :- 
	findall(A,inventory(A),B), 
	panjang(B,N), 
	N>4, 
	write('Inventory sudah penuh.'), nl, !, fail.
take(X) :-
	write('Tidak ada '), write(X), write(' di lokasi ini'), nl, !, fail.

/*untuk melihat list inventory*/
lihatinv :- findall(A,inventory(A),Inv), write(Inv),nl,!.

/*fungsi drop*/
drop(X) :- 
	inventory(X), 
	retract(inventory(X)), 
	item(A,X),
	player_at(Y,Z),
	assertz(item_at(A,X,Y,Z)),
	write(X), write(' telah dijatuhkan.'), !.
drop(X) :- 
	\+inventory(X), 
	write(X), write(' tidak ada di inventory'), nl, !, fail.

/*fungsi use*/
use(X) :- 
	weapon(X,_,_), 
	inventory(X),
	retract(inventory(X)),
	equipped_weapon(Y),
	Y == hand,
	asserta(equipped_weapon(X)),
	write('Weaponmu sekarang adalah '), write(X), nl, !.
use(X) :- 
	weapon(X,_,_), 
	inventory(X),
	retract(inventory(X)),
	equipped_weapon(Y),
	retract(equipped_weapon(Y)),
	asserta(equipped_weapon(X)),
	asserta(inventory(Y)), 
	write('Weaponmu sekarang adalah '), write(X), nl, !.
use(X) :- 
	weapon(X,_,_), 
	\+inventory(X), 
	write('Tidak ada '), write(X), write(' dalam inventory.'), nl, !, fail.
use(X) :- 
	armor(X,_),
	inventory(X),
	findall(A,equipped_armor(A),B),
	panjang(B,N),
	N=0,
	retract(inventory(X)),
	asserta(equipped_armor(X)), 
	write('Armormu sekarang adalah '), write(X), nl, !.
use(X) :- 
	armor(X,_), 
	inventory(X), 
	retract(inventory(X)), 
	equipped_armor(Y),
	retract(equipped_armor(Y)), 
	asserta(equipped_armor(X)),
	asserta(inventory(Y)),
	write('Armormu sekarang adalah '), write(X), nl, !.
use(X) :- 
	armor(X,_), 
	\+inventory(X), 
	write('Tidak ada '), write(X), write(' dalam inventory.'), nl, !, fail.
use(X) :-
	medicine(X,B),
	inventory(X),
	health(A),
	A=100,
	write('health masih full, tidak bisa ditambah'), !, fail.
use(X) :-
	medicine(X,_),
	inventory(X),
	health(A),
	A+30>=100,
	retract(inventory(X)),
	retract(health(M)),
	asserta(health(100)),
	write('health berhasil ditambah, health anda sekarang adalah 100'),!.
use(X) :-
	medicine(X,_),
	inventory(X),
	health(A),
	A+30<100,
	Z is A + 30,
	retract(inventory(X)),
	retract(health(M)),
	asserta(health(Z)),
	write('health berhasil ditambah, health anda sekarang adalah'), write(Z),!.
use(X) :-
	medicine(X,B),
	\+inventory(X),
	write('Tidak ada '), write(X), write(' dalam inventory.'), nl, !, fail.

/*fungsi unequip*/
unequip(none) :- !.
unequip(hand) :- !.
unequip(X) :- equipped_weapon(Y), equipped_armor(Z), X \= Y, X \= Z, write('kamu sedang tidak menggunakan '),write(X),!.
unequip(X) :- equipped_weapon(X), retract(equipped_weapon(X)), asserta(equipped_weapon(hand)), asserta(inventory(X)), drop(X),!.
unequip(X) :- equipped_armor(X), retract(equipped_armor(X)), asserta(equipped_armor(none)), asserta(inventory(X)), drop(X),!.

/*fungsi attack (belum lengkap)*/
attack :- 
	player_at(X,Y),
	enemy_at(NomorEnemy,A,B),
	X \=A, Y \=B, write('Tidak ada musuh dalam jarak yang dekat!'),!.

attack :- 
	player_at(X,Y),
	enemy_at(NomorEnemy,X,Y),
	equipped_weapon(Weapon),
	weapon(Weapon,_,AmmoNeeded),
	inventory(Ammo),
	ammo(Ammo,Weapon,JlhAmmo),
	JlhAmmo < AmmoNeeded,write('Ammo tidak cukup!'),!.

attack :- 
	player_at(X,Y), health(Health),
	enemy_at(NomorEnemy,X,Y),
	enemy(NomorEnemy,HealthEnemy,ArmorEnemy,WeaponEnemy),
	equipped_armor(Armor),
	equipped_weapon(Weapon),
	weapon(Weapon,Dmg,AmmoNeeded),
	weapon(WeaponEnemy,DmgEnemy,_),
	inventory(Ammo), ammo(Ammo,Weapon,JlhAmmo),
	JlhAmmo >= AmmoNeeded,
	write('Kamu menyerang musuh dengan '), write(Weapon), write('. '),
	calculate_damage(NomorEnemy,HealthEnemy,ArmorEnemy,Dmg),
	write('Health musuh tersisa '), 
	enemy(NomorEnemy,B,_,_),
	write(B),!.

/* fungsi calculate_damage: menghitung damage yang dilakukan kepada musuh */
calculate_damage(NomorEnemy,Health,Armor,Dmg) :- 
	X is Dmg - Armor,
	X > 0, 
	Y is Health - X, 
	Y =< 0,
	retract(enemy(NomorEnemy,Health,Armor,WeaponEnemy)),
	asserta(enemy(NomorEnemy,100,Armor,WeaponEnemy)),!.

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
