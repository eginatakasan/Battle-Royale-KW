/* Data Test*/
health(100).
weapon(ak47,50,2).
armor(vest,20).
ammo(ak47_ammo,ak47,10).
medicine(bandage,15).
equipped_weapon(ak47).
inventory(['bandage','ak47_ammo','helmet']).

save(F) :-  open('save_file.pl',write,Stream),
            health(X),write(Stream,health(X)),write(Stream,'.'), nl(Stream),
            armor(A,Y),write(Stream,armor(A,Y)),write(Stream,'.'),nl(Stream),
            weapon(Z,D,E),write(Stream,weapon(Z,D,E)),write(Stream,'.'),nl(Stream),
            ammo(B,C,S),write(Stream,ammo(B,C,S)),write(Stream,'.'),nl(Stream),  /*Asumsi ammo terdiri dari 3 param */
            inventory([H|T]),write(Stream,inventory([H|T])),write(Stream,'.'),nl(Stream),
            close(Stream).

load(X) :- consult('save_file.pl'),['save_file'].