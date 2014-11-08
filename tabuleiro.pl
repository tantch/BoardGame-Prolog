:-consult(prints).

board([[0,1,0,0,0,0,2,2,0,0,0,1,2,0],
      [0,0,0,2,2,0,1,2,1,1,2,2,2,2],
      [2,0,0,1,1,1,1,1,1,1,2,0,0,0],
      [1,1,1,1,2,0,0,2,2,1,2,0,1,1],
      [0,0,0,0,2,0,0,0,0,1,1,1,1,0],
      [0,2,0,2,2,0,1,0,2,1,0,2,0,1],
      [0,0,0,1,0,0,2,2,2,0,0,0,0,1],
      [1,0,0,1,2,2,2,1,0,0,1,0,0,0],
      [0,2,2,1,1,0,2,1,0,0,0,0,2,0],
      [1,0,2,2,1,0,2,0,0,2,0,0,0,0],
      [1,1,1,2,2,2,2,2,0,0,0,1,0,0],
      [0,0,2,2,0,0,0,2,1,0,2,0,2,2], 
      [2,0,1,1,1,1,2,2,0,0,2,0,1,0],
      [1,1,1,0,0,0,0,2,2,0,0,0,1,1]]).

membro(X, [X|_]):- !. 
membro(X, [_|Y]):- membro(X,Y). 
concatena([], L, L). 
concatena([X|Y], L, [X|Lista]):- concatena(Y, L, Lista). 

nth0(0, [Head|_], Head) .

nth0(N, [_|Tail], Elem) :-
    nonvar(N),
    M is N-1,
    nth0(M, Tail, Elem).

nth0(N,[_|T],Item) :-      
    var(N),        
    nth0(M,T,Item),
    N is M + 1.

replace(Val,[H|List],Pos,[H|Res]):- Pos > 0, !, 
                                Pos1 is Pos - 1, replace(Val,List,Pos1,Res). 
replace(Val, [_|List], 0, [Val|List]).
        
placePc(X-Y,C,B,Br):-
        nth0(Y,B,Row),
        replace(C,Row,X,R2),
        replace(R2,B,Y,Br).



element(X1-Y1,C,B):-
       nth0(Y1,B,Row),
       nth0(X1,Row,C).
        

isEmpty(X-Y,B):-
        element(X-Y,0,B).
isBlack(X1-Y1,B):-
        element(X1-Y1,2,B).
isWhite(X1-Y1,B):-
        element(X1-Y1,1,B).
isColor(X1-Y1,C,B):-
        C == 1,
        isWhite(X1-Y1,B).
isColor(X1-Y1,C,B):-
        C == 2,
        isBlack(X1-Y1,B).

ligado(X1-Y1,X2-Y2,C,B):-
        isColor(X1-Y1,C,B),
        isColor(X2-Y2,C,B),
        X1 == X2,
        R is Y2 +1,
        Y1 == R.
ligado(X1-Y1,X2-Y2,C,B):-
        isColor(X1-Y1,C,B),
        isColor(X2-Y2,C,B),
        X1 == X2,
        R is Y2-1,
        Y1 == R.
ligado(X1-Y1,X2-Y2,C,B):-
        isColor(X1-Y1,C,B),
        isColor(X2-Y2,C,B),
        R is X2-1,
        Y1 == Y2,
        X1 == R.
ligado(X1-Y1,X2-Y2,C,B):-
        isColor(X1-Y1,C,B),
        isColor(X2-Y2,C,B),
        R is X2 +1,
        Y1 == Y2,
        X1 == R.


inverte([X], [X]). 
inverte([X|Y], Lista):- inverte(Y, Lista1), concatena(Lista1, [X], Lista). 
winWhite(B):- 
        profundidade([], 0-_Yi, 13-_Yf, _Sol_inv,1,B).
winBlack(B):- 
        profundidade([], 0-_Yi, 13-_Yf, _Sol_inv,2,B).

profundidade(Caminho, Xf-Yf, Xf-Yf, [Xf-Yf|Caminho],_C,_B).
profundidade(Caminho, Xi-Yi, Xf-Yf, Sol,C,B):- 
 ligado(Xi-Yi, X2-Y2,C,B),
 \+ membro(X2-Y2, Caminho),
 profundidade([Xi-Yi|Caminho], X2-Y2, Xf-Yf, Sol,C,B). 


%oneMoveTurn(X-Y,B,P,Bn).
%twoMoveTurn(X1-Y1,X2-Y2,B,P,Bn).

isDiag(X-Y,B,C,Xr-Yr):-
        Xr is X+1,
        Yr is Y+1,
        isColor(Xr-Yr,C,B).
isDiag(X-Y,B,C,Xr-Yr):-
        Xr is X-1,
        Yr is Y+1,
        isColor(Xr-Yr,C,B).
isDiag(X-Y,B,C,Xr-Yr):-
        Xr is X+1,
        Yr is Y-1,
        isColor(Xr-Yr,C,B).
isDiag(X-Y,B,C,Xr-Yr):-
        Xr is X-1,
        Yr is Y-1,
        isColor(Xr-Yr,C,B).
areConnected(_X1-Y1,X2-_Y2,B,C):-
        Xr is X2,
        Yr is Y1,
        isColor(Xr-Yr,C,B).
areConnected(X1-_Y1,_X2-Y2,B,C):-
        Xr is X1,
        Yr is Y2,
        isColor(Xr-Yr,C,B).


validateMove(X-Y,B,C):-
        isDiag(X-Y,B,C,Xr-Yr),
        areConnected(X-Y,Xr-Yr,B,C).
validateMove(X-Y,B,C):-
        \+ isDiag(X-Y,B,C,_).


test:- board(B),printBoard(B).
askInput(1,B):-
        write('Where do you want to play?(ex: 3-5.)'),nl,
        read(X-Y),nl,
        treatInput(1,B,X-Y).
        

treatInput(B,X-Y):-
        length(B,T),
        integer(X),
        integer(Y),
        X<T,
        Y<T,
        isEmpty(X-Y,B),
        placePc(X-Y,1,B,Br),
        validateMove(X-Y,B,1),
        cycle(Br).
treatInput(B,X1-Y1,X2-Y2):-
        length(B,T),
        integer(X1),
        integer(Y1),
        integer(X2),
        integer(Y2),
        X1<T,Y1<T,X2<T,Y2<T,
        isEmpty(X1-Y1,B),
        isEmpty(X2-Y2,B),
        placePc(X1-Y1,1,B,Br),
        placePc(X2-Y2,1,Br,Bf),
        validateMove(X1-Y1,B,1),
        validateMove(X2-Y2,B,1),
        cycle(Bf).
treatInput(_,B,_):-
        write('Invalid input'),nl,
        cycle(B).
start:-
        board(B),
        cycle(B).
cycle(B):-
        printBoard(B),
        askInput(1,B).
        
        

