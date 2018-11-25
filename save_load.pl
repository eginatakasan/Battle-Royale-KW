/* Data Test*/

/*health(100).
armor(vest,20).
weapon(ak47,50,2).
inventory(['medicine','pistol','pistol_ammo']).
ammo(none,none,none).
enemy_at(1,10,2).
enemy_at(2,5,4).
player_at(5,5).
item_at(type,name,x,y).
item_at(type1,name1,x1,y1).
item_at(typeammo,nameammo,x,y,nb).
item_at(typeammo1,nameammo1,x1,y1,nb1).*/


save :-     open('save_file.txt',write,Stream),
            player_at(PosPX,PosPY),write(Stream,player_at(PosPX,PosPY)),write(Stream,'.'),nl(Stream),
            timer(I),write(Stream,timer(I)),write(Stream,'.'),nl(Stream),
            health(X),write(Stream,health(X)),write(Stream,'.'), nl(Stream),
            equipped_weapon(D,E),write(Stream,equipped_weapon(D,E)),write(Stream,'.'),nl(Stream),
            equipped_armor(A),write(Stream,armor(A)),write(Stream,'.'),nl(Stream),
            forall(inventory(H),(write(Stream,inventory(H)),write(Stream,'.'),nl(Stream))),
            forall(inventory(I,J),(write(Stream,inventory(I,J)),write(Stream,'.'),nl(Stream))),
            forall(enemy_at(G,PosEX,PosEY),(write(Stream,enemy_at(G,PosEX,PosEY)),write(Stream,'.'),nl(Stream))),
            forall(enemy(K,X1,Y1,Z1),(write(Stream,enemy(K,X1,Y1,Z1)),write(Stream,'.'),nl(Stream))),
            forall(item_at(Type,Name,PosIX,PosIY),(write(Stream,item_at(Type,Name,PosIX,PosIY)),write(Stream,'.'),nl(Stream))),
            forall(item_at(TypeAmmo,NameAmmo,PosIAX,PosIAY,Nb),(write(Stream,item_at(TypeAmmo,NameAmmo,PosIAX,PosIAY,Nb)),write(Stream,'.'),nl(Stream))),
            write(Stream,'end'),write(Stream,'.'),nl(Stream),
            close(Stream).

load:- 
		open('save_file.txt',read,File),
		retractall(player_at(_,_)),
		retractall(timer(_)),
		retractall(health(_)),
		retractall(is_deadzone(_,_)),
		retractall(enemy_at(_,_)),
		retractall(item_at(_,_)),
		retractall(inventory(_)),
		retractall(inventory(_,_)),
		retractall(equipped_weapon(_,_)),
		retractall(enemy(_,_,_,_)),
		reading(File),
		asserta( (is_deadzone(X,_) :- X =:= 15) ),
		asserta( (is_deadzone(X,_) :- X =:= 0)),
		asserta( (is_deadzone(_,Y) :- Y =:= 15)),
		asserta( (is_deadzone(_,Y) :- Y =:= 0)),
		timer(Time),
		A is 1,
		make_deadzone(A,Time).

reading(File):- 
		read(File,A),
		check_end(A,File).

make_deadzone(X,X):-!.
make_deadzone(A,X):-
	Z is A mod 7,
	Z =:= 0,
	V is X / 7,
	shrink_map(V),
	B is A+1,
	make_deadzone(B,X),!.
make_deadzone(A,X):-
	Z is A mod 7,
	Z \=0,
	B is A+1,
	make_deadzone(B,X),!.

check_end(end,_):-!.
check_end(A,File):-
		A \= end,
		assertz(A),
		reading(File).



		

