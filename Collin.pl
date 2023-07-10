/**************************************************************
 * Name:  Collin Schumacher                                   *
 * Project : Buildup Project Prolog                           *
 * Class : CMPS 366 Organization of Programming Languages     *
 * Date : 4/28/2023                                           *
 **************************************************************/

/**********************************************************************
Function Name: main                             
Purpose: (HANDLES INPUT) welcome user menu and is the 
executer for the game
Parameters: 
            none
Return Value: none
Algorithm:
            1. clear screen 
            2. prompt
            3. get user input 
            4. call game_menu
Assistance Received: I used this link to figure out how to clear the screen
https://stackoverflow.com/questions/53262099/swi-prolog-how-to-clear-terminal-screen-with-a-keyboard-shortcut-or-global-pre
**********************************************************************/
main():-
        tty_clear,
        write("ALL INPUTS MUST END WITH A PERIOD BEFORE HITTING ENTER\n"),
        write("Welcome to Buildup please choose from one of the following options\n"),
        write("1. load a game\n"),
        write("2. Play a new game\n"),
        write("3. Exit Buildup\n"),
        read(Input),
        game_menu(Input).

/**********************************************************************
Function Name: game_menu                             
Purpose: (HANDLES ACTION BASED ON INPUT) welcome user menu
Parameters: 
            Input user input passed by value
Return Value: none
Algorithm:
            1. If Input not 1-3 prompt and recursively call this function
            ELSE
            2. If Input is 1 call load_game
            ELSE
            3. If Input is 2 new_game(0,0)
            OTHERWISE
            4. prompt and terminate
Assistance Received: I used this link to figure out how to clear the screen
https://stackoverflow.com/questions/53262099/swi-prolog-how-to-clear-terminal-screen-with-a-keyboard-shortcut-or-global-pre
**********************************************************************/
game_menu(Input):-
	Input \= 1,
	Input \= 2,
	Input \= 3,
        tty_clear,
        write("ALL INPUTS MUST END WITH A PERIOD BEFORE HITTING ENTER\n"),
        write("Invalid entry please try again\n"),
        write("Welcome to Buildup please choose from one of the following options\n"),
        write("1. load a game\n"),
        write("2. Play a new game\n"),
        write("3. Exit Buildup\n"),
        read(NewChoice),
	game_menu(NewChoice).
game_menu(Input):-
        Input == 1,
        load_game().
game_menu(Input):-
        Input == 2,    
        new_game(0,0).
game_menu(Input):-
        Input == 3,                
        write("Closing Buildup until next time\n"),
        halt.   

/**********************************************************************
Function Name: new_game                             
Purpose: To make a new game
Parameters: 
            Hroundswon the win count for human player passed by value
            Croundswon the win count for computer player passed by value
Return Value: none
Algorithm:
            1. clear the screen
            2. setup boneyards (SHUFFLE MODELS)
            3. create stacks and draw first 6 tiles from the boneyard and hand and draw first 6 tiles from the boneyard again
            4. add rounds won, 0, hands, updated boneyards, and stacks into 1 giant list
            5. repeat steps 1-4 for the computer player
            6. combine these 2 lists into one gigantic list 
            7. get the domino value for the first domino in each players hand for determining the first player (see step 8)
            8. display the game and call first_player
Assistance Received: I used this link to figure out how to clear the screen
https://stackoverflow.com/questions/53262099/swi-prolog-how-to-clear-terminal-screen-with-a-keyboard-shortcut-or-global-pre
**********************************************************************/
new_game(Hroundswon, Croundswon):-
        tty_clear,
        initial_computer_boneyard(W),
        initial_human_boneyard(B),
        setup_boneyard(B, NB),
        A= [],
        load_up_list(A,NB,5,C),
        length(B, G),
        draw_from_boneyard(A,NB,6,G,D),
        load_up_list(A,D,5,E),
        draw_from_boneyard(A,D,6,(G-6),F),
        add([0,Hroundswon],E,Hhand),
        add(Hhand,F,Boneyard),
        add(Boneyard,C,HStack),
        Human= HStack,
        setup_boneyard(W, NW),
        load_up_list(A,NW,5,Q),
        length(W, J),
        draw_from_boneyard(A,NW,6,J,X),
        load_up_list(A,X,5,K),
        draw_from_boneyard(A,X,6,(G-6),P),
        add([0,Croundswon],K,Chand),
        add(Chand,P,Boneyards),
        add(Boneyards,Q,CStack),
        Computer= CStack,
        write("Computer:\n"),
        nth0(0,Computer,CurrentCstack),
        nth0(1,Computer,CurrentCboneyard),
        nth0(2,Computer,CurrentChand),
        nth0(3,Computer,CurrentCscore),
        nth0(4,Computer,CRound),
        write("Stacks:\n"),
        write(CurrentCstack),
        write("\n"),
        write("Boneyard:\n"),
        write(CurrentCboneyard),
        write("\n"),
        write("Hand:\n"),
        write(CurrentChand),
        write("\n"),
        write("Score:\n"),
        write(CurrentCscore),
        write("\n"),
        write("Rounds Won:\n"),
        write(CRound),
        write("\n"),
        write("\n"),
        write("Human:\n"),
        nth0(0,Human,CurrentHstack),
        nth0(1,Human,CurrentHboneyard),
        nth0(2,Human,CurrentHhand),
        nth0(3,Human,CurrentHscore),
        nth0(4,Human,HRound),
        write("Stacks:\n"),
        write(CurrentHstack),
        write("\n"),
        write("Boneyard:\n"),
        write(CurrentHboneyard),
        write("\n"),
        write("Hand:\n"),
        write(CurrentHhand),
        write("\n"),
        write("Score:\n"),
        write(CurrentHscore),
        write("\n"),
        write("Rounds Won:\n"),
        write(HRound),
        write("\n"),
        write("\n"),
        nth0(2,Computer,Tiles),
        nth0(0,Tiles, CNewtile),
        nth0(2,Human,HTile),
        nth0(0,HTile, HNewtile),
        domino_value(HNewtile,Hvalue),
        domino_value(CNewtile,Cvalue),
        first_player(Hroundswon, Croundswon, Hvalue, Cvalue, HNewtile, CNewtile, Human,Computer).
       
/**********************************************************************
Function Name: initial_computer_boneyard                             
Purpose: original boneyard pile for computer player
Parameters: 
            W returned computer boneyard model passed by value
Return Value: returns W (initialized computer boneyard model)
Algorithm:
            1. return the boneyard model
Assistance Received: none
**********************************************************************/
initial_computer_boneyard(W):-
      [   [w, 0, 0], [w, 0, 1], [w, 0, 2], [w, 0, 3], [w, 0, 4], [w, 0, 5], [w, 0, 6], [w, 1, 1]
        , [w, 1, 2], [w, 1, 3], [w, 1, 4], [w, 1, 5], [w, 1, 6], [w, 2, 2], [w, 2, 3]
        , [w, 2, 4], [w, 2, 5], [w, 2, 6], [w, 3, 3], [w, 3, 4], [w, 3, 5], [w, 3, 6], [w, 4, 4]
        , [w, 4, 5], [w, 4, 6], [w, 5, 5], [w, 5, 6], [w, 6, 6]
      ] = A,
      W = A.

/**********************************************************************
Function Name: initial_human_boneyard                             
Purpose: original boneyard pile for human player
Parameters: 
            B returned human boneyard model passed by value
Return Value: returns B (initialized human boneyard model)
Algorithm:
            1. return the boneyard model
Assistance Received: none
**********************************************************************/
initial_human_boneyard(B):-
      [   [b, 0, 0], [b, 0, 1], [b, 0, 2], [b, 0, 3], [b, 0, 4], [b, 0, 5], [b, 0, 6], [b, 1, 1]
        , [b, 1, 2], [b, 1, 3], [b, 1, 4], [b, 1, 5], [b, 1, 6], [b, 2, 2], [b, 2, 3]
        , [b, 2, 4], [b, 2, 5], [b, 2, 6], [b, 3, 3], [b, 3, 4], [b, 3, 5], [b, 3, 6], [b, 4, 4]
        , [b, 4, 5], [b, 4, 6], [b, 5, 5], [b, 5, 6], [b, 6, 6]
      ] = A,
      B = A.

/**********************************************************************
Function Name: setup_boneyard                             
Purpose: To shuffle the boneyard pile
Parameters: 
            Boneyard the original unshuffled boneyard passed by value
            New_boneyard returned shuffled boneyard passed by value
Return Value: returns New_boneyard (updated shuffled list)
Algorithm:
            1. shuffle the list and return New_boneyard
Assistance Received: I used this link to figure out how to shuffle a list 
https://stackoverflow.com/questions/27431281/shuffling-a-list-in-prolog
**********************************************************************/
setup_boneyard(Boneyard, New_boneyard):-
        random_permutation(Boneyard, New_boneyard).

/**********************************************************************
Function Name: add                             
Purpose: To add a value to a list (Used for various list creations)
Parameters: 
            A the original list passed by value
            B the term being added to the list passed by value
            C the returned updated list passed by value
Return Value: returns C (updated list)
Algorithm:
            1. add B to list A and then...
            2. return C
Assistance Received: none
**********************************************************************/
add(A, B, C):-
        [B | A] = C.

/**********************************************************************
Function Name: load_up_list                             
Purpose: To add in a specified amount of tiles to a list (Used for creating hands and stacks)
Parameters: 
            List a new list used to construct the updated boneyard passed by value
            Model the boneyard itself passed by value
            Num the current position of boneyard passed by value
            C the returned updated list passed by value
Return Value: returns C (updated list)
Algorithm:
            1. If Num >= 0 get the current domino iteration from Model
            add the tile to the list and deincrement Num by 1 and recursively call this function
            OTHERWISE
            2. return C
Assistance Received: none
**********************************************************************/
load_up_list(List, _Model, Num, C):-
       C = List,
       Num is -1.
load_up_list(List, Model, Num, C):-
        Num >= 0,
        nth0(Num,Model,Tile),
        NewI is Num - 1,
        load_up_list([Tile | List],Model,NewI,C).

/**********************************************************************
Function Name: draw_from_boneyard                             
Purpose: draw a specified amount of dominoes from the boneyard
Parameters: 
            List a new list used to construct the updated boneyard passed by value
            Model the boneyard itself passed by value
            Num the current position of boneyard passed by value
            Max the highest index before returning passed by value
            C the returned updated boneyard passed by value
Return Value: returns C (updated boneyard)
Algorithm:
            1. If Num <= Max get the current domino iteration from Model 
            add the tile to the list and increment Num by 1 and recursively call this function
            OTHERWISE
            2. reverse the list for C and return C
Assistance Received: none
**********************************************************************/
draw_from_boneyard(List, _Model, Num, Max, C):-
        reverse(List,C),
        Num is Max.
draw_from_boneyard(List, Model, Num, Max, C):-
        Num =< Max,
        nth0(Num,Model,Tile),
        NewI is Num + 1,
        draw_from_boneyard([Tile | List],Model,NewI,Max,C).

/**********************************************************************
Function Name: domino_value                             
Purpose: get the numerical value of the domino
Parameters: 
            Tile the domino we are converting passed by value
            Value the returned value passed by value
Return Value: returns Value
Algorithm:
            1. get the second element in the Tile list
            2. get the third element in the Tile list
            3. return these two values added up
Assistance Received: none
**********************************************************************/
domino_value(Tile, Value):-
        nth0(1,Tile,First),
        nth0(2,Tile,Second),
        Value is First + Second.

/**********************************************************************
Function Name: first_player                             
Purpose: who goes first
Parameters: 
            Hroundswon the rounds won by Human passed by value
            Croundswon the rounds won by Computer passed by value
            Hvalue Human's first drawn domino in the hand's numerical value passed by value
            Cvalue Computer's first drawn domino in the hand's numerical value passed by value
            HNewtile Human's first drawn domino passed by value
            CNewtile Computer's first drawn domino passed by value
            Human human player list passed by value
            Computer computer player list passed by value
Return Value: none
Algorithm:
            1. If Cvalue < Hvalue display that human goes first show the two domino pieces drawn and 
            continue prompt and update the game contents approiately and that player makes its move
            ELSE
            2. If Cvalue > Hvalue display that computer goes first show the two domino pieces drawn and 
            continue prompt and update the game contents approiately and that player makes its move
            OTHERWISE
            3. reset game            
Assistance Received: none
**********************************************************************/
first_player(_Hroundswon, _Croundswon, Hvalue, Cvalue, HNewtile, CNewtile,Human,Computer):-
        Cvalue < Hvalue,
        write("Human goes first becuase it drew the bigger domino it drew "),
        write(HNewtile),
        write(" while Computer drew "),
        write(CNewtile),
        write("\n"),
        write("Type any number or letter followed by a period to continue"),
        read(_P),
        Name = human,
        add([Name], Human, Game),
        add(Game, Computer, NewGame),
        display_game(NewGame),
        make_move(NewGame,0).
first_player(_Hroundswon, _Croundswon, Hvalue, Cvalue, HNewtile, CNewtile, Human,Computer):-
        Cvalue > Hvalue,
        write("Computer goes first becuase it drew the bigger domino it drew "),
        write(CNewtile),
        write(" while Human drew "),
        write(HNewtile),
        write("\n"),
        write("Type any number or letter followed by a period to continue"),
        read(_P),
        Name = computer,
        add([Name], Human, Game),
        add(Game, Computer, NewGame),
        display_game(NewGame),
        make_move(NewGame,0).
