/* Data Test*/
health(100).
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
item_at(typeammo1,nameammo1,x1,y1,nb1).

save(F) :-  open('save_file.pl',write,Stream),
            health(X),write(Stream,health(X)),write(Stream,'.'), nl(Stream),
            armor(A,Y),write(Stream,armor(A,Y)),write(Stream,'.'),nl(Stream),
            weapon(Z,D,E),write(Stream,weapon(Z,D,E)),write(Stream,'.'),nl(Stream),
            ammo(B,C,S),write(Stream,ammo(B,C,S)),write(Stream,'.'),nl(Stream),  /*Asumsi ammo terdiri dari 3 param */
            inventory([H|T]),write(Stream,inventory([H|T])),write(Stream,'.'),nl(Stream),
            forall(enemy_at(G,PosEX,PosEY),(write(Stream,enemy_at(G,PosEX,PosEY)),write(Stream,'.'),nl(Stream))),
            player_at(PosPX,PosPY),write(Stream,player_at(PosPX,PosPY)),write(Stream,'.'),nl(Stream),
            forall(item_at(Type,Name,PosIX,PosIY),(write(Stream,item_at(Type,Name,PosIX,PosIY)),write(Stream,'.'),nl(Stream))),
            forall(item_at(TypeAmmo,NameAmmo,PosIAX,PosIAY,Nb),(write(Stream,item_at(TypeAmmo,NameAmmo,PosIAX,PosIAY,Nb)),write(Stream,'.'),nl(Stream))),
            close(Stream).

load(X) :- consult('main.pl'),['main'].