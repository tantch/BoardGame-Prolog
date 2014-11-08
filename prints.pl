printElement(0,'+').
printElement(1,'W').
printElement(2,'B').
printLine([X|Xs],H):- 
        H < 13,
        H1 is H+1,
        printElement(X,Y),
        write(Y),
        write('--'),
        printLine(Xs,H1).

printLine([X|_],H):- 
        H > 12,
        printElement(X,Y),
        write(Y).

printBoard(B):-
        write('       0  1  2  3  4  5  6  7  8  9  10 11 12 13\n'),
        write('                      black\n'),
        printBoard(B,0),
        write('                      black\n').      

printBoard([X|Bs],H):-
        H<13,
        H \=6,
        H1 is H+1,
        write('       '),
        printLine(X,0),
        write('  '),
        write(H),
        write('\n'),
        write('       '),
        write('|  |  |  |  |  |  |  |  |  |  |  |  |  |\n'),
        printBoard(Bs,H1).
printBoard([X|Bs],H):-
        H==6,
        H1 is H+1, 
        write('white  '),
        printLine(X,0),
        write('  '),
        write(H),
        write('  white'),
        write('\n'),
        write('       '),
        write('|  |  |  |  |  |  |  |  |  |  |  |  |  |\n'),
        printBoard(Bs,H1).
printBoard([X|_],H):-  
        H>12,
        write('       '),
        printLine(X,0),
        write('  '),
        write(H),
        write('\n').