first_player(Hroundswon, Croundswon, Hvalue, Cvalue, _HNewtile, _CNewtile, _Human,_Computer):-
        Hvalue == Cvalue,
        new_game(Hroundswon, Croundswon).

/**********************************************************************
Function Name: display_game                             
Purpose: used for displaying game contents in a user friendly format
Parameters: 
            Newgame the game passed by value
Return Value: none
Algorithm:
            1. clear the console window
            2. approiately display the game contents line by line with its corresponding identifier on top of it
            3. continue prompt
            
Assistance Received: none
**********************************************************************/
display_game(Newgame):-
        tty_clear,
        nth0(0,Newgame,Computer),
        nth0(1,Newgame,Human),
        nth0(2,Newgame,Turn),
        write("Computer:\n"),
        nth0(0,Computer,CurrentCstack),
        nth0(1,Computer,CurrentCboneyard),
        nth0(2,Computer,CurrentChand),
        nth0(3,Computer,CurrentCscore),
        nth0(4,Computer,CRound),
        write("Stacks:\n"),
        write(CurrentCstack),
        write("\n"),
        write("Boneyard:\n"),
        write(CurrentCboneyard),
        write("\n"),
        write("Hand:\n"),
        write(CurrentChand),
        write("\n"),
        write("Score:\n"),
        write(CurrentCscore),
        write("\n"),
        write("Rounds Won:\n"),
        write(CRound),
        write("\n"),
        write("\n"),
        write("Human:\n"),
        nth0(0,Human,CurrentHstack),
        nth0(1,Human,CurrentHboneyard),
        nth0(2,Human,CurrentHhand),
        nth0(3,Human,CurrentHscore),
        nth0(4,Human,HRound),
        write("Stacks:\n"),
        write(CurrentHstack),
        write("\n"),
        write("Boneyard:\n"),
        write(CurrentHboneyard),
        write("\n"),
        write("Hand:\n"),
        write(CurrentHhand),
        write("\n"),
        write("Score:\n"),
        write(CurrentHscore),
        write("\n"),
        write("Rounds Won:\n"),
        write(HRound),
        write("\n"),
        write("Turn: "),
        nth0(2,Newgame,Turn),
        write(Turn),
        write("\n"),
        write("Type any number or letter followed by a period to continue"),
        read(_P).

/**********************************************************************
Function Name: human_menu_type                             
Purpose: used for input when human can only stack on own side
Parameters: 
            Hand the heand that is being read passed by value
            Num the iterator passed by value
            Size The size of the hand passed by value
            Stack the stack that is being read passed by value
            A a spare variable used for keeping track of total passed by value
            Dominoes the value returned from A passed by value
Return Value: Returns Dominoes
Algorithm:
            1. If Num is Size (A/999) is not equal to Size return 0
            ELSE
            2. If Num is Size (A/999) is equal to Size return 999
            OTHERWISE
            3. increment A based off of can_move ('s) return value 
            increment Num by 1 and recursively call this function with 
            updated values
            
Assistance Received: none
**********************************************************************/
human_menu_type(Hand,Num,Size,Stack,A,Dominoes):-
        Num == Size,
        B is A / 999,
        B \= Size,
        Temp = 0,
        Dominoes is Temp.
human_menu_type(Hand,Num,Size,Stack,A,Dominoes):-
        Num == Size,
        B is A / 999,
        B == Size,
        Temp = 999,
        Dominoes is Temp.
human_menu_type(Hand,Num,Size,Stack,A,Dominoes):-
        Num < Size,
        nth0(Num,Hand,H),
        can_move(H,Stack,Test),
        Newa is A + Test,
        Newnum is Num + 1,
        human_menu_type(Hand,Newnum,Size,Stack,Newa,Dominoes).

/**********************************************************************
Function Name: backup_human_input_selection                             
Purpose: used for input when human can only stack on own side
Parameters: 
            Value type of input used passed by value
            Newgame the game passed by value
            Number the value that is being returned passed by value
Return Value: returns Number when applicable
Algorithm:
            1. If Value is not 1-4 prompt and recursively call this function 
            ELSE
            2. If Value is 1 then determine_legal_placement(1,Newgame,CurrentHhand,CurrentHstack,[],0,0,100)
            ELSE
            3. If Value is 2 then make_move(Newgame,3)
            ELSE
            4. If Value is 3 return 5
            OTHERWISE
            5. call main()
            
Assistance Received: none
**********************************************************************/
backup_human_input_selection(Value, Newgame, Number):-
        Value \= 1,
        Value \= 2,
        Value \= 3,
        Value \= 4,
        write("Invalid entry please try again"),
        write("Please choose from one of the following options\n"),
        write("1. Stack on own side\n"),
        write("2. Help me!\n"),
        write("3. Save game\n"),
        write("4. Exit current game\n"),
        read(X),
        backup_human_input_selection(X, Newgame, Number).   
backup_human_input_selection(Value, Newgame, Number):-
        Value == 1,
        nth0(1,Newgame,Human),
        nth0(0,Human,CurrentHstack),
        nth0(2,Human,CurrentHhand),       
        nth0(0,Newgame,Computer),
        nth0(0,Computer,CurrentCstack),
        nth0(2,Computer,CurrentChand),
        determine_legal_placement(1,Newgame,CurrentHhand,CurrentHstack,[],0,0,100).
backup_human_input_selection(Value, Newgame, Number):-
        Value == 2,
       make_move(Newgame,3).
backup_human_input_selection(Value, Newgame, Number):-
        Value == 3,
        Number is Value + 2.     
backup_human_input_selection(Value, Newgame, Number):-
        Value == 4,
        main().

/**********************************************************************
Function Name: last_human_input_selection                             
Purpose: used for input when human can only stack on opponents side
Parameters: 
            Value type of input used passed by value
            Newgame the game passed by value
            Number the value that is being returned passed by value
Return Value: returns Number when applicable
Algorithm:
            1. If Value is not 1-5 prompt and recursively call this function 
            ELSE
            2. If Value is 1 then determine_legal_placement(2,Newgame,CurrentHhand,CurrentCstack,[],0,0,500)
            ELSE
            3. If Value is 2 then make_move(Newgame,356)
            ELSE
            4. If Value is 3 return 5
            OTHERWISE
            5. call main()
            
Assistance Received: none
**********************************************************************/
last_human_input_selection(Value, Newgame, Number):-
        Value \= 1,
        Value \= 2,
        Value \= 3,
        Value \= 4,
        write("Invalid entry please try again"),
        write("Please choose from one of the following options\n"),
        write("1. Stack on opponents side\n"),
        write("2. Help me!\n"),
        write("3. Save game\n"),
        write("4. Exit current game\n"),
        read(X),
        last_human_input_selection(X, Newgame, Number).   
last_human_input_selection(Value, Newgame, Number):-
        Value == 1,
        nth0(1,Newgame,Human),
        nth0(0,Human,CurrentHstack),
        nth0(2,Human,CurrentHhand),       
        nth0(0,Newgame,Computer),
        nth0(0,Computer,CurrentCstack),
        nth0(2,Computer,CurrentChand),
        determine_legal_placement(2,Newgame,CurrentHhand,CurrentCstack,[],0,0,500).
last_human_input_selection(Value, Newgame, Number):-
        Value == 2,
       make_move(Newgame,356).
last_human_input_selection(Value, Newgame, Number):-
        Value == 3,
        Number is Value + 2.     
last_human_input_selection(Value, Newgame, Number):-
        Value == 4,
        main().

/**********************************************************************
Function Name: make_move                             
Purpose: Make a move if applicable
Parameters: 
            Newgame the game passed by value
            Assist type of input used passed by value
Return Value: none
Algorithm:
            1. If Assist is 356 determine_legal_placement(3,Newgame,CurrentHhand,CurrentCstack,[],0,0,356)
            ELSE
            2. If Assist is 3 determine_legal_placement(Assist,Newgame,CurrentHhand,CurrentCstack,[],0,0,1)
            ELSE
            3. If its the humans turn and human can only stack on opponents side display approiate prompt and use the approiate selector
            ELSE
            4. If its the humans turn and human can only stack on own side display approiate prompt and use the approiate selector
            ELSE
            5. If its humnans turn display default prompt and default selector
            ELSE
            6. If turn is computer then determine_legal_placement(2,Newgame,CurrentChand,CurrentHstack,[],0,0,1)
            OTHERWISE
            7. determine_legal_placement(2,Newgame,CurrentHhand,CurrentCstack,[],0,0,1)

            
Assistance Received: none
**********************************************************************/
make_move(Newgame,Assist):-
        Assist == 356,
        nth0(2,Newgame,Turn),
        nth0(1,Newgame,Human),
        nth0(0,Human,CurrentHstack),
        nth0(2,Human,CurrentHhand),       
        nth0(0,Newgame,Computer),
        nth0(0,Computer,CurrentCstack),
        nth0(2,Computer,CurrentChand),
        determine_legal_placement(3,Newgame,CurrentHhand,CurrentCstack,[],0,0,356).
make_move(Newgame,Assist):-
        Assist == 3,
        nth0(2,Newgame,Turn),
        nth0(1,Newgame,Human),
        nth0(0,Human,CurrentHstack),
        nth0(2,Human,CurrentHhand),       
        nth0(0,Newgame,Computer),
        nth0(0,Computer,CurrentCstack),
        nth0(2,Computer,CurrentChand),
        determine_legal_placement(Assist,Newgame,CurrentHhand,CurrentCstack,[],0,0,1).
make_move(Newgame,Assist):-
        nth0(2,Newgame,Turn),
        nth0(1,Newgame,Human),
        nth0(0,Human,CurrentHstack),
        nth0(2,Human,CurrentHhand),       
        nth0(0,Newgame,Computer),
        nth0(0,Computer,CurrentCstack),
        nth0(2,Computer,CurrentChand),
        nth0(0,CurrentHhand,H),        
        length(CurrentHhand,P),
        can_move(H,CurrentHstack,ONE),
        can_move(H,CurrentHstack,TWO),
        Turn == human, 
        P == 1,
        TWO > 0,
        ONE > 0, 
        determine_legal_placement(1,Newgame,CurrentHhand,CurrentHstack,[],0,0,1). 
make_move(Newgame,Assist):-
        nth0(2,Newgame,Turn),
        nth0(1,Newgame,Human),
        nth0(0,Human,CurrentHstack),
        nth0(2,Human,CurrentHhand),       
        nth0(0,Newgame,Computer),
        nth0(0,Computer,CurrentCstack),
        nth0(2,Computer,CurrentChand),
        nth0(0,CurrentHhand,H),        
        length(CurrentHhand,P),
        human_menu_type(CurrentHhand,0,P,CurrentHstack,0,DOMINOES),
        DOMINOES > 0,
        P == 1,
        Turn == human, 
        write("Please choose from one of the following options\n"),
        write("1. Stack on opponents side\n"),
        write("2. Help me!\n"),
        write("3. Save game\n"),
        write("4. Exit current game\n"),
        read(Number),
        last_human_input_selection(Number, Newgame, Output),
        Number == 1,
        determine_legal_placement(Output,Newgame,CurrentHhand,CurrentHstack,[],0,0,1). 
make_move(Newgame,Assist):-
        nth0(2,Newgame,Turn),
        nth0(1,Newgame,Human),
        nth0(0,Human,CurrentHstack),
        nth0(2,Human,CurrentHhand),       
        nth0(0,Newgame,Computer),
        nth0(0,Computer,CurrentCstack),
        nth0(2,Computer,CurrentChand),
        nth0(0,CurrentHhand,H),        
        length(CurrentHhand,P),
        human_menu_type(CurrentHhand,0,P,CurrentCstack,0,DOMINOES),
        DOMINOES > 0,
        P > 1,
        Turn == human, 
        write("Please choose from one of the following options\n"),
        write("1. Stack on own side\n"),
        write("2. Help me!\n"),
        write("3. Save game\n"),
        write("4. Exit current game\n"),
        read(Number),
        backup_human_input_selection(Number, Newgame, Output),
        Number == 1,
        determine_legal_placement(Output,Newgame,CurrentHhand,CurrentHstack,[],0,0,1). 
make_move(Newgame,Assist):-
        nth0(2,Newgame,Turn),
        nth0(1,Newgame,Human),
        nth0(0,Human,CurrentHstack),
        nth0(2,Human,CurrentHhand),       
        length(CurrentHhand,P),
        P > 1,
        Turn == human, 
        write("Please choose from one of the following options\n"),
        write("1. Stack on own side\n"),
        write("2. Stack on opponent's side\n"),
        write("3. Help me!\n"),
        write("4. Save game\n"),
        write("5. Exit current game\n"),
        read(Number),
        human_selection(Number, Newgame,Output),
        Number == 1,
        determine_legal_placement(Output,Newgame,CurrentHhand,CurrentHstack,[],0,0,1).       
make_move(Newgame,Assist):-
        nth0(2,Newgame,Turn),
        nth0(1,Newgame,Human),
        nth0(0,Human,CurrentHstack),
        nth0(2,Human,CurrentHhand),       
        nth0(0,Newgame,Computer),
        nth0(0,Computer,CurrentCstack),
        nth0(2,Computer,CurrentChand),
        Turn == computer,
        determine_legal_placement(2,Newgame,CurrentChand,CurrentHstack,[],0,0,1).
