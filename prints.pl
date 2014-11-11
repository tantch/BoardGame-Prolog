printElement(0,'+').
printElement(1,'W').
printElement(2,'B').
printLine([X|Xs],H,T):-
        H < T-1,
        H1 is H+1,
        printElement(X,Y),
        write(Y),
        write('---'),
        printLine(Xs,H1,T).

printLine([X|_],H,T):- 

        T1 is T -1, 
        H >= T1,
        printElement(X,Y),
        write(Y).

printHorDash(H,T):-
        H<T,
        write('|   '),
        H1 is H+1,
        printHorDash(H1,T).
printHorDash(T,T).

printTopNumbers(H,T):-
        H<10,!,
        write(' '),write(H),write('  '),
        H1 is H+1,
        printTopNumbers(H1,T);
        H<T,
        write(H),write('  '),
        H1 is H+1,
        printTopNumbers(H1,T).
printTopNumbers(T,T).
printBoard(B):-
        length(B,T),
        write('      '),
        printTopNumbers(0,T),nl,
        write('                      black\n'),
        printBoard(B,0,T),
        write('      '),
        printTopNumbers(0,T),nl,
        write('                      black\n').      

printBoard([X|Bs],H,T):-
        T1 is T/2,
        T2 is T1 -1,
        H >T2,
        H =< T1,
        H1 is H+1, 
        write('white  '),
        printLine(X,0,T),
        write('  '),
        write(H),
        write('  white'),
        write('\n'),
        write('       '),
        printHorDash(0,T),nl,
        printBoard(Bs,H1,T).
printBoard([X|Bs],H,T):-
        T1 is T-1,
        H<T1,
        H1 is H+1,
        write('       '),
        printLine(X,0,T),
        write('  '),
        write(H),
        write('\n'),
        write('       '),
        printHorDash(0,T),nl,
        printBoard(Bs,H1,T).
printBoard([X|_],H,T):-
        T1 is T-2,  
        H>T1,
        write('       '),
        printLine(X,0,T),
        write('  '),
        write(H),
        write('\n').
printMenu:-
        write('/===========================================\\\n'),
        write('|                                           |\n'),
        write('|                 WhirlWind                 |\n'),
        write('|                                           |\n'),
        write('|                                           |\n'),
        write('|     1. Player vs Player                   |\n'),
        write('|     2. Player vs Computer                 |\n'),
        write('|     3. Computer vs Computer               |\n'),
        write('|                                           |\n'),
        write('|                                           |\n'),
        write('|                                           |\n'),
        write('|                                           |\n'),
       write('\\===========================================/\n').