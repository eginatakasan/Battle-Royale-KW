save(X) :- open('save_file.pl',write,Stream),health(X), armor(_,Y), equipped_weapon(Z), ammo(_,_,S),inventory(T),write(health(X)),write(Stream,armor(_,Y)), write(Stream,equipped_weapon(Z)),write(Stream,ammo(_,_,S)),write(Stream,inventory(T)).

load(X) :- consult('save_file.pl'),['save_file'].

status :- health(X), equipped_armor(NamaArmor),armor(NamaArmor,Y), equipped_weapon(Z,S), write('Health: '),write(X),nl, write('Armor: '), write(Y),nl,write('Weapon: '),write(Z),nl,write('Ammo: '),write(S),nl,write('Inventory:'),nl,lihatinv,nl.