make_move(Newgame,Assist):-
        nth0(1,Newgame,Human),
        nth0(0,Human,CurrentHstack),
        nth0(2,Human,CurrentHhand),       
        nth0(0,Newgame,Computer),
        nth0(0,Computer,CurrentCstack),
        nth0(2,Computer,CurrentChand),
        determine_legal_placement(2,Newgame,CurrentHhand,CurrentCstack,[],0,0,1).

/**********************************************************************
Function Name: is_double_domino                             
Purpose: Is it a double domino?
Parameters: 
            Domino the domino passed by value
            Type the value that is being returned passed by value
Return Value: Returns Type of domino
Algorithm:
            1. If Domino is NOT [b,0,0], [b,1,1], [b,2,2], [b,3,3], [b,4,4], [b,5,5], [b,6,6]
            Return 1
            OTHERWISE
            2. Return 2
Assistance Received: none
**********************************************************************/
is_double_domino(Domino, Type):-
        Domino \= [b,0,0],
        Domino \= [b,1,1],
        Domino \= [b,2,2],
        Domino \= [b,3,3],
        Domino \= [b,4,4],
        Domino \= [b,5,5],
        Domino \= [b,6,6],
        Domino \= [w,0,0],
        Domino \= [w,1,1],
        Domino \= [w,2,2],
        Domino \= [w,3,3],
        Domino \= [w,4,4],
        Domino \= [w,5,5],
        Domino \= [w,6,6],
        Type = 1.
is_double_domino(_Domino, Type):-
        Type = 2.

/**********************************************************************
Function Name: human_input                             
Purpose: To get the human input for the moves
Parameters: 
            Input the input passed by value
            Size the moves size passed by value
            Output the value that is being returned passed by value
Return Value: Returns Output
Algorithm:
            1. If Size is 0 then Output is 0 and return Output
            ELSE
            2. If Input < 0 prompt and recursively call this function
            ELSE
            3. If Input > Size prompt and recursively call this function
            OTHERWISE
            4. Output is Input and return Output 
Assistance Received: none
**********************************************************************/
human_input(Input, Size, Output):-
        Size == 0,
        Output is 0.
human_input(Input, Size, Output):-
        Input < 0,
        write("Invalid entry please try again\n"),
        write("Enter a number between 1 and "),
        Newsize is Size + 1,
        write(Newsize),
        read(Newinput),
        Value is Newinput - 1,
        human_input(Value, Newsize, Output).
human_input(Input, Size, Output):-
        Input > Size,
        write("Invalid entry please try again\n"),
        write("Enter a number between 1 and "),
        Newsize is Size + 1,
        write(Newsize),
        read(Newinput),
        Value is Newinput - 1,
        human_input(Value, Newsize, Output).
human_input(Input, Size, Output):-
        Output is Input.

/**********************************************************************
Function Name: draw_time                             
Purpose: To get the number of times tiles are to be drawn from the boneyards
Parameters: 
            Num the number of times tiles were drawn from the boneyard passed by value
            Times the value that is being returned passed by value
Return Value: Returns Times
Algorithm:
            1. If Num > 6 Times is 6 and return Times 
            ELSE
            2. If Num == 4 Times is 4 and return Times 
            OTHERWISE
            3. Times is 0 and return Times 
Assistance Received: none
**********************************************************************/
draw_time(Num, Times):-
        Num > 6,
        Times is 6.
draw_time(Num, Times):-
        Num == 4,
        Times is 4.
draw_time(Num, Times):-
        Times is 0.

/**********************************************************************
Function Name: loading_up_list                             
Purpose: To get the number of times tiles were added to the hands (USED IN CONJUNCTION WITH draw_time function)
Parameters: 
            Num the number of times tiles were drawn from the boneyard passed by value
            Times the value that is being returned passed by value
Return Value: Returns Times
Algorithm:
            1. If Num > 0 Times is Num -1 and return Times 
            ELSE
            2. Times is 0 and return Times
Assistance Received: none
**********************************************************************/
loading_up_list(Num, Times):-
        Num > 0,
        Times is Num - 1.
loading_up_list(Num, Times):-
        Times is 0.

/**********************************************************************
Function Name: tournament_winner                             
Purpose: To announce the winner of the tournament 
Parameters: 
            HRound Human's rounds won passed by value
            CRound Computer's rounds won passed by value
Return Value: none
Algorithm:
            1. If HRound > CRound then announce Human as winner of the tournament and 
            its Number of rounds won and terminate 
            ELSE
            2. If CRound > HRound then announce Computer as winner of the tournament and 
            its Number of rounds won and terminate 
            OTHERWISE
            3. If CRound is HRound then announce winner of the tournament is a draw and 
            the Number of rounds won and terminate
Assistance Received: none
**********************************************************************/
tournament_winner(HRound, CRound):-
        HRound > CRound,
        write("Human has won the tournament with a score of "),
        write(HRound),
        write("\n"),
        halt.
tournament_winner(HRound, CRound):-
        CRound > HRound,
        write("Computer has won the tournament with a score of "),
        write(CRound),
        write("\n"),
        halt.
tournament_winner(HRound, CRound):-
        CRound == HRound,
        write("Tournament is a draw with a score of "),
        write(CRound),
        write("\n"),
        halt.    

/**********************************************************************
Function Name: another_input                             
Purpose: To determine if the user wants to play another round or not (HANDLES ACTIONS BASED ON INPUT)
Parameters: 
            HRound Human's rounds won passed by value
            CRound Computer's rounds won passed by value
            Num the parced input from another_round passed by value
Return Value: none
Algorithm:
            1. If num is not 1-2 then write("Invalid entry, please try again\n") and call another_round (HANDLES INPUT) function 
            ELSE
            2. If Num is 1 then call new_game(HRound, CRound)
            OTHERWISE
            3. If Num is 2 then call tournament_winner(HRound, CRound)
Assistance Received: none
**********************************************************************/
another_input(HRound, CRound, Num):-
        Num \= 1,
        Num \= 2,
        write("Invalid entry, please try again\n"),
        another_round(HRound, CRound).
another_input(HRound, CRound, Num):-
        Num == 1,
        new_game(HRound, CRound).
another_input(HRound, CRound, Num):-
        Num == 2,
        tournament_winner(HRound, CRound).

/**********************************************************************
Function Name: another_round                             
Purpose: To determine if the user wants to play another round or not (HANDLES INPUT)
Parameters: 
            HRound Human's rounds won passed by value
            CRound Computer's rounds won passed by value
Return Value: none
Algorithm:
            1. Prompts user for another round reads in the input and calls another_input (ACTIONS BASED ON THE INPUT)
Assistance Received: none
**********************************************************************/
another_round(HRound, CRound):-
        write("Do you want to play another round please choose from one of the following\n"),
        write("1. play another round\n"),
        write("2. to quit\n"),
        read(Num),
        another_input(HRound, CRound, Num).

/**********************************************************************
Function Name: round_winner                             
Purpose: To determine who won the round 
Parameters: 
            Newgame the game passed by value
Return Value: none
Algorithm:
            1. If Human score is more then Computer score then announce Human 
            as the winner and its score and increase Human's Number of rounds won by 1 display the updated 
            game and prompt if the user wants to play another round or not from another_round
            function
            ELSE
            2. If Computer score is more then Human score then announce Computer 
            as the winner and its score and increase Computer's Number of rounds won by 1 display the updated 
            game and prompt if the user wants to play another round or not from another_round
            function
            OTHERWISE
            3. The round is a draw score is announced Increase Human's Number of rounds won AND Computer's Number of rounds won by 1
            display the updated game and prompt if the user wants to play another round or not from another_round
            function
Assistance Received: none
**********************************************************************/
round_winner(Newgame):-
        nth0(0,Newgame,Computer),
        nth0(1,Newgame,Human),
        nth0(2,Newgame,Turn),        
        nth0(0,Computer,CurrentCstack),
        nth0(1,Computer,CurrentCboneyard),
        nth0(2,Computer,CurrentChand), 
        nth0(3,Computer,CurrentCscore),
        nth0(4,Computer,CRound),
        nth0(0,Human,CurrentHstack),
        nth0(1,Human,CurrentHboneyard),
        nth0(2,Human,CurrentHhand),   
        nth0(3,Human,CurrentHscore),
        nth0(4,Human,HRound),
        CurrentHscore > CurrentCscore,
        write("Human has won the round with a score of "),
        write(CurrentHscore),
        write("\n"),
        write("Type any number or letter followed by a period to continue"),
        read(_P),
        NewHR is HRound + 1,
        add([CurrentHscore,NewHR],[],Hhand),
        add(Hhand, [], HB),
        add(HB,CurrentHstack,Newhuman),
        add([CurrentCscore,CRound],[],Chand),
        add(Chand, [], CB),
        add(CB,CurrentCstack,Newcomputer),
        add([Turn], Newhuman, Game),
        add(Game, Newcomputer, GAME),
        display_game(GAME),
        another_round(NewHR, CRound).
round_winner(Newgame):-
        nth0(0,Newgame,Computer),
        nth0(1,Newgame,Human),
        nth0(2,Newgame,Turn),        
        nth0(0,Computer,CurrentCstack),
        nth0(1,Computer,CurrentCboneyard),
        nth0(2,Computer,CurrentChand), 
        nth0(3,Computer,CurrentCscore),
        nth0(4,Computer,CRound),
        nth0(0,Human,CurrentHstack),
        nth0(1,Human,CurrentHboneyard),
        nth0(2,Human,CurrentHhand),   
        nth0(3,Human,CurrentHscore),
        nth0(4,Human,HRound),
        CurrentCscore > CurrentHscore,
        write("Computer has won the round with a score of "),
        write(CurrentCscore),
        write("\n"),
        write("Type any number or letter followed by a period to continue"),
        read(_P),
        NewCR is CRound + 1,
        add([CurrentHscore,HRound],[],Hhand),
        add(Hhand, [], HB),
        add(HB,CurrentHstack,Newhuman),
        add([CurrentCscore,NewCR],[],Chand),
        add(Chand, [], CB),
        add(CB,CurrentCstack,Newcomputer),
        add([Turn], Newhuman, Game),
        add(Game, Newcomputer, GAME),
        display_game(GAME),
        another_round(HRound,NewCR).
round_winner(Newgame):-
        nth0(0,Newgame,Computer),
        nth0(1,Newgame,Human),
        nth0(2,Newgame,Turn),        
        nth0(0,Human,CurrentHstack),
        nth0(1,Human,CurrentHboneyard),
        nth0(2,Human,CurrentHhand),   
        nth0(3,Human,CurrentHscore),
        nth0(4,Human,HRound),
        nth0(0,Computer,CurrentCstack),
        nth0(1,Computer,CurrentCboneyard),
        nth0(2,Computer,CurrentChand), 
        nth0(3,Computer,CurrentCscore),
        nth0(4,Computer,CRound),
        CurrentCscore == CurrentHscore,
        write("Round is a draw with a score of "),
        write(CurrentCscore),
        write("\n"),
        write("Type any number or letter followed by a period to continue"),
        read(_P),
        NewCR is CRound + 1,
        NewHR is HRound + 1,
        add([CurrentHscore,NewHR],[],Hhand),
        add(Hhand, [], HB),
        add(HB,CurrentHstack,Newhuman),
        add([CurrentCscore,NewCR],[],Chand),
        add(Chand, [], CB),
        add(CB,CurrentCstack,Newcomputer),
        add([Turn], Newhuman, Game),
        add(Game, Newcomputer, GAME),
        display_game(GAME),
        another_round(NewHR,NewCR).

/**********************************************************************
Function Name: converted_list                             
Purpose: used for coonverting a list of moves to numerical domino value differences e.g [[w,1,1],[b,1,3]] = 2
Parameters: 
            Moves the legal moves list passed by value
            Num the iterator passed by value 
            Max the length of contents passed by value
            B a new list passed by value
            D returned numerical list passed by value
Return Value: returns the converted moves list (AKA D)
Algorithm:
            1. If number is < Max get nth Num move and convert the two tile values 
            2. subtract the two values via absolute value 
            3. add the new value from step 2 to B to get C and 
            recursively call this function and increment num + 1 and B becomes C
            ELSE
            2.If Num is Max reverse the list and D is C
            3. Return D
Assistance Received: USED this for getting absolute value
https://www.swi-prolog.org/pldoc/man?function=abs/1
**********************************************************************/
converted_list(_Moves,Num,Max,B,D):-
    Num == Max,
    reverse(B,C),
    D = C.
converted_list(Moves,Num,Max,B,D):-
    Num < Max,
    nth0(Num,Moves,Tile),
    nth0(0,Tile,Tone),
    nth0(1,Tile,Ttwo),
    domino_value(Tone, Value),
    domino_value(Ttwo, Values),
    Newnum is Num + 1,
    Final_value is abs(Values - Value),
    C = [Final_value | B],
    converted_list(Moves,Newnum,Max,C, D).

