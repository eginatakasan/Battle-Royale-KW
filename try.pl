/* supaya fakta player (2 parameter) bisa diubah */ 
/* kalo mau tau lebih lanjut, google dynamic predicate prolog */
:- dynamic player/2.
:- retractall(player(_,_)).

player(2,2).
map :- drawmap(15,15).
n :- go(n).
e :- go(e).
s :- go(s).
w :- go(w).
look :- player(X,Y),write(X),write(','),write(Y).

drawmap(1,1).
drawmap(X,Y) :- player(U,V),T is 15-U, X =:= T, S is 15-V, S =:= Y, X>0 , Y>0,!,  write('P'), drawmap(X,Y-1).
drawmap(X,Y) :- Y =:= 1, X >0,!, write('X'),nl,!, drawmap(X-1,15),!.
drawmap(X,Y) :- Y =:= 15 ,X >0,!, write('X'), drawmap(X,Y-1),!.
drawmap(X,Y) :- X =:= 15, Y>0, !,write('X'), drawmap(X,Y-1),!.
drawmap(X,Y) :- X =:= 1, Y>0,!,write('X'), drawmap(X,Y-1),!.
drawmap(X,Y) :- X>1,Y>0,!, write('-'), drawmap(X,Y-1).

go(n) :- retract(player(X,Y)), Z is X-1, assert(player(Z,Y)).
go(e) :- retract(player(X,Y)), Z is Y+1, assert(player(X,Z)).
go(s) :- retract(player(X,Y)), Z is X+1, assert(player(Z,Y)).
go(w) :- retract(player(X,Y)), Z is Y-1, assert(player(X,Z)).