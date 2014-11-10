:-consult(prints).

board([[0,1,0,0,0,0,2,2,0,0,0,1,2,0],
      [0,0,1,2,2,0,1,2,1,1,2,2,2,2],
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


isDiag(B,C,Xr-Yr):-
        isColor(Xr-Yr,C,B).
areConnected(_X1-Y1,X2-_Y2,B,C):-
        Xr is X2,
        Yr is Y1,
        isColor(Xr-Yr,C,B).
areConnected(X1-_Y1,_X2-Y2,B,C):-
        Xr is X1,
        Yr is Y2,
        isColor(Xr-Yr,C,B).

validDiag(X-Y,B,C,Xr-Yr):-
        isDiag(B,C,Xr-Yr),
        areConnected(X-Y,Xr-Yr,B,C).
validDiag(_,B,C,Xr-Yr):-
        \+ isDiag(B,C,Xr-Yr).
validateMove(X-Y,B,C):-
        X1 is X-1,
        Y1 is Y-1,
        validDiag(X-Y,B,C,X1-Y1),
        X2 is X+1,
        Y2 is Y-1,
        validDiag(X-Y,B,C,X2-Y2),
        X3 is X+1,
        Y3 is Y+1,
        validDiag(X-Y,B,C,X3-Y3),
        X4 is X-1,
        Y4 is Y+1,
        validDiag(X-Y,B,C,X4-Y4).


test(X1-Y1,X2-Y2):- board(B),printBoard(B),validDiag(X1-Y1,B,1,X2-Y2).

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
treatInput(B,_):-
        write('Invalid input'),nl,
        cycle(B).
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
        validateMove(X1-Y1,Bf,1),
        validateMove(X2-Y2,Bf,1),
        cycle(Bf).
treatInput(B,_,_):-
        write('Invalid input'),nl,
        cycle(B).

treatInputType(B,X):-
        integer(X),
        X>0,
        X<3,
        askInput(X,B).
treatInputType(B,_):-
        write('invalid input'),nl,
        askInputType(B).
askInput(1,B):-
        write('Where do you want to play?(ex: 3-5.)'),nl,
        read(X-Y),nl,
        treatInput(B,X-Y).
askInput(2,B):-
         write('Where do you want to play?(ex: 3-5. 4-5.  separete inputs with enter)'),nl,
        read(X1-Y1),nl,
        read(X2-Y2),nl,
        treatInput(B,X1-Y1,X2-Y2).
askInputType(B):-
        write('How many moves do you want to make? (1/2)'),nl,
        read(X),
        treatInputType(B,X).
        
start:-
        board(B),
        cycle(B).
cycle(B):-
        printBoard(B),
        askInputType(B).
        
        
        