/**********************************************************************
Function Name: find_position                             
Purpose: used for getting the position of a numerical domino value
Parameters: 
            Contents the convrerted domino list passed by value
            Num the iterator passed by value 
            Max the length of contents passed by value
            Element thew number we are looking for in this list passed by value
            Iter the returned position passed by value
Return Value: returns the approiate number when applicable 
Algorithm:
            1. If number is <= Max and current value (Tile) is not equal to Element then
            recursively call this function and increment num +1
            ELSE
            2.If Tiles = Element then iter is Num and return the iterator 
Assistance Received: none
**********************************************************************/    
find_position(Contents,Num,Max,Element,Iter):-
     Num =< Max,
     nth0(Num,Contents,Tile),
     Tile \= Element,
     Newnum is Num + 1,
     find_position(Contents,Newnum,Max,Element,Iter).
find_position(Contents,Num,Max,Element,Iter):-
     Num =< Max,
     nth0(Num,Contents,Tile),
     Tile == Element,
     Iter is Num.

/**********************************************************************
Function Name: computer_input_selection                             
Purpose: used for getting the selected move for computer
Parameters: 
            Moves the move list passed by value
            Iter the iterator passed by value 
            Output the returned value passed by value
Return Value: returns the approiate number when applicable 
Algorithm:
            1. If Iter is 20 then return smallest tile move combo
            ELSE
            2. If Len > 1 and the two colors are equal to eachother then choose a random move that is LEGAL and if they 
            aren't equal return the position in the list
            ELSE
            3. recursively call this function from Iter + 1
            ELSE 
            4. If Len > 1 and the two colors are equal to eachother then choose a random move that is LEGAL and if they 
            are equal recursively call this function from Iter + 1
            ELSE
            5. If its a double tile and the 2 colors are the same, find the smallest move difference in the moves list asnd return the position
            ELSE
            6. If its a double tile and the moves length is between 1-9 and the 2 colors are different then return the biggest Difference
            OTHERWISE
            7. Just return the smallest difference
Assistance Received: none
**********************************************************************/        
computer_input_selection(Moves, Iter, Output):-
        length(Moves,Len),
        converted_list(Moves,0,Len,[],L),
        min_list(L, X),    
        find_position(L,0,Len,X,K),
        nth0(K,Moves, S),
        nth0(0, S, Hand),
        nth0(1, S, Stack),
        nth0(0, Hand, Firstcolor),
        nth0(0,Stack, Secondcolor),
        Iter == 20,
        Output is K.
computer_input_selection(Moves, Iter, Output):-
        length(Moves,Len),
        converted_list(Moves,0,Len,[],L),
        min_list(L, X),    
        find_position(L,0,Len,X,K),
        nth0(K,Moves, S),
        nth0(0, S, Hand),
        nth0(1, S, Stack),
        nth0(0, Hand, Firstcolor),
        nth0(0,Stack, Secondcolor),
        Len > 1,
        Firstcolor == Secondcolor,
        random_between(0, Len, P),
        nth0(P,Moves, NS),
        nth0(0, NS, NHand),
        nth0(1, NS, NStack),
        nth0(0, NHand, NFirstcolor),
        nth0(0,NStack, NSecondcolor),
        NFirstcolor \= NSecondcolor,
        Output is P.

computer_input_selection(Moves, Iter, Output):-
        length(Moves,Len),
        converted_list(Moves,0,Len,[],L),
        min_list(L, X),    
        find_position(L,0,Len,X,K),
        nth0(K,Moves, S),
        nth0(0, S, Hand),
        nth0(1, S, Stack),
        nth0(0, Hand, Firstcolor),
        nth0(0,Stack, Secondcolor),
        Len > 1,
        Firstcolor == Secondcolor,
        random_between(0, Len, P),
        nth0(P,Moves, NS),
        nth0(0, NS, NHand),
        nth0(1, NS, NStack),
        nth0(0, NHand, NFirstcolor),
        nth0(0,NStack, NSecondcolor),
        NFirstcolor == NSecondcolor,
        Newiter is Iter + 1,
        computer_input_selection(Moves, Newiter, Output).
computer_input_selection(Moves, Iter, Output):-
        length(Moves,Len),
        converted_list(Moves,0,Len,[],L),
        max_list(L, X),    
        find_position(L,0,Len,X,K),
        nth0(K,Moves, S),
        nth0(0, S, Hand),
        is_double_domino(Hand, Val),
        Val == 2,
        nth0(1, S, Stack),
        nth0(0, Hand, Firstcolor),
        nth0(0,Stack, Secondcolor),
        Firstcolor == Secondcolor,
        min_list(L, NewX),    
        find_position(L,0,Len,NewX,NewK),
        Output is NewK.       
computer_input_selection(Moves, Iter, Output):-
        length(Moves,Len),
        converted_list(Moves,0,Len,[],L),
        max_list(L, X),    
        find_position(L,0,Len,X,K),
        nth0(K,Moves, S),
        nth0(0, S, Hand),
        is_double_domino(Hand, Val),
        Len >0,
        Len < 10,
        Val == 2,
        nth0(1, S, Stack),
        nth0(0, Hand, Firstcolor),
        nth0(0,Stack, Secondcolor),
        Firstcolor \= Secondcolor,
        Output is K.
computer_input_selection(Moves, Iter, Output):-
        length(Moves,Len),
        converted_list(Moves,0,Len,[],L),
        min_list(L, X),    
        find_position(L,0,Len,X,K),
        nth0(K,Moves, S),
        nth0(0, S, Hand),
        is_double_domino(Hand, Val),
       
        nth0(1, S, Stack),
        nth0(0, Hand, Firstcolor),
        nth0(0,Stack, Secondcolor),
        Firstcolor \= Secondcolor,
        Output is K.

computer_input_selection(Moves, Iter, Output):-
        length(Moves,Len),
        converted_list(Moves,0,Len,[],L),
        min_list(L, X),    
        find_position(L,0,Len,X,K),
        nth0(K,Moves, S),
        nth0(0, S, Hand),
        is_double_domino(Hand, Val),
        Val == 1,
        nth0(1, S, Stack),
        nth0(0, Hand, Firstcolor),
        nth0(0,Stack, Secondcolor),
        Output is K.

/**********************************************************************
Function Name: spare_human_input_selection                             
Purpose: used for validating input when human can only stack on own 
side (INSIDE OF player_move function)
Parameters: 
            Value the input read in from the function it is called 
            inside of passed by value
            Number the returned value (WHEN APPLICABLE) passed by value
Return Value: returns the approiate number when applicable 
Algorithm:
            1. If Value is NOT 1-4 prompt and recursively call this function
            ELSE
            2. If Value is 1 then Number is Value return Number
            ELSE
            3. If Value is 2 then Number is 3 and return Number
            ELSE 
            4. If Value is 3 then Number is 5 and return Number
            OTHERWISE
            5. call main
Assistance Received: none
**********************************************************************/
spare_human_input_selection(Value, Number):-
        Value \= 1,
        Value \= 2,
        Value \= 3,
        Value \= 4,
        write("Invalid entry please try again"),
        write("Please choose from one of the following options\n"),
        write("1. Stack on own side\n"),
        write("2. Help me!\n"),
        write("3. Save game\n"),
        write("4. Exit current game\n"),
        read(X),
        spare_human_input_selection(X, Number).
spare_human_input_selection(Value, Number):-
        Value == 1,
        Number is Value.
spare_human_input_selection(Value, Number):-
        Value == 2,
        Number is Value + 1.
spare_human_input_selection(Value, Number):-
        Value == 3,
        Number is Value + 2.     
spare_human_input_selection(Value, Number):-
        Value == 4,
        main().

/**********************************************************************
Function Name: computer_explaination                             
Purpose: To explain the computers playing strategy
Parameters: 
            A the first half of the selected move passed by value
            B the second half of the selected move passed by value
            Len the size of the move list passed by value

Return Value: returns the approiate number when applicable 
Algorithm:
            1. If Len is 1 write(" because this was the only playable move")
            ELSE
            2. If A is a non double and the 2 colors are different and the Difference is > 3 then 
            write(" to be able to increase a stack and allow for maximum tile coverage").
            ELSE
            3. If A is a non double and the 2 colors are different and the Difference is <= 3 then 
            write(" to be able to claim a stack and allow for maximum tile coverage").
            ELSE
            4. If A is a double then write(" to be able to reset a stack and allow for maximum tile coverage").
            OTHERWISE
            5. write(" because it was the most efficient move detected"). 
Assistance Received: none
**********************************************************************/
computer_explaination(A, B, Len):-
        Len == 1,
        write(" because this was the only playable move").
computer_explaination(A, B, Len):-
        is_double_domino(A, Val),
        nth0(0,A,CA),
        nth0(0,B,CB),
        domino_value(A, Numone),
        domino_value(B, Numtwo),
        Differ is abs(Numone - Numtwo),
        Val == 1,
        CA \= CB,
        Differ > 3,
        write(" to be able to increase a stack and allow for maximum tile coverage").
computer_explaination(A, B, Len):-
        is_double_domino(A, Val),
        nth0(0,A,CA),
        nth0(0,B,CB),
        domino_value(A, Numone),
        domino_value(B, Numtwo),
        Differ is abs(Numone - Numtwo),
        Val == 1,
        CA \= CB,
        Differ =< 3,
        write(" to be able to claim a stack and allow for maximum tile coverage").
computer_explaination(A, B, Len):-
        is_double_domino(A, Val),
        nth0(0,A,CA),
        nth0(0,B,CB),
        domino_value(A, Numone),
        domino_value(B, Numtwo),
        Differ is abs(Numone - Numtwo),
        Val == 2,
        Numone < Numtwo,
        write(" to be able to reset a stack and allow for maximum tile coverage").
computer_explaination(A, B, Len):-      
        write(" because it was the most efficient move detected"). 

/**********************************************************************
Function Name: aux_human_input_selection                             
Purpose: used for validating input when human can only stack on opponents 
side (INSIDE OF player_move function)
Parameters: 
            Value the input read in from the function it is called 
            inside of passed by value
            Newgame the game passed by value
            Moves the moves that be played by value
            Number the returned value (WHEN APPLICABLE) passed by value
Return Value: returns the approiate number when applicable 
Algorithm:
            1. If Value is NOT 1-4 prompt and recursively call this function
            ELSE
            2. If Value is 1 then determine_legal_placement(2,Newgame,CurrentHhand,CurrentCstack,[],0,0,656)
            ELSE
            3. If Value is 2 then Number is 3 and return Number
            ELSE 
            4. If Value is then Number is 5 and return Number
            OTHERWISE
            5. call main
Assistance Received: none
**********************************************************************/
aux_human_input_selection(Value, Newgame, Moves, Number):-
        Value \= 1,
        Value \= 2,
        Value \= 3,
        Value \= 4,
        write("Invalid entry please try again"),
        write("Please choose from one of the following options\n"),
        write("1. Stack on opponents side\n"),
        write("2. Help me!\n"),
        write("3. Save game\n"),
        write("4. Exit current game\n"),
        read(X),
        aux_human_input_selection(X, Newgame, Moves, Number).   
aux_human_input_selection(Value, Newgame, Moves, Number):-
        Value == 1,
        nth0(1,Newgame,Human),
        nth0(0,Human,CurrentHstack),
        nth0(2,Human,CurrentHhand),       
        nth0(0,Newgame,Computer),
        nth0(0,Computer,CurrentCstack),
        nth0(2,Computer,CurrentChand),
        determine_legal_placement(2,Newgame,CurrentHhand,CurrentCstack,[],0,0,656).

aux_human_input_selection(Value, Newgame, Moves, Number):-
        Value == 2,
        Number is Value + 1.
aux_human_input_selection(Value, Newgame, Moves, Number):-
        Value == 3,
        Number is Value + 2.     
aux_human_input_selection(Value, Newgame, Moves, Number):-
        Value == 4,
        main().

/**********************************************************************
Function Name: player_move                             
Purpose: to aid in transitioning between determining legal moves and playing a move if applicable
(BASICALLY USED AS A HELPER FUNCTION for getting the Parameters for update_stack)
Parameters: 
            Hand_tile the players selected tile from the hand passed by value
            Stack The stack passed by value
            Tiles the value returned from this function passed by value 
Return Value: returns tiles 
Algorithm:
            Since its a very long algorithm I'll just sum it up
            1. if its the humans turn to play and it can play then use the approiate prompt and update everything approiately
            ELSE
            2. If the human can't play and its their turn and computer can play then computer plays
            OTHERWISE
            3. tally scores and continue
Assistance Received: none
**********************************************************************/
player_move(Output,Newgame, Moves,Iter):-
        nth0(2,Newgame,Turn),
        Iter == 656,
        Turn == human,
        nth0(1,Newgame,Human),
        nth0(0,Human,CurrentHstack),
        nth0(2,Human,CurrentHhand),       
        nth0(0,Newgame,Computer),
        nth0(0,Computer,CurrentCstack),
        nth0(2,Computer,CurrentChand),
        write(Moves),
        write("\n"),
        write("\n"),
        write("Enter a number between 1 and "),
        length(Moves, J),
        Newj is J - 1,
        Newj > -1,
        write(J),
        write(" \n"),
        read(Input), 
        Response is Input - 1,
        human_input(Response,Newj,Num),
        nth0(Num,Moves,Selection),
        cover(Output, Turn, Selection,Newgame).
