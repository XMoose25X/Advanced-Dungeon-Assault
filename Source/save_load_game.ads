with player; use player;

package save_load_game is

    procedure newGame(player: out Player_Type; dungeon: out Integer);

    procedure saveGame(player: in Player_Type; dungeon: in Integer; fileNum: in Integer);

    procedure loadGame(player: in out Player_Type; dungeon: in out Integer; fileNum: in Integer);

end save_load_game;
