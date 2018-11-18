/*dynamic kamus*/
:- dynamic(inventory/1).
:- dynamic(equipped_weapon/1).
:- dynamic(equipped_armor/1).
:- dynamic(enemy/4).
:- dynamic(health/1).

health(100).
inventory(chicken).
inventory(ak47_ammo).
equipped_weapon(ak47).
equipped_armor(helmet).
weapon(ak47,50,2).
weapon(pistol,35,1).
weapon(chicken,25,0).
weapon(frying_pan,30,0).
weapon(shotgun,60,3).
weapon(hand,10,0).
ammo(ak47_ammo,ak47,1).
armor(helmet,10).
armor(shoes,5).
armor(vest,20).
enemy(1,100,20,ak47). /*enemy(NomorEnemy,HealthEnemy,ArmorEnemy,WeaponEnemy) */


/* attack: kasus enemy tidak di posisi player */
attack :- 
	player_at(X,Y),
	enemy_at(NomorEnemy,A,B),
	X \=A, Y \=B, write('Tidak ada musuh dalam jarak yang dekat!'),!.

/* attack: kasus ammo tidak cukup */
attack :- 
	player_at(X,Y),
	enemy_at(NomorEnemy,X,Y),
	equipped_weapon(Weapon),
	weapon(Weapon,_,AmmoNeeded),
	inventory(Ammo),
	ammo(Ammo,Weapon,JlhAmmo),
	JlhAmmo < AmmoNeeded,write('Ammo tidak cukup!'),!.

/* attack: kasus ammo cukup dan enemy di posisi player*/
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