player_move(Output,Newgame, Moves,Iter):-
        nth0(0,Newgame,Computer),
        nth0(1,Newgame,Human),
        nth0(2,Newgame,Turn),        
        nth0(0,Computer,CurrentCstack),
        nth0(1,Computer,CurrentCboneyard),
        nth0(2,Computer,CurrentChand), 
        nth0(3,Computer,CurrentCscore),
        nth0(4,Computer,CRound),
        nth0(0,Human,CurrentHstack),
        nth0(1,Human,CurrentHboneyard),
        nth0(2,Human,CurrentHhand),   
        nth0(3,Human,CurrentHscore),
        nth0(4,Human,HRound),
        length(CurrentHhand, Hhandsize),
        length(CurrentChand, Chandsize),
        nth0(0,CurrentHhand, H),
        nth0(0,CurrentChand, C),
        can_move(C,CurrentHstack, Cdom),
        can_move(C,CurrentCstack, CCdom),        
        is_double_domino(C, Type),
        length(Moves,J),
        Chandsize == 1,
        Output == 2,
        Type == 1,
        Iter < 20,
        J > 0,  
        Turn == computer,
        Cdom == 0,
        CCdom > 0,      
        computer_input_selection(Moves,0,X),
        nth0(X,Moves,Selection),
        write("Computer chose to stack "),
        nth0(0,Selection,A),
        write(A),
        write(" onto "),
        nth0(1,Selection,B),
        write(B),
        computer_explaination(A, B, J),
        write("\n"),
        %halt.
        write("Type any number or letter followed by a period to continue"),
        read(_P),
        cover(Output, Turn, Selection,Newgame).       
player_move(Output,Newgame, Moves,Iter):-
        Output == 1,
        Iter == 200,
        length(Moves,J),
        J > 0,
        computer_input_selection(Moves,0,X),
        nth0(X,Moves,Selection),
        write("Computer chose to stack "),
        nth0(0,Selection,A),
        write(A),
        write(" onto "),
        nth0(1,Selection,B),
        write(B),
        computer_explaination(A, B, J),
        write("\n"),
        write("Type any number or letter followed by a period to continue"),
        read(_P),       
        cover(Output, computer, Selection,Newgame).
player_move(Output,Newgame, Moves,Iter):-
        Output == 2,
        Iter == 500,
        write(Moves),
        write("\n Enter a number between 1 and "),
        length(Moves, J),
        Newj is J - 1,
        Newj > -1,
        write(J),
        write(" \n"),
        read(Input), 
        Response is Input - 1,
        human_input(Response,Newj,Num),
        nth0(Num,Moves,Move),
        cover(2, human, Move,Newgame).
player_move(Output,Newgame, Moves,Iter):-
        Output == 1,
        Iter == 100,
        write(Moves),
        write("\n Enter a number between 1 and "),
        length(Moves, J),
        Newj is J - 1,
        Newj > -1,
        write(J),
        write(" \n"),
        read(Input), 
        Response is Input - 1,
        human_input(Response,Newj,Num),
        nth0(Num,Moves,Move),
        cover(1, human, Move,Newgame).
player_move(Output,Newgame, Moves,Iter):-
        %I have this new player_move added into the beginning to fix a bug that fixes premature scoring so far it works
        nth0(0,Newgame,Computer),
        nth0(1,Newgame,Human),
        nth0(2,Newgame,Turn),        
        nth0(0,Computer,CurrentCstack),
        nth0(1,Computer,CurrentCboneyard),
        nth0(2,Computer,CurrentChand), 
        nth0(3,Computer,CurrentCscore),
        nth0(4,Computer,CRound),
        nth0(0,Human,CurrentHstack),
        nth0(1,Human,CurrentHboneyard),
        nth0(2,Human,CurrentHhand),   
        nth0(3,Human,CurrentHscore),
        nth0(4,Human,HRound),
        length(CurrentHhand, Hhandsize),
        length(CurrentChand, Chandsize),
        nth0(0,CurrentHhand, H),
        nth0(0,CurrentChand, C),
        can_move(C,CurrentCstack, Comptile),
        can_move(H,CurrentCstack, Humtile),        
        is_double_domino(Comptile, Type),
        % if its a double domino and its not at its maximum checks AKA 20 this helps in preventing stack/list over flow 
        Type \= 2,
        Iter \= 3,
        Iter < 20,
        Turn == human,
        Hhandsize == 1,
        Chandsize == 1,
        Hhandsize > Humtile,
        Chandsize < Comptile,
        write("Please choose from one of the following options\n"),
        write("1. Stack on own side\n"),
        write("2. Help me!\n"),
        write("3. Save game\n"),
        write("4. Exit current game\n"),
        read(X),
        spare_human_input_selection(X, Number),
        %cover(Output, Turn, Move,Newgame),
        determine_legal_placement(Number,Newgame,CurrentHhand,CurrentHstack,[],0,0,100).
 player_move(Output,Newgame, Moves,Iter):-
        %I have this new player_move added into the beginning to fix a bug that fixes premature scoring so far it works
        nth0(0,Newgame,Computer),
        nth0(1,Newgame,Human),
        nth0(2,Newgame,Turn),        
        nth0(0,Computer,CurrentCstack),
        nth0(1,Computer,CurrentCboneyard),
        nth0(2,Computer,CurrentChand), 
        nth0(3,Computer,CurrentCscore),
        nth0(4,Computer,CRound),
        nth0(0,Human,CurrentHstack),
        nth0(1,Human,CurrentHboneyard),
        nth0(2,Human,CurrentHhand),   
        nth0(3,Human,CurrentHscore),
        nth0(4,Human,HRound),
        length(CurrentHhand, Hhandsize),
        length(CurrentChand, Chandsize),
        nth0(0,CurrentHhand, H),
        nth0(0,CurrentChand, C),
        can_move(C,CurrentCstack, Comptile),
        can_move(H,CurrentHstack, Humtile),     
        can_move(H,CurrentCstack, SHumtile),     
        is_double_domino(Comptile, Type),
        Humtile > 0,
        % if its a double domino and its not at its maximum checks AKA 20 this helps in preventing stack/list over flow 
        Type == 2,
        Iter \= 3,
        Iter < 20,
        Turn == human,
        Hhandsize == 1,
        Chandsize == 1,
         SHumtile > 0,
        Hhandsize < Humtile,
        Chandsize > Comptile,
        add([computer], Human, K),
        add(K, Computer, GAME),
        write("Sorry but at this time there are no moves that you can play that means its the computers turn\n"),
        write("Type any number or letter followed by a period to continue"),
        read(_P),
        display_game(GAME),
        make_move(GAME, 0).       
player_move(Output,Newgame, Moves,Iter):-
        %I have this new player_move added into the beginning to fix a bug that fixes premature scoring so far it works
        nth0(0,Newgame,Computer),
        nth0(1,Newgame,Human),
        nth0(2,Newgame,Turn),        
        nth0(0,Computer,CurrentCstack),
        nth0(1,Computer,CurrentCboneyard),
        nth0(2,Computer,CurrentChand), 
        nth0(3,Computer,CurrentCscore),
        nth0(4,Computer,CRound),
        nth0(0,Human,CurrentHstack),
        nth0(1,Human,CurrentHboneyard),
        nth0(2,Human,CurrentHhand),   
        nth0(3,Human,CurrentHscore),
        nth0(4,Human,HRound),
        length(CurrentHhand, Hhandsize),
        length(CurrentChand, Chandsize),
        nth0(0,CurrentHhand, H),
        nth0(0,CurrentChand, C),
        can_move(C,CurrentCstack, Comptile),
        can_move(H,CurrentHstack, Humtile), 
        can_move(H,CurrentCstack, SHumtile),       
        is_double_domino(Comptile, Type),
        Humtile > 0,
        % if its a double domino and its not at its maximum checks AKA 20 this helps in preventing stack/list over flow 
        Type \= 2,
        Iter \= 3,
        Iter < 20,
        Turn == human,
        Hhandsize == 1,
        Chandsize == 1,
        SHumtile == 0,
        Hhandsize < Humtile,
        Chandsize > Comptile,
        write("Please choose from one of the following options\n"),
        write("1. Stack on opponents side\n"),
        write("2. Help me!\n"),
        write("3. Save game\n"),
        write("4. Exit current game\n"),
        read(Number),
        last_human_input_selection(Number, Newgame, X),
        determine_legal_placement(X,Newgame,CurrentHhand,CurrentHstack,[],0,0,1).
player_move(Output,Newgame, Moves,Iter):-
        nth0(0,Newgame,Computer),
        nth0(1,Newgame,Human),
        nth0(2,Newgame,Turn),        
        nth0(0,Computer,CurrentCstack),
        nth0(1,Computer,CurrentCboneyard),
        nth0(2,Computer,CurrentChand), 
        nth0(3,Computer,CurrentCscore),
        nth0(4,Computer,CRound),
        nth0(0,Human,CurrentHstack),
        nth0(1,Human,CurrentHboneyard),
        nth0(2,Human,CurrentHhand),   
        nth0(3,Human,CurrentHscore),
        nth0(4,Human,HRound),
        length(CurrentHboneyard, Pile),
        Iter == 20,
        Pile == 0,
        can_move(CurrentChand,CurrentCstack,DOMINOES),
        DOMINOES == 0,
        write("At this time there are no more playable moves. Time to add up the scores for this hand\n"),
        write("Type any number or letter followed by a period to continue"),
        read(_P),
        score_game(CurrentCstack,0, w, 0,CCstacktotal),
        score_game(CurrentHstack,0, w, 0,CHstacktotal),
        score_game(CurrentChand,0, w, 0,CChandtotal),
        score_game(CurrentCstack,0, b, 0,HCstacktotal),
        score_game(CurrentHstack,0, b, 0,HHstacktotal),
        score_game(CurrentHhand,0, b, 0,HChandtotal),
        New_human_score is (CurrentHscore + HCstacktotal + HHstacktotal) - HChandtotal,
        New_computer_score is (CurrentCscore + CCstacktotal + CHstacktotal) - CChandtotal,
        A = [],
        length(CurrentHboneyard, G),
        add([New_human_score,HRound],[],Hhand),
        add(Hhand, A, HB),
        add(HB,CurrentHstack,Newhuman),
        add([New_computer_score,CRound],[],Chand),
        add(Chand, A, CB),
        add(CB,CurrentCstack,Newcomputer),
        add([Turn], Newhuman, Game),
        add(Game, Newcomputer, GAME),
        display_game(GAME),
        round_winner(GAME).
player_move(Output,Newgame, Moves,Iter):-
        Output == 3,
        length(Moves, J),
        nth0(0,Newgame,Computer),
        nth0(1,Newgame,Human),
        nth0(2,Newgame,Turn),        
        nth0(0,Computer,CurrentCstack),
        nth0(1,Computer,CurrentCboneyard),
        nth0(2,Computer,CurrentChand), 
        nth0(3,Computer,CurrentCscore),
        nth0(4,Computer,CRound),
        nth0(0,Human,CurrentHstack),
        nth0(1,Human,CurrentHboneyard),
        nth0(2,Human,CurrentHhand),   
        nth0(3,Human,CurrentHscore),
        J == 0,
        determine_legal_placement(3,Newgame,CurrentHhand,CurrentHstack,[],0,0,Newiter).
player_move(Output,Newgame, Moves,Iter):-
        Output == 3,
        Iter == 356,
        nth0(0,Newgame,Computer),
        nth0(1,Newgame,Human),
        nth0(2,Newgame,Turn),        
        nth0(0,Computer,CurrentCstack),
        nth0(1,Computer,CurrentCboneyard),
        nth0(2,Computer,CurrentChand), 
        nth0(3,Computer,CurrentCscore),
        nth0(4,Computer,CRound),
        nth0(0,Human,CurrentHstack),
        nth0(1,Human,CurrentHboneyard),
        nth0(2,Human,CurrentHhand),   
        nth0(3,Human,CurrentHscore),
        computer_input_selection(Moves,0,X),
        nth0(X,Moves,Selection),
        nth0(0,Selection,A),
        nth0(1,Selection,B),
        nth0(0,A,C),
        nth0(0,B,D),
        write("I Recommend you draw "),
        write(A),
        write(" and stack onto "),
        write(B),
        length(Moves,Len), 
        computer_explaination(A,B,Len),
        write(". To play this move choose number "), 
        Newx is X + 1,
        write(Newx),
        write(".\nYou got this I believe in you! :)\n"),
        write("\n"),
        write("Type any number or letter followed by a period to continue"),
        read(_P),
       make_move(Newgame,0).
player_move(Output,Newgame, Moves,Iter):-
        Output == 3,
        nth0(0,Newgame,Computer),
        nth0(1,Newgame,Human),
        nth0(2,Newgame,Turn),        
        nth0(0,Computer,CurrentCstack),
        nth0(1,Computer,CurrentCboneyard),
        nth0(2,Computer,CurrentChand), 
        nth0(3,Computer,CurrentCscore),
        nth0(4,Computer,CRound),
        nth0(0,Human,CurrentHstack),
        nth0(1,Human,CurrentHboneyard),
        nth0(2,Human,CurrentHhand),   
        nth0(3,Human,CurrentHscore),
        computer_input_selection(Moves,0,X),
        nth0(X,Moves,Selection),
        nth0(0,Selection,A),
        nth0(1,Selection,B),
        nth0(0,A,C),
        nth0(0,B,D),
        is_double_domino(A,Val),
        Val == 2,
        C \= D,
        write("I Recommend you draw "),
        write(A),
        write(" and stack onto "),
        write(B), 
        length(Moves,Len), 
        computer_explaination(A,B,Len),
        write(". To play this move choose number "), 
        Newx is X + 1,
        write(Newx),
        write(".\nYou got this I believe in you! :)\n"),
        write("\n"),
        write("Type any number or letter followed by a period to continue"),
        read(_P),
       make_move(Newgame,0).
