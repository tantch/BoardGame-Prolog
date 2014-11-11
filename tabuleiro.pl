:-consult(prints).


listFullOf(N, [X|Tail],X) :- N > 0, N2 is N-1, listFullOf(N2, Tail,X).
listFullOf(0, [],_).


changeColor(C,Cf):-
        C =:= 1,!,
        Cf is 2;
        C =:= 2,!,
        Cf is 1.
nextLinePrep(F,Fi,C,Cf):-
        F =:= 0,!,
        Cf is C,
        Fi is 3;
        F =:= 1,!,
        Cf is C,
        Fi is 4;
        F =:= 2,!,
        changeColor(C,Cf),
        Fi is 0;
        F =:= 3,!,
        changeColor(C,Cf),
        Fi is 1;
        F =:= 4,!,
        changeColor(C,Cf),
        Fi is 2.


fillColumn(B,B,T,T,_,_,_).
fillColumn(B,Bf,T,Col,F-Ci,Cp,FC):-
        Cp<T,
        placePc(Col-Cp,FC,B,B1),
        Cp1 is Cp+5,
        changeColor(FC,Cf),
        fillColumn(B1,Bf,T,Col,F-Ci,Cp1,Cf).
fillColumn(B,Bf,T,Col,F-Ci,_,_):-
        Col1 is Col +1,
        nextLinePrep(F,Fi,Ci,C1),
        fillColumn(B,Bf,T,Col1,Fi-C1,Fi,C1).
        
        
board(T,Br):-
       listFullOf(T,Rows,0),
       listFullOf(T,B,Rows), 
       F is round(T/2 +1 -8),
       F > -1,!,
       fillColumn(B,Br,T,0,F-1,F,1);
        listFullOf(T,Rows,0),
       listFullOf(T,B,Rows), 
       F is round(T/2 +1 -4),
       F > -1,
       fillColumn(B,Br,T,0,F-2,F,2).
          
       

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
        length(B,T),
        T1 is T-1,
        profundidade([], 0-_Yi, T1-_Yf, _Sol_inv,1,B).
winBlack(B):- 
        length(B,T),
        T1 is T-1,
        profundidade([], _-0, _-T1, _Sol_inv,2,B).

profundidade(Caminho, Xf-Yf, Xf-Yf, [Xf-Yf|Caminho],_C,_B).
profundidade(Caminho, Xi-Yi, Xf-Yf, Sol,C,B):- 
 ligado(Xi-Yi, X2-Y2,C,B),
 \+ membro(X2-Y2, Caminho),
 profundidade([Xi-Yi|Caminho], X2-Y2, Xf-Yf, Sol,C,B). 


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

treatInput(B,X-Y,P-M):-
        length(B,T),
        integer(X),
        integer(Y),
        X<T,
        Y<T,
        isEmpty(X-Y,B),
        placePc(X-Y,P,B,Br),
        validateMove(X-Y,Br,P),!,
        changeColor(P,P1),
        cycle(Br,P1-M);

        write('Invalid input'),nl,
        cycle(B,P-M).
treatInput(B,X1-Y1,X2-Y2,P-M):-
        length(B,T),
        integer(X1),
        integer(Y1),
        integer(X2),
        integer(Y2),
        X1<T,Y1<T,X2<T,Y2<T,
        isEmpty(X1-Y1,B),
        placePc(X1-Y1,P,B,Br),
        isEmpty(X2-Y2,Br),
        placePc(X2-Y2,P,Br,Bf),
        validateMove(X1-Y1,Bf,P),
        validateMove(X2-Y2,Bf,P),
        changeColor(P,P1),
        cycle(Bf,P1-M).
treatInput(B,_,_,P-M):-
        write('Invalid input'),nl,
        cycle(B,P-M).

treatInputType(B,X,P-M):-
        integer(X),
        X>0,
        X<3,
        askInput(B,X,P-M).
treatInputType(B,_,P-M):-
        write('invalid input'),nl,
        cycle(B,P-M).
askInput(B,1,P-M):-
        write('Where do you want to play?(ex: 3-5.)'),nl,
        read(X-Y),nl,
        treatInput(B,X-Y,P-M).
askInput(B,2,P-M):-
         write('Where do you want to play?(ex: 3-5. 4-5.  separete inputs with enter)'),nl,
        read(X1-Y1),nl,
        placePc(X1-Y1,P,B,Bd),printBoard(Bd),
        read(X2-Y2),nl,
        treatInput(B,X1-Y1,X2-Y2,P-M).
askInputType(B,P-M):-
        write('Player '),write(P),write(','),nl,
        write('How many moves do you want to make? (1/2)'),nl,
        read(X),
        treatInputType(B,X,P-M).
startMenu(M,T):-
        printMenu,
        read(M),nl,
        integer(M),
        M>0,
        M<4,
        write('Choose the side of the board: (12-20)\n'),
        read(T),
        integer(T),
        T>11,
        T<20,
        T1 is round(T mod 2),    
        T1 is 0;
        write('invalid input\n'),
        startMenu(M,T).
start:-
        startMenu(M,T),
        board(T,B),!,
        cycle(B,1-M).

%P-n jogador M- modo de jogador 1/2/3(humano/random/ai)
cycle(B,_):-
        winWhite(B),!,
        printBoard(B),
        write('Player 1 (White) wins the game\n Congrats!\n');
        winBlack(B),!,
        printBoard(B),
        write('Player 2 (Black) wins the game\n Congrats!\n').


cycle(B,P-M):-
        printBoard(B),
        askInputType(B,P-M).
        
        
        

