with player;				Use player;

package save_load_game is

procedure newGame(	player : out player_Type;
					dungeon : out integer );

procedure saveGame(	player : in player_Type;
					dungeon : in integer;
					fileNum : in integer );

procedure loadGame(	player : in out player_Type;
					dungeon : in out integer;
					fileNum : in integer);
					
end save_load_game;