player_move(Output,Newgame, Moves,Iter):-
        Output == 3,
        nth0(0,Newgame,Computer),
        nth0(1,Newgame,Human),
        nth0(2,Newgame,Turn),        
        nth0(0,Computer,CurrentCstack),
        nth0(1,Computer,CurrentCboneyard),
        nth0(2,Computer,CurrentChand), 
        nth0(3,Computer,CurrentCscore),
        nth0(4,Computer,CRound),
        nth0(0,Human,CurrentHstack),
        nth0(1,Human,CurrentHboneyard),
        nth0(2,Human,CurrentHhand),   
        nth0(3,Human,CurrentHscore),
        computer_input_selection(Moves,0,X),
        nth0(X,Moves,Selection),
        nth0(0,Selection,A),
        nth0(1,Selection,B),
        nth0(0,A,C),
        nth0(0,B,D),
        is_double_domino(A,Val),
        Val == 2,
        C == D,
        determine_legal_placement(3,Newgame,CurrentHhand,CurrentHstack,[],0,0,Newiter).
player_move(Output,Newgame, Moves,Iter):-
        Output == 3,
        computer_input_selection(Moves,0,X),
        nth0(X,Moves,Selection),
        nth0(0,Selection,A),
        nth0(1,Selection,B),
        nth0(0,A,C),
        nth0(0,B,D),
        is_double_domino(A,Val),
        Val == 1,
        write("I Recommend you draw "),
        write(A),
        write(" and stack onto "),
        write(B), 
        length(Moves,Len), 
        computer_explaination(A,B,Len),
        write(". To play this move choose number "), 
        Newx is X + 1,
        write(Newx),
        write(".\nYou got this I believe in you! :)\n"),
        write("\n"),
        write("Type any number or letter followed by a period to continue"),
        read(_P),
       make_move(Newgame,0).
player_move(Output,Newgame, Moves,Iter):-
        nth0(0,Newgame,Computer),
        nth0(1,Newgame,Human),
        nth0(2,Newgame,Turn),        
        nth0(0,Computer,CurrentCstack),
        nth0(1,Computer,CurrentCboneyard),
        nth0(2,Computer,CurrentChand), 
        nth0(3,Computer,CurrentCscore),
        nth0(4,Computer,CRound),
        nth0(0,Human,CurrentHstack),
        nth0(1,Human,CurrentHboneyard),
        nth0(2,Human,CurrentHhand),   
        nth0(3,Human,CurrentHscore),
        nth0(4,Human,HRound),
        Iter == 20,
        write("At this time there are no more playable moves. Time to add up the scores for this hand\n"),
        write("Type any number or letter followed by a period to continue"),
        read(_P),
        score_game(CurrentCstack,0, w, 0,CCstacktotal),
        score_game(CurrentHstack,0, w, 0,CHstacktotal),
        score_game(CurrentChand,0, w, 0,CChandtotal),
        score_game(CurrentCstack,0, b, 0,HCstacktotal),
        score_game(CurrentHstack,0, b, 0,HHstacktotal),
        score_game(CurrentHhand,0, b, 0,HChandtotal),
        New_human_score is (CurrentHscore + HCstacktotal + HHstacktotal) - HChandtotal,
        New_computer_score is (CurrentCscore + CCstacktotal + CHstacktotal) - CChandtotal,
        A = [],
        length(CurrentHboneyard, G),
        draw_time(G, Htimes),
        loading_up_list(Htimes, Hnewtime),
        draw_from_boneyard(A,CurrentHboneyard,Htimes,G,NewcurrentHboneyard),
        load_up_list(A,CurrentHboneyard,Hnewtime,E),
        add([New_human_score,HRound],E,Hhand),
        add(Hhand, NewcurrentHboneyard, HB),
        add(HB,CurrentHstack,Newhuman),
        write(Newhuman),
        write("\n"),
        length(CurrentCboneyard, J),
        draw_time(G, Ctimes),
        loading_up_list(Ctimes, Cnewtime),
        draw_from_boneyard(A,CurrentCboneyard,Ctimes,J,NewcurrentCboneyard),
        load_up_list(A,CurrentCboneyard,Cnewtime,M),
        add([New_computer_score,CRound],M,Chand),
        add(Chand, NewcurrentCboneyard, CB),
        add(CB,CurrentCstack,Newcomputer),
        write(Newcomputer),
        write("\n"),
        add([Turn], Newhuman, Game),
        add(Game, Newcomputer, GAME),
        display_game(GAME),
        make_move(GAME,0).
player_move(Output,Newgame, Moves,Iter):-
        length(Moves, J),
        Newj is J - 1,
        Newj =< -1,
        Output == 1,
        nth0(2,Newgame,Turn),
        Turn == computer,
        nth0(1,Newgame,Human),
        nth0(0,Newgame,Computer),
        nth0(0,Human,CurrentHstack),
        nth0(0,Computer,CurrentCstack),
        nth0(2,Human,CurrentHhand),   
        add([human], Human, K),
        add(K, Computer, GAME),
        Newiter is Iter + 1,
        determine_legal_placement(2,GAME,CurrentHhand,CurrentCstack,[],0,0,Newiter).
player_move(Output,Newgame, Moves,Iter):-
        length(Moves, J),
        Newj is J - 1,
        Newj =< -1,
        Output == 1,
        nth0(2,Newgame,Turn),
        nth0(1,Newgame,Human),
        nth0(0,Human,CurrentHstack),
        nth0(2,Human,CurrentHhand),       
        nth0(0,Newgame,Computer),
        nth0(0,Computer,CurrentCstack),
        nth0(2,Computer,CurrentChand),
        Turn == human,
        read(_P),
        add([computer], Human, K),
        add(K, Computer, GAME),
        Newiter is Iter + 1,
        determine_legal_placement(2,GAME,CurrentChand,CurrentHstack,[],0,0,Newiter).
player_move(Output,Newgame, Moves,Iter):-
        length(Moves, J),
        Newj is J - 1,
        Newj =< -1,
        nth0(2,Newgame,Turn),
        Turn == computer,
        Output == 2,
        nth0(2,Newgame,Turn),
        nth0(1,Newgame,Human),
        nth0(0,Human,CurrentHstack),
        nth0(2,Human,CurrentHhand),       
        nth0(0,Newgame,Computer),
        nth0(0,Computer,CurrentCstack),
        nth0(2,Computer,CurrentChand),
        Newiter is Iter + 1,
        determine_legal_placement(1,Newgame,CurrentChand,CurrentCstack,[],0,0,Newiter).
player_move(Output,Newgame, Moves,Iter):-
        length(Moves, J),
        Newj is J - 1,
        Newj =< -1,
        nth0(2,Newgame,Turn),
        Turn == human,
        Output == 2,
        nth0(2,Newgame,Turn),
        Newiter is Iter + 1,
        nth0(1,Newgame,Human),
        nth0(0,Human,CurrentHstack),
        nth0(2,Human,CurrentHhand),       
        nth0(0,Newgame,Computer),
        nth0(0,Computer,CurrentCstack),
        nth0(2,Computer,CurrentChand),
        length(CurrentHhand, TILES),
        TILES == 0,
        determine_legal_placement(1,Newgame,CurrentHhand,CurrentHstack,[],0,0,20).
player_move(Output,Newgame, Moves,Iter):-
        length(Moves, J),
        Newj is J - 1,
        Newj =< -1,
        nth0(2,Newgame,Turn),
        Turn == human,
        Output == 2,
        nth0(2,Newgame,Turn),
        Newiter is Iter + 1,
        nth0(1,Newgame,Human),
        nth0(0,Human,CurrentHstack),
        nth0(2,Human,CurrentHhand),
        nth0(0,CurrentHhand,H),
        nth0(0,Newgame,Computer),
        nth0(0,Computer,CurrentCstack),
        nth0(2,Computer,CurrentChand),
        length(CurrentHhand, TILES),
        can_move(H,CurrentHstack,DOMINOES), 
        TILES < DOMINOES,
        determine_legal_placement(Number,Newgame,CurrentHhand,CurrentHstack,[],0,0,20).
player_move(Output,Newgame, Moves,Iter):-
        length(Moves, J),
        Newj is J - 1,
        Newj =< -1,
        nth0(2,Newgame,Turn),
        Turn == human,
        Output == 2,
        nth0(2,Newgame,Turn),
        Newiter is Iter + 1,
        nth0(1,Newgame,Human),
        nth0(0,Human,CurrentHstack),
        nth0(2,Human,CurrentHhand),
        nth0(0,CurrentHhand,H),
        nth0(0,Newgame,Computer),
        nth0(0,Computer,CurrentCstack),
        nth0(2,Computer,CurrentChand),
        length(CurrentHhand, TILES),
        can_move(H,CurrentHstack,DOMINOES),
        TILES > DOMINOES,
        write("Please choose from one of the following options\n"),
        write("1. Stack on own side\n"),
        write("2. Help me!\n"),
        write("3. Save game\n"),
        write("4. Exit current game\n"),
        read(X),
        spare_human_input_selection(X, Number),
        determine_legal_placement(Number,Newgame,CurrentHhand,CurrentHstack,[],0,0,19).        
player_move(Output,Newgame, Moves,Iter):-
        nth0(2,Newgame,Turn),
        Output \= 2,
        Turn == human,
        nth0(1,Newgame,Human),
        nth0(0,Human,CurrentHstack),
        nth0(2,Human,CurrentHhand),       
        nth0(0,Newgame,Computer),
        nth0(0,Computer,CurrentCstack),
        nth0(2,Computer,CurrentChand),
        nth0(0,CurrentHhand,H),
        can_move(H,CurrentHstack,A),
        can_move(H,CurrentCstack,B), 
        length(CurrentChand,Chandsize),
        length(CurrentHhand,Hhandsize),
        nth0(0,CurrentHhand,H),
        Chandsize == 0,
        Hhandsize == 1,
        A > Hhandsize,
        B < Hhandsize,
        write("Please choose from one of the following options\n"),
        write("1. Stack on opponents side\n"),
        write("2. Help me!\n"),
        write("3. Save game\n"),
        write("4. Exit current game\n"),
        read(X),
        aux_human_input_selection(X, Newgame, Moves, Number),
        determine_legal_placement(Number,Newgame,CurrentHhand,CurrentCstack,[],0,0,Iter).
player_move(Output,Newgame, Moves,Iter):-
        nth0(2,Newgame,Turn),
        Output \= 3,
        Turn == human,
        nth0(1,Newgame,Human),
        nth0(0,Human,CurrentHstack),
        nth0(2,Human,CurrentHhand),       
        nth0(0,Newgame,Computer),
        nth0(0,Computer,CurrentCstack),
        nth0(2,Computer,CurrentChand),
        write(Moves),
        write("\n"),
        write("\n"),
        write("Enter a number between 1 and "),
        length(Moves, J),
        Newj is J - 1,
        Newj > -1,
        write(J),
        write(" \n"),
        read(Input), 
        Response is Input - 1,
        human_input(Response,Newj,Num),
        nth0(Num,Moves,Selection),
        cover(Output, Turn, Selection,Newgame).
player_move(Output,Newgame, Moves,Iter):-
        nth0(2,Newgame,Turn),
        Turn == computer,
        Output == 2,
        length(Moves,J),
        J > 0,   
        computer_input_selection(Moves,0,X),
        nth0(X,Moves,Selection),
        write("Computer chose to stack "),
        nth0(0,Selection,A),
        write(A),
        write(" onto "),
        nth0(1,Selection,B),
        write(B),
        computer_explaination(A, B, J),
        write("\n"),
        write("Type any number or letter followed by a period to continue"),
        read(_P),
        cover(Output, Turn, Selection,Newgame).
player_move(Output,Newgame, Moves,Iter):-
        nth0(2,Newgame,Turn),
        Turn == computer,
        Output == 1,
        length(Moves,J),
        J > 0,
        computer_input_selection(Moves,0,X),
        nth0(X,Moves,Selection),
        write("Computer chose to stack "),
        nth0(0,Selection,A),
        write(A),
        write(" onto "),
        nth0(1,Selection,B),
        write(B),
        computer_explaination(A, B, J),
        write("\n"),
        write("Type any number or letter followed by a period to continue"),
        read(_P),       
        cover(Output, Turn, Selection,Newgame).

/**********************************************************************
Function Name: can_move                             
Purpose: to aid in determining if the current player in playing when its their turn
(BASICALLY USED AS A HELPER FUNCTION for getting the Parameters for update_stack)
Parameters: 
            Hand_tile the players selected tile from the hand passed by value
            Stack The stack passed by value
            Tiles the value returned from this function passed by value 
Return Value: returns tiles 
Algorithm:
            1. If its a non double domino and is numerically less then all 6 stacks
            then return 999
            OTHERWISE
            2. Return 0
Assistance Received: none
**********************************************************************/
can_move(Hand_tile,Stack,Tiles):-
        nth0(0, Stack, A),
        nth0(1, Stack, B),
        nth0(2, Stack, C),
        nth0(3, Stack, D),
        nth0(4, Stack, E),
        nth0(5, Stack, F),
        domino_value(A,G),
        domino_value(B,H),
        domino_value(C,I),
        domino_value(D,J),
        domino_value(E,K),
        domino_value(F,L),
        is_double_domino(Hand_tile,O),
        domino_value(Hand_tile,TEST),
        O == 1,
        TEST < G,
        TEST < H,
        TEST < I,
        TEST < J,
        TEST < K,
        TEST < L,
        Temp = 999,
        Tiles is Temp.
 can_move(Hand_tile,Stack,Tiles):-
        Temp = 0,
        Tiles is Temp.

/**********************************************************************
Function Name: cover                             
Purpose: to interpret the selected move and who is playing 
(BASICALLY USED AS A HELPER FUNCTION for getting the Parameters for update_stack)
Parameters: 
            Output the play type passed by value
            Turn the specified turn passed by value
            Move the selected move passed by value
            Newgame the game passed by value
Return Value: none
Algorithm:
            CurrentCstack = Computer's stacks
            CurrentHstack = Human's stacks 
            Move = [Tile,Onto]
            1. If Turn is human and Output is 2 then call
            update_stack(CurrentCstack, Onto, 0,Tile,[],Turn,Newgame,Output)
            ELSE
            2. If turn is human and Output is 1 then call 
            update_stack(CurrentHstack, Onto, 0,Tile,[],Turn,Newgame,Output)
            ELSE
            3. If turn is computer and Output is 2 then call
            update_stack(CurrentHstack, Onto, 0,Tile,[],Turn,Newgame,Output).
            4. If turn is computer and Output is 1 then call
            update_stack(CurrentCstack, Onto, 0,Tile,[],Turn,Newgame,Output).
Assistance Received: none
**********************************************************************/
cover(Output, Turn, Move,Newgame):-
        Turn == human,
        Output == 2,
        nth0(1,Newgame,Human),
        nth0(0,Human,CurrentHstack),
        nth0(2,Human,CurrentHhand),       
        nth0(0,Newgame,Computer),
        nth0(0,Computer,CurrentCstack),
        nth0(1,Move,Onto),
        nth0(0,Move,Tile),       
        update_stack(CurrentCstack, Onto, 0,Tile,[],Turn,Newgame,Output).
cover(Output, Turn, Move,Newgame):-
        Turn == human,
        Output == 1,
        nth0(1,Newgame,Human),
        nth0(0,Human,CurrentHstack),
        nth0(2,Human,CurrentHhand),       
        nth0(0,Newgame,Computer),
        nth0(0,Computer,CurrentCstack),
        nth0(1,Move,Onto),
        nth0(0,Move,Tile),       
        update_stack(CurrentHstack, Onto, 0,Tile,[],Turn,Newgame,Output).       
cover(Output, Turn, Move,Newgame):-
        Turn == computer,
        Output == 2,
        nth0(1,Newgame,Human),
        nth0(0,Human,CurrentHstack),
        nth0(2,Human,CurrentHhand),       
        nth0(0,Newgame,Computer),
        nth0(0,Computer,CurrentCstack),
        nth0(1,Move,Onto),
        nth0(0,Move,Tile),       
        update_stack(CurrentHstack, Onto, 0,Tile,[],Turn,Newgame,Output).       
cover(Output, Turn, Move,Newgame):-
        Turn == computer,
        Output == 1,
        nth0(1,Newgame,Human),
        nth0(0,Human,CurrentHstack),
        nth0(2,Human,CurrentHhand),       
        nth0(0,Newgame,Computer),
        nth0(0,Computer,CurrentCstack),
        nth0(1,Move,Onto),
        nth0(0,Move,Tile),       
        update_stack(CurrentCstack, Onto, 0,Tile,[],Turn,Newgame,Output).

/**********************************************************************
Function Name: update_stack                             
Purpose: update a stack based on a player selection
Parameters: 
            
            Stack the stack passed by value
            Onto The tile on the stack that is being changed passed by value
            Count the iterator that is used for the recursion passed by value
            Tile the tile we are stacking passed by value
            Newstack the updated stacks passed by value
            Turn the specified turn passed by value
            Newgame the game passed by value
            Output the play type passed by value

Return Value: none
Algorithm:
            1. If count is less then or equal to 5 recursively call this function
            ELSE
            2. If the current tile in the stack (J called via nth0 Count ) J = Onto
            Make that tile Onto INSTEAD of J
            OTHERWISE (this is lengthy so I''m going to sum up the rest)
            3. Based on whatever turn is delete tile from the respective players hand 
            e.g turn is computer delete tiler from its hand
            4. Update the game contents and turn to be the opposite player
            5. call make_move with the new list

Assistance Received: Used this for NON DESTRUCTIVELY removing from a list
https://www.swi-prolog.org/pldoc/doc_for?object=delete/3
**********************************************************************/
update_stack(Stack, Onto, Count,Tile,Newstack,Turn,Newgame,Output):-      
        nth0(Count, Stack, J),
        nth0(2, J, K),
        nth0(2, Onto, L),
        nth0(1, J, M),
        nth0(1, Onto, N),
        nth0(0, J, A),
        nth0(0, Onto, B),
        K == L,
        M == N,
        A == B,
        add(Newstack, Tile, LOP),
        Newcount is Count + 1,
        update_stack(Stack, Onto, Newcount,Tile,LOP,Turn,Newgame,Output).
update_stack(Stack, Onto, Count,Tile,Newstack,Turn,Newgame,Output):-
        Count =< 5,
        nth0(Count, Stack, J),
        Newcount is Count + 1,
        add(Newstack, J, LOP),
        write("\n"),
        %Newstack = LOP,
        update_stack(Stack, Onto, Newcount,Tile,LOP,Turn,Newgame,Output).
update_stack(Stack, Onto, Count,Tile,Newstack,Turn,Newgame,Output):-
        Turn == human,
        Output == 2,
        reverse(Newstack, Updated_stack),
        New_turn = computer,
        nth0(1,Newgame,Human),
        nth0(0,Human,CurrentHstack),
        nth0(1,Human,CurrentHboneyard),
        nth0(2,Human,CurrentHhand),       
        nth0(3,Human,CurrentHscore),
        nth0(4,Human,HRound),        
        nth0(0,Newgame,Computer),       
        nth0(0,Computer,CurrentCstack),
        nth0(1,Computer,CurrentCboneyard),
        nth0(2,Computer,CurrentChand),
        nth0(3,Computer,CurrentCscore),
        nth0(4,Computer,CRound),        
        delete(CurrentHhand, Tile, Updatedhand),
        add([CurrentHscore,HRound],Updatedhand,Hhand),
        add(Hhand,CurrentHboneyard,Boneyard),
        add(Boneyard,CurrentHstack,HUMAN),
        add([CurrentCscore,CRound],CurrentChand,Chand),
        add(Chand,CurrentCboneyard,Boneyards),
        add(Boneyards,Updated_stack,COMPUTER),
        add([New_turn], HUMAN, K),
        add(K, COMPUTER, GAME),
        display_game(GAME),
        make_move(GAME,0).

update_stack(Stack, Onto, Count,Tile,Newstack,Turn,Newgame,Output):-
        Turn == human,
        Output == 1,
        reverse(Newstack, Updated_stack),
         write(Updated_stack),         
         New_turn = computer,
         nth0(1,Newgame,Human),
         nth0(0,Human,CurrentHstack),
         nth0(1,Human,CurrentHboneyard),
         nth0(2,Human,CurrentHhand),       
         nth0(3,Human,CurrentHscore),
         nth0(4,Human,HRound),        
         nth0(0,Newgame,Computer),       
         nth0(0,Computer,CurrentCstack),
         nth0(1,Computer,CurrentCboneyard),
         nth0(2,Computer,CurrentChand),
         nth0(3,Computer,CurrentCscore),
         nth0(4,Computer,CRound),
         delete(CurrentHhand, Tile, Updatedhand),
         add([CurrentHscore,HRound],Updatedhand,Hhand),
         add(Hhand,CurrentHboneyard,Boneyard),
         add(Boneyard,Updated_stack,HUMAN),
         add([CurrentCscore,CRound],CurrentChand,Chand),
         add(Chand,CurrentCboneyard,Boneyards),
         add(Boneyards,CurrentCstack,COMPUTER),
         add([New_turn], HUMAN, K),
         add(K, COMPUTER, GAME),
         display_game(GAME),
         make_move(GAME,0).

update_stack(Stack, Onto, Count,Tile,Newstack,Turn,Newgame,Output):-
        Turn == computer,
        Output == 2,
        reverse(Newstack, Updated_stack),
        New_turn = human,
        nth0(1,Newgame,Human),
        nth0(0,Human,CurrentHstack),
        nth0(1,Human,CurrentHboneyard),
        nth0(2,Human,CurrentHhand),       
        nth0(3,Human,CurrentHscore),
        nth0(4,Human,HRound),        
        nth0(0,Newgame,Computer),       
        nth0(0,Computer,CurrentCstack),
        nth0(1,Computer,CurrentCboneyard),
        nth0(2,Computer,CurrentChand),
        nth0(3,Computer,CurrentCscore),
        nth0(4,Computer,CRound),                
        add([CurrentHscore,HRound],CurrentHhand,Hhand),
        add(Hhand,CurrentHboneyard,Boneyard),
        add(Boneyard,Updated_stack,HUMAN),
        delete(CurrentChand, Tile, Updatedhand),
        add([CurrentCscore,CRound],Updatedhand,Chand),
        add(Chand,CurrentCboneyard,Boneyards),
        add(Boneyards,CurrentCstack,COMPUTER),
        add([New_turn], HUMAN, K),
        add(K, COMPUTER, GAME),
        display_game(GAME),
        make_move(GAME,0).

update_stack(Stack, Onto, Count,Tile,Newstack,Turn,Newgame,Output):-
        Turn == computer,
        Output == 1,
        reverse(Newstack, Updated_stack),
        New_turn = human,
        nth0(1,Newgame,Human),
        nth0(0,Human,CurrentHstack),
        nth0(1,Human,CurrentHboneyard),
        nth0(2,Human,CurrentHhand),       
        nth0(3,Human,CurrentHscore),
        nth0(4,Human,HRound),        
        nth0(0,Newgame,Computer),       
        nth0(0,Computer,CurrentCstack),
        nth0(1,Computer,CurrentCboneyard),
        nth0(2,Computer,CurrentChand),
        nth0(3,Computer,CurrentCscore),
        nth0(4,Computer,CRound),        
        add([CurrentHscore,HRound],CurrentHhand,Hhand),
        add(Hhand,CurrentHboneyard,Boneyard),
        add(Boneyard,CurrentHstack,HUMAN),
        delete(CurrentChand, Tile, Updatedhand),
        add([CurrentCscore,CRound],Updatedhand,Chand),
        add(Chand,CurrentCboneyard,Boneyards),
        add(Boneyards,Updated_stack,COMPUTER),
        add([New_turn], HUMAN, K),
        add(K, COMPUTER, GAME),
        display_game(GAME),
        make_move(GAME,0).

/**********************************************************************
Function Name: determine_legal_placement               
Purpose: Determine all of the legal moves 
Parameters: Output the play type passed by value
            Newgame the game passed by value
            Hand the current player's hand passed by value
            Stack the stack passed by value
            Moves the list of legal moves passed by value 
            (By default when this function is first called Moves starts off as [])
            Stackat an ITERATOR used to get a tile in the Stack at the specified position passed by value
            Handat an ITERATOR used to get a tile in the Hand at the specified position passed by value
            Iter the ITERATOR used for player_move function passed by value
Return Value: none
Algorithm:
            1. If Output is 5 save game and quit
            ELSE
            2. If the the Handat iterator is greater then 5 reverse the list (RMoves) call player_move with RMoves
            OTHERWISE 
            3. (since the rest is long determine if the type of tile nondouble vs double and if it can be playedand numerical value)
           
Assistance Received: none
**********************************************************************/
determine_legal_placement(Output,Newgame,Hand,Stack,Moves,Stackat,Handat,Iter):-
        Output == 5,
        tty_clear,
        nth0(2,Newgame,Turn),
        nth0(0,Human,CurrentHstack),
        nth0(1,Human,CurrentHboneyard),
        nth0(2,Human,CurrentHhand),       
        nth0(3,Human,CurrentHscore),
        nth0(4,Human,HRound),        
        nth0(0,Newgame,Computer),       
        nth0(0,Computer,CurrentCstack),
        nth0(1,Computer,CurrentCboneyard),
        nth0(2,Computer,CurrentChand),
        nth0(3,Computer,CurrentCscore),
        nth0(4,Computer,CRound),       
        write("Enter the file name for this game save (MAKE SURE YOU SURROUND IT WITH '.txt'. (INCLUDING THE PERIOD) e.g: 'file.txt'.)\n"),
        read(J),
        open(J, write, Out),
        write(Out, '[\n'), 
        %Computer contents 
        write(Out, '   [\n'),
        write(Out, '       '), 
        write(Out, CurrentCstack), 
        write(Out, ',\n'),
        write(Out, CurrentCboneyard), 
        write(Out, ',\n'),
        write(Out, '       '), 
        write(Out, CurrentChand), 
        write(Out, ',\n'),
        write(Out, '       '), 
        write(Out, CurrentCscore), 
        write(Out, ',\n'),
        write(Out, '       '), 
        write(Out, CRound), 
        write(Out, '\n'),
        write(Out, '   ],\n'),        
        %Human contents
        write(Out, '   [\n'), 
        write(Out, '       '), 
        write(Out, CurrentHstack), 
        write(Out, ',\n'),
        write(Out, '       '),
        write(Out, ',\n'),
        write(Out, '       '), 
        write(Out, CurrentHhand), 
        write(Out, ',\n'),
        write(Out, '       '), 
        write(Out, CurrentHscore), 
        write(Out, ',\n'),
        write(Out, '       '), 
        write(Out, HRound), 
        write(Out, '\n'),
        write(Out, '   ],\n'),
        write(Out, '     '), 
        write(Out, Turn), 
        write(Out, '\n'),
        write(Out, '].\n'),
        close(Out),       
        display_game(Newgame),
        write("This game is saved as "),
        write(J),
        write('\n'),  
        halt.
determine_legal_placement(Output,Newgame,Hand,Stack,Moves,Stackat,Handat,Iter):-
        Handat > 5,
        reverse(Moves,RMoves),
        player_move(Output,Newgame, RMoves,Iter).
determine_legal_placement(Output,Newgame,Hand,Stack,Moves,Stackat,Handat,Iter):-
        Stackat > 5,
        Newhandat is Handat + 1,
        determine_legal_placement(Output,Newgame,Hand,Stack,Moves,0,Newhandat,Iter).
determine_legal_placement(Output,Newgame,Hand,Stack,Moves,Stackat,Handat,Iter):-
        nth0(Handat,Hand,A),
        nth0(Stackat,Stack,B),
        is_double_domino(A, TypeA),
        is_double_domino(B, TypeB),
        domino_value(A, VA),
        domino_value(B, VB), 
        TypeA \= 2,
        TypeB \= 2,
       Stackat =< 5,
       VA < VB,
       Newstackat is Stackat + 1, 
       determine_legal_placement(Output,Newgame,Hand,Stack,Moves,Newstackat,Handat,Iter).
determine_legal_placement(Output,Newgame,Hand,Stack,Moves,Stackat,Handat,Iter):-
        nth0(Handat,Hand,A),
        nth0(Stackat,Stack,B),
        is_double_domino(A, TypeA),
        is_double_domino(B, TypeB),
        domino_value(A, VA),
        domino_value(B, VB), 
        VA >=VB,
        TypeA \= 2,
        TypeB \= 2,
        add(Moves,[A,B], Newmoves),
        Stackat =< 5,
        Newstackat is Stackat + 1, 
        determine_legal_placement(Output,Newgame,Hand,Stack,Newmoves,Newstackat,Handat,Iter).
determine_legal_placement(Output,Newgame,Hand,Stack,Moves,Stackat,Handat,Iter):-
        nth0(Handat,Hand,A),
        nth0(Stackat,Stack,B),
        is_double_domino(A, TypeA),
        is_double_domino(B, TypeB),
        domino_value(A, VA),
        domino_value(B, VB),
        TypeA \= 2,
        TypeB \= 1,
        VA >=VB,
        add(Moves,[A,B], Newmoves),
        Stackat =< 5,
        Newstackat is Stackat + 1, 
        determine_legal_placement(Output,Newgame,Hand,Stack,Newmoves,Newstackat,Handat,Iter).
determine_legal_placement(Output,Newgame,Hand,Stack,Moves,Stackat,Handat,Iter):-
        nth0(Handat,Hand,A),
        nth0(Stackat,Stack,B),
        is_double_domino(A, TypeA),
        is_double_domino(B, TypeB),
        domino_value(A, VA),
        domino_value(B, VB),
        TypeA \= 1,
        TypeB \= 1,
        VA > VB,
        add(Moves,[A,B], Newmoves),
        Stackat =< 5,
        Newstackat is Stackat + 1, 
        determine_legal_placement(Output,Newgame,Hand,Stack,Newmoves,Newstackat,Handat,Iter).       
determine_legal_placement(Output,Newgame,Hand,Stack,Moves,Stackat,Handat,Iter):-
        nth0(Handat,Hand,A),
        nth0(Stackat,Stack,B),
        is_double_domino(A, TypeA),
        is_double_domino(B, TypeB),
        TypeA \= 1,
        TypeB \= 2,
        add(Moves,[A,B], Newmoves),
        Stackat =< 5,
        Newstackat is Stackat + 1, 
        determine_legal_placement(Output,Newgame,Hand,Stack,Newmoves,Newstackat,Handat,Iter).
determine_legal_placement(Output,Newgame,Hand,Stack,Moves,Stackat,Handat,Iter):-
        Stackat =< 5,
        Newstackat is Stackat + 1,
        determine_legal_placement(Output,Newgame,Hand,Stack,Moves,Newstackat,Handat,Iter).

/**********************************************************************
Function Name: human_selection               
Purpose: DEFAULT human selection for user input
Parameters: Number the input passed by value
            Newgame the game passed by value
            Output the value returned passed by value
Return Value: Returns the selection tallied (Output)
Algorithm:
            1. If Number is not 1-5 prompt and recursively call this function
            ELSE
            2. If the Number is 3 then display help
            ELSE
            3. If the Number is 1 then output is also 1
            ELSE
            4. If the Number is 2 then output is also 2
            ELSE
            5. If the Number is 4 then save the game and quit
            OTHERWISE
            6. If the number is 5 then exit game and go back to main menu.

Assistance Received: none
**********************************************************************/
human_selection(Number, Newgame,Output):-
        Number \= 3,
        Number \= 2,
        Number \= 1,
        Number \= 4,
        Number \= 5,
        write("Invalid entry please try again\n"),
        write("Please choose from one of the following options\n"),
        write("1. Stack on own side\n"),
        write("2. Stack on opponent's side\n"),
        write("3. Help me!\n"),
        write("4. Save game\n"),
        write("5. Exit current game\n"),
        read(Newnumber),
        Output is Newnumber,
        human_selection(Newnumber, Newgame,Output).
human_selection(Number, Newgame,Output):-
        Number == 3,
        make_move(Newgame,3).
human_selection(Number, Newgame,Output):-
        Number == 1,
        Output = 1.
human_selection(Number, Newgame,Output):-
        Number == 2,
        Output = 2.
human_selection(Number, Newgame,Output):-
        Number == 4,
        determine_legal_placement(5,Newgame,_Hand,_Stack,_Moves,_Stackat,_Handat,_Iter).
human_selection(Number, Newgame,Output):-
        Number == 5,
        main().

/**********************************************************************
Function Name: score_game
Purpose: score the game
Parameters: Stack the stack being tallied passed by value
            Count the iterator used in the recursion process passed by value
            Color the color being used in scoring e.g: if its b then tally black tiles for the human
            Total the total tally of tiles passed by value
            X the extra parameter used to return the total passed by value
Return Value: Returns the total tallied (X)
Algorithm:
            1. If Count is less then 6 and if the tile's color is equal 
            to Color, add the dominoes value to Total and incriment total
            and recursively call score_game.
            ELSE
            2. If the count is then 6 and the tile's color is NOT equal 
            to Color then incriment Count and add 0 to tht total and 
            recursively call score_game.
            OTHERWISE 
            3. Count is 6 then return the Total through X.
Assistance Received: none
**********************************************************************/
score_game(Stack, Count, Color, Total,X):-
        Count == 6,
        X is Total.
score_game(Stack, Count, Color, Total,X):-
        nth0(Count,Stack,Tileone),
        nth0(0,Tileone, Tileone_color),
        Tileone_color == Color,
        Count < 6,       
        domino_value(Tileone, Val),
        Newcount is Count + 1,
        Newtotal is Total + Val,
        score_game(Stack, Newcount, Color, Newtotal,X).
score_game(Stack, Count, Color,Total,X):-
        Newcount is Count + 1,
        Newtotal is Total + 0,
        score_game(Stack, Newcount, Color, Newtotal,X).

/**********************************************************************
Function Name: valid_file
Purpose: read the contents of the provided 
Parameters: J the specified filename passed by value
Return Value: none
Algorithm:
            1. If the file exists read the contents and call load_the_first_player
            OTHERWISE 
            3. call load_game again.
Assistance Received: none
**********************************************************************/
valid_file(J):-
        exists_file(J),
        open(J, read, Str),
        read(Str, Game),
        load_the_first_player(Game).
valid_file(J):-
        \+ exists_file(J),
        tty_clear,
        write("invalid entry, file does not exist please try again!\n"),
        load_game().

/**********************************************************************
Function Name: load_game
Purpose: read the contents of the provided 
Parameters: none
Return Value: none
Algorithm:
            1. read in the specified .txt (USER INPUT ONLY) file and check that its valid 
Assistance Received: none
**********************************************************************/
load_game():-
        write("Enter the file name for the saved game (MAKE SURE YOU SURROUND IT WITH '.txt'. (INCLUDING THE PERIOD) e.g: 'file.txt'.)\n"),
        read(J),
        valid_file(J).
        
/**********************************************************************
Function Name: display_game_minus_turn
Purpose: display the game WITHOUT turn (USED IN load_the_first_player)
Parameters: Newgame the game passed by value
Return Value: none
Algorithm:
            1. If the two boneyards have the same starting domino and the list only has a length of 2 instead of 3 display contents and reset game.
            ELSE
            2. Game contains "computer" (WITHOUT QUOTES) then Computer goes first.
            OTHERWISE 
            3. Human goes first.
Assistance Received: none
**********************************************************************/
display_game_minus_turn(Newgame):-
         tty_clear,
        nth0(0,Newgame,Computer),
        nth0(1,Newgame,Human),
        write("Computer:\n"),
        nth0(0,Computer,CurrentCstack),
        nth0(1,Computer,CurrentCboneyard),
        nth0(2,Computer,CurrentChand),
        nth0(3,Computer,CurrentCscore),
        nth0(4,Computer,CRound),
        write("Stacks:\n"),
        write(CurrentCstack),
        write("\n"),
        write("Boneyard:\n"),
        write(CurrentCboneyard),
        write("\n"),
        write("Hand:\n"),
        write(CurrentChand),
        write("\n"),
        write("Score:\n"),
        write(CurrentCscore),
        write("\n"),
        write("Rounds Won:\n"),
        write(CRound),
        write("\n"),
        write("\n"),

        write("Human:\n"),
        nth0(0,Human,CurrentHstack),
        nth0(1,Human,CurrentHboneyard),
        nth0(2,Human,CurrentHhand),
        nth0(3,Human,CurrentHscore),
        nth0(4,Human,HRound),
        write("Stacks:\n"),
        write(CurrentHstack),
        write("\n"),
        write("Boneyard:\n"),
        write(CurrentHboneyard),
        write("\n"),
        write("Hand:\n"),
        write(CurrentHhand),
        write("\n"),
        write("Score:\n"),
        write(CurrentHscore),
        write("\n"),
        write("Rounds Won:\n"),
        write(HRound),
        write("\n"),
        write("Turn: "),
        write("\n"),
        write("Type any number or letter followed by a period to continue"),
        read(_P).

/**********************************************************************
Function Name: load_the_first_player
Purpose: load the first player
Parameters: Game the parsed game from the serialization file passed by value
Return Value: none
Algorithm:
            1. If the two boneyards have the same starting domino and the list only has a length of 2 instead of 3 display contents and reset game.
            ELSE
            2. Game contains "computer" (WITHOUT QUOTES) then Computer goes first.
            OTHERWISE 
            3. Human goes first.
Assistance Received: none
**********************************************************************/
load_the_first_player(Game):-
        length(Game, Game_length),
        nth0(0,Game,Computer),
        nth0(1,Game,Human),
        nth0(1,Human, HB),
        nth0(1,Computer, CB),
        nth0(4,Human, Hround),
        nth0(4,Computer, Cround),
        length(HB, LHB),
        length(CB, LCB),
        nth0(0,HB,Htone),
        nth0(0,CB,Ctone),
        domino_value(Ctone, A),
        domino_value(Htone, B),
        Game_length == 2,
        LHB == 22,
        LCB == 22,
        A == B,
        display_game_minus_turn(Game),
        write("Sorry at this time both players will have the same size starting domino Stacks, Hands, and Boneyards will now reset\n"),
        write("Type any number or letter followed by a period to continue"),
        read(_P),
        new_game(Hround, Cround).
load_the_first_player(Game):-
        nth0(2,Game,Turn),
        Turn == computer,
        write("Computer goes first because it was the first player detected in the serialization file\n"),
        write("Type any number or letter followed by a period to continue"),
        read(_P),
        display_game(Game),
        make_move(Game,0).
load_the_first_player(Game):-
        nth0(2,Game,Turn),
        Turn == human,
        write("Human goes first because it was the first player detected in the serialization file\n"),
        write("Type any number or letter followed by a period to continue"),
        read(_P),
        display_game(Game),
        make_move(Game,0).

%............................................... execute the driver HERE ..............................................
:- main,
halt.